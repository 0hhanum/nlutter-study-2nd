import 'dart:async';

import 'package:challenge/features/auths/repos/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.signUp(email, password);
    });
  }

  @override
  FutureOr<void> build() {
    _repository = AuthenticationRepository();
  }
}

final signUpVM =
    AsyncNotifierProvider<SignUpViewModel, void>(() => SignUpViewModel());
