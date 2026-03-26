import "package:flutter/services.dart";

class EnvConfig {
  static final Map<String, String> _values = <String, String>{};
  static bool _isLoaded = false;

  /// Loads key-value pairs from the `.env` asset.
  static Future<void> load() async {
    if (_isLoaded) {
      return;
    }
    try {
      final String raw = await rootBundle.loadString(".env", cache: false);
      final List<String> lines = raw.split("\n");
      for (final String line in lines) {
        final String trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith("#")) {
          continue;
        }
        final int separatorIndex = trimmed.indexOf("=");
        if (separatorIndex <= 0) {
          continue;
        }
        final String key = trimmed.substring(0, separatorIndex).trim();
        String value = trimmed.substring(separatorIndex + 1).trim();
        if ((value.startsWith("\"") && value.endsWith("\"")) ||
            (value.startsWith("'") && value.endsWith("'"))) {
          value = value.substring(1, value.length - 1);
        }
        _values[key] = value;
      }
    } catch (_) {}
    _isLoaded = true;
  }

  /// Returns the GitHub token from `--dart-define` or fallback `.env`.
  ///
  /// Prioritizing `--dart-define` makes release/CI builds deterministic,
  /// especially when `.env` is unavailable on the build machine.
  static String get githubToken {
    final String tokenFromDefine = const String.fromEnvironment("GITHUB_TOKEN");
    if (tokenFromDefine.trim().isNotEmpty) {
      return tokenFromDefine.trim();
    }
    final String? tokenFromEnv = _values["GITHUB_TOKEN"];
    if (tokenFromEnv != null && tokenFromEnv.trim().isNotEmpty) {
      return tokenFromEnv.trim();
    }
    return "";
  }

  /// Returns the GitHub proxy endpoint from `--dart-define` or fallback `.env`.
  ///
  /// Example:
  /// `https://your-domain.vercel.app/api/github-proxy`
  static String get githubProxyUrl {
    final String proxyFromDefine = const String.fromEnvironment("GITHUB_PROXY_URL");
    if (proxyFromDefine.trim().isNotEmpty) {
      return proxyFromDefine.trim();
    }
    final String? proxyFromEnv = _values["GITHUB_PROXY_URL"];
    if (proxyFromEnv != null && proxyFromEnv.trim().isNotEmpty) {
      return proxyFromEnv.trim();
    }
    return "";
  }

}
