// lib/src/features/habits/presentation/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';
import 'package:habitflow/src/features/habits/data/habit_repository.dart';
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:habitflow/src/features/habits/presentation/add_habit_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final habitsAsyncValue = ref.watch(allHabitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: habitsAsyncValue.when(
        data: (habits) {
          if (habits.isEmpty) {
            return const Center(child: Text('No habits yet. Add one!'));
          }
          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return ListTile(
                title: Text(habit.title),
                subtitle: Text(habit.category),
                trailing: const Icon(Icons.check_circle_outline),
                onTap: () {
                  // TODO: Navigate to habit detail screen
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddHabitScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Habit',
      ),
    );
  }
}