import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'github_fetcher.dart';
import 'project.dart';

/// Loads apps from the build-time snapshot (web/projects.json); falls back to a
/// live public GitHub fetch when there is no snapshot (e.g. local `flutter run`).
class ProjectsStore extends ChangeNotifier {
  List<Project> projects = const [];
  DateTime? syncedAt;
  bool loading = true;

  Future<void> load() async {
    try {
      projects = await _fromSnapshot() ?? await GithubFetcher().fetchProjects();
    } catch (e) {
      debugPrint("Projects failed to load: $e");
    }
    loading = false;
    notifyListeners();
  }

  Future<List<Project>?> _fromSnapshot() async {
    final res = await http.get(Uri.base.resolve("projects.json"));
    if (res.statusCode != 200 || !res.body.trimLeft().startsWith("{")) return null;
    final data = json.decode(res.body) as Map<String, dynamic>;
    syncedAt = DateTime.tryParse(data["syncedAt"] as String? ?? "");
    return [
      for (final p in data["projects"] as List)
        _resolveImage(Project.fromJson(p as Map<String, dynamic>)),
    ];
  }

  /// Snapshot images are site-relative; make them absolute for the image loader.
  Project _resolveImage(Project p) =>
      p.image == null || p.image!.startsWith("http") ? p : p.withImage(Uri.base.resolve(p.image!).toString());
}
