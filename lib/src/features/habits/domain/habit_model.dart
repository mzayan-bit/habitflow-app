// lib/src/features/habits/domain/habit_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'habit_model.freezed.dart';
part 'habit_model.g.dart';

@unfreezed // Use @unfreezed to allow a mutable field
@HiveType(typeId: 0)
class Habit with _$Habit {
  
  // This factory contains ALL fields that are stored in Hive/Firebase
  factory Habit({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) String? description,
    @HiveField(3) required String category,
    @HiveField(4) required DateTime startDate,
    @HiveField(5) required List<int> weekdays,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) DateTime? updatedAt,
    @HiveField(8) required String userId,
    // --- NEW FIELDS ---
    @HiveField(9) @Default(0xFF6A11CB) int color,
    @HiveField(10) @Default(58831) int iconCode,
    @HiveField(11) @Default("MaterialIcons") String iconFamily,
    
    // --- TEMPORARY UI FIELD ---
    // This is a temporary field for UI state and will not be stored
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool isCompletedToday,

  }) = _Habit;

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);
}