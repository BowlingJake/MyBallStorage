// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Game _$GameFromJson(Map<String, dynamic> json) {
  return _Game.fromJson(json);
}

/// @nodoc
mixin _$Game {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'training_session_id')
  String get trainingSessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'game_number')
  int get gameNumber => throw _privateConstructorUsedError; // 新的 JSONB 欄位
  List<GameFrame> get frames => throw _privateConstructorUsedError;
  List<GameEquipment> get equipment =>
      throw _privateConstructorUsedError; // 計算欄位
  @JsonKey(name: 'total_score')
  int get totalScore => throw _privateConstructorUsedError;
  int get strikes => throw _privateConstructorUsedError;
  int get spares => throw _privateConstructorUsedError; // 狀態和元資料
  @JsonKey(name: 'scoring_mode')
  String get scoringMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // 時間戳記
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Game to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameCopyWith<Game> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) then) =
      _$GameCopyWithImpl<$Res, Game>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'training_session_id') String trainingSessionId,
      @JsonKey(name: 'game_number') int gameNumber,
      List<GameFrame> frames,
      List<GameEquipment> equipment,
      @JsonKey(name: 'total_score') int totalScore,
      int strikes,
      int spares,
      @JsonKey(name: 'scoring_mode') String scoringMode,
      @JsonKey(name: 'is_completed') bool isCompleted,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$GameCopyWithImpl<$Res, $Val extends Game>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainingSessionId = null,
    Object? gameNumber = null,
    Object? frames = null,
    Object? equipment = null,
    Object? totalScore = null,
    Object? strikes = null,
    Object? spares = null,
    Object? scoringMode = null,
    Object? isCompleted = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trainingSessionId: null == trainingSessionId
          ? _value.trainingSessionId
          : trainingSessionId // ignore: cast_nullable_to_non_nullable
              as String,
      gameNumber: null == gameNumber
          ? _value.gameNumber
          : gameNumber // ignore: cast_nullable_to_non_nullable
              as int,
      frames: null == frames
          ? _value.frames
          : frames // ignore: cast_nullable_to_non_nullable
              as List<GameFrame>,
      equipment: null == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<GameEquipment>,
      totalScore: null == totalScore
          ? _value.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      strikes: null == strikes
          ? _value.strikes
          : strikes // ignore: cast_nullable_to_non_nullable
              as int,
      spares: null == spares
          ? _value.spares
          : spares // ignore: cast_nullable_to_non_nullable
              as int,
      scoringMode: null == scoringMode
          ? _value.scoringMode
          : scoringMode // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$GameImplCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$$GameImplCopyWith(
          _$GameImpl value, $Res Function(_$GameImpl) then) =
      __$$GameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'training_session_id') String trainingSessionId,
      @JsonKey(name: 'game_number') int gameNumber,
      List<GameFrame> frames,
      List<GameEquipment> equipment,
      @JsonKey(name: 'total_score') int totalScore,
      int strikes,
      int spares,
      @JsonKey(name: 'scoring_mode') String scoringMode,
      @JsonKey(name: 'is_completed') bool isCompleted,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$GameImplCopyWithImpl<$Res>
    extends _$GameCopyWithImpl<$Res, _$GameImpl>
    implements _$$GameImplCopyWith<$Res> {
  __$$GameImplCopyWithImpl(_$GameImpl _value, $Res Function(_$GameImpl) _then)
      : super(_value, _then);

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainingSessionId = null,
    Object? gameNumber = null,
    Object? frames = null,
    Object? equipment = null,
    Object? totalScore = null,
    Object? strikes = null,
    Object? spares = null,
    Object? scoringMode = null,
    Object? isCompleted = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$GameImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trainingSessionId: null == trainingSessionId
          ? _value.trainingSessionId
          : trainingSessionId // ignore: cast_nullable_to_non_nullable
              as String,
      gameNumber: null == gameNumber
          ? _value.gameNumber
          : gameNumber // ignore: cast_nullable_to_non_nullable
              as int,
      frames: null == frames
          ? _value._frames
          : frames // ignore: cast_nullable_to_non_nullable
              as List<GameFrame>,
      equipment: null == equipment
          ? _value._equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<GameEquipment>,
      totalScore: null == totalScore
          ? _value.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      strikes: null == strikes
          ? _value.strikes
          : strikes // ignore: cast_nullable_to_non_nullable
              as int,
      spares: null == spares
          ? _value.spares
          : spares // ignore: cast_nullable_to_non_nullable
              as int,
      scoringMode: null == scoringMode
          ? _value.scoringMode
          : scoringMode // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$GameImpl implements _Game {
  const _$GameImpl(
      {required this.id,
      @JsonKey(name: 'training_session_id') required this.trainingSessionId,
      @JsonKey(name: 'game_number') required this.gameNumber,
      final List<GameFrame> frames = const [],
      final List<GameEquipment> equipment = const [],
      @JsonKey(name: 'total_score') this.totalScore = 0,
      this.strikes = 0,
      this.spares = 0,
      @JsonKey(name: 'scoring_mode') this.scoringMode = 'current',
      @JsonKey(name: 'is_completed') this.isCompleted = false,
      this.notes,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _frames = frames,
        _equipment = equipment;

  factory _$GameImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'training_session_id')
  final String trainingSessionId;
  @override
  @JsonKey(name: 'game_number')
  final int gameNumber;
// 新的 JSONB 欄位
  final List<GameFrame> _frames;
// 新的 JSONB 欄位
  @override
  @JsonKey()
  List<GameFrame> get frames {
    if (_frames is EqualUnmodifiableListView) return _frames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_frames);
  }

  final List<GameEquipment> _equipment;
  @override
  @JsonKey()
  List<GameEquipment> get equipment {
    if (_equipment is EqualUnmodifiableListView) return _equipment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipment);
  }

// 計算欄位
  @override
  @JsonKey(name: 'total_score')
  final int totalScore;
  @override
  @JsonKey()
  final int strikes;
  @override
  @JsonKey()
  final int spares;
// 狀態和元資料
  @override
  @JsonKey(name: 'scoring_mode')
  final String scoringMode;
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  final String? notes;
// 時間戳記
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Game(id: $id, trainingSessionId: $trainingSessionId, gameNumber: $gameNumber, frames: $frames, equipment: $equipment, totalScore: $totalScore, strikes: $strikes, spares: $spares, scoringMode: $scoringMode, isCompleted: $isCompleted, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trainingSessionId, trainingSessionId) ||
                other.trainingSessionId == trainingSessionId) &&
            (identical(other.gameNumber, gameNumber) ||
                other.gameNumber == gameNumber) &&
            const DeepCollectionEquality().equals(other._frames, _frames) &&
            const DeepCollectionEquality()
                .equals(other._equipment, _equipment) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.strikes, strikes) || other.strikes == strikes) &&
            (identical(other.spares, spares) || other.spares == spares) &&
            (identical(other.scoringMode, scoringMode) ||
                other.scoringMode == scoringMode) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
      trainingSessionId,
      gameNumber,
      const DeepCollectionEquality().hash(_frames),
      const DeepCollectionEquality().hash(_equipment),
      totalScore,
      strikes,
      spares,
      scoringMode,
      isCompleted,
      notes,
      createdAt,
      updatedAt);

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      __$$GameImplCopyWithImpl<_$GameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameImplToJson(
      this,
    );
  }
}

abstract class _Game implements Game {
  const factory _Game(
          {required final String id,
          @JsonKey(name: 'training_session_id')
          required final String trainingSessionId,
          @JsonKey(name: 'game_number') required final int gameNumber,
          final List<GameFrame> frames,
          final List<GameEquipment> equipment,
          @JsonKey(name: 'total_score') final int totalScore,
          final int strikes,
          final int spares,
          @JsonKey(name: 'scoring_mode') final String scoringMode,
          @JsonKey(name: 'is_completed') final bool isCompleted,
          final String? notes,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$GameImpl;

  factory _Game.fromJson(Map<String, dynamic> json) = _$GameImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'training_session_id')
  String get trainingSessionId;
  @override
  @JsonKey(name: 'game_number')
  int get gameNumber; // 新的 JSONB 欄位
  @override
  List<GameFrame> get frames;
  @override
  List<GameEquipment> get equipment; // 計算欄位
  @override
  @JsonKey(name: 'total_score')
  int get totalScore;
  @override
  int get strikes;
  @override
  int get spares; // 狀態和元資料
  @override
  @JsonKey(name: 'scoring_mode')
  String get scoringMode;
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  String? get notes; // 時間戳記
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
