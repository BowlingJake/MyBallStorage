import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_session.freezed.dart';
part 'training_session.g.dart';

@freezed
class TrainingSession with _$TrainingSession {
  const factory TrainingSession({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required DateTime date,
    required String center,
    @JsonKey(name: 'is_house_pattern') required bool isHousePattern,
    @JsonKey(name: 'oil_pattern_name') String? oilPatternName,
    @JsonKey(name: 'oil_pattern_length') int? oilPatternLength,
    @JsonKey(name: 'scoring_method') required String scoringMethod,
    @JsonKey(name: 'input_method') required String inputMethod,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _TrainingSession;

  factory TrainingSession.fromJson(Map<String, dynamic> json) =>
      _$TrainingSessionFromJson(json);
}