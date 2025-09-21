// lib/src/features/habits/data/habit_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/src/features/auth/data/auth_repository.dart';
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:habitflow/src/shared/services/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

const String habitBoxName = 'box_habits';
const uuid = Uuid();

class HabitRepository {
  late final NotificationService _notificationService;
  HabitRepository(this._ref) {
    _auth = _ref.read(authRepositoryProvider);
    _firestore = _ref.read(firebaseFirestoreProvider);
    // Get the service instance from the provider
    _notificationService = _ref.read(notificationServiceProvider);
  }

  final Ref _ref;
  late final AuthRepository _auth;
  late final FirebaseFirestore _firestore;

  // Helper to get the user-specific collection reference in Firestore
  CollectionReference<Habit> get _habitsCollection => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('habits')
      .withConverter<Habit>(
        fromFirestore: (snapshot, _) => Habit.fromJson(snapshot.data()!),
        toFirestore: (habit, _) => habit.toJson(),
      );

  // Gets the local Hive box
  Future<Box<Habit>> get _habitBox async {
    // This check is good, but should ideally only run once at startup.
    // It's safe to keep here for now.
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitAdapter());
    }
    return await Hive.openBox<Habit>(habitBoxName);
  }

  // --- CRUD Operations ---

  Future<void> addHabit(Habit habit) async {
    final box = await _habitBox;
    final now = DateTime.now();

    // Use copyWith (from freezed) to set timestamps
    // The userId should already be set from the screen.
    final habitWithMeta = habit.copyWith(
      createdAt: now,
      updatedAt: now,
    );

    // 1. Write to local DB immediately for instant UI feedback
    await box.put(habitWithMeta.id, habitWithMeta);
    await _notificationService.scheduleHabitNotification(habitWithMeta);

    // 2. Try to write to Firestore
    try {
      await _habitsCollection.doc(habitWithMeta.id).set(habitWithMeta);
    } catch (e) {
      // For debugging, it's okay. In production, use a logger.
      debugPrint("Failed to sync new habit to Firestore: $e");
    }
  }

  Future<void> updateHabit(Habit habit) async {
    final box = await _habitBox;
    final updatedHabit = habit.copyWith(updatedAt: DateTime.now());

    // 1. Local update
    await box.put(updatedHabit.id, updatedHabit);
    await _notificationService.cancelHabitNotifications(updatedHabit);
    await _notificationService.scheduleHabitNotification(updatedHabit);

    // 2. Remote update
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

    // 1. Local delete
    await box.delete(habitId);
    if (habitToDelete != null) {
      await _notificationService.cancelHabitNotifications(habitToDelete);
    }
    // 2. Remote delete
    try {
      await _habitsCollection.doc(habitId).delete();
    } catch (e) {
      debugPrint("Failed to sync habit deletion to Firestore: $e");
    }
  }

  // Fetches from local Hive box
  Future<List<Habit>> getAllHabits() async {
    final box = await _habitBox;
    return box.values.toList();
  }

  // --- Sync Logic ---

  Future<void> syncHabits() async {
    if (_auth.currentUser == null) return; // Can't sync if logged out

    final box = await _habitBox;
    final localHabits = box.values.toList();
    final localHabitsMap = {for (var h in localHabits) h.id: h};

    try {
      final remoteSnapshot = await _habitsCollection.get();
      final remoteHabits =
          remoteSnapshot.docs.map((doc) => doc.data()).toList();
      final remoteHabitsMap = {for (var h in remoteHabits) h.id: h};

      // 1. Sync remote changes TO local
      for (final remoteHabit in remoteHabits) {
        final localHabit = localHabitsMap[remoteHabit.id];
        if (localHabit == null ||
            (remoteHabit.updatedAt != null &&
                localHabit.updatedAt != null &&
                remoteHabit.updatedAt!.isAfter(localHabit.updatedAt!))) {
          // If habit is new locally or remote is newer, update local
          await box.put(remoteHabit.id, remoteHabit);
        }
      }

      // 2. Sync local changes TO remote
      for (final localHabit in localHabits) {
        final remoteHabit = remoteHabitsMap[localHabit.id];
        if (remoteHabit == null) {
          // If habit exists locally but not remotely, upload it
          await _habitsCollection.doc(localHabit.id).set(localHabit);
        }
      }

      // 3. Clean up local habits that were deleted on another device.
      for (final localId in localHabitsMap.keys) {
        if (!remoteHabitsMap.containsKey(localId)) {
          await box.delete(localId);
        }
      }
    } catch (e) {
      debugPrint("Error during sync: $e");
    }
  }
}

// Provider for Firestore instance
final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// Update the HabitRepository Provider to pass the ref
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(ref);
});

// A provider to trigger and manage the sync process
final syncHabitsProvider = FutureProvider<void>((ref) async {
  final authState = ref.watch(authStateChangesProvider);
  if (authState.asData?.value != null) {
    await ref.watch(habitRepositoryProvider).syncHabits();
    // After syncing, refresh the UI data
    ref.invalidate(allHabitsProvider);
  }
});

// *** ADD THIS BACK IN ***
// Provider to fetch all habits from the local DB. The UI listens to this.
final allHabitsProvider = FutureProvider<List<Habit>>((ref) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getAllHabits();
});