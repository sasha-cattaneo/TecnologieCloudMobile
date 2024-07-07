class Video {
  final String id;
  final String title;
  final String speaker;
  final String url;
  final String description;
  final String duration;
  final String publishedAt;
  final String urlImage;

  Video.fromJSON(Map<String, dynamic> jsonMap) :
    id = jsonMap['_id'],
    title = jsonMap['title'],
    speaker = (jsonMap['speakers'] ?? ""),
    url = (jsonMap['url'] ?? ""),
    description = (jsonMap['description'] ?? ""),
    duration = (jsonMap['duration'] ?? ""),
    publishedAt = (jsonMap['publishedAt'] ?? ""),
    urlImage = (jsonMap['url_image'] ?? "");
}