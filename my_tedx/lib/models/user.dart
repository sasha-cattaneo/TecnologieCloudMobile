class User {
  final String username;
  final String password;
  final String image;
  final List<Tag> tags;

  User.fromJSON(Map<String, dynamic> jsonMap) :
    username = jsonMap['username'],
    password = jsonMap['password'],
    image = (jsonMap['image'] ?? ""),
    tags = (jsonMap['tags'] as List<dynamic>)
        .map((e) => Tag.fromJSON(e as Map<String, dynamic>))
        .toList();
}

class Tag {
  final String tag;
  final int score;

  Tag.fromJSON(Map<String, dynamic> jsonMap) : 
    tag = jsonMap['tag'],
    score = jsonMap['score'];
}