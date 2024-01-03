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
  final String text, uid;
  final Mood mood;
  final int createdAt;

  MoodModel({
    required this.text,
    required this.uid,
    required this.mood,
    required this.createdAt,
  });

  MoodModel.fromJson({
    required this.text,
    required this.uid,
    required mood,
    required this.createdAt,
  }) : mood = Mood.values.firstWhere((value) => value.name == mood);

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "uid": uid,
      "mood": mood.name,
      "createdAt": createdAt,
    };
  }
}
