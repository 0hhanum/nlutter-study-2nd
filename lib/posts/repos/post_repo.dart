import 'dart:io';

import 'package:challenge/posts/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostRepository {
  static const _postCollection = "threadPost";
  static const _fetchLimit = 5;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadPost({
    required PostModel postModel,
  }) async {
    await _db.collection(_postCollection).add(postModel.toJson());
  }

  List<UploadTask> uploadImages({
    required List<File> images,
    required String uid,
  }) {
    final List<UploadTask> imageTasks = [];
    final imagePath =
        "/threadImages/$uid/${DateTime.now().millisecondsSinceEpoch}"; // 같은 포스트의 이미지는 동일 디렉토리에

    for (File image in images) {
      final ref = _storage
          .ref()
          .child("$imagePath/${DateTime.now().microsecondsSinceEpoch}.jpg");
      final task = ref.putFile(image);
      imageTasks.add(task);
    }
    return imageTasks;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchPosts({
    int? lastItemCreatedAt,
  }) {
    const orderBy = "createdAt";
    final query = _db
        .collection(_postCollection)
        .orderBy(orderBy, descending: true)
        .limit(_fetchLimit);
    if (lastItemCreatedAt == null) {
      return query.get();
    }
    return query.startAfter([lastItemCreatedAt]).get();
  }
}

final postRepoProvider = Provider((ref) => PostRepository());
