import 'package:freezed_annotation/freezed_annotation.dart';
import 'game_roll.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
class Game with _$Game {
  const factory Game({
    required String id,
    @JsonKey(name: 'training_session_id') required String trainingSessionId,
    @JsonKey(name: 'game_number') required int gameNumber,
    
    // 新的 JSONB 欄位
    @Default([]) List<GameFrame> frames,
    @Default([]) List<GameEquipment> equipment,
    
    // 計算欄位
    @JsonKey(name: 'total_score') @Default(0) int totalScore,
    @Default(0) int strikes,
    @Default(0) int spares,
    
    // 狀態和元資料
    @JsonKey(name: 'scoring_mode') @Default('current') String scoringMode,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    String? notes,
    
    // 時間戳記
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}