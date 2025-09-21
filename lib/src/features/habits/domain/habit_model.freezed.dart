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
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(3)
  String get category => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get startDate => throw _privateConstructorUsedError;
  @HiveField(5)
  List<int> get weekdays => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Add userId for Firestore pathing
  @HiveField(8)
  String get userId => throw _privateConstructorUsedError;

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
      @HiveField(8) String userId});
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
      @HiveField(8) String userId});
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
          ? _value._weekdays
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitImpl implements _Habit {
  const _$HabitImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) this.description,
      @HiveField(3) required this.category,
      @HiveField(4) required this.startDate,
      @HiveField(5) required final List<int> weekdays,
      @HiveField(6) required this.createdAt,
      @HiveField(7) this.updatedAt,
      @HiveField(8) required this.userId})
      : _weekdays = weekdays;

  factory _$HabitImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String? description;
  @override
  @HiveField(3)
  final String category;
  @override
  @HiveField(4)
  final DateTime startDate;
  final List<int> _weekdays;
  @override
  @HiveField(5)
  List<int> get weekdays {
    if (_weekdays is EqualUnmodifiableListView) return _weekdays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekdays);
  }

  @override
  @HiveField(6)
  final DateTime createdAt;
  @override
  @HiveField(7)
  final DateTime? updatedAt;
// Add userId for Firestore pathing
  @override
  @HiveField(8)
  final String userId;

  @override
  String toString() {
    return 'Habit(id: $id, title: $title, description: $description, category: $category, startDate: $startDate, weekdays: $weekdays, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            const DeepCollectionEquality().equals(other._weekdays, _weekdays) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      category,
      startDate,
      const DeepCollectionEquality().hash(_weekdays),
      createdAt,
      updatedAt,
      userId);

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
  const factory _Habit(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) final String? description,
      @HiveField(3) required final String category,
      @HiveField(4) required final DateTime startDate,
      @HiveField(5) required final List<int> weekdays,
      @HiveField(6) required final DateTime createdAt,
      @HiveField(7) final DateTime? updatedAt,
      @HiveField(8) required final String userId}) = _$HabitImpl;

  factory _Habit.fromJson(Map<String, dynamic> json) = _$HabitImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  String? get description;
  @override
  @HiveField(3)
  String get category;
  @override
  @HiveField(4)
  DateTime get startDate;
  @override
  @HiveField(5)
  List<int> get weekdays;
  @override
  @HiveField(6)
  DateTime get createdAt;
  @override
  @HiveField(7)
  DateTime? get updatedAt; // Add userId for Firestore pathing
  @override
  @HiveField(8)
  String get userId;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
