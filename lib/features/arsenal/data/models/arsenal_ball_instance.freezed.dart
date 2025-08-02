// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arsenal_ball_instance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArsenalBallInstance _$ArsenalBallInstanceFromJson(Map<String, dynamic> json) {
  return _ArsenalBallInstance.fromJson(json);
}

/// @nodoc
mixin _$ArsenalBallInstance {
  String get instanceId => throw _privateConstructorUsedError;
  String get ballId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  DateTime get addedDate => throw _privateConstructorUsedError;
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  String get bagCategoryId => throw _privateConstructorUsedError;
  BallLayout? get layout => throw _privateConstructorUsedError;
  int get instanceNumber => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // Usage tracking
  int get gamesUsed =>
      throw _privateConstructorUsedError; // Reference to the base bowling ball data - stored as JSON map for serialization
  @JsonKey(name: 'bowling_ball_data')
  @BowlingBallConverter()
  BowlingBall? get bowlingBall =>
      throw _privateConstructorUsedError; // Custom ball data (for user-created balls)
  bool get isCustomBall => throw _privateConstructorUsedError;
  String? get localImagePath => throw _privateConstructorUsedError;

  /// Serializes this ArsenalBallInstance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArsenalBallInstance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArsenalBallInstanceCopyWith<ArsenalBallInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArsenalBallInstanceCopyWith<$Res> {
  factory $ArsenalBallInstanceCopyWith(
          ArsenalBallInstance value, $Res Function(ArsenalBallInstance) then) =
      _$ArsenalBallInstanceCopyWithImpl<$Res, ArsenalBallInstance>;
  @useResult
  $Res call(
      {String instanceId,
      String ballId,
      String userId,
      String nickname,
      DateTime addedDate,
      DateTime? purchaseDate,
      String bagCategoryId,
      BallLayout? layout,
      int instanceNumber,
      String? notes,
      int gamesUsed,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      BowlingBall? bowlingBall,
      bool isCustomBall,
      String? localImagePath});

  $BallLayoutCopyWith<$Res>? get layout;
  $BowlingBallCopyWith<$Res>? get bowlingBall;
}

/// @nodoc
class _$ArsenalBallInstanceCopyWithImpl<$Res, $Val extends ArsenalBallInstance>
    implements $ArsenalBallInstanceCopyWith<$Res> {
  _$ArsenalBallInstanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArsenalBallInstance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instanceId = null,
    Object? ballId = null,
    Object? userId = null,
    Object? nickname = null,
    Object? addedDate = null,
    Object? purchaseDate = freezed,
    Object? bagCategoryId = null,
    Object? layout = freezed,
    Object? instanceNumber = null,
    Object? notes = freezed,
    Object? gamesUsed = null,
    Object? bowlingBall = freezed,
    Object? isCustomBall = null,
    Object? localImagePath = freezed,
  }) {
    return _then(_value.copyWith(
      instanceId: null == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      ballId: null == ballId
          ? _value.ballId
          : ballId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      addedDate: null == addedDate
          ? _value.addedDate
          : addedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      bagCategoryId: null == bagCategoryId
          ? _value.bagCategoryId
          : bagCategoryId // ignore: cast_nullable_to_non_nullable
              as String,
      layout: freezed == layout
          ? _value.layout
          : layout // ignore: cast_nullable_to_non_nullable
              as BallLayout?,
      instanceNumber: null == instanceNumber
          ? _value.instanceNumber
          : instanceNumber // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      gamesUsed: null == gamesUsed
          ? _value.gamesUsed
          : gamesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      bowlingBall: freezed == bowlingBall
          ? _value.bowlingBall
          : bowlingBall // ignore: cast_nullable_to_non_nullable
              as BowlingBall?,
      isCustomBall: null == isCustomBall
          ? _value.isCustomBall
          : isCustomBall // ignore: cast_nullable_to_non_nullable
              as bool,
      localImagePath: freezed == localImagePath
          ? _value.localImagePath
          : localImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ArsenalBallInstance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BallLayoutCopyWith<$Res>? get layout {
    if (_value.layout == null) {
      return null;
    }

    return $BallLayoutCopyWith<$Res>(_value.layout!, (value) {
      return _then(_value.copyWith(layout: value) as $Val);
    });
  }

  /// Create a copy of ArsenalBallInstance
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
abstract class _$$ArsenalBallInstanceImplCopyWith<$Res>
    implements $ArsenalBallInstanceCopyWith<$Res> {
  factory _$$ArsenalBallInstanceImplCopyWith(_$ArsenalBallInstanceImpl value,
          $Res Function(_$ArsenalBallInstanceImpl) then) =
      __$$ArsenalBallInstanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String instanceId,
      String ballId,
      String userId,
      String nickname,
      DateTime addedDate,
      DateTime? purchaseDate,
      String bagCategoryId,
      BallLayout? layout,
      int instanceNumber,
      String? notes,
      int gamesUsed,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      BowlingBall? bowlingBall,
      bool isCustomBall,
      String? localImagePath});

  @override
  $BallLayoutCopyWith<$Res>? get layout;
  @override
  $BowlingBallCopyWith<$Res>? get bowlingBall;
}

/// @nodoc
class __$$ArsenalBallInstanceImplCopyWithImpl<$Res>
    extends _$ArsenalBallInstanceCopyWithImpl<$Res, _$ArsenalBallInstanceImpl>
    implements _$$ArsenalBallInstanceImplCopyWith<$Res> {
  __$$ArsenalBallInstanceImplCopyWithImpl(_$ArsenalBallInstanceImpl _value,
      $Res Function(_$ArsenalBallInstanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArsenalBallInstance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instanceId = null,
    Object? ballId = null,
    Object? userId = null,
    Object? nickname = null,
    Object? addedDate = null,
    Object? purchaseDate = freezed,
    Object? bagCategoryId = null,
    Object? layout = freezed,
    Object? instanceNumber = null,
    Object? notes = freezed,
    Object? gamesUsed = null,
    Object? bowlingBall = freezed,
    Object? isCustomBall = null,
    Object? localImagePath = freezed,
  }) {
    return _then(_$ArsenalBallInstanceImpl(
      instanceId: null == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      ballId: null == ballId
          ? _value.ballId
          : ballId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      addedDate: null == addedDate
          ? _value.addedDate
          : addedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      bagCategoryId: null == bagCategoryId
          ? _value.bagCategoryId
          : bagCategoryId // ignore: cast_nullable_to_non_nullable
              as String,
      layout: freezed == layout
          ? _value.layout
          : layout // ignore: cast_nullable_to_non_nullable
              as BallLayout?,
      instanceNumber: null == instanceNumber
          ? _value.instanceNumber
          : instanceNumber // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      gamesUsed: null == gamesUsed
          ? _value.gamesUsed
          : gamesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      bowlingBall: freezed == bowlingBall
          ? _value.bowlingBall
          : bowlingBall // ignore: cast_nullable_to_non_nullable
              as BowlingBall?,
      isCustomBall: null == isCustomBall
          ? _value.isCustomBall
          : isCustomBall // ignore: cast_nullable_to_non_nullable
              as bool,
      localImagePath: freezed == localImagePath
          ? _value.localImagePath
          : localImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArsenalBallInstanceImpl implements _ArsenalBallInstance {
  const _$ArsenalBallInstanceImpl(
      {required this.instanceId,
      required this.ballId,
      required this.userId,
      this.nickname = '',
      required this.addedDate,
      this.purchaseDate,
      required this.bagCategoryId,
      this.layout,
      this.instanceNumber = 1,
      this.notes,
      this.gamesUsed = 0,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      this.bowlingBall,
      this.isCustomBall = false,
      this.localImagePath});

  factory _$ArsenalBallInstanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArsenalBallInstanceImplFromJson(json);

  @override
  final String instanceId;
  @override
  final String ballId;
  @override
  final String userId;
  @override
  @JsonKey()
  final String nickname;
  @override
  final DateTime addedDate;
  @override
  final DateTime? purchaseDate;
  @override
  final String bagCategoryId;
  @override
  final BallLayout? layout;
  @override
  @JsonKey()
  final int instanceNumber;
  @override
  final String? notes;
// Usage tracking
  @override
  @JsonKey()
  final int gamesUsed;
// Reference to the base bowling ball data - stored as JSON map for serialization
  @override
  @JsonKey(name: 'bowling_ball_data')
  @BowlingBallConverter()
  final BowlingBall? bowlingBall;
// Custom ball data (for user-created balls)
  @override
  @JsonKey()
  final bool isCustomBall;
  @override
  final String? localImagePath;

  @override
  String toString() {
    return 'ArsenalBallInstance(instanceId: $instanceId, ballId: $ballId, userId: $userId, nickname: $nickname, addedDate: $addedDate, purchaseDate: $purchaseDate, bagCategoryId: $bagCategoryId, layout: $layout, instanceNumber: $instanceNumber, notes: $notes, gamesUsed: $gamesUsed, bowlingBall: $bowlingBall, isCustomBall: $isCustomBall, localImagePath: $localImagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArsenalBallInstanceImpl &&
            (identical(other.instanceId, instanceId) ||
                other.instanceId == instanceId) &&
            (identical(other.ballId, ballId) || other.ballId == ballId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.addedDate, addedDate) ||
                other.addedDate == addedDate) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.bagCategoryId, bagCategoryId) ||
                other.bagCategoryId == bagCategoryId) &&
            (identical(other.layout, layout) || other.layout == layout) &&
            (identical(other.instanceNumber, instanceNumber) ||
                other.instanceNumber == instanceNumber) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.gamesUsed, gamesUsed) ||
                other.gamesUsed == gamesUsed) &&
            (identical(other.bowlingBall, bowlingBall) ||
                other.bowlingBall == bowlingBall) &&
            (identical(other.isCustomBall, isCustomBall) ||
                other.isCustomBall == isCustomBall) &&
            (identical(other.localImagePath, localImagePath) ||
                other.localImagePath == localImagePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      instanceId,
      ballId,
      userId,
      nickname,
      addedDate,
      purchaseDate,
      bagCategoryId,
      layout,
      instanceNumber,
      notes,
      gamesUsed,
      bowlingBall,
      isCustomBall,
      localImagePath);

  /// Create a copy of ArsenalBallInstance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArsenalBallInstanceImplCopyWith<_$ArsenalBallInstanceImpl> get copyWith =>
      __$$ArsenalBallInstanceImplCopyWithImpl<_$ArsenalBallInstanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArsenalBallInstanceImplToJson(
      this,
    );
  }
}

abstract class _ArsenalBallInstance implements ArsenalBallInstance {
  const factory _ArsenalBallInstance(
      {required final String instanceId,
      required final String ballId,
      required final String userId,
      final String nickname,
      required final DateTime addedDate,
      final DateTime? purchaseDate,
      required final String bagCategoryId,
      final BallLayout? layout,
      final int instanceNumber,
      final String? notes,
      final int gamesUsed,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      final BowlingBall? bowlingBall,
      final bool isCustomBall,
      final String? localImagePath}) = _$ArsenalBallInstanceImpl;

  factory _ArsenalBallInstance.fromJson(Map<String, dynamic> json) =
      _$ArsenalBallInstanceImpl.fromJson;

  @override
  String get instanceId;
  @override
  String get ballId;
  @override
  String get userId;
  @override
  String get nickname;
  @override
  DateTime get addedDate;
  @override
  DateTime? get purchaseDate;
  @override
  String get bagCategoryId;
  @override
  BallLayout? get layout;
  @override
  int get instanceNumber;
  @override
  String? get notes; // Usage tracking
  @override
  int get gamesUsed; // Reference to the base bowling ball data - stored as JSON map for serialization
  @override
  @JsonKey(name: 'bowling_ball_data')
  @BowlingBallConverter()
  BowlingBall? get bowlingBall; // Custom ball data (for user-created balls)
  @override
  bool get isCustomBall;
  @override
  String? get localImagePath;

  /// Create a copy of ArsenalBallInstance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArsenalBallInstanceImplCopyWith<_$ArsenalBallInstanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
