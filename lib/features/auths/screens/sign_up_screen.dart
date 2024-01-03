import 'package:challenge/commons/utils.dart';
import 'package:challenge/features/auths/screens/sign_in_screen.dart';
import 'package:challenge/features/auths/screens/widgets/auth_screen.dart';
import 'package:challenge/features/auths/view_models/sign_up_vm.dart';
import 'package:challenge/features/timelines/screens/timeline_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  static const routeURL = "/sign-up";
  static const routeName = "signUp";

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  void _goToSignInScreen() {
    context.push(SignInScreen.routeURL);
  }

  Future<void> _onSignUp(String email, String password) async {
    await ref.read(signUpVM.notifier).signUp(email, password);
    if (!context.mounted) return;
    if (ref.read(signUpVM).hasError) {
      final error = ref.read(signUpVM).error as FirebaseException;
      showFirebaseErrorSnack(context, error);
    } else {
      context.go(TimelineScreen.routeURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: AuthScreen(
        greetingText: "Join us.",
        buttonText: "Sign Up",
        subButtonText: "Already have an account?",
        onSubButtonTap: _goToSignInScreen,
        onAuthButtonTap: _onSignUp,
      ),
    );
  }
}
