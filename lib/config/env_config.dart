/// Build-time configuration, passed with `--dart-define`.
///
/// Never bundle secrets as Flutter assets: on web every asset is publicly downloadable.
/// Prefer GITHUB_PROXY_URL (token stays on the server in `api/`) over GITHUB_TOKEN.
class EnvConfig {
  static const String githubToken = String.fromEnvironment("GITHUB_TOKEN");
  static const String githubProxyUrl = String.fromEnvironment("GITHUB_PROXY_URL");
}
