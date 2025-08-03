// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_arsenal_instance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserArsenalInstance _$UserArsenalInstanceFromJson(Map<String, dynamic> json) {
  return _UserArsenalInstance.fromJson(json);
}

/// @nodoc
mixin _$UserArsenalInstance {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ball_id')
  int get ballId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'added_date')
  DateTime get addedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'games_used')
  int get gamesUsed => throw _privateConstructorUsedError; // 球袋分類 (最多9個)
  @JsonKey(name: 'bag_category_1')
  String? get bagCategory1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_category_2')
  String? get bagCategory2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_category_3')
  String? get bagCategory3 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_category_4')
  String? get bagCategory4 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_category_5')
  String? get bagCategory5 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_category_6')
  String? get bagCategory6 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_category_7')
  String? get bagCategory7 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_category_8')
  String? get bagCategory8 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_category_9')
  String? get bagCategory9 => throw _privateConstructorUsedError; // Layout 信息
  @JsonKey(name: 'has_layout')
  bool get hasLayout => throw _privateConstructorUsedError;
  @JsonKey(name: 'layout_type')
  String? get layoutType =>
      throw _privateConstructorUsedError; // 'VLS' 或 'DUAL_ANGLE'
  @JsonKey(name: 'layout_value_1')
  double? get layoutValue1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'layout_value_2')
  double? get layoutValue2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'layout_value_3')
  double? get layoutValue3 =>
      throw _privateConstructorUsedError; // 關聯的球數據 (從JOIN獲取，不存在數據庫中)
  @JsonKey(name: 'bowling_ball_data')
  @BowlingBallConverter()
  BowlingBall? get bowlingBall => throw _privateConstructorUsedError;

  /// Serializes this UserArsenalInstance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserArsenalInstance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserArsenalInstanceCopyWith<UserArsenalInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserArsenalInstanceCopyWith<$Res> {
  factory $UserArsenalInstanceCopyWith(
          UserArsenalInstance value, $Res Function(UserArsenalInstance) then) =
      _$UserArsenalInstanceCopyWithImpl<$Res, UserArsenalInstance>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'ball_id') int ballId,
      String? notes,
      @JsonKey(name: 'added_date') DateTime addedDate,
      @JsonKey(name: 'games_used') int gamesUsed,
      @JsonKey(name: 'bag_category_1') String? bagCategory1,
      @JsonKey(name: 'bag_category_2') String? bagCategory2,
      @JsonKey(name: 'bag_category_3') String? bagCategory3,
      @JsonKey(name: 'bag_category_4') String? bagCategory4,
      @JsonKey(name: 'bag_category_5') String? bagCategory5,
      @JsonKey(name: 'bag_category_6') String? bagCategory6,
      @JsonKey(name: 'bag_category_7') String? bagCategory7,
      @JsonKey(name: 'bag_category_8') String? bagCategory8,
      @JsonKey(name: 'bag_category_9') String? bagCategory9,
      @JsonKey(name: 'has_layout') bool hasLayout,
      @JsonKey(name: 'layout_type') String? layoutType,
      @JsonKey(name: 'layout_value_1') double? layoutValue1,
      @JsonKey(name: 'layout_value_2') double? layoutValue2,
      @JsonKey(name: 'layout_value_3') double? layoutValue3,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      BowlingBall? bowlingBall});

  $BowlingBallCopyWith<$Res>? get bowlingBall;
}

/// @nodoc
class _$UserArsenalInstanceCopyWithImpl<$Res, $Val extends UserArsenalInstance>
    implements $UserArsenalInstanceCopyWith<$Res> {
  _$UserArsenalInstanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserArsenalInstance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? ballId = null,
    Object? notes = freezed,
    Object? addedDate = null,
    Object? gamesUsed = null,
    Object? bagCategory1 = freezed,
    Object? bagCategory2 = freezed,
    Object? bagCategory3 = freezed,
    Object? bagCategory4 = freezed,
    Object? bagCategory5 = freezed,
    Object? bagCategory6 = freezed,
    Object? bagCategory7 = freezed,
    Object? bagCategory8 = freezed,
    Object? bagCategory9 = freezed,
    Object? hasLayout = null,
    Object? layoutType = freezed,
    Object? layoutValue1 = freezed,
    Object? layoutValue2 = freezed,
    Object? layoutValue3 = freezed,
    Object? bowlingBall = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      ballId: null == ballId
          ? _value.ballId
          : ballId // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      addedDate: null == addedDate
          ? _value.addedDate
          : addedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gamesUsed: null == gamesUsed
          ? _value.gamesUsed
          : gamesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      bagCategory1: freezed == bagCategory1
          ? _value.bagCategory1
          : bagCategory1 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory2: freezed == bagCategory2
          ? _value.bagCategory2
          : bagCategory2 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory3: freezed == bagCategory3
          ? _value.bagCategory3
          : bagCategory3 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory4: freezed == bagCategory4
          ? _value.bagCategory4
          : bagCategory4 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory5: freezed == bagCategory5
          ? _value.bagCategory5
          : bagCategory5 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory6: freezed == bagCategory6
          ? _value.bagCategory6
          : bagCategory6 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory7: freezed == bagCategory7
          ? _value.bagCategory7
          : bagCategory7 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory8: freezed == bagCategory8
          ? _value.bagCategory8
          : bagCategory8 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory9: freezed == bagCategory9
          ? _value.bagCategory9
          : bagCategory9 // ignore: cast_nullable_to_non_nullable
              as String?,
      hasLayout: null == hasLayout
          ? _value.hasLayout
          : hasLayout // ignore: cast_nullable_to_non_nullable
              as bool,
      layoutType: freezed == layoutType
          ? _value.layoutType
          : layoutType // ignore: cast_nullable_to_non_nullable
              as String?,
      layoutValue1: freezed == layoutValue1
          ? _value.layoutValue1
          : layoutValue1 // ignore: cast_nullable_to_non_nullable
              as double?,
      layoutValue2: freezed == layoutValue2
          ? _value.layoutValue2
          : layoutValue2 // ignore: cast_nullable_to_non_nullable
              as double?,
      layoutValue3: freezed == layoutValue3
          ? _value.layoutValue3
          : layoutValue3 // ignore: cast_nullable_to_non_nullable
              as double?,
      bowlingBall: freezed == bowlingBall
          ? _value.bowlingBall
          : bowlingBall // ignore: cast_nullable_to_non_nullable
              as BowlingBall?,
    ) as $Val);
  }

  /// Create a copy of UserArsenalInstance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BowlingBallCopyWith<$Res>? get bowlingBall {
    if (_value.bowlingBall == null) {
      return null;
    }

    return $BowlingBallCopyWith<$Res>(_value.bowlingBall!, (value) {
      return _then(_value.copyWith(bowlingBall: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserArsenalInstanceImplCopyWith<$Res>
    implements $UserArsenalInstanceCopyWith<$Res> {
  factory _$$UserArsenalInstanceImplCopyWith(_$UserArsenalInstanceImpl value,
          $Res Function(_$UserArsenalInstanceImpl) then) =
      __$$UserArsenalInstanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'ball_id') int ballId,
      String? notes,
      @JsonKey(name: 'added_date') DateTime addedDate,
      @JsonKey(name: 'games_used') int gamesUsed,
      @JsonKey(name: 'bag_category_1') String? bagCategory1,
      @JsonKey(name: 'bag_category_2') String? bagCategory2,
      @JsonKey(name: 'bag_category_3') String? bagCategory3,
      @JsonKey(name: 'bag_category_4') String? bagCategory4,
      @JsonKey(name: 'bag_category_5') String? bagCategory5,
      @JsonKey(name: 'bag_category_6') String? bagCategory6,
      @JsonKey(name: 'bag_category_7') String? bagCategory7,
      @JsonKey(name: 'bag_category_8') String? bagCategory8,
      @JsonKey(name: 'bag_category_9') String? bagCategory9,
      @JsonKey(name: 'has_layout') bool hasLayout,
      @JsonKey(name: 'layout_type') String? layoutType,
      @JsonKey(name: 'layout_value_1') double? layoutValue1,
      @JsonKey(name: 'layout_value_2') double? layoutValue2,
      @JsonKey(name: 'layout_value_3') double? layoutValue3,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      BowlingBall? bowlingBall});

  @override
  $BowlingBallCopyWith<$Res>? get bowlingBall;
}

/// @nodoc
class __$$UserArsenalInstanceImplCopyWithImpl<$Res>
    extends _$UserArsenalInstanceCopyWithImpl<$Res, _$UserArsenalInstanceImpl>
    implements _$$UserArsenalInstanceImplCopyWith<$Res> {
  __$$UserArsenalInstanceImplCopyWithImpl(_$UserArsenalInstanceImpl _value,
      $Res Function(_$UserArsenalInstanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserArsenalInstance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? ballId = null,
    Object? notes = freezed,
    Object? addedDate = null,
    Object? gamesUsed = null,
    Object? bagCategory1 = freezed,
    Object? bagCategory2 = freezed,
    Object? bagCategory3 = freezed,
    Object? bagCategory4 = freezed,
    Object? bagCategory5 = freezed,
    Object? bagCategory6 = freezed,
    Object? bagCategory7 = freezed,
    Object? bagCategory8 = freezed,
    Object? bagCategory9 = freezed,
    Object? hasLayout = null,
    Object? layoutType = freezed,
    Object? layoutValue1 = freezed,
    Object? layoutValue2 = freezed,
    Object? layoutValue3 = freezed,
    Object? bowlingBall = freezed,
  }) {
    return _then(_$UserArsenalInstanceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      ballId: null == ballId
          ? _value.ballId
          : ballId // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      addedDate: null == addedDate
          ? _value.addedDate
          : addedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gamesUsed: null == gamesUsed
          ? _value.gamesUsed
          : gamesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      bagCategory1: freezed == bagCategory1
          ? _value.bagCategory1
          : bagCategory1 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory2: freezed == bagCategory2
          ? _value.bagCategory2
          : bagCategory2 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory3: freezed == bagCategory3
          ? _value.bagCategory3
          : bagCategory3 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory4: freezed == bagCategory4
          ? _value.bagCategory4
          : bagCategory4 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory5: freezed == bagCategory5
          ? _value.bagCategory5
          : bagCategory5 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory6: freezed == bagCategory6
          ? _value.bagCategory6
          : bagCategory6 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory7: freezed == bagCategory7
          ? _value.bagCategory7
          : bagCategory7 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory8: freezed == bagCategory8
          ? _value.bagCategory8
          : bagCategory8 // ignore: cast_nullable_to_non_nullable
              as String?,
      bagCategory9: freezed == bagCategory9
          ? _value.bagCategory9
          : bagCategory9 // ignore: cast_nullable_to_non_nullable
              as String?,
      hasLayout: null == hasLayout
          ? _value.hasLayout
          : hasLayout // ignore: cast_nullable_to_non_nullable
              as bool,
      layoutType: freezed == layoutType
          ? _value.layoutType
          : layoutType // ignore: cast_nullable_to_non_nullable
              as String?,
      layoutValue1: freezed == layoutValue1
          ? _value.layoutValue1
          : layoutValue1 // ignore: cast_nullable_to_non_nullable
              as double?,
      layoutValue2: freezed == layoutValue2
          ? _value.layoutValue2
          : layoutValue2 // ignore: cast_nullable_to_non_nullable
              as double?,
      layoutValue3: freezed == layoutValue3
          ? _value.layoutValue3
          : layoutValue3 // ignore: cast_nullable_to_non_nullable
              as double?,
      bowlingBall: freezed == bowlingBall
          ? _value.bowlingBall
          : bowlingBall // ignore: cast_nullable_to_non_nullable
              as BowlingBall?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserArsenalInstanceImpl implements _UserArsenalInstance {
  const _$UserArsenalInstanceImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'ball_id') required this.ballId,
      this.notes,
      @JsonKey(name: 'added_date') required this.addedDate,
      @JsonKey(name: 'games_used') this.gamesUsed = 0,
      @JsonKey(name: 'bag_category_1') this.bagCategory1,
      @JsonKey(name: 'bag_category_2') this.bagCategory2,
      @JsonKey(name: 'bag_category_3') this.bagCategory3,
      @JsonKey(name: 'bag_category_4') this.bagCategory4,
      @JsonKey(name: 'bag_category_5') this.bagCategory5,
      @JsonKey(name: 'bag_category_6') this.bagCategory6,
      @JsonKey(name: 'bag_category_7') this.bagCategory7,
      @JsonKey(name: 'bag_category_8') this.bagCategory8,
      @JsonKey(name: 'bag_category_9') this.bagCategory9,
      @JsonKey(name: 'has_layout') this.hasLayout = false,
      @JsonKey(name: 'layout_type') this.layoutType,
      @JsonKey(name: 'layout_value_1') this.layoutValue1,
      @JsonKey(name: 'layout_value_2') this.layoutValue2,
      @JsonKey(name: 'layout_value_3') this.layoutValue3,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      this.bowlingBall});

  factory _$UserArsenalInstanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserArsenalInstanceImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'ball_id')
  final int ballId;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'added_date')
  final DateTime addedDate;
  @override
  @JsonKey(name: 'games_used')
  final int gamesUsed;
// 球袋分類 (最多9個)
  @override
  @JsonKey(name: 'bag_category_1')
  final String? bagCategory1;
  @override
  @JsonKey(name: 'bag_category_2')
  final String? bagCategory2;
  @override
  @JsonKey(name: 'bag_category_3')
  final String? bagCategory3;
  @override
  @JsonKey(name: 'bag_category_4')
  final String? bagCategory4;
  @override
  @JsonKey(name: 'bag_category_5')
  final String? bagCategory5;
  @override
  @JsonKey(name: 'bag_category_6')
  final String? bagCategory6;
  @override
  @JsonKey(name: 'bag_category_7')
  final String? bagCategory7;
  @override
  @JsonKey(name: 'bag_category_8')
  final String? bagCategory8;
  @override
  @JsonKey(name: 'bag_category_9')
  final String? bagCategory9;
// Layout 信息
  @override
  @JsonKey(name: 'has_layout')
  final bool hasLayout;
  @override
  @JsonKey(name: 'layout_type')
  final String? layoutType;
// 'VLS' 或 'DUAL_ANGLE'
  @override
  @JsonKey(name: 'layout_value_1')
  final double? layoutValue1;
  @override
  @JsonKey(name: 'layout_value_2')
  final double? layoutValue2;
  @override
  @JsonKey(name: 'layout_value_3')
  final double? layoutValue3;
// 關聯的球數據 (從JOIN獲取，不存在數據庫中)
  @override
  @JsonKey(name: 'bowling_ball_data')
  @BowlingBallConverter()
  final BowlingBall? bowlingBall;

  @override
  String toString() {
    return 'UserArsenalInstance(id: $id, userId: $userId, ballId: $ballId, notes: $notes, addedDate: $addedDate, gamesUsed: $gamesUsed, bagCategory1: $bagCategory1, bagCategory2: $bagCategory2, bagCategory3: $bagCategory3, bagCategory4: $bagCategory4, bagCategory5: $bagCategory5, bagCategory6: $bagCategory6, bagCategory7: $bagCategory7, bagCategory8: $bagCategory8, bagCategory9: $bagCategory9, hasLayout: $hasLayout, layoutType: $layoutType, layoutValue1: $layoutValue1, layoutValue2: $layoutValue2, layoutValue3: $layoutValue3, bowlingBall: $bowlingBall)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserArsenalInstanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.ballId, ballId) || other.ballId == ballId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.addedDate, addedDate) ||
                other.addedDate == addedDate) &&
            (identical(other.gamesUsed, gamesUsed) ||
                other.gamesUsed == gamesUsed) &&
            (identical(other.bagCategory1, bagCategory1) ||
                other.bagCategory1 == bagCategory1) &&
            (identical(other.bagCategory2, bagCategory2) ||
                other.bagCategory2 == bagCategory2) &&
            (identical(other.bagCategory3, bagCategory3) ||
                other.bagCategory3 == bagCategory3) &&
            (identical(other.bagCategory4, bagCategory4) ||
                other.bagCategory4 == bagCategory4) &&
            (identical(other.bagCategory5, bagCategory5) ||
                other.bagCategory5 == bagCategory5) &&
            (identical(other.bagCategory6, bagCategory6) ||
                other.bagCategory6 == bagCategory6) &&
            (identical(other.bagCategory7, bagCategory7) ||
                other.bagCategory7 == bagCategory7) &&
            (identical(other.bagCategory8, bagCategory8) ||
                other.bagCategory8 == bagCategory8) &&
            (identical(other.bagCategory9, bagCategory9) ||
                other.bagCategory9 == bagCategory9) &&
            (identical(other.hasLayout, hasLayout) ||
                other.hasLayout == hasLayout) &&
            (identical(other.layoutType, layoutType) ||
                other.layoutType == layoutType) &&
            (identical(other.layoutValue1, layoutValue1) ||
                other.layoutValue1 == layoutValue1) &&
            (identical(other.layoutValue2, layoutValue2) ||
                other.layoutValue2 == layoutValue2) &&
            (identical(other.layoutValue3, layoutValue3) ||
                other.layoutValue3 == layoutValue3) &&
            (identical(other.bowlingBall, bowlingBall) ||
                other.bowlingBall == bowlingBall));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        ballId,
        notes,
        addedDate,
        gamesUsed,
        bagCategory1,
        bagCategory2,
        bagCategory3,
        bagCategory4,
        bagCategory5,
        bagCategory6,
        bagCategory7,
        bagCategory8,
        bagCategory9,
        hasLayout,
        layoutType,
        layoutValue1,
        layoutValue2,
        layoutValue3,
        bowlingBall
      ]);

  /// Create a copy of UserArsenalInstance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserArsenalInstanceImplCopyWith<_$UserArsenalInstanceImpl> get copyWith =>
      __$$UserArsenalInstanceImplCopyWithImpl<_$UserArsenalInstanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserArsenalInstanceImplToJson(
      this,
    );
  }
}

abstract class _UserArsenalInstance implements UserArsenalInstance {
  const factory _UserArsenalInstance(
      {required final int id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'ball_id') required final int ballId,
      final String? notes,
      @JsonKey(name: 'added_date') required final DateTime addedDate,
      @JsonKey(name: 'games_used') final int gamesUsed,
      @JsonKey(name: 'bag_category_1') final String? bagCategory1,
      @JsonKey(name: 'bag_category_2') final String? bagCategory2,
      @JsonKey(name: 'bag_category_3') final String? bagCategory3,
      @JsonKey(name: 'bag_category_4') final String? bagCategory4,
      @JsonKey(name: 'bag_category_5') final String? bagCategory5,
      @JsonKey(name: 'bag_category_6') final String? bagCategory6,
      @JsonKey(name: 'bag_category_7') final String? bagCategory7,
      @JsonKey(name: 'bag_category_8') final String? bagCategory8,
      @JsonKey(name: 'bag_category_9') final String? bagCategory9,
      @JsonKey(name: 'has_layout') final bool hasLayout,
      @JsonKey(name: 'layout_type') final String? layoutType,
      @JsonKey(name: 'layout_value_1') final double? layoutValue1,
      @JsonKey(name: 'layout_value_2') final double? layoutValue2,
      @JsonKey(name: 'layout_value_3') final double? layoutValue3,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      final BowlingBall? bowlingBall}) = _$UserArsenalInstanceImpl;

  factory _UserArsenalInstance.fromJson(Map<String, dynamic> json) =
      _$UserArsenalInstanceImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'ball_id')
  int get ballId;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'added_date')
  DateTime get addedDate;
  @override
  @JsonKey(name: 'games_used')
  int get gamesUsed; // 球袋分類 (最多9個)
  @override
  @JsonKey(name: 'bag_category_1')
  String? get bagCategory1;
  @override
  @JsonKey(name: 'bag_category_2')
  String? get bagCategory2;
  @override
  @JsonKey(name: 'bag_category_3')
  String? get bagCategory3;
  @override
  @JsonKey(name: 'bag_category_4')
  String? get bagCategory4;
  @override
  @JsonKey(name: 'bag_category_5')
  String? get bagCategory5;
  @override
  @JsonKey(name: 'bag_category_6')
  String? get bagCategory6;
  @override
  @JsonKey(name: 'bag_category_7')
  String? get bagCategory7;
  @override
  @JsonKey(name: 'bag_category_8')
  String? get bagCategory8;
  @override
  @JsonKey(name: 'bag_category_9')
  String? get bagCategory9; // Layout 信息
  @override
  @JsonKey(name: 'has_layout')
  bool get hasLayout;
  @override
  @JsonKey(name: 'layout_type')
  String? get layoutType; // 'VLS' 或 'DUAL_ANGLE'
  @override
  @JsonKey(name: 'layout_value_1')
  double? get layoutValue1;
  @override
  @JsonKey(name: 'layout_value_2')
  double? get layoutValue2;
  @override
  @JsonKey(name: 'layout_value_3')
  double? get layoutValue3; // 關聯的球數據 (從JOIN獲取，不存在數據庫中)
  @override
  @JsonKey(name: 'bowling_ball_data')
  @BowlingBallConverter()
  BowlingBall? get bowlingBall;

  /// Create a copy of UserArsenalInstance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserArsenalInstanceImplCopyWith<_$UserArsenalInstanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
