// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Habit _$HabitFromJson(Map<String, dynamic> json) {
  return _Habit.fromJson(json);
}

/// @nodoc
mixin _$Habit {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(0)
  set id(String value) => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(1)
  set title(String value) => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(2)
  set description(String? value) => throw _privateConstructorUsedError;
  @HiveField(3)
  String get category => throw _privateConstructorUsedError;
  @HiveField(3)
  set category(String value) => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get startDate => throw _privateConstructorUsedError;
  @HiveField(4)
  set startDate(DateTime value) => throw _privateConstructorUsedError;
  @HiveField(5)
  List<int> get weekdays => throw _privateConstructorUsedError;
  @HiveField(5)
  set weekdays(List<int> value) => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(6)
  set createdAt(DateTime value) => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(7)
  set updatedAt(DateTime? value) => throw _privateConstructorUsedError;
  @HiveField(8)
  String get userId => throw _privateConstructorUsedError;
  @HiveField(8)
  set userId(String value) =>
      throw _privateConstructorUsedError; // --- NEW FIELDS ---
  @HiveField(9)
  int get color => throw _privateConstructorUsedError; // --- NEW FIELDS ---
  @HiveField(9)
  set color(int value) => throw _privateConstructorUsedError;
  @HiveField(10)
  int get iconCode => throw _privateConstructorUsedError;
  @HiveField(10)
  set iconCode(int value) => throw _privateConstructorUsedError;
  @HiveField(11)
  String get iconFamily => throw _privateConstructorUsedError;
  @HiveField(11)
  set iconFamily(String value) =>
      throw _privateConstructorUsedError; // --- TEMPORARY UI FIELD ---
// This is a temporary field for UI state and will not be stored
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isCompletedToday =>
      throw _privateConstructorUsedError; // --- TEMPORARY UI FIELD ---
// This is a temporary field for UI state and will not be stored
  @JsonKey(includeFromJson: false, includeToJson: false)
  set isCompletedToday(bool value) => throw _privateConstructorUsedError;

  /// Serializes this Habit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitCopyWith<Habit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitCopyWith<$Res> {
  factory $HabitCopyWith(Habit value, $Res Function(Habit) then) =
      _$HabitCopyWithImpl<$Res, Habit>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String? description,
      @HiveField(3) String category,
      @HiveField(4) DateTime startDate,
      @HiveField(5) List<int> weekdays,
      @HiveField(6) DateTime createdAt,
      @HiveField(7) DateTime? updatedAt,
      @HiveField(8) String userId,
      @HiveField(9) int color,
      @HiveField(10) int iconCode,
      @HiveField(11) String iconFamily,
      @JsonKey(includeFromJson: false, includeToJson: false)
      bool isCompletedToday});
}

/// @nodoc
class _$HabitCopyWithImpl<$Res, $Val extends Habit>
    implements $HabitCopyWith<$Res> {
  _$HabitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? category = null,
    Object? startDate = null,
    Object? weekdays = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? userId = null,
    Object? color = null,
    Object? iconCode = null,
    Object? iconFamily = null,
    Object? isCompletedToday = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekdays: null == weekdays
          ? _value.weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      iconCode: null == iconCode
          ? _value.iconCode
          : iconCode // ignore: cast_nullable_to_non_nullable
              as int,
      iconFamily: null == iconFamily
          ? _value.iconFamily
          : iconFamily // ignore: cast_nullable_to_non_nullable
              as String,
      isCompletedToday: null == isCompletedToday
          ? _value.isCompletedToday
          : isCompletedToday // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HabitImplCopyWith<$Res> implements $HabitCopyWith<$Res> {
  factory _$$HabitImplCopyWith(
          _$HabitImpl value, $Res Function(_$HabitImpl) then) =
      __$$HabitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String? description,
      @HiveField(3) String category,
      @HiveField(4) DateTime startDate,
      @HiveField(5) List<int> weekdays,
      @HiveField(6) DateTime createdAt,
      @HiveField(7) DateTime? updatedAt,
      @HiveField(8) String userId,
      @HiveField(9) int color,
      @HiveField(10) int iconCode,
      @HiveField(11) String iconFamily,
      @JsonKey(includeFromJson: false, includeToJson: false)
      bool isCompletedToday});
}

/// @nodoc
class __$$HabitImplCopyWithImpl<$Res>
    extends _$HabitCopyWithImpl<$Res, _$HabitImpl>
    implements _$$HabitImplCopyWith<$Res> {
  __$$HabitImplCopyWithImpl(
      _$HabitImpl _value, $Res Function(_$HabitImpl) _then)
      : super(_value, _then);

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? category = null,
    Object? startDate = null,
    Object? weekdays = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? userId = null,
    Object? color = null,
    Object? iconCode = null,
    Object? iconFamily = null,
    Object? isCompletedToday = null,
  }) {
    return _then(_$HabitImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekdays: null == weekdays
          ? _value.weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      iconCode: null == iconCode
          ? _value.iconCode
          : iconCode // ignore: cast_nullable_to_non_nullable
              as int,
      iconFamily: null == iconFamily
          ? _value.iconFamily
          : iconFamily // ignore: cast_nullable_to_non_nullable
              as String,
      isCompletedToday: null == isCompletedToday
          ? _value.isCompletedToday
          : isCompletedToday // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitImpl implements _Habit {
  _$HabitImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) this.description,
      @HiveField(3) required this.category,
      @HiveField(4) required this.startDate,
      @HiveField(5) required this.weekdays,
      @HiveField(6) required this.createdAt,
      @HiveField(7) this.updatedAt,
      @HiveField(8) required this.userId,
      @HiveField(9) this.color = 0xFF6A11CB,
      @HiveField(10) this.iconCode = 58831,
      @HiveField(11) this.iconFamily = "MaterialIcons",
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isCompletedToday = false});

  factory _$HabitImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitImplFromJson(json);

  @override
  @HiveField(0)
  String id;
  @override
  @HiveField(1)
  String title;
  @override
  @HiveField(2)
  String? description;
  @override
  @HiveField(3)
  String category;
  @override
  @HiveField(4)
  DateTime startDate;
  @override
  @HiveField(5)
  List<int> weekdays;
  @override
  @HiveField(6)
  DateTime createdAt;
  @override
  @HiveField(7)
  DateTime? updatedAt;
  @override
  @HiveField(8)
  String userId;
// --- NEW FIELDS ---
  @override
  @JsonKey()
  @HiveField(9)
  int color;
  @override
  @JsonKey()
  @HiveField(10)
  int iconCode;
  @override
  @JsonKey()
  @HiveField(11)
  String iconFamily;
// --- TEMPORARY UI FIELD ---
// This is a temporary field for UI state and will not be stored
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isCompletedToday;

  @override
  String toString() {
    return 'Habit(id: $id, title: $title, description: $description, category: $category, startDate: $startDate, weekdays: $weekdays, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, color: $color, iconCode: $iconCode, iconFamily: $iconFamily, isCompletedToday: $isCompletedToday)';
  }

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      __$$HabitImplCopyWithImpl<_$HabitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitImplToJson(
      this,
    );
  }
}

abstract class _Habit implements Habit {
  factory _Habit(
      {@HiveField(0) required String id,
      @HiveField(1) required String title,
      @HiveField(2) String? description,
      @HiveField(3) required String category,
      @HiveField(4) required DateTime startDate,
      @HiveField(5) required List<int> weekdays,
      @HiveField(6) required DateTime createdAt,
      @HiveField(7) DateTime? updatedAt,
      @HiveField(8) required String userId,
      @HiveField(9) int color,
      @HiveField(10) int iconCode,
      @HiveField(11) String iconFamily,
      @JsonKey(includeFromJson: false, includeToJson: false)
      bool isCompletedToday}) = _$HabitImpl;

  factory _Habit.fromJson(Map<String, dynamic> json) = _$HabitImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @HiveField(0)
  set id(String value);
  @override
  @HiveField(1)
  String get title;
  @HiveField(1)
  set title(String value);
  @override
  @HiveField(2)
  String? get description;
  @HiveField(2)
  set description(String? value);
  @override
  @HiveField(3)
  String get category;
  @HiveField(3)
  set category(String value);
  @override
  @HiveField(4)
  DateTime get startDate;
  @HiveField(4)
  set startDate(DateTime value);
  @override
  @HiveField(5)
  List<int> get weekdays;
  @HiveField(5)
  set weekdays(List<int> value);
  @override
  @HiveField(6)
  DateTime get createdAt;
  @HiveField(6)
  set createdAt(DateTime value);
  @override
  @HiveField(7)
  DateTime? get updatedAt;
  @HiveField(7)
  set updatedAt(DateTime? value);
  @override
  @HiveField(8)
  String get userId;
  @HiveField(8)
  set userId(String value); // --- NEW FIELDS ---
  @override
  @HiveField(9)
  int get color; // --- NEW FIELDS ---
  @HiveField(9)
  set color(int value);
  @override
  @HiveField(10)
  int get iconCode;
  @HiveField(10)
  set iconCode(int value);
  @override
  @HiveField(11)
  String get iconFamily;
  @HiveField(11)
  set iconFamily(String value); // --- TEMPORARY UI FIELD ---
// This is a temporary field for UI state and will not be stored
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isCompletedToday; // --- TEMPORARY UI FIELD ---
// This is a temporary field for UI state and will not be stored
  @JsonKey(includeFromJson: false, includeToJson: false)
  set isCompletedToday(bool value);

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
