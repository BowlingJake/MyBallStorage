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
  int get gameNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_score')
  int get totalScore => throw _privateConstructorUsedError; // 舊的陣列欄位（向後相容）
  @JsonKey(name: 'frame_scores')
  List<int> get frameScores => throw _privateConstructorUsedError;
  int get strikes => throw _privateConstructorUsedError;
  int get spares => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'balls_used')
  List<Map<String, dynamic>> get ballsUsed =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'detailed_rolls')
  List<Map<String, dynamic>> get detailedRolls =>
      throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError; // 新的個別 frame 欄位
  @JsonKey(name: 'frame_1_ball1')
  int get frame1Ball1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_1_ball2')
  int get frame1Ball2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_2_ball1')
  int get frame2Ball1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_2_ball2')
  int get frame2Ball2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_3_ball1')
  int get frame3Ball1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_3_ball2')
  int get frame3Ball2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_4_ball1')
  int get frame4Ball1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_4_ball2')
  int get frame4Ball2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_5_ball1')
  int get frame5Ball1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_5_ball2')
  int get frame5Ball2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_6_ball1')
  int get frame6Ball1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_6_ball2')
  int get frame6Ball2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_7_ball1')
  int get frame7Ball1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_7_ball2')
  int get frame7Ball2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_8_ball1')
  int get frame8Ball1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_8_ball2')
  int get frame8Ball2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_9_ball1')
  int get frame9Ball1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_9_ball2')
  int get frame9Ball2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_10_ball1')
  int get frame10Ball1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_10_ball2')
  int get frame10Ball2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'frame_10_ball3')
  int? get frame10Ball3 => throw _privateConstructorUsedError; // 計分模式和狀態
  @JsonKey(name: 'scoring_mode')
  String get scoringMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_frame')
  int get currentFrame => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'total_score') int totalScore,
      @JsonKey(name: 'frame_scores') List<int> frameScores,
      int strikes,
      int spares,
      String? notes,
      @JsonKey(name: 'balls_used') List<Map<String, dynamic>> ballsUsed,
      @JsonKey(name: 'detailed_rolls') List<Map<String, dynamic>> detailedRolls,
      DateTime timestamp,
      @JsonKey(name: 'frame_1_ball1') int frame1Ball1,
      @JsonKey(name: 'frame_1_ball2') int frame1Ball2,
      @JsonKey(name: 'frame_2_ball1') int frame2Ball1,
      @JsonKey(name: 'frame_2_ball2') int frame2Ball2,
      @JsonKey(name: 'frame_3_ball1') int frame3Ball1,
      @JsonKey(name: 'frame_3_ball2') int frame3Ball2,
      @JsonKey(name: 'frame_4_ball1') int frame4Ball1,
      @JsonKey(name: 'frame_4_ball2') int frame4Ball2,
      @JsonKey(name: 'frame_5_ball1') int frame5Ball1,
      @JsonKey(name: 'frame_5_ball2') int frame5Ball2,
      @JsonKey(name: 'frame_6_ball1') int frame6Ball1,
      @JsonKey(name: 'frame_6_ball2') int frame6Ball2,
      @JsonKey(name: 'frame_7_ball1') int frame7Ball1,
      @JsonKey(name: 'frame_7_ball2') int frame7Ball2,
      @JsonKey(name: 'frame_8_ball1') int frame8Ball1,
      @JsonKey(name: 'frame_8_ball2') int frame8Ball2,
      @JsonKey(name: 'frame_9_ball1') int frame9Ball1,
      @JsonKey(name: 'frame_9_ball2') int frame9Ball2,
      @JsonKey(name: 'frame_10_ball1') int frame10Ball1,
      @JsonKey(name: 'frame_10_ball2') int frame10Ball2,
      @JsonKey(name: 'frame_10_ball3') int? frame10Ball3,
      @JsonKey(name: 'scoring_mode') String scoringMode,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'current_frame') int currentFrame});
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
    Object? totalScore = null,
    Object? frameScores = null,
    Object? strikes = null,
    Object? spares = null,
    Object? notes = freezed,
    Object? ballsUsed = null,
    Object? detailedRolls = null,
    Object? timestamp = null,
    Object? frame1Ball1 = null,
    Object? frame1Ball2 = null,
    Object? frame2Ball1 = null,
    Object? frame2Ball2 = null,
    Object? frame3Ball1 = null,
    Object? frame3Ball2 = null,
    Object? frame4Ball1 = null,
    Object? frame4Ball2 = null,
    Object? frame5Ball1 = null,
    Object? frame5Ball2 = null,
    Object? frame6Ball1 = null,
    Object? frame6Ball2 = null,
    Object? frame7Ball1 = null,
    Object? frame7Ball2 = null,
    Object? frame8Ball1 = null,
    Object? frame8Ball2 = null,
    Object? frame9Ball1 = null,
    Object? frame9Ball2 = null,
    Object? frame10Ball1 = null,
    Object? frame10Ball2 = null,
    Object? frame10Ball3 = freezed,
    Object? scoringMode = null,
    Object? isCompleted = null,
    Object? currentFrame = null,
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
      totalScore: null == totalScore
          ? _value.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      frameScores: null == frameScores
          ? _value.frameScores
          : frameScores // ignore: cast_nullable_to_non_nullable
              as List<int>,
      strikes: null == strikes
          ? _value.strikes
          : strikes // ignore: cast_nullable_to_non_nullable
              as int,
      spares: null == spares
          ? _value.spares
          : spares // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      ballsUsed: null == ballsUsed
          ? _value.ballsUsed
          : ballsUsed // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      detailedRolls: null == detailedRolls
          ? _value.detailedRolls
          : detailedRolls // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      frame1Ball1: null == frame1Ball1
          ? _value.frame1Ball1
          : frame1Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame1Ball2: null == frame1Ball2
          ? _value.frame1Ball2
          : frame1Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame2Ball1: null == frame2Ball1
          ? _value.frame2Ball1
          : frame2Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame2Ball2: null == frame2Ball2
          ? _value.frame2Ball2
          : frame2Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame3Ball1: null == frame3Ball1
          ? _value.frame3Ball1
          : frame3Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame3Ball2: null == frame3Ball2
          ? _value.frame3Ball2
          : frame3Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame4Ball1: null == frame4Ball1
          ? _value.frame4Ball1
          : frame4Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame4Ball2: null == frame4Ball2
          ? _value.frame4Ball2
          : frame4Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame5Ball1: null == frame5Ball1
          ? _value.frame5Ball1
          : frame5Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame5Ball2: null == frame5Ball2
          ? _value.frame5Ball2
          : frame5Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame6Ball1: null == frame6Ball1
          ? _value.frame6Ball1
          : frame6Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame6Ball2: null == frame6Ball2
          ? _value.frame6Ball2
          : frame6Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame7Ball1: null == frame7Ball1
          ? _value.frame7Ball1
          : frame7Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame7Ball2: null == frame7Ball2
          ? _value.frame7Ball2
          : frame7Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame8Ball1: null == frame8Ball1
          ? _value.frame8Ball1
          : frame8Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame8Ball2: null == frame8Ball2
          ? _value.frame8Ball2
          : frame8Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame9Ball1: null == frame9Ball1
          ? _value.frame9Ball1
          : frame9Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame9Ball2: null == frame9Ball2
          ? _value.frame9Ball2
          : frame9Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame10Ball1: null == frame10Ball1
          ? _value.frame10Ball1
          : frame10Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame10Ball2: null == frame10Ball2
          ? _value.frame10Ball2
          : frame10Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame10Ball3: freezed == frame10Ball3
          ? _value.frame10Ball3
          : frame10Ball3 // ignore: cast_nullable_to_non_nullable
              as int?,
      scoringMode: null == scoringMode
          ? _value.scoringMode
          : scoringMode // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      currentFrame: null == currentFrame
          ? _value.currentFrame
          : currentFrame // ignore: cast_nullable_to_non_nullable
              as int,
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
      @JsonKey(name: 'total_score') int totalScore,
      @JsonKey(name: 'frame_scores') List<int> frameScores,
      int strikes,
      int spares,
      String? notes,
      @JsonKey(name: 'balls_used') List<Map<String, dynamic>> ballsUsed,
      @JsonKey(name: 'detailed_rolls') List<Map<String, dynamic>> detailedRolls,
      DateTime timestamp,
      @JsonKey(name: 'frame_1_ball1') int frame1Ball1,
      @JsonKey(name: 'frame_1_ball2') int frame1Ball2,
      @JsonKey(name: 'frame_2_ball1') int frame2Ball1,
      @JsonKey(name: 'frame_2_ball2') int frame2Ball2,
      @JsonKey(name: 'frame_3_ball1') int frame3Ball1,
      @JsonKey(name: 'frame_3_ball2') int frame3Ball2,
      @JsonKey(name: 'frame_4_ball1') int frame4Ball1,
      @JsonKey(name: 'frame_4_ball2') int frame4Ball2,
      @JsonKey(name: 'frame_5_ball1') int frame5Ball1,
      @JsonKey(name: 'frame_5_ball2') int frame5Ball2,
      @JsonKey(name: 'frame_6_ball1') int frame6Ball1,
      @JsonKey(name: 'frame_6_ball2') int frame6Ball2,
      @JsonKey(name: 'frame_7_ball1') int frame7Ball1,
      @JsonKey(name: 'frame_7_ball2') int frame7Ball2,
      @JsonKey(name: 'frame_8_ball1') int frame8Ball1,
      @JsonKey(name: 'frame_8_ball2') int frame8Ball2,
      @JsonKey(name: 'frame_9_ball1') int frame9Ball1,
      @JsonKey(name: 'frame_9_ball2') int frame9Ball2,
      @JsonKey(name: 'frame_10_ball1') int frame10Ball1,
      @JsonKey(name: 'frame_10_ball2') int frame10Ball2,
      @JsonKey(name: 'frame_10_ball3') int? frame10Ball3,
      @JsonKey(name: 'scoring_mode') String scoringMode,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'current_frame') int currentFrame});
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
    Object? totalScore = null,
    Object? frameScores = null,
    Object? strikes = null,
    Object? spares = null,
    Object? notes = freezed,
    Object? ballsUsed = null,
    Object? detailedRolls = null,
    Object? timestamp = null,
    Object? frame1Ball1 = null,
    Object? frame1Ball2 = null,
    Object? frame2Ball1 = null,
    Object? frame2Ball2 = null,
    Object? frame3Ball1 = null,
    Object? frame3Ball2 = null,
    Object? frame4Ball1 = null,
    Object? frame4Ball2 = null,
    Object? frame5Ball1 = null,
    Object? frame5Ball2 = null,
    Object? frame6Ball1 = null,
    Object? frame6Ball2 = null,
    Object? frame7Ball1 = null,
    Object? frame7Ball2 = null,
    Object? frame8Ball1 = null,
    Object? frame8Ball2 = null,
    Object? frame9Ball1 = null,
    Object? frame9Ball2 = null,
    Object? frame10Ball1 = null,
    Object? frame10Ball2 = null,
    Object? frame10Ball3 = freezed,
    Object? scoringMode = null,
    Object? isCompleted = null,
    Object? currentFrame = null,
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
      totalScore: null == totalScore
          ? _value.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      frameScores: null == frameScores
          ? _value._frameScores
          : frameScores // ignore: cast_nullable_to_non_nullable
              as List<int>,
      strikes: null == strikes
          ? _value.strikes
          : strikes // ignore: cast_nullable_to_non_nullable
              as int,
      spares: null == spares
          ? _value.spares
          : spares // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      ballsUsed: null == ballsUsed
          ? _value._ballsUsed
          : ballsUsed // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      detailedRolls: null == detailedRolls
          ? _value._detailedRolls
          : detailedRolls // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      frame1Ball1: null == frame1Ball1
          ? _value.frame1Ball1
          : frame1Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame1Ball2: null == frame1Ball2
          ? _value.frame1Ball2
          : frame1Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame2Ball1: null == frame2Ball1
          ? _value.frame2Ball1
          : frame2Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame2Ball2: null == frame2Ball2
          ? _value.frame2Ball2
          : frame2Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame3Ball1: null == frame3Ball1
          ? _value.frame3Ball1
          : frame3Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame3Ball2: null == frame3Ball2
          ? _value.frame3Ball2
          : frame3Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame4Ball1: null == frame4Ball1
          ? _value.frame4Ball1
          : frame4Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame4Ball2: null == frame4Ball2
          ? _value.frame4Ball2
          : frame4Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame5Ball1: null == frame5Ball1
          ? _value.frame5Ball1
          : frame5Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame5Ball2: null == frame5Ball2
          ? _value.frame5Ball2
          : frame5Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame6Ball1: null == frame6Ball1
          ? _value.frame6Ball1
          : frame6Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame6Ball2: null == frame6Ball2
          ? _value.frame6Ball2
          : frame6Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame7Ball1: null == frame7Ball1
          ? _value.frame7Ball1
          : frame7Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame7Ball2: null == frame7Ball2
          ? _value.frame7Ball2
          : frame7Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame8Ball1: null == frame8Ball1
          ? _value.frame8Ball1
          : frame8Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame8Ball2: null == frame8Ball2
          ? _value.frame8Ball2
          : frame8Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame9Ball1: null == frame9Ball1
          ? _value.frame9Ball1
          : frame9Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame9Ball2: null == frame9Ball2
          ? _value.frame9Ball2
          : frame9Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame10Ball1: null == frame10Ball1
          ? _value.frame10Ball1
          : frame10Ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      frame10Ball2: null == frame10Ball2
          ? _value.frame10Ball2
          : frame10Ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      frame10Ball3: freezed == frame10Ball3
          ? _value.frame10Ball3
          : frame10Ball3 // ignore: cast_nullable_to_non_nullable
              as int?,
      scoringMode: null == scoringMode
          ? _value.scoringMode
          : scoringMode // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      currentFrame: null == currentFrame
          ? _value.currentFrame
          : currentFrame // ignore: cast_nullable_to_non_nullable
              as int,
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
      @JsonKey(name: 'total_score') required this.totalScore,
      @JsonKey(name: 'frame_scores') final List<int> frameScores = const [],
      this.strikes = 0,
      this.spares = 0,
      this.notes,
      @JsonKey(name: 'balls_used')
      final List<Map<String, dynamic>> ballsUsed = const [],
      @JsonKey(name: 'detailed_rolls')
      final List<Map<String, dynamic>> detailedRolls = const [],
      required this.timestamp,
      @JsonKey(name: 'frame_1_ball1') this.frame1Ball1 = 0,
      @JsonKey(name: 'frame_1_ball2') this.frame1Ball2 = 0,
      @JsonKey(name: 'frame_2_ball1') this.frame2Ball1 = 0,
      @JsonKey(name: 'frame_2_ball2') this.frame2Ball2 = 0,
      @JsonKey(name: 'frame_3_ball1') this.frame3Ball1 = 0,
      @JsonKey(name: 'frame_3_ball2') this.frame3Ball2 = 0,
      @JsonKey(name: 'frame_4_ball1') this.frame4Ball1 = 0,
      @JsonKey(name: 'frame_4_ball2') this.frame4Ball2 = 0,
      @JsonKey(name: 'frame_5_ball1') this.frame5Ball1 = 0,
      @JsonKey(name: 'frame_5_ball2') this.frame5Ball2 = 0,
      @JsonKey(name: 'frame_6_ball1') this.frame6Ball1 = 0,
      @JsonKey(name: 'frame_6_ball2') this.frame6Ball2 = 0,
      @JsonKey(name: 'frame_7_ball1') this.frame7Ball1 = 0,
      @JsonKey(name: 'frame_7_ball2') this.frame7Ball2 = 0,
      @JsonKey(name: 'frame_8_ball1') this.frame8Ball1 = 0,
      @JsonKey(name: 'frame_8_ball2') this.frame8Ball2 = 0,
      @JsonKey(name: 'frame_9_ball1') this.frame9Ball1 = 0,
      @JsonKey(name: 'frame_9_ball2') this.frame9Ball2 = 0,
      @JsonKey(name: 'frame_10_ball1') this.frame10Ball1 = 0,
      @JsonKey(name: 'frame_10_ball2') this.frame10Ball2 = 0,
      @JsonKey(name: 'frame_10_ball3') this.frame10Ball3,
      @JsonKey(name: 'scoring_mode') this.scoringMode = 'traditional',
      @JsonKey(name: 'is_completed') this.isCompleted = false,
      @JsonKey(name: 'current_frame') this.currentFrame = 1})
      : _frameScores = frameScores,
        _ballsUsed = ballsUsed,
        _detailedRolls = detailedRolls;

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
  @override
  @JsonKey(name: 'total_score')
  final int totalScore;
// 舊的陣列欄位（向後相容）
  final List<int> _frameScores;
// 舊的陣列欄位（向後相容）
  @override
  @JsonKey(name: 'frame_scores')
  List<int> get frameScores {
    if (_frameScores is EqualUnmodifiableListView) return _frameScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_frameScores);
  }

  @override
  @JsonKey()
  final int strikes;
  @override
  @JsonKey()
  final int spares;
  @override
  final String? notes;
  final List<Map<String, dynamic>> _ballsUsed;
  @override
  @JsonKey(name: 'balls_used')
  List<Map<String, dynamic>> get ballsUsed {
    if (_ballsUsed is EqualUnmodifiableListView) return _ballsUsed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ballsUsed);
  }

  final List<Map<String, dynamic>> _detailedRolls;
  @override
  @JsonKey(name: 'detailed_rolls')
  List<Map<String, dynamic>> get detailedRolls {
    if (_detailedRolls is EqualUnmodifiableListView) return _detailedRolls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_detailedRolls);
  }

  @override
  final DateTime timestamp;
// 新的個別 frame 欄位
  @override
  @JsonKey(name: 'frame_1_ball1')
  final int frame1Ball1;
  @override
  @JsonKey(name: 'frame_1_ball2')
  final int frame1Ball2;
  @override
  @JsonKey(name: 'frame_2_ball1')
  final int frame2Ball1;
  @override
  @JsonKey(name: 'frame_2_ball2')
  final int frame2Ball2;
  @override
  @JsonKey(name: 'frame_3_ball1')
  final int frame3Ball1;
  @override
  @JsonKey(name: 'frame_3_ball2')
  final int frame3Ball2;
  @override
  @JsonKey(name: 'frame_4_ball1')
  final int frame4Ball1;
  @override
  @JsonKey(name: 'frame_4_ball2')
  final int frame4Ball2;
  @override
  @JsonKey(name: 'frame_5_ball1')
  final int frame5Ball1;
  @override
  @JsonKey(name: 'frame_5_ball2')
  final int frame5Ball2;
  @override
  @JsonKey(name: 'frame_6_ball1')
  final int frame6Ball1;
  @override
  @JsonKey(name: 'frame_6_ball2')
  final int frame6Ball2;
  @override
  @JsonKey(name: 'frame_7_ball1')
  final int frame7Ball1;
  @override
  @JsonKey(name: 'frame_7_ball2')
  final int frame7Ball2;
  @override
  @JsonKey(name: 'frame_8_ball1')
  final int frame8Ball1;
  @override
  @JsonKey(name: 'frame_8_ball2')
  final int frame8Ball2;
  @override
  @JsonKey(name: 'frame_9_ball1')
  final int frame9Ball1;
  @override
  @JsonKey(name: 'frame_9_ball2')
  final int frame9Ball2;
  @override
  @JsonKey(name: 'frame_10_ball1')
  final int frame10Ball1;
  @override
  @JsonKey(name: 'frame_10_ball2')
  final int frame10Ball2;
  @override
  @JsonKey(name: 'frame_10_ball3')
  final int? frame10Ball3;
// 計分模式和狀態
  @override
  @JsonKey(name: 'scoring_mode')
  final String scoringMode;
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  @JsonKey(name: 'current_frame')
  final int currentFrame;

  @override
  String toString() {
    return 'Game(id: $id, trainingSessionId: $trainingSessionId, gameNumber: $gameNumber, totalScore: $totalScore, frameScores: $frameScores, strikes: $strikes, spares: $spares, notes: $notes, ballsUsed: $ballsUsed, detailedRolls: $detailedRolls, timestamp: $timestamp, frame1Ball1: $frame1Ball1, frame1Ball2: $frame1Ball2, frame2Ball1: $frame2Ball1, frame2Ball2: $frame2Ball2, frame3Ball1: $frame3Ball1, frame3Ball2: $frame3Ball2, frame4Ball1: $frame4Ball1, frame4Ball2: $frame4Ball2, frame5Ball1: $frame5Ball1, frame5Ball2: $frame5Ball2, frame6Ball1: $frame6Ball1, frame6Ball2: $frame6Ball2, frame7Ball1: $frame7Ball1, frame7Ball2: $frame7Ball2, frame8Ball1: $frame8Ball1, frame8Ball2: $frame8Ball2, frame9Ball1: $frame9Ball1, frame9Ball2: $frame9Ball2, frame10Ball1: $frame10Ball1, frame10Ball2: $frame10Ball2, frame10Ball3: $frame10Ball3, scoringMode: $scoringMode, isCompleted: $isCompleted, currentFrame: $currentFrame)';
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
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            const DeepCollectionEquality()
                .equals(other._frameScores, _frameScores) &&
            (identical(other.strikes, strikes) || other.strikes == strikes) &&
            (identical(other.spares, spares) || other.spares == spares) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._ballsUsed, _ballsUsed) &&
            const DeepCollectionEquality()
                .equals(other._detailedRolls, _detailedRolls) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.frame1Ball1, frame1Ball1) ||
                other.frame1Ball1 == frame1Ball1) &&
            (identical(other.frame1Ball2, frame1Ball2) ||
                other.frame1Ball2 == frame1Ball2) &&
            (identical(other.frame2Ball1, frame2Ball1) ||
                other.frame2Ball1 == frame2Ball1) &&
            (identical(other.frame2Ball2, frame2Ball2) ||
                other.frame2Ball2 == frame2Ball2) &&
            (identical(other.frame3Ball1, frame3Ball1) ||
                other.frame3Ball1 == frame3Ball1) &&
            (identical(other.frame3Ball2, frame3Ball2) ||
                other.frame3Ball2 == frame3Ball2) &&
            (identical(other.frame4Ball1, frame4Ball1) ||
                other.frame4Ball1 == frame4Ball1) &&
            (identical(other.frame4Ball2, frame4Ball2) ||
                other.frame4Ball2 == frame4Ball2) &&
            (identical(other.frame5Ball1, frame5Ball1) ||
                other.frame5Ball1 == frame5Ball1) &&
            (identical(other.frame5Ball2, frame5Ball2) ||
                other.frame5Ball2 == frame5Ball2) &&
            (identical(other.frame6Ball1, frame6Ball1) ||
                other.frame6Ball1 == frame6Ball1) &&
            (identical(other.frame6Ball2, frame6Ball2) ||
                other.frame6Ball2 == frame6Ball2) &&
            (identical(other.frame7Ball1, frame7Ball1) ||
                other.frame7Ball1 == frame7Ball1) &&
            (identical(other.frame7Ball2, frame7Ball2) ||
                other.frame7Ball2 == frame7Ball2) &&
            (identical(other.frame8Ball1, frame8Ball1) ||
                other.frame8Ball1 == frame8Ball1) &&
            (identical(other.frame8Ball2, frame8Ball2) ||
                other.frame8Ball2 == frame8Ball2) &&
            (identical(other.frame9Ball1, frame9Ball1) ||
                other.frame9Ball1 == frame9Ball1) &&
            (identical(other.frame9Ball2, frame9Ball2) ||
                other.frame9Ball2 == frame9Ball2) &&
            (identical(other.frame10Ball1, frame10Ball1) ||
                other.frame10Ball1 == frame10Ball1) &&
            (identical(other.frame10Ball2, frame10Ball2) ||
                other.frame10Ball2 == frame10Ball2) &&
            (identical(other.frame10Ball3, frame10Ball3) ||
                other.frame10Ball3 == frame10Ball3) &&
            (identical(other.scoringMode, scoringMode) ||
                other.scoringMode == scoringMode) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.currentFrame, currentFrame) ||
                other.currentFrame == currentFrame));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        trainingSessionId,
        gameNumber,
        totalScore,
        const DeepCollectionEquality().hash(_frameScores),
        strikes,
        spares,
        notes,
        const DeepCollectionEquality().hash(_ballsUsed),
        const DeepCollectionEquality().hash(_detailedRolls),
        timestamp,
        frame1Ball1,
        frame1Ball2,
        frame2Ball1,
        frame2Ball2,
        frame3Ball1,
        frame3Ball2,
        frame4Ball1,
        frame4Ball2,
        frame5Ball1,
        frame5Ball2,
        frame6Ball1,
        frame6Ball2,
        frame7Ball1,
        frame7Ball2,
        frame8Ball1,
        frame8Ball2,
        frame9Ball1,
        frame9Ball2,
        frame10Ball1,
        frame10Ball2,
        frame10Ball3,
        scoringMode,
        isCompleted,
        currentFrame
      ]);

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
      @JsonKey(name: 'total_score') required final int totalScore,
      @JsonKey(name: 'frame_scores') final List<int> frameScores,
      final int strikes,
      final int spares,
      final String? notes,
      @JsonKey(name: 'balls_used') final List<Map<String, dynamic>> ballsUsed,
      @JsonKey(name: 'detailed_rolls')
      final List<Map<String, dynamic>> detailedRolls,
      required final DateTime timestamp,
      @JsonKey(name: 'frame_1_ball1') final int frame1Ball1,
      @JsonKey(name: 'frame_1_ball2') final int frame1Ball2,
      @JsonKey(name: 'frame_2_ball1') final int frame2Ball1,
      @JsonKey(name: 'frame_2_ball2') final int frame2Ball2,
      @JsonKey(name: 'frame_3_ball1') final int frame3Ball1,
      @JsonKey(name: 'frame_3_ball2') final int frame3Ball2,
      @JsonKey(name: 'frame_4_ball1') final int frame4Ball1,
      @JsonKey(name: 'frame_4_ball2') final int frame4Ball2,
      @JsonKey(name: 'frame_5_ball1') final int frame5Ball1,
      @JsonKey(name: 'frame_5_ball2') final int frame5Ball2,
      @JsonKey(name: 'frame_6_ball1') final int frame6Ball1,
      @JsonKey(name: 'frame_6_ball2') final int frame6Ball2,
      @JsonKey(name: 'frame_7_ball1') final int frame7Ball1,
      @JsonKey(name: 'frame_7_ball2') final int frame7Ball2,
      @JsonKey(name: 'frame_8_ball1') final int frame8Ball1,
      @JsonKey(name: 'frame_8_ball2') final int frame8Ball2,
      @JsonKey(name: 'frame_9_ball1') final int frame9Ball1,
      @JsonKey(name: 'frame_9_ball2') final int frame9Ball2,
      @JsonKey(name: 'frame_10_ball1') final int frame10Ball1,
      @JsonKey(name: 'frame_10_ball2') final int frame10Ball2,
      @JsonKey(name: 'frame_10_ball3') final int? frame10Ball3,
      @JsonKey(name: 'scoring_mode') final String scoringMode,
      @JsonKey(name: 'is_completed') final bool isCompleted,
      @JsonKey(name: 'current_frame') final int currentFrame}) = _$GameImpl;

  factory _Game.fromJson(Map<String, dynamic> json) = _$GameImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'training_session_id')
  String get trainingSessionId;
  @override
  @JsonKey(name: 'game_number')
  int get gameNumber;
  @override
  @JsonKey(name: 'total_score')
  int get totalScore; // 舊的陣列欄位（向後相容）
  @override
  @JsonKey(name: 'frame_scores')
  List<int> get frameScores;
  @override
  int get strikes;
  @override
  int get spares;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'balls_used')
  List<Map<String, dynamic>> get ballsUsed;
  @override
  @JsonKey(name: 'detailed_rolls')
  List<Map<String, dynamic>> get detailedRolls;
  @override
  DateTime get timestamp; // 新的個別 frame 欄位
  @override
  @JsonKey(name: 'frame_1_ball1')
  int get frame1Ball1;
  @override
  @JsonKey(name: 'frame_1_ball2')
  int get frame1Ball2;
  @override
  @JsonKey(name: 'frame_2_ball1')
  int get frame2Ball1;
  @override
  @JsonKey(name: 'frame_2_ball2')
  int get frame2Ball2;
  @override
  @JsonKey(name: 'frame_3_ball1')
  int get frame3Ball1;
  @override
  @JsonKey(name: 'frame_3_ball2')
  int get frame3Ball2;
  @override
  @JsonKey(name: 'frame_4_ball1')
  int get frame4Ball1;
  @override
  @JsonKey(name: 'frame_4_ball2')
  int get frame4Ball2;
  @override
  @JsonKey(name: 'frame_5_ball1')
  int get frame5Ball1;
  @override
  @JsonKey(name: 'frame_5_ball2')
  int get frame5Ball2;
  @override
  @JsonKey(name: 'frame_6_ball1')
  int get frame6Ball1;
  @override
  @JsonKey(name: 'frame_6_ball2')
  int get frame6Ball2;
  @override
  @JsonKey(name: 'frame_7_ball1')
  int get frame7Ball1;
  @override
  @JsonKey(name: 'frame_7_ball2')
  int get frame7Ball2;
  @override
  @JsonKey(name: 'frame_8_ball1')
  int get frame8Ball1;
  @override
  @JsonKey(name: 'frame_8_ball2')
  int get frame8Ball2;
  @override
  @JsonKey(name: 'frame_9_ball1')
  int get frame9Ball1;
  @override
  @JsonKey(name: 'frame_9_ball2')
  int get frame9Ball2;
  @override
  @JsonKey(name: 'frame_10_ball1')
  int get frame10Ball1;
  @override
  @JsonKey(name: 'frame_10_ball2')
  int get frame10Ball2;
  @override
  @JsonKey(name: 'frame_10_ball3')
  int? get frame10Ball3; // 計分模式和狀態
  @override
  @JsonKey(name: 'scoring_mode')
  String get scoringMode;
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  @JsonKey(name: 'current_frame')
  int get currentFrame;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
