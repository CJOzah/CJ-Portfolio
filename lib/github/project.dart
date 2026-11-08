/// A portfolio-ready app, as stored in web/projects.json.
/// Holds only display-safe fields: never source code or tokens.
class Project {
  final String id;
  final String title;
  final String summary;
  final String? image;
  final String? storeUrl;
  final String? sourceUrl; // null for private repos
  final String? language;
  final int stars;
  final DateTime? updated;
  final String? owner;
  final bool isOrg;
  final bool isPrivate;

  const Project({
    required this.id,
    required this.title,
    required this.summary,
    this.image,
    this.storeUrl,
    this.sourceUrl,
    this.language,
    this.stars = 0,
    this.updated,
    this.owner,
    this.isOrg = false,
    this.isPrivate = false,
  });

  Project withImage(String? image) => Project(
        id: id,
        title: title,
        summary: summary,
        image: image,
        storeUrl: storeUrl,
        sourceUrl: sourceUrl,
        language: language,
        stars: stars,
        updated: updated,
        owner: owner,
        isOrg: isOrg,
        isPrivate: isPrivate,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "summary": summary,
        "image": image,
        "storeUrl": storeUrl,
        "sourceUrl": sourceUrl,
        "language": language,
        "stars": stars,
        "updated": updated?.toIso8601String(),
        "owner": owner,
        "isOrg": isOrg,
        "isPrivate": isPrivate,
      };

  factory Project.fromJson(Map<String, dynamic> j) => Project(
        id: j["id"] as String,
        title: j["title"] as String,
        summary: j["summary"] as String? ?? "",
        image: j["image"] as String?,
        storeUrl: j["storeUrl"] as String?,
        sourceUrl: j["sourceUrl"] as String?,
        language: j["language"] as String?,
        stars: j["stars"] as int? ?? 0,
        updated: DateTime.tryParse(j["updated"] as String? ?? ""),
        owner: j["owner"] as String?,
        isOrg: j["isOrg"] as bool? ?? false,
        isPrivate: j["isPrivate"] as bool? ?? false,
      );
}
