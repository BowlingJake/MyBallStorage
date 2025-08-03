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
  int get gamesUsed =>
      throw _privateConstructorUsedError; // 球袋分配 (Boolean: true=在該袋中, false=不在, null=袋子未開通)
  @JsonKey(name: 'bag_1')
  bool? get bag1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_2')
  bool? get bag2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_3')
  bool? get bag3 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_4')
  bool? get bag4 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_5')
  bool? get bag5 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_6')
  bool? get bag6 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_7')
  bool? get bag7 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_8')
  bool? get bag8 => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_9')
  bool? get bag9 => throw _privateConstructorUsedError; // Layout 信息
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
      @JsonKey(name: 'bag_1') bool? bag1,
      @JsonKey(name: 'bag_2') bool? bag2,
      @JsonKey(name: 'bag_3') bool? bag3,
      @JsonKey(name: 'bag_4') bool? bag4,
      @JsonKey(name: 'bag_5') bool? bag5,
      @JsonKey(name: 'bag_6') bool? bag6,
      @JsonKey(name: 'bag_7') bool? bag7,
      @JsonKey(name: 'bag_8') bool? bag8,
      @JsonKey(name: 'bag_9') bool? bag9,
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
    Object? bag1 = freezed,
    Object? bag2 = freezed,
    Object? bag3 = freezed,
    Object? bag4 = freezed,
    Object? bag5 = freezed,
    Object? bag6 = freezed,
    Object? bag7 = freezed,
    Object? bag8 = freezed,
    Object? bag9 = freezed,
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
      bag1: freezed == bag1
          ? _value.bag1
          : bag1 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag2: freezed == bag2
          ? _value.bag2
          : bag2 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag3: freezed == bag3
          ? _value.bag3
          : bag3 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag4: freezed == bag4
          ? _value.bag4
          : bag4 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag5: freezed == bag5
          ? _value.bag5
          : bag5 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag6: freezed == bag6
          ? _value.bag6
          : bag6 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag7: freezed == bag7
          ? _value.bag7
          : bag7 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag8: freezed == bag8
          ? _value.bag8
          : bag8 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag9: freezed == bag9
          ? _value.bag9
          : bag9 // ignore: cast_nullable_to_non_nullable
              as bool?,
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
      @JsonKey(name: 'bag_1') bool? bag1,
      @JsonKey(name: 'bag_2') bool? bag2,
      @JsonKey(name: 'bag_3') bool? bag3,
      @JsonKey(name: 'bag_4') bool? bag4,
      @JsonKey(name: 'bag_5') bool? bag5,
      @JsonKey(name: 'bag_6') bool? bag6,
      @JsonKey(name: 'bag_7') bool? bag7,
      @JsonKey(name: 'bag_8') bool? bag8,
      @JsonKey(name: 'bag_9') bool? bag9,
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
    Object? bag1 = freezed,
    Object? bag2 = freezed,
    Object? bag3 = freezed,
    Object? bag4 = freezed,
    Object? bag5 = freezed,
    Object? bag6 = freezed,
    Object? bag7 = freezed,
    Object? bag8 = freezed,
    Object? bag9 = freezed,
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
      bag1: freezed == bag1
          ? _value.bag1
          : bag1 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag2: freezed == bag2
          ? _value.bag2
          : bag2 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag3: freezed == bag3
          ? _value.bag3
          : bag3 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag4: freezed == bag4
          ? _value.bag4
          : bag4 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag5: freezed == bag5
          ? _value.bag5
          : bag5 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag6: freezed == bag6
          ? _value.bag6
          : bag6 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag7: freezed == bag7
          ? _value.bag7
          : bag7 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag8: freezed == bag8
          ? _value.bag8
          : bag8 // ignore: cast_nullable_to_non_nullable
              as bool?,
      bag9: freezed == bag9
          ? _value.bag9
          : bag9 // ignore: cast_nullable_to_non_nullable
              as bool?,
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
      @JsonKey(name: 'bag_1') this.bag1,
      @JsonKey(name: 'bag_2') this.bag2,
      @JsonKey(name: 'bag_3') this.bag3,
      @JsonKey(name: 'bag_4') this.bag4,
      @JsonKey(name: 'bag_5') this.bag5,
      @JsonKey(name: 'bag_6') this.bag6,
      @JsonKey(name: 'bag_7') this.bag7,
      @JsonKey(name: 'bag_8') this.bag8,
      @JsonKey(name: 'bag_9') this.bag9,
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
// 球袋分配 (Boolean: true=在該袋中, false=不在, null=袋子未開通)
  @override
  @JsonKey(name: 'bag_1')
  final bool? bag1;
  @override
  @JsonKey(name: 'bag_2')
  final bool? bag2;
  @override
  @JsonKey(name: 'bag_3')
  final bool? bag3;
  @override
  @JsonKey(name: 'bag_4')
  final bool? bag4;
  @override
  @JsonKey(name: 'bag_5')
  final bool? bag5;
  @override
  @JsonKey(name: 'bag_6')
  final bool? bag6;
  @override
  @JsonKey(name: 'bag_7')
  final bool? bag7;
  @override
  @JsonKey(name: 'bag_8')
  final bool? bag8;
  @override
  @JsonKey(name: 'bag_9')
  final bool? bag9;
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
    return 'UserArsenalInstance(id: $id, userId: $userId, ballId: $ballId, notes: $notes, addedDate: $addedDate, gamesUsed: $gamesUsed, bag1: $bag1, bag2: $bag2, bag3: $bag3, bag4: $bag4, bag5: $bag5, bag6: $bag6, bag7: $bag7, bag8: $bag8, bag9: $bag9, hasLayout: $hasLayout, layoutType: $layoutType, layoutValue1: $layoutValue1, layoutValue2: $layoutValue2, layoutValue3: $layoutValue3, bowlingBall: $bowlingBall)';
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
            (identical(other.bag1, bag1) || other.bag1 == bag1) &&
            (identical(other.bag2, bag2) || other.bag2 == bag2) &&
            (identical(other.bag3, bag3) || other.bag3 == bag3) &&
            (identical(other.bag4, bag4) || other.bag4 == bag4) &&
            (identical(other.bag5, bag5) || other.bag5 == bag5) &&
            (identical(other.bag6, bag6) || other.bag6 == bag6) &&
            (identical(other.bag7, bag7) || other.bag7 == bag7) &&
            (identical(other.bag8, bag8) || other.bag8 == bag8) &&
            (identical(other.bag9, bag9) || other.bag9 == bag9) &&
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
        bag1,
        bag2,
        bag3,
        bag4,
        bag5,
        bag6,
        bag7,
        bag8,
        bag9,
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
      @JsonKey(name: 'bag_1') final bool? bag1,
      @JsonKey(name: 'bag_2') final bool? bag2,
      @JsonKey(name: 'bag_3') final bool? bag3,
      @JsonKey(name: 'bag_4') final bool? bag4,
      @JsonKey(name: 'bag_5') final bool? bag5,
      @JsonKey(name: 'bag_6') final bool? bag6,
      @JsonKey(name: 'bag_7') final bool? bag7,
      @JsonKey(name: 'bag_8') final bool? bag8,
      @JsonKey(name: 'bag_9') final bool? bag9,
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
  int get gamesUsed; // 球袋分配 (Boolean: true=在該袋中, false=不在, null=袋子未開通)
  @override
  @JsonKey(name: 'bag_1')
  bool? get bag1;
  @override
  @JsonKey(name: 'bag_2')
  bool? get bag2;
  @override
  @JsonKey(name: 'bag_3')
  bool? get bag3;
  @override
  @JsonKey(name: 'bag_4')
  bool? get bag4;
  @override
  @JsonKey(name: 'bag_5')
  bool? get bag5;
  @override
  @JsonKey(name: 'bag_6')
  bool? get bag6;
  @override
  @JsonKey(name: 'bag_7')
  bool? get bag7;
  @override
  @JsonKey(name: 'bag_8')
  bool? get bag8;
  @override
  @JsonKey(name: 'bag_9')
  bool? get bag9; // Layout 信息
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
