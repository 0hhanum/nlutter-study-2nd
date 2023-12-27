class PostModel {
  final String id, contents, author, authorUid;
  final List<String> imageURLs;
  final int createdAt;

  PostModel({
    required this.id,
    required this.contents,
    required this.author,
    required this.authorUid,
    required this.imageURLs,
    required this.createdAt,
  });

  PostModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        contents = json["contents"],
        author = json["author"],
        authorUid = json["authorUid"],
        imageURLs = List<String>.from(json["imageURLs"]),
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "contents": contents,
      "author": author,
      "authorUid": authorUid,
      "imageURLs": imageURLs,
      "createdAt": createdAt,
    };
  }
}
