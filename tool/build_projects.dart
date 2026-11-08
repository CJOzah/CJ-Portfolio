// Snapshots your GitHub apps (own + organizations) into web/projects.json and
// web/projects/*, so the site never needs a token at runtime.
//
//   PORTFOLIO_GITHUB_TOKEN=ghp_xxx dart run tool/build_projects.dart
//
// Token: classic PAT with `repo` + `read:org` (fine-grained tokens cover one owner only).
// Without a token it falls back to public repos.
import 'dart:convert';
import 'dart:io';

import 'package:canaan_portfolio/github/github_fetcher.dart';
import 'package:canaan_portfolio/github/project.dart';
import 'package:http/http.dart' as http;

const _outDir = "web/projects";
const _maxImageBytes = 5 * 1024 * 1024;

/// The token may only ever be sent to these hosts.
const _githubHosts = {"github.com", "api.github.com", "raw.githubusercontent.com"};

Future<void> main() async {
  final token = Platform.environment["PORTFOLIO_GITHUB_TOKEN"]?.trim() ?? "";
  final projects = await GithubFetcher(token: token).fetchProjects();

  final dir = Directory(_outDir);
  if (dir.existsSync()) dir.deleteSync(recursive: true);
  dir.createSync(recursive: true);

  final client = http.Client();
  final saved = <Project>[];
  for (var i = 0; i < projects.length; i++) {
    final p = projects[i];
    saved.add(p.withImage(await _download(client, p.image, "app-$i", token)));
  }
  client.close();

  File("web/projects.json").writeAsStringSync(const JsonEncoder.withIndent("  ").convert({
    "syncedAt": DateTime.now().toUtc().toIso8601String(),
    "projects": [for (final p in saved) p.toJson()],
  }));
  final orgs = saved.where((p) => p.isOrg).length;
  stdout.writeln("Wrote ${saved.length} projects ($orgs from orgs, "
      "${token.isEmpty ? "public only: no PORTFOLIO_GITHUB_TOKEN" : "authenticated"}).");
}

/// Downloads an image to web/projects/, returning its site-relative path or null.
Future<String?> _download(http.Client client, String? url, String name, String token) async {
  if (url == null) return null;
  // The fetcher wraps some GitHub images in a public resize proxy; go to the source instead.
  final weserv = RegExp(r"^https://images\.weserv\.nl/\?url=(.+)$").firstMatch(url);
  var uri = Uri.parse(weserv != null ? "https://${weserv.group(1)}" : url);

  // Follow redirects by hand so the token is never forwarded off GitHub (e.g. to S3).
  for (var hop = 0; hop < 5; hop++) {
    final request = http.Request("GET", uri)..followRedirects = false;
    if (token.isNotEmpty && _githubHosts.contains(uri.host)) {
      request.headers["Authorization"] = "Bearer $token";
    }
    final http.StreamedResponse res;
    try {
      res = await client.send(request).timeout(const Duration(seconds: 30));
    } catch (e) {
      stderr.writeln("  image failed ($name): $e");
      return null;
    }
    final location = res.headers["location"];
    if (res.isRedirect || (res.statusCode >= 300 && res.statusCode < 400 && location != null)) {
      await res.stream.drain<void>();
      uri = uri.resolve(location!);
      continue;
    }
    final type = res.headers["content-type"] ?? "";
    final ext = const {
      "image/png": "png", "image/jpeg": "jpg", "image/gif": "gif",
      "image/webp": "webp", "image/svg+xml": "svg",
    }[type.split(";").first.trim()];
    final bytes = await res.stream.toBytes();
    if (res.statusCode != 200 || ext == null || bytes.length > _maxImageBytes) {
      stderr.writeln("  image skipped ($name): ${res.statusCode} $type ${bytes.length}B");
      return null;
    }
    File("$_outDir/$name.$ext").writeAsBytesSync(bytes);
    return "projects/$name.$ext";
  }
  return null;
}
