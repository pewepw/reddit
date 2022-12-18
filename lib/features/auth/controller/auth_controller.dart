// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/repository/auth_repository.dart';

import '../../../core/utils.dart';
import '../../../model/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false); //Loading state

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (error) => showSnackBar(context, error.message),
      (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }
}
