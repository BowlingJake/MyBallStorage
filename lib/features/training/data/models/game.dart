import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
class Game with _$Game {
  const factory Game({
    required String id,
    @JsonKey(name: 'training_session_id') required String trainingSessionId,
    @JsonKey(name: 'game_number') required int gameNumber,
    @JsonKey(name: 'total_score') required int totalScore,
    // 舊的陣列欄位（向後相容）
    @JsonKey(name: 'frame_scores') @Default([]) List<int> frameScores,
    @Default(0) int strikes,
    @Default(0) int spares,
    String? notes,
    @JsonKey(name: 'balls_used') @Default([]) List<Map<String, dynamic>> ballsUsed,
    @JsonKey(name: 'detailed_rolls') @Default([]) List<Map<String, dynamic>> detailedRolls,
    required DateTime timestamp,
    // 新的個別 frame 欄位
    @JsonKey(name: 'frame_1_ball1') @Default(0) int frame1Ball1,
    @JsonKey(name: 'frame_1_ball2') @Default(0) int frame1Ball2,
    @JsonKey(name: 'frame_2_ball1') @Default(0) int frame2Ball1,
    @JsonKey(name: 'frame_2_ball2') @Default(0) int frame2Ball2,
    @JsonKey(name: 'frame_3_ball1') @Default(0) int frame3Ball1,
    @JsonKey(name: 'frame_3_ball2') @Default(0) int frame3Ball2,
    @JsonKey(name: 'frame_4_ball1') @Default(0) int frame4Ball1,
    @JsonKey(name: 'frame_4_ball2') @Default(0) int frame4Ball2,
    @JsonKey(name: 'frame_5_ball1') @Default(0) int frame5Ball1,
    @JsonKey(name: 'frame_5_ball2') @Default(0) int frame5Ball2,
    @JsonKey(name: 'frame_6_ball1') @Default(0) int frame6Ball1,
    @JsonKey(name: 'frame_6_ball2') @Default(0) int frame6Ball2,
    @JsonKey(name: 'frame_7_ball1') @Default(0) int frame7Ball1,
    @JsonKey(name: 'frame_7_ball2') @Default(0) int frame7Ball2,
    @JsonKey(name: 'frame_8_ball1') @Default(0) int frame8Ball1,
    @JsonKey(name: 'frame_8_ball2') @Default(0) int frame8Ball2,
    @JsonKey(name: 'frame_9_ball1') @Default(0) int frame9Ball1,
    @JsonKey(name: 'frame_9_ball2') @Default(0) int frame9Ball2,
    @JsonKey(name: 'frame_10_ball1') @Default(0) int frame10Ball1,
    @JsonKey(name: 'frame_10_ball2') @Default(0) int frame10Ball2,
    @JsonKey(name: 'frame_10_ball3') int? frame10Ball3,
    // 計分模式和狀態
    @JsonKey(name: 'scoring_mode') @Default('traditional') String scoringMode,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'current_frame') @Default(1) int currentFrame,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}