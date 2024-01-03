import 'package:challenge/constants/gaps.dart';
import 'package:challenge/constants/sizes.dart';
import 'package:challenge/features/auths/repos/auth_repo.dart';
import 'package:challenge/features/moods/view_models/timeline_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});
  static const String routeURL = "/timeline";
  void _onLongPress(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Delete post"),
        message: const Text("Are you sure?"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {},
            isDestructiveAction: true,
            child: const Text("Delete"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              context.pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(authRepo).user;
    return ref.watch(timelineVM).when(
          data: (moods) => ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size12,
              vertical: Sizes.size16,
            ),
            itemCount: moods.length,
            separatorBuilder: (context, index) => Gaps.v10,
            itemBuilder: (context, index) {
              final mood = moods[index];
              final isAuthor = currentUser?.uid == mood.uid;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onLongPress: isAuthor ? () => _onLongPress(context) : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Sizes.size16),
                      decoration: BoxDecoration(
                        color: isAuthor
                            ? Colors.black12
                            : Colors.lightGreenAccent.shade400,
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            mood.mood.emoji,
                            style: const TextStyle(fontSize: Sizes.size28),
                          ),
                          Gaps.h10,
                          Text(mood.text),
                        ],
                      ),
                    ),
                  ),
                  Gaps.v8,
                  Text(
                    timeAgo.format(
                      DateTime.fromMillisecondsSinceEpoch(mood.createdAt),
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              );
            },
          ),
          error: (error, stackTrace) =>
              Center(child: Text("Something went wrong. $error")),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
        );
  }
}
