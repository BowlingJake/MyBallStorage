// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrainingSession _$TrainingSessionFromJson(Map<String, dynamic> json) {
  return _TrainingSession.fromJson(json);
}

/// @nodoc
mixin _$TrainingSession {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get center => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_house_pattern')
  bool get isHousePattern => throw _privateConstructorUsedError;
  @JsonKey(name: 'oil_pattern_name')
  String? get oilPatternName => throw _privateConstructorUsedError;
  @JsonKey(name: 'oil_pattern_length')
  int? get oilPatternLength => throw _privateConstructorUsedError;
  @JsonKey(name: 'scoring_method')
  String get scoringMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'input_method')
  String get inputMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TrainingSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingSessionCopyWith<TrainingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingSessionCopyWith<$Res> {
  factory $TrainingSessionCopyWith(
          TrainingSession value, $Res Function(TrainingSession) then) =
      _$TrainingSessionCopyWithImpl<$Res, TrainingSession>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      DateTime date,
      String center,
      @JsonKey(name: 'is_house_pattern') bool isHousePattern,
      @JsonKey(name: 'oil_pattern_name') String? oilPatternName,
      @JsonKey(name: 'oil_pattern_length') int? oilPatternLength,
      @JsonKey(name: 'scoring_method') String scoringMethod,
      @JsonKey(name: 'input_method') String inputMethod,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$TrainingSessionCopyWithImpl<$Res, $Val extends TrainingSession>
    implements $TrainingSessionCopyWith<$Res> {
  _$TrainingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? date = null,
    Object? center = null,
    Object? isHousePattern = null,
    Object? oilPatternName = freezed,
    Object? oilPatternLength = freezed,
    Object? scoringMethod = null,
    Object? inputMethod = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as String,
      isHousePattern: null == isHousePattern
          ? _value.isHousePattern
          : isHousePattern // ignore: cast_nullable_to_non_nullable
              as bool,
      oilPatternName: freezed == oilPatternName
          ? _value.oilPatternName
          : oilPatternName // ignore: cast_nullable_to_non_nullable
              as String?,
      oilPatternLength: freezed == oilPatternLength
          ? _value.oilPatternLength
          : oilPatternLength // ignore: cast_nullable_to_non_nullable
              as int?,
      scoringMethod: null == scoringMethod
          ? _value.scoringMethod
          : scoringMethod // ignore: cast_nullable_to_non_nullable
              as String,
      inputMethod: null == inputMethod
          ? _value.inputMethod
          : inputMethod // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingSessionImplCopyWith<$Res>
    implements $TrainingSessionCopyWith<$Res> {
  factory _$$TrainingSessionImplCopyWith(_$TrainingSessionImpl value,
          $Res Function(_$TrainingSessionImpl) then) =
      __$$TrainingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      DateTime date,
      String center,
      @JsonKey(name: 'is_house_pattern') bool isHousePattern,
      @JsonKey(name: 'oil_pattern_name') String? oilPatternName,
      @JsonKey(name: 'oil_pattern_length') int? oilPatternLength,
      @JsonKey(name: 'scoring_method') String scoringMethod,
      @JsonKey(name: 'input_method') String inputMethod,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$TrainingSessionImplCopyWithImpl<$Res>
    extends _$TrainingSessionCopyWithImpl<$Res, _$TrainingSessionImpl>
    implements _$$TrainingSessionImplCopyWith<$Res> {
  __$$TrainingSessionImplCopyWithImpl(
      _$TrainingSessionImpl _value, $Res Function(_$TrainingSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? date = null,
    Object? center = null,
    Object? isHousePattern = null,
    Object? oilPatternName = freezed,
    Object? oilPatternLength = freezed,
    Object? scoringMethod = null,
    Object? inputMethod = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TrainingSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      center: null == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as String,
      isHousePattern: null == isHousePattern
          ? _value.isHousePattern
          : isHousePattern // ignore: cast_nullable_to_non_nullable
              as bool,
      oilPatternName: freezed == oilPatternName
          ? _value.oilPatternName
          : oilPatternName // ignore: cast_nullable_to_non_nullable
              as String?,
      oilPatternLength: freezed == oilPatternLength
          ? _value.oilPatternLength
          : oilPatternLength // ignore: cast_nullable_to_non_nullable
              as int?,
      scoringMethod: null == scoringMethod
          ? _value.scoringMethod
          : scoringMethod // ignore: cast_nullable_to_non_nullable
              as String,
      inputMethod: null == inputMethod
          ? _value.inputMethod
          : inputMethod // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainingSessionImpl implements _TrainingSession {
  const _$TrainingSessionImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.title,
      required this.date,
      required this.center,
      @JsonKey(name: 'is_house_pattern') required this.isHousePattern,
      @JsonKey(name: 'oil_pattern_name') this.oilPatternName,
      @JsonKey(name: 'oil_pattern_length') this.oilPatternLength,
      @JsonKey(name: 'scoring_method') required this.scoringMethod,
      @JsonKey(name: 'input_method') required this.inputMethod,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$TrainingSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingSessionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String title;
  @override
  final DateTime date;
  @override
  final String center;
  @override
  @JsonKey(name: 'is_house_pattern')
  final bool isHousePattern;
  @override
  @JsonKey(name: 'oil_pattern_name')
  final String? oilPatternName;
  @override
  @JsonKey(name: 'oil_pattern_length')
  final int? oilPatternLength;
  @override
  @JsonKey(name: 'scoring_method')
  final String scoringMethod;
  @override
  @JsonKey(name: 'input_method')
  final String inputMethod;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TrainingSession(id: $id, userId: $userId, title: $title, date: $date, center: $center, isHousePattern: $isHousePattern, oilPatternName: $oilPatternName, oilPatternLength: $oilPatternLength, scoringMethod: $scoringMethod, inputMethod: $inputMethod, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.center, center) || other.center == center) &&
            (identical(other.isHousePattern, isHousePattern) ||
                other.isHousePattern == isHousePattern) &&
            (identical(other.oilPatternName, oilPatternName) ||
                other.oilPatternName == oilPatternName) &&
            (identical(other.oilPatternLength, oilPatternLength) ||
                other.oilPatternLength == oilPatternLength) &&
            (identical(other.scoringMethod, scoringMethod) ||
                other.scoringMethod == scoringMethod) &&
            (identical(other.inputMethod, inputMethod) ||
                other.inputMethod == inputMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      date,
      center,
      isHousePattern,
      oilPatternName,
      oilPatternLength,
      scoringMethod,
      inputMethod,
      createdAt,
      updatedAt);

  /// Create a copy of TrainingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingSessionImplCopyWith<_$TrainingSessionImpl> get copyWith =>
      __$$TrainingSessionImplCopyWithImpl<_$TrainingSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingSessionImplToJson(
      this,
    );
  }
}

abstract class _TrainingSession implements TrainingSession {
  const factory _TrainingSession(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          required final String title,
          required final DateTime date,
          required final String center,
          @JsonKey(name: 'is_house_pattern') required final bool isHousePattern,
          @JsonKey(name: 'oil_pattern_name') final String? oilPatternName,
          @JsonKey(name: 'oil_pattern_length') final int? oilPatternLength,
          @JsonKey(name: 'scoring_method') required final String scoringMethod,
          @JsonKey(name: 'input_method') required final String inputMethod,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$TrainingSessionImpl;

  factory _TrainingSession.fromJson(Map<String, dynamic> json) =
      _$TrainingSessionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get title;
  @override
  DateTime get date;
  @override
  String get center;
  @override
  @JsonKey(name: 'is_house_pattern')
  bool get isHousePattern;
  @override
  @JsonKey(name: 'oil_pattern_name')
  String? get oilPatternName;
  @override
  @JsonKey(name: 'oil_pattern_length')
  int? get oilPatternLength;
  @override
  @JsonKey(name: 'scoring_method')
  String get scoringMethod;
  @override
  @JsonKey(name: 'input_method')
  String get inputMethod;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of TrainingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingSessionImplCopyWith<_$TrainingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
