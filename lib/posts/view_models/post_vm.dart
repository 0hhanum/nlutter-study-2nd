import 'dart:async';
import 'dart:io';

import 'package:challenge/authentications/view_models/auth_vm.dart';
import 'package:challenge/posts/models/post_model.dart';
import 'package:challenge/posts/repos/post_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostViewModel extends AsyncNotifier<void> {
  late final PostRepository _repository;

  Future<void> uploadPost({
    required String contents,
    List<File>? images,
  }) async {
    final List<String> imageURLs = [];
    if (ref.read(authProvider).user == null) {
      return;
    }
    state = const AsyncValue.loading();
    final user = ref.read(authProvider).user!;
    if (images != null) {
      try {
        // upload images
        final tasks = _repository.uploadImages(images: images, uid: user.uid);
        for (UploadTask task in tasks) {
          final snapshot = await task;
          if (snapshot.metadata != null) {
            imageURLs.add(await snapshot.ref.getDownloadURL());
          }
        }
      } catch (error, stackTrace) {
        AsyncValue.error(error, stackTrace);
      }
    }
    final postModel = PostModel(
      id: "",
      contents: contents,
      author: user.displayName ?? "Anonymous",
      authorUid: user.uid,
      imageURLs: imageURLs,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = await AsyncValue.guard(
      () async => await _repository.uploadPost(postModel: postModel),
    );
  }

  @override
  FutureOr build() {
    _repository = ref.read(postRepoProvider);
  }
}

final postProvider =
    AsyncNotifierProvider<PostViewModel, void>(() => PostViewModel());
