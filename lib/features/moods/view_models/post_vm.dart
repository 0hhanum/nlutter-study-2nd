import 'dart:async';

import 'package:challenge/features/moods/models/mood_model.dart';
import 'package:challenge/features/moods/repos/mood_repo.dart';
import 'package:challenge/features/moods/view_models/timeline_vm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostViewModel extends AsyncNotifier<void> {
  late final MoodRepository _repository;

  Future<void> postMood(MoodModel mood) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createMood(mood);
      await ref.read(timelineVM.notifier).refreshMoods();
    });
  }

  @override
  FutureOr<void> build() {
    _repository = ref.read(moodRepoProvider);
  }
}

final postVM =
    AsyncNotifierProvider<PostViewModel, void>(() => PostViewModel());
