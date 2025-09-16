import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_roll.freezed.dart';
part 'game_roll.g.dart';

@freezed
class GameRoll with _$GameRoll {
  const factory GameRoll({
    @JsonKey(name: 'roll_number') required int rollNumber,
    @JsonKey(name: 'pins_knocked') required int pinsKnocked,
    @JsonKey(name: 'pin_states') required List<bool> pinStates,
    @JsonKey(name: 'ball_used') String? ballUsed,
  }) = _GameRoll;

  factory GameRoll.fromJson(Map<String, dynamic> json) => _$GameRollFromJson(json);
}

@freezed
class GameFrame with _$GameFrame {
  const factory GameFrame({
    @JsonKey(name: 'frame_number') required int frameNumber,
    required List<GameRoll> rolls,
    @JsonKey(name: 'frame_score') int? frameScore,
    @JsonKey(name: 'is_spare') @Default(false) bool isSpare,
    @JsonKey(name: 'is_strike') @Default(false) bool isStrike,
  }) = _GameFrame;

  factory GameFrame.fromJson(Map<String, dynamic> json) => _$GameFrameFromJson(json);
}

@freezed
class GameEquipment with _$GameEquipment {
  const factory GameEquipment({
    @JsonKey(name: 'ball_id') required String ballId,
    @JsonKey(name: 'ball_name') required String ballName,
    required int weight,
    required String surface,
    @JsonKey(name: 'usage_count') @Default(0) int usageCount,
  }) = _GameEquipment;

  factory GameEquipment.fromJson(Map<String, dynamic> json) => _$GameEquipmentFromJson(json);
}