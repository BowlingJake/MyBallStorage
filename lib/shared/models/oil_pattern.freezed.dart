// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oil_pattern.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OilPattern _$OilPatternFromJson(Map<String, dynamic> json) {
  return _OilPattern.fromJson(json);
}

/// @nodoc
mixin _$OilPattern {
  String? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get length => throw _privateConstructorUsedError;
  int? get volume => throw _privateConstructorUsedError;
  @JsonKey(name: 'difficulty_level')
  int? get difficultyLevel => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'pattern_type')
  String get patternType => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OilPattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OilPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OilPatternCopyWith<OilPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OilPatternCopyWith<$Res> {
  factory $OilPatternCopyWith(
          OilPattern value, $Res Function(OilPattern) then) =
      _$OilPatternCopyWithImpl<$Res, OilPattern>;
  @useResult
  $Res call(
      {String? id,
      String name,
      int? length,
      int? volume,
      @JsonKey(name: 'difficulty_level') int? difficultyLevel,
      String? description,
      @JsonKey(name: 'pattern_type') String patternType,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$OilPatternCopyWithImpl<$Res, $Val extends OilPattern>
    implements $OilPatternCopyWith<$Res> {
  _$OilPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OilPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? length = freezed,
    Object? volume = freezed,
    Object? difficultyLevel = freezed,
    Object? description = freezed,
    Object? patternType = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      length: freezed == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int?,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as int?,
      difficultyLevel: freezed == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      patternType: null == patternType
          ? _value.patternType
          : patternType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OilPatternImplCopyWith<$Res>
    implements $OilPatternCopyWith<$Res> {
  factory _$$OilPatternImplCopyWith(
          _$OilPatternImpl value, $Res Function(_$OilPatternImpl) then) =
      __$$OilPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String name,
      int? length,
      int? volume,
      @JsonKey(name: 'difficulty_level') int? difficultyLevel,
      String? description,
      @JsonKey(name: 'pattern_type') String patternType,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$OilPatternImplCopyWithImpl<$Res>
    extends _$OilPatternCopyWithImpl<$Res, _$OilPatternImpl>
    implements _$$OilPatternImplCopyWith<$Res> {
  __$$OilPatternImplCopyWithImpl(
      _$OilPatternImpl _value, $Res Function(_$OilPatternImpl) _then)
      : super(_value, _then);

  /// Create a copy of OilPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? length = freezed,
    Object? volume = freezed,
    Object? difficultyLevel = freezed,
    Object? description = freezed,
    Object? patternType = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$OilPatternImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      length: freezed == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as int?,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as int?,
      difficultyLevel: freezed == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      patternType: null == patternType
          ? _value.patternType
          : patternType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OilPatternImpl implements _OilPattern {
  const _$OilPatternImpl(
      {this.id,
      required this.name,
      this.length,
      this.volume,
      @JsonKey(name: 'difficulty_level') this.difficultyLevel,
      this.description,
      @JsonKey(name: 'pattern_type') this.patternType = 'house',
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$OilPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$OilPatternImplFromJson(json);

  @override
  final String? id;
  @override
  final String name;
  @override
  final int? length;
  @override
  final int? volume;
  @override
  @JsonKey(name: 'difficulty_level')
  final int? difficultyLevel;
  @override
  final String? description;
  @override
  @JsonKey(name: 'pattern_type')
  final String patternType;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'OilPattern(id: $id, name: $name, length: $length, volume: $volume, difficultyLevel: $difficultyLevel, description: $description, patternType: $patternType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OilPatternImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.patternType, patternType) ||
                other.patternType == patternType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, length, volume,
      difficultyLevel, description, patternType, createdAt, updatedAt);

  /// Create a copy of OilPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OilPatternImplCopyWith<_$OilPatternImpl> get copyWith =>
      __$$OilPatternImplCopyWithImpl<_$OilPatternImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OilPatternImplToJson(
      this,
    );
  }
}

abstract class _OilPattern implements OilPattern {
  const factory _OilPattern(
          {final String? id,
          required final String name,
          final int? length,
          final int? volume,
          @JsonKey(name: 'difficulty_level') final int? difficultyLevel,
          final String? description,
          @JsonKey(name: 'pattern_type') final String patternType,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$OilPatternImpl;

  factory _OilPattern.fromJson(Map<String, dynamic> json) =
      _$OilPatternImpl.fromJson;

  @override
  String? get id;
  @override
  String get name;
  @override
  int? get length;
  @override
  int? get volume;
  @override
  @JsonKey(name: 'difficulty_level')
  int? get difficultyLevel;
  @override
  String? get description;
  @override
  @JsonKey(name: 'pattern_type')
  String get patternType;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of OilPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OilPatternImplCopyWith<_$OilPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserFavoritePattern _$UserFavoritePatternFromJson(Map<String, dynamic> json) {
  return _UserFavoritePattern.fromJson(json);
}

/// @nodoc
mixin _$UserFavoritePattern {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'oil_pattern_id')
  String get oilPatternId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'performance_rating')
  int? get performanceRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // 關聯的油圖資訊（來自 JOIN 查詢）
  @JsonKey(name: 'oil_pattern')
  OilPattern? get oilPattern => throw _privateConstructorUsedError;

  /// Serializes this UserFavoritePattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserFavoritePattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserFavoritePatternCopyWith<UserFavoritePattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserFavoritePatternCopyWith<$Res> {
  factory $UserFavoritePatternCopyWith(
          UserFavoritePattern value, $Res Function(UserFavoritePattern) then) =
      _$UserFavoritePatternCopyWithImpl<$Res, UserFavoritePattern>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'oil_pattern_id') String oilPatternId,
      String? notes,
      @JsonKey(name: 'performance_rating') int? performanceRating,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'oil_pattern') OilPattern? oilPattern});

  $OilPatternCopyWith<$Res>? get oilPattern;
}

/// @nodoc
class _$UserFavoritePatternCopyWithImpl<$Res, $Val extends UserFavoritePattern>
    implements $UserFavoritePatternCopyWith<$Res> {
  _$UserFavoritePatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserFavoritePattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? oilPatternId = null,
    Object? notes = freezed,
    Object? performanceRating = freezed,
    Object? createdAt = freezed,
    Object? oilPattern = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      oilPatternId: null == oilPatternId
          ? _value.oilPatternId
          : oilPatternId // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      performanceRating: freezed == performanceRating
          ? _value.performanceRating
          : performanceRating // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      oilPattern: freezed == oilPattern
          ? _value.oilPattern
          : oilPattern // ignore: cast_nullable_to_non_nullable
              as OilPattern?,
    ) as $Val);
  }

  /// Create a copy of UserFavoritePattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OilPatternCopyWith<$Res>? get oilPattern {
    if (_value.oilPattern == null) {
      return null;
    }

    return $OilPatternCopyWith<$Res>(_value.oilPattern!, (value) {
      return _then(_value.copyWith(oilPattern: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserFavoritePatternImplCopyWith<$Res>
    implements $UserFavoritePatternCopyWith<$Res> {
  factory _$$UserFavoritePatternImplCopyWith(_$UserFavoritePatternImpl value,
          $Res Function(_$UserFavoritePatternImpl) then) =
      __$$UserFavoritePatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'oil_pattern_id') String oilPatternId,
      String? notes,
      @JsonKey(name: 'performance_rating') int? performanceRating,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'oil_pattern') OilPattern? oilPattern});

  @override
  $OilPatternCopyWith<$Res>? get oilPattern;
}

/// @nodoc
class __$$UserFavoritePatternImplCopyWithImpl<$Res>
    extends _$UserFavoritePatternCopyWithImpl<$Res, _$UserFavoritePatternImpl>
    implements _$$UserFavoritePatternImplCopyWith<$Res> {
  __$$UserFavoritePatternImplCopyWithImpl(_$UserFavoritePatternImpl _value,
      $Res Function(_$UserFavoritePatternImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserFavoritePattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? oilPatternId = null,
    Object? notes = freezed,
    Object? performanceRating = freezed,
    Object? createdAt = freezed,
    Object? oilPattern = freezed,
  }) {
    return _then(_$UserFavoritePatternImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      oilPatternId: null == oilPatternId
          ? _value.oilPatternId
          : oilPatternId // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      performanceRating: freezed == performanceRating
          ? _value.performanceRating
          : performanceRating // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      oilPattern: freezed == oilPattern
          ? _value.oilPattern
          : oilPattern // ignore: cast_nullable_to_non_nullable
              as OilPattern?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserFavoritePatternImpl implements _UserFavoritePattern {
  const _$UserFavoritePatternImpl(
      {this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'oil_pattern_id') required this.oilPatternId,
      this.notes,
      @JsonKey(name: 'performance_rating') this.performanceRating,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'oil_pattern') this.oilPattern});

  factory _$UserFavoritePatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserFavoritePatternImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'oil_pattern_id')
  final String oilPatternId;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'performance_rating')
  final int? performanceRating;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
// 關聯的油圖資訊（來自 JOIN 查詢）
  @override
  @JsonKey(name: 'oil_pattern')
  final OilPattern? oilPattern;

  @override
  String toString() {
    return 'UserFavoritePattern(id: $id, userId: $userId, oilPatternId: $oilPatternId, notes: $notes, performanceRating: $performanceRating, createdAt: $createdAt, oilPattern: $oilPattern)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserFavoritePatternImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.oilPatternId, oilPatternId) ||
                other.oilPatternId == oilPatternId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.performanceRating, performanceRating) ||
                other.performanceRating == performanceRating) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.oilPattern, oilPattern) ||
                other.oilPattern == oilPattern));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, oilPatternId, notes,
      performanceRating, createdAt, oilPattern);

  /// Create a copy of UserFavoritePattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserFavoritePatternImplCopyWith<_$UserFavoritePatternImpl> get copyWith =>
      __$$UserFavoritePatternImplCopyWithImpl<_$UserFavoritePatternImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserFavoritePatternImplToJson(
      this,
    );
  }
}

abstract class _UserFavoritePattern implements UserFavoritePattern {
  const factory _UserFavoritePattern(
          {final String? id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'oil_pattern_id') required final String oilPatternId,
          final String? notes,
          @JsonKey(name: 'performance_rating') final int? performanceRating,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'oil_pattern') final OilPattern? oilPattern}) =
      _$UserFavoritePatternImpl;

  factory _UserFavoritePattern.fromJson(Map<String, dynamic> json) =
      _$UserFavoritePatternImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'oil_pattern_id')
  String get oilPatternId;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'performance_rating')
  int? get performanceRating;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt; // 關聯的油圖資訊（來自 JOIN 查詢）
  @override
  @JsonKey(name: 'oil_pattern')
  OilPattern? get oilPattern;

  /// Create a copy of UserFavoritePattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserFavoritePatternImplCopyWith<_$UserFavoritePatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
