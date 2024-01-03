import 'dart:async';

import 'package:challenge/features/moods/models/mood_model.dart';
import 'package:challenge/features/moods/repos/mood_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineViewModel extends AsyncNotifier<List<MoodModel>> {
  late final MoodRepository _repository;
  Future<List<MoodModel>> _fetchMoods() async {
    final result = await _repository.getMoods();
    final moodModels = result.docs.map((doc) {
      final json = doc.data();
      json["id"] = doc.id;
      return MoodModel.fromJson(json);
    }).toList();
    return moodModels;
  }

  Future<void> deleteMood(String id) async {
    await _repository.deleteMood(id);
    if (state.value == null) {
      return;
    }
    state.value!.removeWhere((element) => element.id == id);
    state = AsyncData([...state.value!]);
  }

  Future<void> refreshMoods() async {
    final results = await _fetchMoods();
    state = AsyncValue.data(results);
  }

  @override
  FutureOr<List<MoodModel>> build() async {
    _repository = ref.read(moodRepoProvider);
    return await _fetchMoods();
  }
}

final timelineVM = AsyncNotifierProvider<TimelineViewModel, List<MoodModel>>(
  () => TimelineViewModel(),
);
