// lib/src/features/habits/domain/habit_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'habit_model.freezed.dart';
part 'habit_model.g.dart';

@freezed
@HiveType(typeId: 0)
class Habit with _$Habit {
  const factory Habit({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) String? description,
    @HiveField(3) required String category,
    @HiveField(4) required DateTime startDate,
    @HiveField(5) required List<int> weekdays,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) DateTime? updatedAt,
    // Add userId for Firestore pathing
    @HiveField(8) required String userId, 
  }) = _Habit;

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);
}