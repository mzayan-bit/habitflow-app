// lib/src/features/habits/data/habit_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';
import 'package:habitflow/src/features/habits/domain/habit_log_model.dart';
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:habitflow/src/shared/services/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

// FIX: Renamed boxes to '_v2' to clear corrupted data and start fresh
const String habitBoxName = 'box_habits_v2';
const String logBoxName = 'box_logs_v2';
const uuid = Uuid();

String getLogId(String habitId, DateTime date) {
  final normalizedDate = DateTime(date.year, date.month, date.day);
  return '${habitId}_${normalizedDate.year}-${normalizedDate.month}-${normalizedDate.day}';
}

DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

class HabitRepository {
  late final NotificationService _notificationService;
  HabitRepository(this._ref) {
    _auth = _ref.read(authRepositoryProvider);
    _firestore = _ref.read(firebaseFirestoreProvider);
    _notificationService = _ref.read(notificationServiceProvider);
  }

  final Ref _ref;
  late final AuthRepository _auth;
  late final FirebaseFirestore _firestore;

  CollectionReference<Habit> get _habitsCollection => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('habits')
      .withConverter<Habit>(
        fromFirestore: (snapshot, _) => Habit.fromJson(snapshot.data()!),
        toFirestore: (habit, _) => habit.toJson(),
      );

  CollectionReference<HabitLog> get _logsCollection => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('logs')
      .withConverter<HabitLog>(
        fromFirestore: (snapshot, _) => HabitLog.fromJson(snapshot.data()!),
        toFirestore: (log, _) => log.toJson(),
      );

  Future<Box<Habit>> get _habitBox async {
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(HabitAdapter());
    return await Hive.openBox<Habit>(habitBoxName);
  }

  Future<Box<HabitLog>> get _logBox async {
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(HabitLogAdapter());
    return await Hive.openBox<HabitLog>(logBoxName);
  }

  // --- Habit CRUD ---
  Future<void> addHabit(Habit habit) async {
    final box = await _habitBox;
    final now = DateTime.now();
    final habitWithMeta = habit.copyWith(
      createdAt: now,
      updatedAt: now,
    );
    await box.put(habitWithMeta.id, habitWithMeta);
    await _notificationService.scheduleHabitNotification(habitWithMeta);
    try {
      await _habitsCollection.doc(habitWithMeta.id).set(habitWithMeta);
    } catch (e) {
      debugPrint("Failed to sync new habit to Firestore: $e");
    }
  }

  Future<void> updateHabit(Habit habit) async {
    final box = await _habitBox;
    final updatedHabit = habit.copyWith(updatedAt: DateTime.now());
    await box.put(updatedHabit.id, updatedHabit);
    await _notificationService.cancelHabitNotifications(updatedHabit);
    await _notificationService.scheduleHabitNotification(updatedHabit);
    try {
      await _habitsCollection
          .doc(updatedHabit.id)
          .set(updatedHabit, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Failed to sync habit update to Firestore: $e");
    }
  }

  Future<void> deleteHabit(String habitId) async {
    final box = await _habitBox;
    final habitToDelete = box.get(habitId);
    await box.delete(habitId);
    if (habitToDelete != null) {
      await _notificationService.cancelHabitNotifications(habitToDelete);
    }
    // Delete all associated logs
    final logBox = await _logBox;
    final logIdsToDelete = logBox.values
        .where((log) => log.habitId == habitId)
        .map((log) => log.id)
        .toList();
    await logBox.deleteAll(logIdsToDelete);

    // Sync deletions
    try {
      await _habitsCollection.doc(habitId).delete();
      for (var logId in logIdsToDelete) {
        await _logsCollection.doc(logId).delete();
      }
    } catch (e) {
      debugPrint("Failed to sync habit deletion to Firestore: $e");
    }
  }

  Future<List<Habit>> getAllHabits() async {
    final box = await _habitBox;
    return box.values.toList();
  }

  // --- Habit Log Methods ---
  Future<void> toggleHabitLog(String habitId, DateTime date) async {
    final box = await _logBox;
    final normalizedDate = _normalizeDate(date);
    final logId = getLogId(habitId, normalizedDate);
    final existingLog = box.get(logId);

    if (existingLog == null) {
      final newLog = HabitLog(id: logId, habitId: habitId, date: normalizedDate);
      await box.put(logId, newLog);
      try {
        await _logsCollection.doc(logId).set(newLog);
      } catch (e) {
        debugPrint("Failed to sync new log: $e");
      }
    } else {
      await box.delete(logId);
      try {
        await _logsCollection.doc(logId).delete();
      } catch (e) {
        debugPrint("Failed to sync log deletion: $e");
      }
    }
  }

  Future<List<HabitLog>> getLogsForHabit(String habitId) async {
    final box = await _logBox;
    return box.values.where((log) => log.habitId == habitId).toList();
  }

  Future<List<HabitLog>> getAllLogs() async {
    final box = await _logBox;
    return box.values.toList();
  }

  Future<Map<DateTime, int>> getLogsMapForHabit(String habitId) async {
    final box = await _logBox;
    final logs = box.values.where((log) => log.habitId == habitId);
    return {for (var log in logs) _normalizeDate(log.date): log.count};
  }

  Future<bool> isHabitDone(String habitId, DateTime date) async {
    final box = await _logBox;
    final logId = getLogId(habitId, date);
    return box.containsKey(logId);
  }

  // --- Streak Calculation ---
  int calculateStreak(Map<DateTime, int> logDates) {
    if (logDates.isEmpty) return 0;
    int streak = 0;
    DateTime today = _normalizeDate(DateTime.now());
    if (!logDates.containsKey(today)) {
      today = today.subtract(const Duration(days: 1));
    }
    while (logDates.containsKey(today)) {
      streak++;
      today = today.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int calculateOverallStreak(List<Habit> habits, List<HabitLog> logs) {
    if (habits.isEmpty) return 0;

    final logIdSet = logs.map((log) => log.id).toSet();
    int streak = 0;
    DateTime today = _normalizeDate(DateTime.now());

    bool checkDay(DateTime date) {
      final habitsForThisDay =
          habits.where((h) => h.weekdays.contains(date.weekday));
      if (habitsForThisDay.isEmpty) return true;
      return habitsForThisDay.every((h) => logIdSet.contains(getLogId(h.id, date)));
    }

    if (!checkDay(today)) {
      today = today.subtract(const Duration(days: 1));
    }

    while (checkDay(today)) {
      streak++;
      today = today.subtract(const Duration(days: 1));
      if (streak > 365) break; 
    }
    return streak;
  }

  // --- Sync Logic ---
  Future<void> syncHabits() async {
    if (_auth.currentUser == null) return;
    final habitBox = await _habitBox;
    final localHabitsMap = {for (var h in habitBox.values) h.id: h};
    try {
      final remoteSnapshot = await _habitsCollection.get();
      final remoteHabits = remoteSnapshot.docs.map((doc) => doc.data()).toList();
      for (final remoteHabit in remoteHabits) {
        final localHabit = localHabitsMap[remoteHabit.id];
        if (localHabit == null ||
            (remoteHabit.updatedAt != null &&
                localHabit.updatedAt != null &&
                remoteHabit.updatedAt!.isAfter(localHabit.updatedAt!))) {
          await habitBox.put(remoteHabit.id, remoteHabit);
        }
      }
      for (final localHabit in localHabitsMap.values) {
        if (!remoteHabits.any((rh) => rh.id == localHabit.id)) {
          await _habitsCollection.doc(localHabit.id).set(localHabit);
        }
      }
      for (final localId in localHabitsMap.keys) {
        if (!remoteHabits.any((rh) => rh.id == localId)) {
          await habitBox.delete(localId);
        }
      }
    } catch (e) {
      debugPrint("Error during habit sync: $e");
    }
    final logBox = await _logBox;
    final localLogsMap = {for (var log in logBox.values) log.id: log};
    try {
      final remoteLogSnapshot = await _logsCollection.get();
      final remoteLogs = remoteLogSnapshot.docs.map((doc) => doc.data()).toList();
      for (final remoteLog in remoteLogs) {
        if (!localLogsMap.containsKey(remoteLog.id)) {
          await logBox.put(remoteLog.id, remoteLog);
        }
      }
      for (final localLog in localLogsMap.values) {
        if (!remoteLogs.any((rl) => rl.id == localLog.id)) {
          await _logsCollection.doc(localLog.id).set(localLog);
        }
      }
      for (final localId in localLogsMap.keys) {
        if (!remoteLogs.any((rl) => rl.id == localId)) {
          await logBox.delete(localId);
        }
      }
    } catch (e) {
      debugPrint("Error during log sync: $e");
    }
  }
}

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(ref);
});

final syncHabitsProvider = FutureProvider<void>((ref) async {
  final authState = ref.watch(authStateChangesProvider);
  if (authState.asData?.value != null) {
    await ref.watch(habitRepositoryProvider).syncHabits();
    ref.invalidate(allHabitsProvider);
    ref.invalidate(allHabitLogsProvider);
    ref.invalidate(habitsForDayProvider);
    ref.invalidate(habitStreakProvider);
    ref.invalidate(habitLogsMapProvider);
    ref.invalidate(overallStreakProvider);
  }
});

final allHabitsProvider = FutureProvider<List<Habit>>((ref) {
  return ref.watch(habitRepositoryProvider).getAllHabits();
});

final allHabitLogsProvider = FutureProvider<List<HabitLog>>((ref) {
  return ref.watch(habitRepositoryProvider).getAllLogs();
});

final habitByIdProvider =
    FutureProvider.family<Habit?, String>((ref, habitId) async {
  final habits = await ref.watch(allHabitsProvider.future);
  try {
    return habits.firstWhere((habit) => habit.id == habitId);
  } catch (e) {
    return null;
  }
});

final habitsForDayProvider =
    FutureProvider.family<List<Habit>, DateTime>((ref, date) async {
  final allHabits = await ref.watch(allHabitsProvider.future);
  final allLogs = await ref.watch(allHabitLogsProvider.future);
  final normalizedDate = _normalizeDate(date);
  
  final logIdSet = allLogs.map((log) => log.id).toSet();

  final habitsForDay = allHabits.where((habit) {
    return habit.weekdays.contains(normalizedDate.weekday);
  }).toList();

  for (var habit in habitsForDay) {
    final logId = getLogId(habit.id, normalizedDate);
    habit.isCompletedToday = logIdSet.contains(logId);
  }

  return habitsForDay;
});

final isHabitDoneProvider =
    FutureProvider.family<bool, ({String habitId, DateTime date})>(
  (ref, ids) async {
    return ref.watch(habitRepositoryProvider).isHabitDone(ids.habitId, ids.date);
  },
);

final habitLogsMapProvider =
    FutureProvider.family<Map<DateTime, int>, String>((ref, habitId) async {
  final repo = ref.watch(habitRepositoryProvider);
  return repo.getLogsMapForHabit(habitId);
});

final habitStreakProvider =
    FutureProvider.family<int, String>((ref, habitId) async {
  final repo = ref.watch(habitRepositoryProvider);
  final logsMap = await repo.getLogsMapForHabit(habitId);
  return repo.calculateStreak(logsMap);
});

final overallStreakProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(habitRepositoryProvider);
  final habits = await ref.watch(allHabitsProvider.future);
  final logs = await ref.watch(allHabitLogsProvider.future);
  return repo.calculateOverallStreak(habits, logs);
});