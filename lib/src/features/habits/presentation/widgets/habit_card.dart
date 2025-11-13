// lib/src/features/habits/presentation/widgets/habit_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/main.dart';
import 'package:habitflow/src/features/habits/data/habit_repository.dart';
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:habitflow/src/features/habits/presentation/add_habit_screen.dart';
import 'package:habitflow/src/features/habits/presentation/habit_detail_screen.dart';

class HabitCard extends ConsumerWidget {
  final Habit habit;
  final DateTime date;

  const HabitCard({
    super.key,
    required this.habit,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDoneAsync =
        ref.watch(isHabitDoneProvider((habitId: habit.id, date: date)));

    void toggleCompletion() {
      ref.read(habitRepositoryProvider).toggleHabitLog(habit.id, date);
      ref.invalidate(isHabitDoneProvider((habitId: habit.id, date: date)));
      ref.invalidate(habitsForDayProvider(date));
      ref.invalidate(allHabitLogsProvider);
      ref.invalidate(overallStreakProvider);
    }

    return isDoneAsync.when(
      data: (isDone) => Dismissible(
        key: Key(habit.id),
        background: _buildDismissibleBackground(
            Alignment.centerLeft, Colors.green, Icons.check),
        secondaryBackground: _buildDismissibleBackground(
            Alignment.centerRight, Colors.blue, Icons.edit),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            toggleCompletion();
          }
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            return true;
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddHabitScreen(habitToEdit: habit)));
            return false;
          }
        },
        child: Card(
          color: isDone
              ? Color(habit.color).withAlpha(77) // 0.3 opacity
              : HabitFlowTheme.darkSurface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HabitDetailScreen(habitId: habit.id)));
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(habit.color).withAlpha(51), // 0.2 opacity
                    child: Icon(
                      // --- FIX: Access .data from the IconPickerIcon wrapper ---
                      (deserializeIcon(Map<String, dynamic>.from({
                        'key': habit.iconFamily,
                        'data': habit.iconCode
                      }))?.data) ?? Icons.task_alt, 
                      color: Color(habit.color),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Once per day",
                          style: TextStyle(
                              color: HabitFlowTheme.kWhite70.withAlpha(204), // 0.8 opacity
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Transform.scale(
                    scale: 1.4,
                    child: Checkbox(
                      value: isDone,
                      activeColor: Color(habit.color),
                      checkColor: Colors.white,
                      side: const BorderSide(color: Colors.white54, width: 2),
                      shape: const CircleBorder(),
                      onChanged: (val) => toggleCompletion(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      loading: () => const Card(
          color: HabitFlowTheme.darkSurface,
          child: SizedBox(
              height: 90, child: Center(child: CircularProgressIndicator()))),
      error: (e, s) =>
          Card(color: Colors.red, child: Center(child: Text("Error: $e"))),
    );
  }

  Widget _buildDismissibleBackground(
      Alignment alignment, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Icon(icon, color: Colors.white),
    );
  }
}