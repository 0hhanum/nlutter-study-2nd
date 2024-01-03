import 'package:challenge/commons/utils.dart';
import 'package:challenge/features/auths/screens/widgets/auth_screen.dart';
import 'package:challenge/features/auths/view_models/sign_in_vm.dart';
import 'package:challenge/features/timelines/screens/timeline_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  static const routeURL = "/sign-in";
  static const routeName = "signIn";

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends ConsumerState<SignInScreen> {
  void _goBackToSignUpScreen() {
    context.pop();
  }

  Future<void> _onSignIn(String email, String password) async {
    await ref.read(signInVM.notifier).signIn(email, password);
    if (!context.mounted) return;
    if (ref.read(signInVM).hasError) {
      final error = ref.read(signInVM).error as FirebaseException;
      showFirebaseErrorSnack(context, error);
    } else {
      context.go(TimelineScreen.routeURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: AuthScreen(
        greetingText: "Welcome.",
        buttonText: "Sign In",
        subButtonText: "Don't you have an account?",
        onSubButtonTap: _goBackToSignUpScreen,
        onAuthButtonTap: _onSignIn,
      ),
    );
  }
}
