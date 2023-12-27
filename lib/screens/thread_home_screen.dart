import 'package:challenge/constants/sizes.dart';
import 'package:challenge/data/post_data.dart';
import 'package:challenge/navs/thread_main_nav.dart';
import 'package:challenge/posts/view_models/timeline_vm.dart';
import 'package:challenge/utils/utils.dart';
import 'package:challenge/widgets/home_screens/thread_post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThreadHomeScreen extends ConsumerWidget {
  const ThreadHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = isDarkMode(context);
    return ref.watch(timelineProvider).when(
          data: (posts) => Scaffold(
            appBar: AppBar(
              title: SizedBox(
                height: Sizes.size40,
                child: Image.network(
                  threadLogoUrl,
                  color: getTextColorByMode(isDark),
                ),
              ),
            ),
            body: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size14,
              ),
              itemCount: posts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ThreadPostCard(
                  post: posts[index],
                );
              },
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "Something went wrong. Please try again. $error $stackTrace",
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
  }
}
