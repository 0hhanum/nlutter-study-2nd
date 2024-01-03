import 'package:challenge/firebase_options.dart';
import 'package:challenge/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: FlutterApp(),
    ),
  );
}

class FlutterApp extends ConsumerWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.read(router),
      theme: ThemeData(
        textTheme: Typography.blackCupertino,
        useMaterial3: true,
      ),
    );
  }
}
