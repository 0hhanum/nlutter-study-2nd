import 'dart:async';

import 'package:challenge/posts/models/post_model.dart';
import 'package:challenge/posts/repos/post_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineViewModel extends AsyncNotifier<List<PostModel>> {
  late final PostRepository _repository;

  Future<List<PostModel>> _fetchPosts({int? lastItemCreatedAt}) async {
    final result =
        await _repository.fetchPosts(lastItemCreatedAt: lastItemCreatedAt);
    final posts = result.docs.map(
      (doc) => PostModel.fromJson({
        ...doc.data(),
        "id": doc.id,
      }),
    );
    print(posts);
    return posts.toList();
  }

  Future<void> fetchNextPosts() async {
    if (state.value == null) return;
    final newPosts =
        await _fetchPosts(lastItemCreatedAt: state.value!.last.createdAt);
    state = AsyncValue.data([...state.value!, ...newPosts]);
  }

  @override
  FutureOr<List<PostModel>> build() async {
    _repository = ref.read(postRepoProvider);
    return await _fetchPosts();
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<PostModel>>(
  () => TimelineViewModel(),
);
