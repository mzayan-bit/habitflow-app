// lib/src/features/habits/presentation/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitFlow Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome, ${user?.email ?? 'User'}!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}