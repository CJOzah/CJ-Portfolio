// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'package:canaan_portfolio/config/env_config.dart';
import 'package:canaan_portfolio/github_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GithubRepos extends ChangeNotifier {
  List<GithubRepo> githubRepo = [];
  final Set<String> _invitedRepoFullNames = <String>{};
  final Map<String, String> _repoReadmeHeaderImageByFullName = <String, String>{};
  final Map<String, String> _repoOverviewByFullName = <String, String>{};
  final Map<String, String> _repoTitleByFullName = <String, String>{};
  final Map<String, String> _repoPlayStoreUrlByFullName = <String, String>{};
  final Map<String, List<_ReadmeSubProject>> _repoSubProjectsByFullName =
      <String, List<_ReadmeSubProject>>{};
  static const String _githubUsername = "CJOzah";

  /// Fetches repositories from GitHub.
  ///
  /// If `GITHUB_TOKEN` exists, this fetches personal and organization repos
  /// available to the authenticated user, including private repos when allowed.
  /// Without a token, it fetches public repos for the configured username and
  /// any public organization repos for orgs that username belongs to.
  Future<void> getGithubRepos() async {
    final String githubToken = EnvConfig.githubToken;
    final bool useAuthenticatedRequest = githubToken.trim().isNotEmpty;

    final Map<String, String> headers = {
      "Connection": "keep-alive",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept": "application/vnd.github+json",
    };

    if (useAuthenticatedRequest) {
      headers["Authorization"] = "Bearer $githubToken";
    }

    try {
      if (useAuthenticatedRequest) {
        final List<GithubRepo>? authenticatedRepos =
            await _fetchAuthenticatedRepos(headers);
        if (authenticatedRepos != null) {
          githubRepo = authenticatedRepos;
          await _populateReadmeHeaderImages(
            repos: githubRepo,
            headers: headers,
          );
          _expandEventpadiRepoIntoSubProjects();
          _filterReposWithoutReadmeImage();
          notifyListeners();
          debugPrint("Loaded ${githubRepo.length} repos (authenticated).");
          return;
        }
      }

      _invitedRepoFullNames.clear();
      final List<GithubRepo> publicRepos = await _fetchPublicUserAndOrgRepos();
      githubRepo = publicRepos;
      await _populateReadmeHeaderImages(
        repos: githubRepo,
        headers: publicHeadersForReadmeFetch,
      );
      _expandEventpadiRepoIntoSubProjects();
      _filterReposWithoutReadmeImage();
      notifyListeners();
      debugPrint("Loaded ${githubRepo.length} repos (public fallback).");
    } on TimeoutException {
      _invitedRepoFullNames.clear();
      _repoReadmeHeaderImageByFullName.clear();
      _repoOverviewByFullName.clear();
      _repoTitleByFullName.clear();
      _repoPlayStoreUrlByFullName.clear();
      _repoSubProjectsByFullName.clear();
      githubRepo = [];
      notifyListeners();
    }
  }

  Map<String, String> get publicHeadersForReadmeFetch => <String, String>{
        "Connection": "keep-alive",
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept": "application/vnd.github+json",
      };

  /// Fetches authenticated user repos plus repos from organizations the user belongs to.
  ///
  /// Returns null if authentication failed (401/403) to allow public fallback.
  Future<List<GithubRepo>?> _fetchAuthenticatedRepos(
      Map<String, String> headers) async {
    final Uri authProbeUrl = Uri.parse(
        "https://api.github.com/user/repos?visibility=all&affiliation=owner,organization_member,collaborator&sort=updated&per_page=100&page=1");
    final http.Response userReposResponse =
        await _getWithTimeout(authProbeUrl, headers);

    if (userReposResponse.statusCode == 401 || userReposResponse.statusCode == 403) {
      debugPrint("Authentication failed. Falling back to public repos.");
      return null;
    }
    if (userReposResponse.statusCode != 200) {
      debugPrint(userReposResponse.body);
      debugPrint("Error Code: ${userReposResponse.statusCode}");
      return <GithubRepo>[];
    }

    final List<GithubRepo> userRepos = await _fetchPagedReposFromUrl(
      baseUrl:
          "https://api.github.com/user/repos?visibility=all&affiliation=owner,organization_member,collaborator&sort=updated&per_page=100",
      headers: headers,
    );
    final List<GithubRepo> allAccessibleUserRepos = await _fetchPagedReposFromUrl(
      baseUrl:
          "https://api.github.com/user/repos?type=all&sort=updated&per_page=100",
      headers: headers,
    );
    final List<GithubRepo> invitedRepos =
        await _fetchInvitedRepos(headers: headers);
    final List<String> orgLogins = await _fetchAuthenticatedOrgLogins(headers);
    final List<GithubRepo> orgRepos = await _fetchOrgRepos(
      orgLogins: orgLogins,
      headers: headers,
      type: "all",
    );

    final List<GithubRepo> mergedRepos = _mergeAndDeduplicateRepos(
        <GithubRepo>[...userRepos, ...allAccessibleUserRepos, ...invitedRepos, ...orgRepos]);
    debugPrint(
        "GitHub source counts -> affiliation:${userRepos.length}; typeAll:${allAccessibleUserRepos.length}; invited:${invitedRepos.length}; org:${orgRepos.length}; merged:${mergedRepos.length}; orgs:${orgLogins.length}");
    return mergedRepos;
  }

  /// Fetches public user repos plus public repos from organizations the user belongs to.
  Future<List<GithubRepo>> _fetchPublicUserAndOrgRepos() async {
    final Map<String, String> publicHeaders = publicHeadersForReadmeFetch;
    final List<GithubRepo> userRepos = await _fetchPagedReposFromUrl(
      baseUrl:
          "https://api.github.com/users/$_githubUsername/repos?sort=updated&per_page=100",
      headers: publicHeaders,
    );
    final List<String> orgLogins = await _fetchPublicOrgLogins(publicHeaders);
    final List<GithubRepo> orgRepos = await _fetchOrgRepos(
      orgLogins: orgLogins,
      headers: publicHeaders,
      type: "public",
    );

    final List<GithubRepo> mergedRepos =
        _mergeAndDeduplicateRepos(<GithubRepo>[...userRepos, ...orgRepos]);
    debugPrint(
        "GitHub public source counts -> user:${userRepos.length}; org:${orgRepos.length}; merged:${mergedRepos.length}; orgs:${orgLogins.length}");
    return mergedRepos;
  }

  /// Fetches organization logins for the authenticated user.
  Future<List<String>> _fetchAuthenticatedOrgLogins(
      Map<String, String> headers) async {
    return _fetchPagedOrgLoginsFromUrl(
      baseUrl: "https://api.github.com/user/orgs?per_page=100",
      headers: headers,
    );
  }

  /// Fetches public organization logins for the configured username.
  Future<List<String>> _fetchPublicOrgLogins(
      Map<String, String> headers) async {
    return _fetchPagedOrgLoginsFromUrl(
      baseUrl: "https://api.github.com/users/$_githubUsername/orgs?per_page=100",
      headers: headers,
    );
  }

  /// Fetches repositories for each provided organization login.
  Future<List<GithubRepo>> _fetchOrgRepos({
    required List<String> orgLogins,
    required Map<String, String> headers,
    required String type,
  }) async {
    final List<GithubRepo> orgRepos = <GithubRepo>[];
    for (final String orgLogin in orgLogins) {
      final List<GithubRepo> pagedOrgRepos = await _fetchPagedReposFromUrl(
        baseUrl:
            "https://api.github.com/orgs/$orgLogin/repos?type=$type&sort=updated&per_page=100",
        headers: headers,
      );
      orgRepos.addAll(pagedOrgRepos);
    }
    return orgRepos;
  }

  /// Fetches repositories the user is invited to via pending invitations.
  Future<List<GithubRepo>> _fetchInvitedRepos({
    required Map<String, String> headers,
  }) async {
    final List<GithubRepo> invitedRepos = <GithubRepo>[];
    _invitedRepoFullNames.clear();
    int page = 1;

    while (true) {
      final Uri invitationUrl = Uri.parse(
          "https://api.github.com/user/repository_invitations?per_page=100&page=$page");
      final http.Response invitationResponse =
          await _getWithTimeout(invitationUrl, headers);
      if (invitationResponse.statusCode != 200) {
        break;
      }

      final dynamic invitationDecoded = json.decode(invitationResponse.body);
      if (invitationDecoded is! List || invitationDecoded.isEmpty) {
        break;
      }

      for (final dynamic invitation in invitationDecoded) {
        if (invitation is! Map<String, dynamic>) {
          continue;
        }
        final dynamic repository = invitation["repository"];
        if (repository is! Map<String, dynamic>) {
          continue;
        }
        final String? fullName = repository["full_name"] as String?;
        if (fullName == null || fullName.trim().isEmpty) {
          continue;
        }
        _invitedRepoFullNames.add(fullName);
      }

      if (invitationDecoded.length < 100) {
        break;
      }
      page++;
    }

    for (final String fullName in _invitedRepoFullNames) {
      final Uri repoDetailsUrl = Uri.parse("https://api.github.com/repos/$fullName");
      final http.Response repoDetailsResponse =
          await _getWithTimeout(repoDetailsUrl, headers);
      if (repoDetailsResponse.statusCode == 200) {
        invitedRepos.addAll(_parseRepos("[${repoDetailsResponse.body}]"));
      }
    }

    return invitedRepos;
  }

  /// Fetches all paginated repository results from a GitHub endpoint.
  Future<List<GithubRepo>> _fetchPagedReposFromUrl({
    required String baseUrl,
    required Map<String, String> headers,
  }) async {
    final List<GithubRepo> repos = <GithubRepo>[];
    int page = 1;
    while (true) {
      final Uri pageUrl = Uri.parse("$baseUrl&page=$page");
      final http.Response response = await _getWithTimeout(pageUrl, headers);
      if (response.statusCode != 200) {
        break;
      }
      final List<GithubRepo> pageRepos = _parseRepos(response.body);
      if (pageRepos.isEmpty) {
        break;
      }
      repos.addAll(pageRepos);
      if (pageRepos.length < 100) {
        break;
      }
      page++;
    }
    return repos;
  }

  /// Fetches all paginated organization login results from a GitHub endpoint.
  Future<List<String>> _fetchPagedOrgLoginsFromUrl({
    required String baseUrl,
    required Map<String, String> headers,
  }) async {
    final List<String> orgLogins = <String>[];
    int page = 1;
    while (true) {
      final Uri pageUrl = Uri.parse("$baseUrl&page=$page");
      final http.Response response = await _getWithTimeout(pageUrl, headers);
      if (response.statusCode != 200) {
        break;
      }
      final List<String> pageOrgs = _parseOrgLogins(response.body);
      if (pageOrgs.isEmpty) {
        break;
      }
      orgLogins.addAll(pageOrgs);
      if (pageOrgs.length < 100) {
        break;
      }
      page++;
    }
    return orgLogins;
  }

  /// Executes GET request with standard timeout.
  Future<http.Response> _getWithTimeout(
      Uri url, Map<String, String> headers) async {
    return http.get(url, headers: headers).timeout(const Duration(seconds: 60));
  }

  /// Fetches and caches the first README image URL for each repository.
  Future<void> _populateReadmeHeaderImages({
    required List<GithubRepo> repos,
    required Map<String, String> headers,
  }) async {
    _repoReadmeHeaderImageByFullName.clear();
    _repoOverviewByFullName.clear();
    _repoTitleByFullName.clear();
    _repoPlayStoreUrlByFullName.clear();
    _repoSubProjectsByFullName.clear();
    for (final GithubRepo repo in repos) {
      final String? fullName = repo.fullName?.trim();
      if (fullName == null || fullName.isEmpty) {
        continue;
      }
      final _ReadmeMetadata readmeMetadata = await _fetchReadmeMetadataForRepo(
        fullName: fullName,
        defaultBranch: repo.defaultBranch,
        headers: headers,
      );
      final String? imageUrl = readmeMetadata.imageUrl;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        _repoReadmeHeaderImageByFullName[fullName] = imageUrl;
      }
      final String? overview = readmeMetadata.overview;
      if (overview != null && overview.isNotEmpty) {
        _repoOverviewByFullName[fullName] = overview;
      }
      final String? title = readmeMetadata.title;
      if (title != null && title.isNotEmpty) {
        _repoTitleByFullName[fullName] = title;
      }
      final String? playStoreUrl = readmeMetadata.playStoreUrl;
      if (playStoreUrl != null && playStoreUrl.isNotEmpty) {
        _repoPlayStoreUrlByFullName[fullName] = playStoreUrl;
      }
      final List<_ReadmeSubProject> subProjects = readmeMetadata.subProjects;
      if (_isEventpadiRepo(repo) && subProjects.length > 1) {
        _repoSubProjectsByFullName[fullName] = subProjects;
        for (int index = 0; index < subProjects.length; index++) {
          final _ReadmeSubProject subProject = subProjects[index];
          final String syntheticKey = _buildSubProjectKey(fullName, index);
          if (subProject.imageUrl.isNotEmpty) {
            _repoReadmeHeaderImageByFullName[syntheticKey] = subProject.imageUrl;
          }
          if (subProject.overview.isNotEmpty) {
            _repoOverviewByFullName[syntheticKey] = subProject.overview;
          }
          if (subProject.title.isNotEmpty) {
            _repoTitleByFullName[syntheticKey] = subProject.title;
          }
          if (subProject.projectUrl.isNotEmpty) {
            _repoPlayStoreUrlByFullName[syntheticKey] = subProject.projectUrl;
          }
        }
      }
    }
  }

  /// Replaces Eventpadi parent repo card with README-defined sub-project cards.
  void _expandEventpadiRepoIntoSubProjects() {
    final List<GithubRepo> expandedRepos = <GithubRepo>[];
    for (final GithubRepo repo in githubRepo) {
      final String? fullName = repo.fullName?.trim();
      if (fullName == null || fullName.isEmpty) {
        expandedRepos.add(repo);
        continue;
      }
      final List<_ReadmeSubProject>? subProjects = _repoSubProjectsByFullName[fullName];
      if (subProjects == null || subProjects.isEmpty) {
        expandedRepos.add(repo);
        continue;
      }
      for (int index = 0; index < subProjects.length; index++) {
        final _ReadmeSubProject subProject = subProjects[index];
        expandedRepos.add(
          GithubRepo(
            id: repo.id == null ? null : repo.id! + index + 1,
            name: subProject.title,
            fullName: _buildSubProjectKey(fullName, index),
            owner: repo.owner,
            htmlUrl: repo.htmlUrl,
            description: subProject.overview,
            pushedAt: repo.pushedAt,
            defaultBranch: repo.defaultBranch,
          ),
        );
      }
    }
    githubRepo = expandedRepos;
  }

  /// Keeps only repositories that have an extracted README header image.
  void _filterReposWithoutReadmeImage() {
    githubRepo = githubRepo.where((GithubRepo repo) {
      final String? fullName = repo.fullName?.trim();
      if (fullName == null || fullName.isEmpty) {
        return false;
      }
      final String? imageUrl = _repoReadmeHeaderImageByFullName[fullName];
      return imageUrl != null && imageUrl.isNotEmpty;
    }).toList();
  }

  /// Fetches README metadata (header image and Overview text) for one repository.
  Future<_ReadmeMetadata> _fetchReadmeMetadataForRepo({
    required String fullName,
    required String? defaultBranch,
    required Map<String, String> headers,
  }) async {
    final Uri readmeUrl = Uri.parse("https://api.github.com/repos/$fullName/readme");
    final http.Response response = await _getWithTimeout(readmeUrl, headers);
    if (response.statusCode != 200) {
      return const _ReadmeMetadata();
    }
    final dynamic decoded = json.decode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return const _ReadmeMetadata();
    }
    final String? content = decoded["content"] as String?;
    final String? encoding = decoded["encoding"] as String?;
    final String? readmePath = decoded["path"] as String?;
    if (content == null || content.isEmpty || encoding != "base64") {
      return const _ReadmeMetadata();
    }
    final String markdown = utf8.decode(base64.decode(content.replaceAll("\n", "")));
    final String? rawImageUrl = _extractFirstImageUrlFromMarkdown(markdown);
    final String? normalizedImageUrl =
        rawImageUrl == null || rawImageUrl.isEmpty
            ? null
            : _normalizeReadmeImageUrl(
                repoFullName: fullName,
                defaultBranch: defaultBranch,
                rawImageUrl: rawImageUrl,
                readmePath: readmePath,
              );
    final String? overview = _extractOverviewFromMarkdown(markdown);
    final String? title = _extractTitleFromMarkdown(markdown);
    final String? playStoreUrl = _extractPlayStoreUrlFromMarkdown(markdown);
    final List<_ReadmeSubProject> subProjects = _extractSubProjectsFromMarkdown(
      markdown: markdown,
      repoFullName: fullName,
      defaultBranch: defaultBranch,
      readmePath: readmePath,
    );
    return _ReadmeMetadata(
      imageUrl: normalizedImageUrl,
      overview: overview,
      title: title,
      playStoreUrl: playStoreUrl,
      subProjects: subProjects,
    );
  }

  /// Extracts top-level README sections as standalone project cards.
  List<_ReadmeSubProject> _extractSubProjectsFromMarkdown({
    required String markdown,
    required String repoFullName,
    required String? defaultBranch,
    required String? readmePath,
  }) {
    final List<String> lines = markdown.split("\n");
    final List<_ReadmeSubProject> projects = <_ReadmeSubProject>[];
    int index = 0;
    while (index < lines.length) {
      final String currentLine = lines[index].trim();
      if (!currentLine.startsWith("# ") || currentLine.startsWith("##")) {
        index++;
        continue;
      }

      final String title = currentLine.replaceFirst("# ", "").trim();
      index++;
      final List<String> sectionLines = <String>[];
      while (index < lines.length) {
        final String line = lines[index].trim();
        if (line.startsWith("# ") && !line.startsWith("##")) {
          break;
        }
        sectionLines.add(lines[index]);
        index++;
      }

      final String sectionMarkdown = sectionLines.join("\n");
      final String? sectionOverview = _extractOverviewFromMarkdown(sectionMarkdown);
      final String? sectionRawImage = _extractImageUrlFromImagesSection(sectionMarkdown) ??
          _extractFirstImageUrlFromMarkdown(sectionMarkdown);
      final String? sectionImage = sectionRawImage == null || sectionRawImage.isEmpty
          ? null
          : _normalizeReadmeImageUrl(
              repoFullName: repoFullName,
              defaultBranch: defaultBranch,
              rawImageUrl: sectionRawImage,
              readmePath: readmePath,
            );
      final String? sectionUrl = _extractPlayStoreUrlFromMarkdown(sectionMarkdown);
      if (title.isEmpty ||
          sectionOverview == null ||
          sectionOverview.isEmpty ||
          sectionImage == null ||
          sectionImage.isEmpty) {
        continue;
      }
      projects.add(
        _ReadmeSubProject(
          title: title,
          overview: sectionOverview,
          imageUrl: sectionImage,
          projectUrl: sectionUrl ?? "",
        ),
      );
    }
    return projects;
  }

  /// Builds a stable synthetic key for sub-project metadata maps.
  String _buildSubProjectKey(String fullName, int index) {
    return "$fullName::subproject::$index";
  }

  /// Checks if this repository should be expanded from README sub-projects.
  bool _isEventpadiRepo(GithubRepo repo) {
    final String fullName = repo.fullName?.toLowerCase() ?? "";
    final String name = repo.name?.toLowerCase() ?? "";
    return fullName.contains("eventpadi") || name.contains("eventpadi");
  }

  /// Extracts first image URL from markdown or inline html image tags.
  String? _extractFirstImageUrlFromMarkdown(String markdown) {
    final String? imagesSectionUrl = _extractImageUrlFromImagesSection(markdown);
    if (imagesSectionUrl != null) {
      return imagesSectionUrl;
    }
    final RegExp markdownImageRegExp = RegExp(
        "!\\[[^\\]]*\\]\\(\\s*<?([^>\\s)]+)>?(?:\\s+['\"][^'\"]*['\"])?\\s*\\)");
    final RegExp htmlImageRegExp =
        RegExp("<img[^>]*src=[\"']([^\"']+)[\"']", caseSensitive: false);

    final RegExpMatch? markdownMatch = markdownImageRegExp.firstMatch(markdown);
    if (markdownMatch != null) {
      return markdownMatch.group(1);
    }
    final RegExpMatch? htmlMatch = htmlImageRegExp.firstMatch(markdown);
    if (htmlMatch != null) {
      return htmlMatch.group(1);
    }
    return null;
  }

  /// Extracts first URL under markdown heading like `### Images`.
  String? _extractImageUrlFromImagesSection(String markdown) {
    final List<String> lines = markdown.split("\n");
    bool inImagesSection = false;
    final RegExp urlRegExp = RegExp(r"^https?:\/\/\S+$");
    for (final String line in lines) {
      final String trimmed = line.trim();
      if (trimmed.isEmpty) {
        continue;
      }

      final bool isHeading = trimmed.startsWith("#");
      if (isHeading) {
        final String headingText =
            trimmed.replaceFirst(RegExp(r"^#+\s*"), "").toLowerCase();
        inImagesSection = headingText == "images";
        continue;
      }

      final String normalizedLine = trimmed
          .replaceFirst(RegExp(r"^[-*]\s+"), "")
          .replaceFirst(RegExp(r"^\d+\.\s+"), "");

      if (inImagesSection && urlRegExp.hasMatch(normalizedLine)) {
        return normalizedLine;
      }
    }
    return null;
  }

  /// Extracts text content under markdown heading like `## Overview`.
  String? _extractOverviewFromMarkdown(String markdown) {
    final List<String> lines = markdown.split("\n");
    bool inOverviewSection = false;
    final List<String> overviewLines = <String>[];
    for (final String line in lines) {
      final String trimmed = line.trim();
      final bool isHeading = trimmed.startsWith("#");
      if (isHeading) {
        if (inOverviewSection) {
          break;
        }
        final String headingText =
            trimmed.replaceFirst(RegExp(r"^#+\s*"), "").toLowerCase();
        inOverviewSection = headingText == "overview";
        continue;
      }
      if (!inOverviewSection) {
        continue;
      }
      if (trimmed.isEmpty) {
        if (overviewLines.isNotEmpty && overviewLines.last.isNotEmpty) {
          overviewLines.add("");
        }
        continue;
      }
      final String withoutListPrefix = trimmed
          .replaceFirst(RegExp(r"^[-*]\s+"), "")
          .replaceFirst(RegExp(r"^\d+\.\s+"), "");
      final String normalizedLine = withoutListPrefix
          .replaceAll(RegExp(r"!\[[^\]]*\]\([^)]*\)"), "")
          .replaceAll(RegExp(r"\[([^\]]+)\]\([^)]*\)"), r"$1")
          .trim();
      if (normalizedLine.isNotEmpty) {
        overviewLines.add(normalizedLine);
      }
    }
    if (overviewLines.isEmpty) {
      return null;
    }
    return overviewLines.join(" ").replaceAll(RegExp(r"\s+"), " ").trim();
  }

  /// Extracts project title from a `Title` section with heading fallback.
  String? _extractTitleFromMarkdown(String markdown) {
    final String? titleFromSection = _extractTitleValueFromTitleSection(markdown);
    if (titleFromSection != null && titleFromSection.isNotEmpty) {
      return titleFromSection;
    }
    final List<String> lines = markdown.split("\n");
    for (final String line in lines) {
      final String trimmed = line.trim();
      if (!trimmed.startsWith("#")) {
        continue;
      }
      final String headingText =
          trimmed.replaceFirst(RegExp(r"^#+\s*"), "").trim();
      if (headingText.isNotEmpty) {
        return headingText;
      }
    }
    return null;
  }

  /// Extracts the first value under markdown heading like `## Title`.
  String? _extractTitleValueFromTitleSection(String markdown) {
    final List<String> lines = markdown.split("\n");
    bool inTitleSection = false;
    for (final String line in lines) {
      final String trimmed = line.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final bool isHeading = trimmed.startsWith("#");
      if (isHeading) {
        if (inTitleSection) {
          break;
        }
        final String headingText =
            trimmed.replaceFirst(RegExp(r"^#+\s*"), "").toLowerCase();
        inTitleSection = headingText == "title";
        continue;
      }
      if (!inTitleSection) {
        continue;
      }
      final String normalizedLine = trimmed
          .replaceFirst(RegExp(r"^title\s*:\s*"), "")
          .replaceAll(RegExp(r"!\[[^\]]*\]\([^)]*\)"), "")
          .replaceAll(RegExp(r"\[([^\]]+)\]\([^)]*\)"), r"$1")
          .trim();
      if (normalizedLine.isNotEmpty) {
        return normalizedLine;
      }
    }
    return null;
  }

  /// Extracts Play Store URL, prioritizing README Link section.
  String? _extractPlayStoreUrlFromMarkdown(String markdown) {
    final String? linkSectionUrl = _extractUrlFromLinkSection(markdown);
    final String? playStoreUrlFromLinkSection = _normalizePlayStoreUrl(linkSectionUrl);
    if (playStoreUrlFromLinkSection != null) {
      return playStoreUrlFromLinkSection;
    }
    final RegExp markdownLinkRegExp = RegExp(r"\[[^\]]+\]\((https?:\/\/[^)\s]+)\)");
    final Iterable<RegExpMatch> markdownLinkMatches =
        markdownLinkRegExp.allMatches(markdown);
    for (final RegExpMatch match in markdownLinkMatches) {
      final String? url = _normalizePlayStoreUrl(match.group(1));
      if (url != null) {
        return url;
      }
    }
    final RegExp plainUrlRegExp = RegExp(r"https?:\/\/[^\s)]+");
    final Iterable<RegExpMatch> plainUrlMatches = plainUrlRegExp.allMatches(markdown);
    for (final RegExpMatch match in plainUrlMatches) {
      final String? url = _normalizePlayStoreUrl(match.group(0));
      if (url != null) {
        return url;
      }
    }
    return null;
  }

  /// Extracts first URL under markdown heading like `## Link` or `## Links`.
  String? _extractUrlFromLinkSection(String markdown) {
    final List<String> lines = markdown.split("\n");
    bool inLinkSection = false;
    final RegExp urlRegExp = RegExp(r"https?:\/\/[^\s)]+");
    for (final String line in lines) {
      final String trimmed = line.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final bool isHeading = trimmed.startsWith("#");
      if (isHeading) {
        final String headingText =
            trimmed.replaceFirst(RegExp(r"^#+\s*"), "").toLowerCase();
        if (inLinkSection) {
          break;
        }
        inLinkSection = headingText == "link" || headingText == "links";
        continue;
      }
      if (!inLinkSection) {
        continue;
      }
      final String normalizedLine = trimmed
          .replaceFirst(RegExp(r"^[-*]\s+"), "")
          .replaceFirst(RegExp(r"^\d+\.\s+"), "");
      final RegExpMatch? markdownMatch =
          RegExp(r"\[[^\]]+\]\((https?:\/\/[^)\s]+)\)").firstMatch(normalizedLine);
      if (markdownMatch != null) {
        return markdownMatch.group(1);
      }
      final RegExpMatch? urlMatch = urlRegExp.firstMatch(normalizedLine);
      if (urlMatch != null) {
        return urlMatch.group(0);
      }
    }
    return null;
  }

  /// Normalizes and validates candidate Play Store URL.
  String? _normalizePlayStoreUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) {
      return null;
    }
    String normalized = rawUrl.trim();
    if (normalized.startsWith("<") && normalized.endsWith(">")) {
      normalized = normalized.substring(1, normalized.length - 1);
    }
    normalized = normalized.replaceFirst(RegExp(r"[.,;:!?]+$"), "");
    final Uri? parsed = Uri.tryParse(normalized);
    if (parsed == null) {
      return null;
    }
    final String host = parsed.host.toLowerCase();
    if (host != "play.google.com") {
      return null;
    }
    return normalized;
  }

  /// Normalizes README image URLs to an absolute URL.
  String? _normalizeReadmeImageUrl({
    required String repoFullName,
    required String? defaultBranch,
    required String rawImageUrl,
    required String? readmePath,
  }) {
    final String trimmed = rawImageUrl.trim();
    if (trimmed.startsWith("data:")) {
      return null;
    }
    if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
      final String? normalizedGithubBlobUrl =
          _convertGithubBlobToRaw(trimmed, defaultBranch);
      if (normalizedGithubBlobUrl != null) {
        return normalizedGithubBlobUrl;
      }
      final Uri? parsed = Uri.tryParse(trimmed);
      if (parsed != null &&
          parsed.host.toLowerCase() == "user-images.githubusercontent.com") {
        final String proxyTarget = trimmed.replaceFirst(RegExp(r"^https?:\/\/"), "");
        return "https://images.weserv.nl/?url=$proxyTarget";
      }
      if (parsed != null &&
          parsed.host.toLowerCase() == "github.com" &&
          parsed.pathSegments.isNotEmpty &&
          parsed.pathSegments.first.toLowerCase() == "user-attachments") {
        final String proxyTarget = trimmed.replaceFirst(RegExp(r"^https?:\/\/"), "");
        return "https://images.weserv.nl/?url=$proxyTarget";
      }
      return trimmed;
    }
    if (trimmed.startsWith("//")) {
      return "https:$trimmed";
    }
    final String safeBranch = (defaultBranch == null || defaultBranch.trim().isEmpty)
        ? "main"
        : defaultBranch.trim();
    final String cleanedPath = _resolveRelativeReadmePath(
      rawPath: trimmed,
      readmePath: readmePath,
    );
    return "https://raw.githubusercontent.com/$repoFullName/$safeBranch/$cleanedPath";
  }

  /// Converts github blob URLs to raw content URLs when possible.
  String? _convertGithubBlobToRaw(String url, String? defaultBranch) {
    final Uri? parsed = Uri.tryParse(url);
    if (parsed == null || parsed.host.toLowerCase() != "github.com") {
      return null;
    }
    final List<String> segments = parsed.pathSegments;
    final int blobIndex = segments.indexOf("blob");
    if (blobIndex < 2 || blobIndex + 2 >= segments.length) {
      return null;
    }
    final String owner = segments[0];
    final String repo = segments[1];
    final String branch = segments[blobIndex + 1].isEmpty
        ? ((defaultBranch == null || defaultBranch.trim().isEmpty)
            ? "main"
            : defaultBranch.trim())
        : segments[blobIndex + 1];
    final String path = segments.sublist(blobIndex + 2).join("/");
    if (path.isEmpty) {
      return null;
    }
    return "https://raw.githubusercontent.com/$owner/$repo/$branch/$path";
  }

  /// Resolves image paths that are relative to README location.
  String _resolveRelativeReadmePath({
    required String rawPath,
    required String? readmePath,
  }) {
    String path = rawPath.trim();
    if (path.startsWith("/")) {
      return path.substring(1);
    }
    while (path.startsWith("./")) {
      path = path.substring(2);
    }

    final List<String> baseSegments = <String>[];
    if (readmePath != null && readmePath.contains("/")) {
      baseSegments.addAll(readmePath.split("/")..removeLast());
    }

    while (path.startsWith("../")) {
      path = path.substring(3);
      if (baseSegments.isNotEmpty) {
        baseSegments.removeLast();
      }
    }

    if (baseSegments.isEmpty) {
      return path;
    }
    return "${baseSegments.join("/")}/$path";
  }

  /// Parses repository payload into strongly typed repo models.
  List<GithubRepo> _parseRepos(String responseBody) {
    return List<GithubRepo>.from(
        json.decode(responseBody).map((x) => GithubRepo.fromJson(x)));
  }

  /// Parses organization payload into a list of org login names.
  List<String> _parseOrgLogins(String responseBody) {
    final dynamic decoded = json.decode(responseBody);
    if (decoded is! List) {
      return <String>[];
    }
    return decoded
        .map((dynamic x) => x["login"] as String?)
        .whereType<String>()
        .toList();
  }

  /// Merges repos and de-duplicates them by repository id or full name.
  List<GithubRepo> _mergeAndDeduplicateRepos(List<GithubRepo> repos) {
    final Map<String, GithubRepo> uniqueRepos = <String, GithubRepo>{};
    for (final GithubRepo repo in repos) {
      final String? description = repo.description?.trim();
      if (description == null || description.isEmpty) {
        continue;
      }
      final String dedupeKey = repo.id?.toString() ?? repo.fullName ?? repo.name ?? "";
      if (dedupeKey.isEmpty) {
        continue;
      }
      uniqueRepos[dedupeKey] = repo;
    }
    final List<GithubRepo> mergedRepos = uniqueRepos.values.toList();
    mergedRepos.sort((GithubRepo a, GithubRepo b) {
      final DateTime? aPushedAt = a.pushedAt;
      final DateTime? bPushedAt = b.pushedAt;
      if (aPushedAt == null && bPushedAt == null) {
        return 0;
      }
      if (aPushedAt == null) {
        return 1;
      }
      if (bPushedAt == null) {
        return -1;
      }
      return bPushedAt.compareTo(aPushedAt);
    });
    return mergedRepos;
  }

  List<GithubRepo> getGithubRepo() {
    return githubRepo;
  }

  /// Returns true when this repo originated from repository invitations.
  bool isInvitedRepo(GithubRepo repo) {
    final String? fullName = repo.fullName?.trim();
    if (fullName != null && fullName.isNotEmpty) {
      return _invitedRepoFullNames.contains(fullName);
    }
    final String? ownerLogin = repo.owner?.login?.trim();
    final String? repoName = repo.name?.trim();
    if (ownerLogin == null || ownerLogin.isEmpty || repoName == null || repoName.isEmpty) {
      return false;
    }
    return _invitedRepoFullNames.contains("$ownerLogin/$repoName");
  }

  /// Returns README header image URL for the given repository.
  String? getRepoReadmeHeaderImage(GithubRepo repo) {
    final String? fullName = repo.fullName?.trim();
    if (fullName == null || fullName.isEmpty) {
      return null;
    }
    return _repoReadmeHeaderImageByFullName[fullName];
  }

  /// Returns README Overview text, falling back to repository description.
  String getRepoProjectDescription(GithubRepo repo) {
    final String? fullName = repo.fullName?.trim();
    if (fullName != null && fullName.isNotEmpty) {
      final String? overview = _repoOverviewByFullName[fullName];
      if (overview != null && overview.isNotEmpty) {
        return overview;
      }
    }
    final String? description = repo.description?.trim();
    if (description == null || description.isEmpty) {
      return "No Description";
    }
    return description;
  }

  /// Returns README title text, falling back to repository name.
  String getRepoProjectHeading(GithubRepo repo) {
    final String? fullName = repo.fullName?.trim();
    if (fullName != null && fullName.isNotEmpty) {
      final String? title = _repoTitleByFullName[fullName];
      if (title != null && title.isNotEmpty) {
        return title;
      }
    }
    final String? name = repo.name?.trim();
    if (name == null || name.isEmpty) {
      return "No name";
    }
    return name;
  }

  /// Returns Play Store URL from README Link section or search fallback.
  String getRepoProjectUrl(GithubRepo repo) {
    final String? fullName = repo.fullName?.trim();
    if (fullName != null && fullName.isNotEmpty) {
      final String? playStoreUrl = _repoPlayStoreUrlByFullName[fullName];
      if (playStoreUrl != null && playStoreUrl.isNotEmpty) {
        return playStoreUrl;
      }
    }
    final String projectName = getRepoProjectHeading(repo).trim().isEmpty
        ? (repo.name?.trim().isEmpty ?? true)
            ? "app"
            : repo.name!.trim()
        : getRepoProjectHeading(repo).trim();
    return "https://play.google.com/store/search?q=${Uri.encodeComponent(projectName)}&c=apps";
  }

  void clearGithubRepo() {
    _invitedRepoFullNames.clear();
    _repoReadmeHeaderImageByFullName.clear();
    _repoOverviewByFullName.clear();
    _repoTitleByFullName.clear();
    _repoPlayStoreUrlByFullName.clear();
    _repoSubProjectsByFullName.clear();
    githubRepo = [];
    debugPrint("$githubRepo");
    notifyListeners();
  }
}

class _ReadmeMetadata {
  const _ReadmeMetadata({
    this.imageUrl,
    this.overview,
    this.title,
    this.playStoreUrl,
    this.subProjects = const <_ReadmeSubProject>[],
  });

  final String? imageUrl;
  final String? overview;
  final String? title;
  final String? playStoreUrl;
  final List<_ReadmeSubProject> subProjects;
}

class _ReadmeSubProject {
  const _ReadmeSubProject({
    required this.title,
    required this.overview,
    required this.imageUrl,
    required this.projectUrl,
  });

  final String title;
  final String overview;
  final String imageUrl;
  final String projectUrl;
}
