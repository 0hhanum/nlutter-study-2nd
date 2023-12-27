import 'package:challenge/constants/sizes.dart';
import 'package:challenge/navs/thread_main_nav.dart';
import 'package:challenge/posts/view_models/timeline_vm.dart';
import 'package:challenge/utils/utils.dart';
import 'package:challenge/widgets/home_screens/thread_post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThreadHomeScreen extends ConsumerStatefulWidget {
  const ThreadHomeScreen({super.key});

  @override
  ThreadHomeScreenState createState() => ThreadHomeScreenState();
}

class ThreadHomeScreenState extends ConsumerState<ThreadHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  void _scrollListener() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      await ref.read(timelineProvider.notifier).fetchNextPosts();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            body: Stack(
              children: [
                ListView.separated(
                  controller: _scrollController,
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
                if (isLoading)
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: Sizes.size10,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator.adaptive(),
                      ],
                    ),
                  ),
              ],
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
