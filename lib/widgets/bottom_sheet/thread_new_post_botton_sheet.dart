import 'dart:io';

import 'package:challenge/constants/gaps.dart';
import 'package:challenge/constants/sizes.dart';
import 'package:challenge/posts/view_models/post_vm.dart';
import 'package:challenge/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ThreadNewPostBottomSheet extends ConsumerStatefulWidget {
  const ThreadNewPostBottomSheet({super.key});

  @override
  ThreadNewPostBottomSheetState createState() =>
      ThreadNewPostBottomSheetState();
}

class ThreadNewPostBottomSheetState
    extends ConsumerState<ThreadNewPostBottomSheet> {
  bool _hasContent = false;
  String _contents = "";
  List<File> _images = [];

  final TextEditingController _controller = TextEditingController();

  Future<void> _pickImages(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 40,
      requestFullMetadata: false,
    );
    if (image == null) return;

    setState(() {
      _images = [..._images, File(image.path)];
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _onPost() async {
    if (_contents == "") return;
    await ref.read(postProvider.notifier).uploadPost(
          contents: _contents,
        );

    if (!mounted) return;
    if (ref.read(postProvider).hasError) {
      final error = ref.read(postProvider).error as FirebaseException;
      showFirebaseErrorSnack(context, error);
      return;
    }
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _contents = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      height: size.height * 0.85,
      child: Scaffold(
        appBar: _appBar(),
        body: _body(size: size),
      ),
    );
  }

  Padding _body({required Size size}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.size16,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                const Divider(),
                Gaps.v10,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      child: Text(
                        "H",
                      ),
                    ),
                    Gaps.h16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hanum",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            controller: _controller,
                            onChanged: (String value) {
                              setState(() {
                                _hasContent = value != "";
                              });
                            },
                            onTapOutside: (e) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: "Start a thread...",
                            ),
                          ),
                          Gaps.v10,
                          Row(
                            children: List.generate(
                              _images.length,
                              (index) => _selectedImage(index),
                            ),
                          ),
                          Gaps.v10,
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _pickImages(ImageSource.gallery),
                                child: const FaIcon(
                                  FontAwesomeIcons.paperclip,
                                  color: Colors.grey,
                                ),
                              ),
                              Gaps.h14,
                              GestureDetector(
                                onTap: () => _pickImages(ImageSource.camera),
                                child: const FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            width: size.width * 0.9,
            bottom: Sizes.size52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Anyone can reply",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                ref.watch(postProvider).isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : GestureDetector(
                        onTap: _onPost,
                        child: Text(
                          "Post",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _hasContent
                                ? Colors.blueAccent
                                : Colors.blueAccent.shade100,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _selectedImage(int index) {
    return SizedBox(
      width: Sizes.size96,
      height: Sizes.size96,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.file(
                _images[index],
                width: Sizes.size80,
                height: Sizes.size80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: Sizes.size3,
            right: Sizes.size3 + Sizes.size16,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                width: Sizes.size20,
                height: Sizes.size20,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FontAwesomeIcons.minus,
                  color: Colors.white,
                  size: Sizes.size14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "New thread",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 9),
          child: Center(
            child: Text(
              "Cancel",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
