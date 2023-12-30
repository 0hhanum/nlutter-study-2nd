import 'package:challenge/constants/sizes.dart';
import 'package:challenge/data/thread_search_data.dart';
import 'package:challenge/posts/view_models/search_vm.dart';
import 'package:challenge/screens/widgets/user_list.dart';
import 'package:challenge/utils/utils.dart';
import 'package:challenge/widgets/home_screens/thread_post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThreadSearchScreen extends ConsumerStatefulWidget {
  const ThreadSearchScreen({super.key});

  @override
  ThreadSearchScreenState createState() => ThreadSearchScreenState();
}

class ThreadSearchScreenState extends ConsumerState<ThreadSearchScreen> {
  bool _isSearching = false;

  void _onChanged(String value) {
    if (value.isEmpty && _isSearching) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _onSearch(String value) async {
    if (value.isEmpty) return;
    setState(() {
      _isSearching = true;
    });
    await ref.read(searchProvider.notifier).search(value);
  }

  final List<ThreadSearchData> _searchData = List.generate(
    threadSearchData.length,
    (index) {
      final data = threadSearchData[index];
      return ThreadSearchData(
        nickname: data["nickname"],
        subtitle: data["subtitle"],
        followers: data["followers"],
      );
    },
  );

  final String fakeImageUrl = "https://picsum.photos/200/300";

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: _appBar(),
        body: _isSearching
            ? ref.watch(searchProvider).when(
                  data: (posts) => ListView.separated(
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
                  error: (error, stackTrace) => Center(
                    child: Text("Something went wrong. $error \n $stackTrace"),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
            : UserList(
                searchData: _searchData,
                isDark: isDark,
                fakeImageUrl: fakeImageUrl,
              ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Row(
        children: [
          Text(
            "Search",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Sizes.size28,
            ),
          ),
        ],
      ),
      bottom: _appBarBottom(),
    );
  }

  PreferredSize _appBarBottom() {
    final isDark = isDarkMode(context);
    return PreferredSize(
      preferredSize: const Size.fromHeight(
        Sizes.size36,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size16,
        ),
        child: CupertinoSearchTextField(
          autocorrect: false,
          onSubmitted: _onSearch,
          onChanged: _onChanged,
          style: TextStyle(
            color: getTextColorByMode(isDark),
          ),
        ),
      ),
    );
  }
}
