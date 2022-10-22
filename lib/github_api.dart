// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'package:canaan_portfolio/github_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GithubRepos extends ChangeNotifier {
  List<GithubRepo> githubRepo = [];
  getGithubRepos() async {
    // bool result = await InternetConnectionChecker().hasConnection;

    var url = Uri.parse("https://api.github.com/users/CJOzah/repos");
    try {
      var response = await http.get(
        url,
        headers: {
          'Connection': 'keep-alive',
          'Content-Type': 'application/json',
          'Accept-Encoding': 'gzip, deflate, br'
        },
      ).timeout(const Duration(seconds: 60));

      debugPrint("${response.statusCode}");
      if (response.statusCode == 504) {
        githubRepo = [];
        notifyListeners();
        debugPrint(response.body);
      } else if (response.statusCode == 500) {
        githubRepo = [];
        notifyListeners();
        debugPrint(response.body);
      } else if (response.statusCode == 400) {
        githubRepo = [];
        notifyListeners();
        debugPrint(response.body);
      } else if (response.statusCode == 200) {
        githubRepo = List<GithubRepo>.from(
            json.decode(response.body).map((x) => GithubRepo.fromJson(x)));
        notifyListeners();
        debugPrint("$githubRepo");
      } else {
        githubRepo = [];
        notifyListeners();
        debugPrint("Error Code: ${response.statusCode}");
      }
    } on TimeoutException {
      githubRepo = [];
      notifyListeners();
    }
  }

  List<GithubRepo> getGithubRepo() {
    return githubRepo;
  }

  void clearGithubRepo() {
    githubRepo = [];
    debugPrint("$githubRepo");
    notifyListeners();
  }
}
