// lib/src/features/habits/data/habit_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

const String habitBoxName = 'box_habits';
const uuid = Uuid();

class HabitRepository {
  Future<Box<Habit>> get _habitBox async {
    // Before using the box, we need to register the adapter
    if (!Hive.isAdapterRegistered(0)) {
       Hive.registerAdapter(HabitAdapter());
    }
    return await Hive.openBox<Habit>(habitBoxName);
  }

  Future<void> addHabit(Habit habit) async {
    final box = await _habitBox;
    // Hive uses keys, so we use the habit's ID as the key
    await box.put(habit.id, habit);
    
    // TODO: Add logic to sync with Firestore
  }
  
  Future<List<Habit>> getAllHabits() async {
    final box = await _habitBox;
    // Return all values from the box as a list
    return box.values.toList();
  }

  Future<void> updateHabit(Habit habit) async {
    // `put` works for both creating and updating
    await addHabit(habit);
  }

  Future<void> deleteHabit(String habitId) async {
    final box = await _habitBox;
    await box.delete(habitId);
    
    // TODO: Add logic to sync deletion with Firestore
  }
}

// Provider for the HabitRepository
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository();
});

// Provider to fetch all habits. `FutureProvider` is great for one-off data fetches.
final allHabitsProvider = FutureProvider<List<Habit>>((ref) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getAllHabits();
});