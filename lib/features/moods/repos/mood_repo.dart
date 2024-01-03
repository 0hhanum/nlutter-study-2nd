import 'package:challenge/features/moods/models/mood_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoodRepository {
  static const moodCollection = "moods";
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createMood(MoodModel mood) async {
    final moodJson = mood.toJson();
    await _db.collection(moodCollection).add(moodJson);
  }
}

final moodRepoProvider = Provider((ref) => MoodRepository());
