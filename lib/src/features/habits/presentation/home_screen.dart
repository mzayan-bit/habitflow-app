// lib/src/features/habits/presentation/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';
import 'package:habitflow/src/features/habits/data/habit_repository.dart';
import 'package:habitflow/src/features/habits/presentation/add_habit_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This triggers the sync logic when the home screen is built
    ref.watch(syncHabitsProvider);
    // This gets the habit data for display
    final habitsAsyncValue = ref.watch(allHabitsProvider);
    // This watches the sync state for the loading indicator
    final syncState = ref.watch(syncHabitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
        actions: [
          // Show a loading spinner in the app bar while syncing
          if (syncState.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: habitsAsyncValue.when(
        data: (habits) {
          if (habits.isEmpty) {
            return const Center(
              child: Text('No habits yet. Add one to get started!'),
            );
          }
          return RefreshIndicator(
            // Allow user to pull-to-refresh and trigger a sync
            onRefresh: () async {
              ref.invalidate(syncHabitsProvider);
            },
            child: ListView.builder(
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
            ),
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
        // **FIX**: Code style fix (tooltip before child)
        tooltip: 'Add Habit',
        child: const Icon(Icons.add),
      ),
    );
  }
}