import 'package:challenge/commons/utils.dart';
import 'package:challenge/constants/gaps.dart';
import 'package:challenge/constants/sizes.dart';
import 'package:challenge/features/auths/repos/auth_repo.dart';
import 'package:challenge/features/moods/models/mood_model.dart';
import 'package:challenge/features/moods/view_models/post_vm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});

  @override
  PostScreenState createState() => PostScreenState();
}

class PostScreenState extends ConsumerState<PostScreen> {
  Mood? _selectedMood;
  String _text = "";

  void _onSelectMood(Mood mood) {
    setState(() {
      _selectedMood = mood;
    });
  }

  void _onChanged(String value) {
    setState(() {
      _text = value;
    });
  }

  Future<void> _onPost() async {
    if (_selectedMood == null || _text.isEmpty) return;
    final user = ref.read(authRepo).user;
    if (user == null) return;
    final moodModel = MoodModel(
      text: _text,
      uid: user.uid,
      mood: _selectedMood!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await ref.read(postVM.notifier).postMood(moodModel);
    if (!mounted) return;
    if (ref.read(postVM).hasError) {
      showFirebaseErrorSnack(
        context,
        ref.read(postVM).error as FirebaseException,
      );
      return;
    }
    // TODO : add textField controller and init text and mood state
    context.go("/timeline");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gaps.v48,
        const Text(
          "How do you feel?",
          style: TextStyle(
            fontSize: Sizes.size36,
          ),
        ),
        Gaps.v24,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: Mood.values
              .map(
                (mood) => GestureDetector(
                  onTap: () => _onSelectMood(mood),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _selectedMood == mood ? Colors.blue : Colors.grey,
                          Colors.white,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(Sizes.size10),
                    child: Text(
                      mood.emoji,
                      style: const TextStyle(
                        fontSize: Sizes.size32,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        Gaps.v40,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size18),
            child: TextFormField(
              onChanged: _onChanged,
              maxLength: 100,
              maxLines: 5,
              onTapOutside: (e) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _onPost,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size36,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: const Text(
                "Post",
                style: TextStyle(
                  fontSize: Sizes.size44,
                ),
              ),
            ),
          ),
        ),
        Gaps.v40,
      ],
    );
  }
}
