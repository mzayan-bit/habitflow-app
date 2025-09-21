// lib/src/features/auth/presentation/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';
import 'package:habitflow/src/features/auth/presentation/login_screen.dart'; // We will create this next
import 'package:habitflow/src/features/habits/presentation/home_screen.dart'; // And this one too

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // User is logged in, show the home screen
          return const HomeScreen();
        } else {
          // User is not logged in, show the login screen
          return const LoginScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Something went wrong: $error')),
      ),
    );
  }
}