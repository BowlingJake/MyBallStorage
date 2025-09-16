// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_roll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameRoll _$GameRollFromJson(Map<String, dynamic> json) {
  return _GameRoll.fromJson(json);
}

/// @nodoc
mixin _$GameRoll {
  @JsonKey(name: 'roll_number')
  int get rollNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'pins_knocked')
  int get pinsKnocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'pin_states')
  List<bool> get pinStates => throw _privateConstructorUsedError;
  @JsonKey(name: 'ball_used')
  String? get ballUsed => throw _privateConstructorUsedError;

  /// Serializes this GameRoll to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameRoll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameRollCopyWith<GameRoll> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameRollCopyWith<$Res> {
  factory $GameRollCopyWith(GameRoll value, $Res Function(GameRoll) then) =
      _$GameRollCopyWithImpl<$Res, GameRoll>;
  @useResult
  $Res call(
      {@JsonKey(name: 'roll_number') int rollNumber,
      @JsonKey(name: 'pins_knocked') int pinsKnocked,
      @JsonKey(name: 'pin_states') List<bool> pinStates,
      @JsonKey(name: 'ball_used') String? ballUsed});
}

/// @nodoc
class _$GameRollCopyWithImpl<$Res, $Val extends GameRoll>
    implements $GameRollCopyWith<$Res> {
  _$GameRollCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameRoll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rollNumber = null,
    Object? pinsKnocked = null,
    Object? pinStates = null,
    Object? ballUsed = freezed,
  }) {
    return _then(_value.copyWith(
      rollNumber: null == rollNumber
          ? _value.rollNumber
          : rollNumber // ignore: cast_nullable_to_non_nullable
              as int,
      pinsKnocked: null == pinsKnocked
          ? _value.pinsKnocked
          : pinsKnocked // ignore: cast_nullable_to_non_nullable
              as int,
      pinStates: null == pinStates
          ? _value.pinStates
          : pinStates // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      ballUsed: freezed == ballUsed
          ? _value.ballUsed
          : ballUsed // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameRollImplCopyWith<$Res>
    implements $GameRollCopyWith<$Res> {
  factory _$$GameRollImplCopyWith(
          _$GameRollImpl value, $Res Function(_$GameRollImpl) then) =
      __$$GameRollImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'roll_number') int rollNumber,
      @JsonKey(name: 'pins_knocked') int pinsKnocked,
      @JsonKey(name: 'pin_states') List<bool> pinStates,
      @JsonKey(name: 'ball_used') String? ballUsed});
}

/// @nodoc
class __$$GameRollImplCopyWithImpl<$Res>
    extends _$GameRollCopyWithImpl<$Res, _$GameRollImpl>
    implements _$$GameRollImplCopyWith<$Res> {
  __$$GameRollImplCopyWithImpl(
      _$GameRollImpl _value, $Res Function(_$GameRollImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameRoll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rollNumber = null,
    Object? pinsKnocked = null,
    Object? pinStates = null,
    Object? ballUsed = freezed,
  }) {
    return _then(_$GameRollImpl(
      rollNumber: null == rollNumber
          ? _value.rollNumber
          : rollNumber // ignore: cast_nullable_to_non_nullable
              as int,
      pinsKnocked: null == pinsKnocked
          ? _value.pinsKnocked
          : pinsKnocked // ignore: cast_nullable_to_non_nullable
              as int,
      pinStates: null == pinStates
          ? _value._pinStates
          : pinStates // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      ballUsed: freezed == ballUsed
          ? _value.ballUsed
          : ballUsed // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameRollImpl implements _GameRoll {
  const _$GameRollImpl(
      {@JsonKey(name: 'roll_number') required this.rollNumber,
      @JsonKey(name: 'pins_knocked') required this.pinsKnocked,
      @JsonKey(name: 'pin_states') required final List<bool> pinStates,
      @JsonKey(name: 'ball_used') this.ballUsed})
      : _pinStates = pinStates;

  factory _$GameRollImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameRollImplFromJson(json);

  @override
  @JsonKey(name: 'roll_number')
  final int rollNumber;
  @override
  @JsonKey(name: 'pins_knocked')
  final int pinsKnocked;
  final List<bool> _pinStates;
  @override
  @JsonKey(name: 'pin_states')
  List<bool> get pinStates {
    if (_pinStates is EqualUnmodifiableListView) return _pinStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pinStates);
  }

  @override
  @JsonKey(name: 'ball_used')
  final String? ballUsed;

  @override
  String toString() {
    return 'GameRoll(rollNumber: $rollNumber, pinsKnocked: $pinsKnocked, pinStates: $pinStates, ballUsed: $ballUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameRollImpl &&
            (identical(other.rollNumber, rollNumber) ||
                other.rollNumber == rollNumber) &&
            (identical(other.pinsKnocked, pinsKnocked) ||
                other.pinsKnocked == pinsKnocked) &&
            const DeepCollectionEquality()
                .equals(other._pinStates, _pinStates) &&
            (identical(other.ballUsed, ballUsed) ||
                other.ballUsed == ballUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rollNumber, pinsKnocked,
      const DeepCollectionEquality().hash(_pinStates), ballUsed);

  /// Create a copy of GameRoll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameRollImplCopyWith<_$GameRollImpl> get copyWith =>
      __$$GameRollImplCopyWithImpl<_$GameRollImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameRollImplToJson(
      this,
    );
  }
}

abstract class _GameRoll implements GameRoll {
  const factory _GameRoll(
      {@JsonKey(name: 'roll_number') required final int rollNumber,
      @JsonKey(name: 'pins_knocked') required final int pinsKnocked,
      @JsonKey(name: 'pin_states') required final List<bool> pinStates,
      @JsonKey(name: 'ball_used') final String? ballUsed}) = _$GameRollImpl;

  factory _GameRoll.fromJson(Map<String, dynamic> json) =
      _$GameRollImpl.fromJson;

  @override
  @JsonKey(name: 'roll_number')
  int get rollNumber;
  @override
  @JsonKey(name: 'pins_knocked')
  int get pinsKnocked;
  @override
  @JsonKey(name: 'pin_states')
  List<bool> get pinStates;
  @override
  @JsonKey(name: 'ball_used')
  String? get ballUsed;

  /// Create a copy of GameRoll
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameRollImplCopyWith<_$GameRollImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameFrame _$GameFrameFromJson(Map<String, dynamic> json) {
  return _GameFrame.fromJson(json);
}

/// @nodoc
mixin _$GameFrame {
  @JsonKey(name: 'frame_number')
  int get frameNumber => throw _privateConstructorUsedError;
  List<GameRoll> get rolls => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_score')
  int? get frameScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_spare')
  bool get isSpare => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_strike')
  bool get isStrike => throw _privateConstructorUsedError;

  /// Serializes this GameFrame to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameFrame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameFrameCopyWith<GameFrame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameFrameCopyWith<$Res> {
  factory $GameFrameCopyWith(GameFrame value, $Res Function(GameFrame) then) =
      _$GameFrameCopyWithImpl<$Res, GameFrame>;
  @useResult
  $Res call(
      {@JsonKey(name: 'frame_number') int frameNumber,
      List<GameRoll> rolls,
      @JsonKey(name: 'frame_score') int? frameScore,
      @JsonKey(name: 'is_spare') bool isSpare,
      @JsonKey(name: 'is_strike') bool isStrike});
}

/// @nodoc
class _$GameFrameCopyWithImpl<$Res, $Val extends GameFrame>
    implements $GameFrameCopyWith<$Res> {
  _$GameFrameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameFrame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frameNumber = null,
    Object? rolls = null,
    Object? frameScore = freezed,
    Object? isSpare = null,
    Object? isStrike = null,
  }) {
    return _then(_value.copyWith(
      frameNumber: null == frameNumber
          ? _value.frameNumber
          : frameNumber // ignore: cast_nullable_to_non_nullable
              as int,
      rolls: null == rolls
          ? _value.rolls
          : rolls // ignore: cast_nullable_to_non_nullable
              as List<GameRoll>,
      frameScore: freezed == frameScore
          ? _value.frameScore
          : frameScore // ignore: cast_nullable_to_non_nullable
              as int?,
      isSpare: null == isSpare
          ? _value.isSpare
          : isSpare // ignore: cast_nullable_to_non_nullable
              as bool,
      isStrike: null == isStrike
          ? _value.isStrike
          : isStrike // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameFrameImplCopyWith<$Res>
    implements $GameFrameCopyWith<$Res> {
  factory _$$GameFrameImplCopyWith(
          _$GameFrameImpl value, $Res Function(_$GameFrameImpl) then) =
      __$$GameFrameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'frame_number') int frameNumber,
      List<GameRoll> rolls,
      @JsonKey(name: 'frame_score') int? frameScore,
      @JsonKey(name: 'is_spare') bool isSpare,
      @JsonKey(name: 'is_strike') bool isStrike});
}

/// @nodoc
class __$$GameFrameImplCopyWithImpl<$Res>
    extends _$GameFrameCopyWithImpl<$Res, _$GameFrameImpl>
    implements _$$GameFrameImplCopyWith<$Res> {
  __$$GameFrameImplCopyWithImpl(
      _$GameFrameImpl _value, $Res Function(_$GameFrameImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameFrame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frameNumber = null,
    Object? rolls = null,
    Object? frameScore = freezed,
    Object? isSpare = null,
    Object? isStrike = null,
  }) {
    return _then(_$GameFrameImpl(
      frameNumber: null == frameNumber
          ? _value.frameNumber
          : frameNumber // ignore: cast_nullable_to_non_nullable
              as int,
      rolls: null == rolls
          ? _value._rolls
          : rolls // ignore: cast_nullable_to_non_nullable
              as List<GameRoll>,
      frameScore: freezed == frameScore
          ? _value.frameScore
          : frameScore // ignore: cast_nullable_to_non_nullable
              as int?,
      isSpare: null == isSpare
          ? _value.isSpare
          : isSpare // ignore: cast_nullable_to_non_nullable
              as bool,
      isStrike: null == isStrike
          ? _value.isStrike
          : isStrike // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameFrameImpl implements _GameFrame {
  const _$GameFrameImpl(
      {@JsonKey(name: 'frame_number') required this.frameNumber,
      required final List<GameRoll> rolls,
      @JsonKey(name: 'frame_score') this.frameScore,
      @JsonKey(name: 'is_spare') this.isSpare = false,
      @JsonKey(name: 'is_strike') this.isStrike = false})
      : _rolls = rolls;

  factory _$GameFrameImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameFrameImplFromJson(json);

  @override
  @JsonKey(name: 'frame_number')
  final int frameNumber;
  final List<GameRoll> _rolls;
  @override
  List<GameRoll> get rolls {
    if (_rolls is EqualUnmodifiableListView) return _rolls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rolls);
  }

  @override
  @JsonKey(name: 'frame_score')
  final int? frameScore;
  @override
  @JsonKey(name: 'is_spare')
  final bool isSpare;
  @override
  @JsonKey(name: 'is_strike')
  final bool isStrike;

  @override
  String toString() {
    return 'GameFrame(frameNumber: $frameNumber, rolls: $rolls, frameScore: $frameScore, isSpare: $isSpare, isStrike: $isStrike)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameFrameImpl &&
            (identical(other.frameNumber, frameNumber) ||
                other.frameNumber == frameNumber) &&
            const DeepCollectionEquality().equals(other._rolls, _rolls) &&
            (identical(other.frameScore, frameScore) ||
                other.frameScore == frameScore) &&
            (identical(other.isSpare, isSpare) || other.isSpare == isSpare) &&
            (identical(other.isStrike, isStrike) ||
                other.isStrike == isStrike));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      frameNumber,
      const DeepCollectionEquality().hash(_rolls),
      frameScore,
      isSpare,
      isStrike);

  /// Create a copy of GameFrame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameFrameImplCopyWith<_$GameFrameImpl> get copyWith =>
      __$$GameFrameImplCopyWithImpl<_$GameFrameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameFrameImplToJson(
      this,
    );
  }
}

abstract class _GameFrame implements GameFrame {
  const factory _GameFrame(
      {@JsonKey(name: 'frame_number') required final int frameNumber,
      required final List<GameRoll> rolls,
      @JsonKey(name: 'frame_score') final int? frameScore,
      @JsonKey(name: 'is_spare') final bool isSpare,
      @JsonKey(name: 'is_strike') final bool isStrike}) = _$GameFrameImpl;

  factory _GameFrame.fromJson(Map<String, dynamic> json) =
      _$GameFrameImpl.fromJson;

  @override
  @JsonKey(name: 'frame_number')
  int get frameNumber;
  @override
  List<GameRoll> get rolls;
  @override
  @JsonKey(name: 'frame_score')
  int? get frameScore;
  @override
  @JsonKey(name: 'is_spare')
  bool get isSpare;
  @override
  @JsonKey(name: 'is_strike')
  bool get isStrike;

  /// Create a copy of GameFrame
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameFrameImplCopyWith<_$GameFrameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameEquipment _$GameEquipmentFromJson(Map<String, dynamic> json) {
  return _GameEquipment.fromJson(json);
}

/// @nodoc
mixin _$GameEquipment {
  @JsonKey(name: 'ball_id')
  String get ballId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ball_name')
  String get ballName => throw _privateConstructorUsedError;
  int get weight => throw _privateConstructorUsedError;
  String get surface => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_count')
  int get usageCount => throw _privateConstructorUsedError;

  /// Serializes this GameEquipment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameEquipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameEquipmentCopyWith<GameEquipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameEquipmentCopyWith<$Res> {
  factory $GameEquipmentCopyWith(
          GameEquipment value, $Res Function(GameEquipment) then) =
      _$GameEquipmentCopyWithImpl<$Res, GameEquipment>;
  @useResult
  $Res call(
      {@JsonKey(name: 'ball_id') String ballId,
      @JsonKey(name: 'ball_name') String ballName,
      int weight,
      String surface,
      @JsonKey(name: 'usage_count') int usageCount});
}

/// @nodoc
class _$GameEquipmentCopyWithImpl<$Res, $Val extends GameEquipment>
    implements $GameEquipmentCopyWith<$Res> {
  _$GameEquipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameEquipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ballId = null,
    Object? ballName = null,
    Object? weight = null,
    Object? surface = null,
    Object? usageCount = null,
  }) {
    return _then(_value.copyWith(
      ballId: null == ballId
          ? _value.ballId
          : ballId // ignore: cast_nullable_to_non_nullable
              as String,
      ballName: null == ballName
          ? _value.ballName
          : ballName // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int,
      surface: null == surface
          ? _value.surface
          : surface // ignore: cast_nullable_to_non_nullable
              as String,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameEquipmentImplCopyWith<$Res>
    implements $GameEquipmentCopyWith<$Res> {
  factory _$$GameEquipmentImplCopyWith(
          _$GameEquipmentImpl value, $Res Function(_$GameEquipmentImpl) then) =
      __$$GameEquipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'ball_id') String ballId,
      @JsonKey(name: 'ball_name') String ballName,
      int weight,
      String surface,
      @JsonKey(name: 'usage_count') int usageCount});
}

/// @nodoc
class __$$GameEquipmentImplCopyWithImpl<$Res>
    extends _$GameEquipmentCopyWithImpl<$Res, _$GameEquipmentImpl>
    implements _$$GameEquipmentImplCopyWith<$Res> {
  __$$GameEquipmentImplCopyWithImpl(
      _$GameEquipmentImpl _value, $Res Function(_$GameEquipmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameEquipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ballId = null,
    Object? ballName = null,
    Object? weight = null,
    Object? surface = null,
    Object? usageCount = null,
  }) {
    return _then(_$GameEquipmentImpl(
      ballId: null == ballId
          ? _value.ballId
          : ballId // ignore: cast_nullable_to_non_nullable
              as String,
      ballName: null == ballName
          ? _value.ballName
          : ballName // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int,
      surface: null == surface
          ? _value.surface
          : surface // ignore: cast_nullable_to_non_nullable
              as String,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameEquipmentImpl implements _GameEquipment {
  const _$GameEquipmentImpl(
      {@JsonKey(name: 'ball_id') required this.ballId,
      @JsonKey(name: 'ball_name') required this.ballName,
      required this.weight,
      required this.surface,
      @JsonKey(name: 'usage_count') this.usageCount = 0});

  factory _$GameEquipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameEquipmentImplFromJson(json);

  @override
  @JsonKey(name: 'ball_id')
  final String ballId;
  @override
  @JsonKey(name: 'ball_name')
  final String ballName;
  @override
  final int weight;
  @override
  final String surface;
  @override
  @JsonKey(name: 'usage_count')
  final int usageCount;

  @override
  String toString() {
    return 'GameEquipment(ballId: $ballId, ballName: $ballName, weight: $weight, surface: $surface, usageCount: $usageCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameEquipmentImpl &&
            (identical(other.ballId, ballId) || other.ballId == ballId) &&
            (identical(other.ballName, ballName) ||
                other.ballName == ballName) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.surface, surface) || other.surface == surface) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, ballId, ballName, weight, surface, usageCount);

  /// Create a copy of GameEquipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameEquipmentImplCopyWith<_$GameEquipmentImpl> get copyWith =>
      __$$GameEquipmentImplCopyWithImpl<_$GameEquipmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameEquipmentImplToJson(
      this,
    );
  }
}

abstract class _GameEquipment implements GameEquipment {
  const factory _GameEquipment(
          {@JsonKey(name: 'ball_id') required final String ballId,
          @JsonKey(name: 'ball_name') required final String ballName,
          required final int weight,
          required final String surface,
          @JsonKey(name: 'usage_count') final int usageCount}) =
      _$GameEquipmentImpl;

  factory _GameEquipment.fromJson(Map<String, dynamic> json) =
      _$GameEquipmentImpl.fromJson;

  @override
  @JsonKey(name: 'ball_id')
  String get ballId;
  @override
  @JsonKey(name: 'ball_name')
  String get ballName;
  @override
  int get weight;
  @override
  String get surface;
  @override
  @JsonKey(name: 'usage_count')
  int get usageCount;

  /// Create a copy of GameEquipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameEquipmentImplCopyWith<_$GameEquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
