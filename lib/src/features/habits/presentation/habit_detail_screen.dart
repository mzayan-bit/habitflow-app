// lib/src/features/habits/presentation/habit_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/main.dart';
import 'package:habitflow/src/features/habits/data/habit_repository.dart';
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:habitflow/src/features/habits/presentation/add_habit_screen.dart';

class HabitDetailScreen extends ConsumerWidget {
  final String habitId;
  const HabitDetailScreen({super.key, required this.habitId});

  void _deleteHabit(BuildContext context, WidgetRef ref, Habit habit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: HabitFlowTheme.darkSurface,
        title:
            const Text("Delete Habit?", style: TextStyle(color: Colors.white)),
        content: Text(
            "Are you sure you want to delete '${habit.title}'? This action cannot be undone.",
            style: const TextStyle(color: HabitFlowTheme.kWhite70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(habitRepositoryProvider).deleteHabit(habit.id);
              ref.invalidate(allHabitsProvider);
              ref.invalidate(habitsForDayProvider);
              ref.invalidate(habitStreakProvider);
              ref.invalidate(habitLogsMapProvider);
              if (context.mounted) {
                Navigator.of(ctx).pop(); // Close dialog
                Navigator.of(context).pop(); // Close detail screen
              }
            },
            child:
                const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitAsync = ref.watch(habitByIdProvider(habitId));
    final logsAsync = ref.watch(habitLogsMapProvider(habitId));
    final streakAsync = ref.watch(habitStreakProvider(habitId));

    return Scaffold(
      backgroundColor: HabitFlowTheme.darkBg,
      appBar: AppBar(
        backgroundColor: HabitFlowTheme.darkBg,
        title: habitAsync.when(
          data: (habit) => Text(habit?.title ?? "Habit Details"),
          loading: () => const Text("Loading..."),
          error: (e, s) => const Text("Error"),
        ),
        actions: [
          habitAsync.when(
            data: (habit) {
              if (habit == null) return const SizedBox.shrink();
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                AddHabitScreen(habitToEdit: habit))),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteHabit(context, ref, habit),
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (e, s) => const SizedBox.shrink(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- STREAK CARD ---
              streakAsync.when(
                data: (streak) => Card(
                  color: HabitFlowTheme.darkSurface,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Colors.orange, size: 30),
                        const SizedBox(width: 10),
                        Text(
                          "$streak Day Streak",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const SizedBox(),
              ),
              const SizedBox(height: 30),
              // --- CALENDAR HEATMAP ---
              const Text(
                "Completion History",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                color: HabitFlowTheme.darkSurface,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: logsAsync.when(
                    data: (logs) => HeatMapCalendar(
                      datasets: logs,
                      colorsets: {
                        1: habitAsync.value?.color != null
                            ? Color(habitAsync.value!.color)
                            : HabitFlowTheme.primaryColor,
                      },
                      defaultColor: Colors.transparent,
                      textColor: Colors.white,
                      monthFontSize: 16,
                      weekFontSize: 12,
                      weekTextColor: Colors.white70,
                      colorMode: ColorMode.color,
                      showColorTip: false,
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, s) => const Center(
                        child: Text("Could not load history",
                            style: TextStyle(color: Colors.red))),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // --- NOTES SECTION ---
              const Text(
                "Notes",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Card(
                color: HabitFlowTheme.darkSurface,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Notes feature coming soon. You'll be able to add notes for each completion!",
                    style: TextStyle(color: HabitFlowTheme.kWhite70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}