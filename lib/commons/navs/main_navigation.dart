import 'package:challenge/features/moods/views/post_screen.dart';
import 'package:challenge/features/moods/views/timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum MainNavigationTab {
  timeline(screen: TimelineScreen(), icon: Icons.home),
  post(screen: PostScreen(), icon: Icons.upload);

  const MainNavigationTab({
    required this.screen,
    required this.icon,
  });

  final Widget screen;
  final IconData icon;
}

class MainNavigation extends StatelessWidget {
  static const String routeName = "home";
  static const String routeURL = "/:tab(timeline|post)";

  MainNavigation({super.key, required String tabString})
      : tab = MainNavigationTab.values.firstWhere(
          (value) => value.name == tabString,
          orElse: () => MainNavigationTab.timeline,
        );

  final MainNavigationTab tab;

  void _onTab(int index, BuildContext context) {
    final selectedTab = MainNavigationTab.values[index];
    context.go("/${selectedTab.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _onTab(index, context),
        currentIndex: tab.index,
        items: MainNavigationTab.values
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                label: tab.name,
              ),
            )
            .toList(),
      ),
      body: Stack(
        children: MainNavigationTab.values
            .map(
              (value) => Offstage(
                offstage: value != tab,
                child: value.screen,
              ),
            )
            .toList(),
      ),
    );
  }
}
