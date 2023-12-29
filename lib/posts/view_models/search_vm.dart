import 'dart:async';

import 'package:challenge/posts/models/post_model.dart';
import 'package:challenge/posts/repos/post_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchViewModel extends AsyncNotifier<List<PostModel>> {
  late final PostRepository _repository;

  Future<void> search(String value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _repository.searchPost(value);
      return result.docs
          .map(
            (doc) => PostModel.fromJson({
              ...doc.data(),
              "id": doc.id,
            }),
          )
          .toList();
    });
  }

  @override
  FutureOr<List<PostModel>> build() {
    _repository = ref.read(postRepoProvider);
    return [];
  }
}

final searchProvider = AsyncNotifierProvider<SearchViewModel, List<PostModel>>(
  () => SearchViewModel(),
);
