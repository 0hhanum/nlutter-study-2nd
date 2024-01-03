import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void showFirebaseErrorSnack(BuildContext context, FirebaseException error) {
  final snack = SnackBar(
    showCloseIcon: true,
    content: Text(error.message ?? "Something went wrong"),
  );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}
