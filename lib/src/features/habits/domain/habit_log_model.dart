// lib/src/features/habits/domain/habit_log_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'habit_log_model.freezed.dart';
part 'habit_log_model.g.dart';

@freezed
@HiveType(typeId: 1) // IMPORTANT: New unique typeId
class HabitLog with _$HabitLog {
  const factory HabitLog({
    @HiveField(0) required String id,
    @HiveField(1) required String habitId,
    @HiveField(2) required DateTime date, // The day it was completed for
    @HiveField(3) @Default(1) int count, // For multi-rep habits
  }) = _HabitLog;

  factory HabitLog.fromJson(Map<String, dynamic> json) => _$HabitLogFromJson(json);
}