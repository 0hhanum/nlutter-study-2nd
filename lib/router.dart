import 'package:challenge/commons/navs/main_navigation.dart';
import 'package:challenge/features/auths/repos/auth_repo.dart';
import 'package:challenge/features/auths/screens/sign_in_screen.dart';
import 'package:challenge/features/auths/screens/sign_up_screen.dart';
import 'package:challenge/features/timelines/screens/timeline_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final router = Provider(
  (ref) => GoRouter(
    initialLocation: TimelineScreen.routeURL,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.matchedLocation != SignUpScreen.routeURL &&
            state.matchedLocation != SignInScreen.routeURL) {
          return SignUpScreen.routeURL;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeURL,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: SignInScreen.routeName,
        path: SignInScreen.routeURL,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        name: MainNavigation.routeName,
        path: MainNavigation.routeURL,
        builder: (context, state) => const MainNavigation(),
      ),
    ],
  ),
);
