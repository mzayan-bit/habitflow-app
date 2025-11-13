// lib/src/features/auth/presentation/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/main.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';
import 'package:habitflow/src/features/auth/presentation/login_screen.dart';
import 'package:habitflow/src/shared/widgets/app_shell.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // User is logged in, show the full app shell
          return const AppShell();
        } else {
          // User is not logged in, show the login screen
          return const LoginScreen();
        }
      },
      loading: () => const Scaffold(
        backgroundColor: HabitFlowTheme.darkBg,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: HabitFlowTheme.darkBg,
        body: Center(child: Text('Something went wrong: $error')),
      ),
    );
  }
}