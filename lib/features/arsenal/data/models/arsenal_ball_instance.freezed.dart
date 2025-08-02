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
  @JsonKey(name: 'instance_id')
  String get instanceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ball_id')
  String get ballId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'added_date')
  DateTime get addedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_date')
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_category_id')
  String get bagCategoryId => throw _privateConstructorUsedError;
  BallLayout? get layout => throw _privateConstructorUsedError;
  @JsonKey(name: 'instance_number')
  int get instanceNumber => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // Usage tracking
  @JsonKey(name: 'games_used')
  int get gamesUsed =>
      throw _privateConstructorUsedError; // Reference to the base bowling ball data - stored as JSON map for serialization
  @JsonKey(name: 'bowling_ball_data')
  @BowlingBallConverter()
  BowlingBall? get bowlingBall =>
      throw _privateConstructorUsedError; // Custom ball data (for user-created balls)
  @JsonKey(name: 'is_custom_ball')
  bool get isCustomBall => throw _privateConstructorUsedError;
  @JsonKey(name: 'local_image_path')
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
      {@JsonKey(name: 'instance_id') String instanceId,
      @JsonKey(name: 'ball_id') String ballId,
      @JsonKey(name: 'user_id') String userId,
      String nickname,
      @JsonKey(name: 'added_date') DateTime addedDate,
      @JsonKey(name: 'purchase_date') DateTime? purchaseDate,
      @JsonKey(name: 'bag_category_id') String bagCategoryId,
      BallLayout? layout,
      @JsonKey(name: 'instance_number') int instanceNumber,
      String? notes,
      @JsonKey(name: 'games_used') int gamesUsed,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      BowlingBall? bowlingBall,
      @JsonKey(name: 'is_custom_ball') bool isCustomBall,
      @JsonKey(name: 'local_image_path') String? localImagePath});

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
      {@JsonKey(name: 'instance_id') String instanceId,
      @JsonKey(name: 'ball_id') String ballId,
      @JsonKey(name: 'user_id') String userId,
      String nickname,
      @JsonKey(name: 'added_date') DateTime addedDate,
      @JsonKey(name: 'purchase_date') DateTime? purchaseDate,
      @JsonKey(name: 'bag_category_id') String bagCategoryId,
      BallLayout? layout,
      @JsonKey(name: 'instance_number') int instanceNumber,
      String? notes,
      @JsonKey(name: 'games_used') int gamesUsed,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      BowlingBall? bowlingBall,
      @JsonKey(name: 'is_custom_ball') bool isCustomBall,
      @JsonKey(name: 'local_image_path') String? localImagePath});

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
      {@JsonKey(name: 'instance_id') required this.instanceId,
      @JsonKey(name: 'ball_id') required this.ballId,
      @JsonKey(name: 'user_id') required this.userId,
      this.nickname = '',
      @JsonKey(name: 'added_date') required this.addedDate,
      @JsonKey(name: 'purchase_date') this.purchaseDate,
      @JsonKey(name: 'bag_category_id') required this.bagCategoryId,
      this.layout,
      @JsonKey(name: 'instance_number') this.instanceNumber = 1,
      this.notes,
      @JsonKey(name: 'games_used') this.gamesUsed = 0,
      @JsonKey(name: 'bowling_ball_data')
      @BowlingBallConverter()
      this.bowlingBall,
      @JsonKey(name: 'is_custom_ball') this.isCustomBall = false,
      @JsonKey(name: 'local_image_path') this.localImagePath});

  factory _$ArsenalBallInstanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArsenalBallInstanceImplFromJson(json);

  @override
  @JsonKey(name: 'instance_id')
  final String instanceId;
  @override
  @JsonKey(name: 'ball_id')
  final String ballId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey()
  final String nickname;
  @override
  @JsonKey(name: 'added_date')
  final DateTime addedDate;
  @override
  @JsonKey(name: 'purchase_date')
  final DateTime? purchaseDate;
  @override
  @JsonKey(name: 'bag_category_id')
  final String bagCategoryId;
  @override
  final BallLayout? layout;
  @override
  @JsonKey(name: 'instance_number')
  final int instanceNumber;
  @override
  final String? notes;
// Usage tracking
  @override
  @JsonKey(name: 'games_used')
  final int gamesUsed;
// Reference to the base bowling ball data - stored as JSON map for serialization
  @override
  @JsonKey(name: 'bowling_ball_data')
  @BowlingBallConverter()
  final BowlingBall? bowlingBall;
// Custom ball data (for user-created balls)
  @override
  @JsonKey(name: 'is_custom_ball')
  final bool isCustomBall;
  @override
  @JsonKey(name: 'local_image_path')
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
          {@JsonKey(name: 'instance_id') required final String instanceId,
          @JsonKey(name: 'ball_id') required final String ballId,
          @JsonKey(name: 'user_id') required final String userId,
          final String nickname,
          @JsonKey(name: 'added_date') required final DateTime addedDate,
          @JsonKey(name: 'purchase_date') final DateTime? purchaseDate,
          @JsonKey(name: 'bag_category_id') required final String bagCategoryId,
          final BallLayout? layout,
          @JsonKey(name: 'instance_number') final int instanceNumber,
          final String? notes,
          @JsonKey(name: 'games_used') final int gamesUsed,
          @JsonKey(name: 'bowling_ball_data')
          @BowlingBallConverter()
          final BowlingBall? bowlingBall,
          @JsonKey(name: 'is_custom_ball') final bool isCustomBall,
          @JsonKey(name: 'local_image_path') final String? localImagePath}) =
      _$ArsenalBallInstanceImpl;

  factory _ArsenalBallInstance.fromJson(Map<String, dynamic> json) =
      _$ArsenalBallInstanceImpl.fromJson;

  @override
  @JsonKey(name: 'instance_id')
  String get instanceId;
  @override
  @JsonKey(name: 'ball_id')
  String get ballId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get nickname;
  @override
  @JsonKey(name: 'added_date')
  DateTime get addedDate;
  @override
  @JsonKey(name: 'purchase_date')
  DateTime? get purchaseDate;
  @override
  @JsonKey(name: 'bag_category_id')
  String get bagCategoryId;
  @override
  BallLayout? get layout;
  @override
  @JsonKey(name: 'instance_number')
  int get instanceNumber;
  @override
  String? get notes; // Usage tracking
  @override
  @JsonKey(name: 'games_used')
  int get gamesUsed; // Reference to the base bowling ball data - stored as JSON map for serialization
  @override
  @JsonKey(name: 'bowling_ball_data')
  @BowlingBallConverter()
  BowlingBall? get bowlingBall; // Custom ball data (for user-created balls)
  @override
  @JsonKey(name: 'is_custom_ball')
  bool get isCustomBall;
  @override
  @JsonKey(name: 'local_image_path')
  String? get localImagePath;

  /// Create a copy of ArsenalBallInstance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArsenalBallInstanceImplCopyWith<_$ArsenalBallInstanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
