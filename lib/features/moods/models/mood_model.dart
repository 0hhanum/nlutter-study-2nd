enum Mood {
  happy(emoji: "😊"),
  sad(emoji: "🥲"),
  lovely(emoji: "🥰"),
  surprised(emoji: "😱"),
  tired(emoji: "🥵"),
  ;

  const Mood({
    required this.emoji,
  });

  final String emoji;
}

class MoodModel {
  final String text, uid, id;
  final Mood mood;
  final int createdAt;

  MoodModel({
    required this.id,
    required this.text,
    required this.uid,
    required this.mood,
    required this.createdAt,
  });

  MoodModel.fromJson(Map<String, dynamic> json)
      : text = json["text"]!,
        uid = json["uid"]!,
        createdAt = json["createdAt"]!,
        mood = Mood.values.firstWhere((value) => value.name == json["mood"]),
        id = json["id"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "uid": uid,
      "mood": mood.name,
      "createdAt": createdAt,
    };
  }
}
