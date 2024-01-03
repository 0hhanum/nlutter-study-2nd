import 'package:challenge/constants/gaps.dart';
import 'package:challenge/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  final String greetingText, buttonText, subButtonText;
  final Function(String email, String password) onAuthButtonTap;
  final void Function() onSubButtonTap;

  const AuthScreen({
    super.key,
    required this.greetingText,
    required this.buttonText,
    required this.subButtonText,
    required this.onAuthButtonTap,
    required this.onSubButtonTap,
  });

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  final passwordLength = 6;
  Future<void> _onSubmit() async {
    if (_formKey.currentState == null) return;
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      await widget.onAuthButtonTap(_formData["email"]!, _formData["password"]!);
    }
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is required.";
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password is required.";
    }
    if (password.length < passwordLength) {
      return "Password has to longer than $passwordLength.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Gaps.v40,
        Container(
          color: Colors.lightGreen,
          alignment: Alignment.centerRight,
          child: Text(
            widget.greetingText,
            style: const TextStyle(
              fontSize: Sizes.size64,
            ),
          ),
        ),
        Gaps.v48,
        Expanded(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(
                right: Sizes.size64,
              ),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                    validator: (value) => _validateEmail(value),
                    onSaved: (newValue) => _formData["email"] = newValue!,
                  ),
                  Gaps.v12,
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    validator: (value) => _validatePassword(value),
                    onSaved: (newValue) => _formData["password"] = newValue!,
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: [
            GestureDetector(
              onTap: widget.onSubButtonTap,
              child: Text(
                widget.subButtonText,
              ),
            ),
            Gaps.v8,
            GestureDetector(
              onTap: _onSubmit,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size24,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Text(
                  widget.buttonText,
                  style: const TextStyle(
                    fontSize: Sizes.size44,
                  ),
                ),
              ),
            ),
          ],
        ),
        Gaps.v72,
      ],
    );
  }
}
