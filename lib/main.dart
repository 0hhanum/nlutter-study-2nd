import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(
    const FlutterApp(),
  );
}

class FlutterApp extends ConsumerWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp();
  }
}
