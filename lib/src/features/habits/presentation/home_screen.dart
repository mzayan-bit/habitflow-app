// lib/src/features/habits/presentation/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/main.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';
import 'package:habitflow/src/features/habits/data/habit_repository.dart';
import 'package:habitflow/src/features/habits/presentation/add_habit_screen.dart';
import 'package:habitflow/src/features/habits/presentation/widgets/habit_card.dart';
import 'package:habitflow/src/shared/widgets/app_shell.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// FIX: Added imports for strict typing
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:habitflow/src/features/habits/domain/habit_log_model.dart';

DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final normalizedDate = _normalizeDate(DateTime.now());
    final habitsAsync = ref.watch(habitsForDayProvider(normalizedDate));
    final allLogsAsync = ref.watch(allHabitLogsProvider);
    final streakAsync = ref.watch(overallStreakProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Flow",
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.notifications, color: HabitFlowTheme.kWhite70),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: HabitFlowTheme.primaryColor,
              child: Text(
                user?.email?[0].toUpperCase() ??
                    (user?.isAnonymous ?? false ? "G" : "?"),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(syncHabitsProvider),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- GREETING ---
                Text(
                  "${_getGreeting()}, ${user?.displayName ?? (user?.isAnonymous ?? false ? 'Guest' : 'User')} 🌞",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Text(
                  "Here’s your flow for today!",
                  style:
                      TextStyle(fontSize: 16, color: HabitFlowTheme.kWhite70),
                ),
                const SizedBox(height: 24),

                // --- PROGRESS OVERVIEW CARD ---
                _buildProgressCard(
                    context, habitsAsync, allLogsAsync, streakAsync),

                const SizedBox(height: 24),
                // --- HABIT LIST ---
                const Text(
                  "Today's Habits",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                habitsAsync.when(
                  data: (habits) {
                    if (habits.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text("No habits for today. Add one!",
                              style:
                                  TextStyle(color: HabitFlowTheme.kWhite70)),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: habits.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        return HabitCard(habit: habit, date: normalizedDate);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(
                      child: Text("Error: $e",
                          style: const TextStyle(color: Colors.red))),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddHabitScreen()));
        },
        tooltip: 'Add Habit',
        child: const Icon(Icons.add),
      ),
    );
  }

  // FIX: Added Strict Types <List<Habit>>, etc. to AsyncValue parameters
  Widget _buildProgressCard(
      BuildContext context,
      AsyncValue<List<Habit>> habitsAsync,
      AsyncValue<List<HabitLog>> allLogsAsync,
      AsyncValue<int> streakAsync) {
    return habitsAsync.when(
      data: (habits) {
        // Now 'habits' is strictly List<Habit>, so .where() works correctly
        final completed = habits.where((h) => h.isCompletedToday).length;
        final total = habits.length;
        final percent = total > 0 ? (completed / total) : 0.0;

        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const AppShell(initialIndex: 1)));
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: HabitFlowTheme.darkSurface,
              gradient: LinearGradient(
                colors: [
                  HabitFlowTheme.primaryColor.withAlpha(128),
                  HabitFlowTheme.darkSurface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // --- Circular Progress ---
                Expanded(
                  flex: 2,
                  child: CircularPercentIndicator(
                    radius: 55.0,
                    lineWidth: 10.0,
                    percent: percent,
                    center: Text(
                      "${(percent * 100).toInt()}%",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: HabitFlowTheme.darkBg,
                    progressColor: HabitFlowTheme.primaryColor,
                  ),
                ),
                // --- Text Stats ---
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$completed of $total Habits",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Text(
                        "Completed today",
                        style: TextStyle(
                            fontSize: 14, color: HabitFlowTheme.kWhite70),
                      ),
                      const SizedBox(height: 10),
                      streakAsync.when(
                        data: (streak) => Text(
                          "🔥 $streak Day Streak",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        loading: () => const Text("Loading streak..."),
                        error: (e, s) => const Text("🔥 0 Day Streak"),
                      ),
                      const Text(
                        "Current overall streak",
                        style: TextStyle(
                            fontSize: 14, color: HabitFlowTheme.kWhite70),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Center(child: Text("Error loading progress")),
    );
  }
}