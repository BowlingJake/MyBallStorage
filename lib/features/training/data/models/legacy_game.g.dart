// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legacy_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LegacyGameImpl _$$LegacyGameImplFromJson(Map<String, dynamic> json) =>
    _$LegacyGameImpl(
      id: json['id'] as String,
      trainingSessionId: json['training_session_id'] as String,
      gameNumber: (json['game_number'] as num).toInt(),
      totalScore: (json['total_score'] as num).toInt(),
      frameScores: (json['frame_scores'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      strikes: (json['strikes'] as num?)?.toInt() ?? 0,
      spares: (json['spares'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
      ballsUsed: (json['balls_used'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      detailedRolls: (json['detailed_rolls'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      timestamp: DateTime.parse(json['timestamp'] as String),
      frame1Ball1: (json['frame_1_ball1'] as num?)?.toInt() ?? 0,
      frame1Ball2: (json['frame_1_ball2'] as num?)?.toInt() ?? 0,
      frame2Ball1: (json['frame_2_ball1'] as num?)?.toInt() ?? 0,
      frame2Ball2: (json['frame_2_ball2'] as num?)?.toInt() ?? 0,
      frame3Ball1: (json['frame_3_ball1'] as num?)?.toInt() ?? 0,
      frame3Ball2: (json['frame_3_ball2'] as num?)?.toInt() ?? 0,
      frame4Ball1: (json['frame_4_ball1'] as num?)?.toInt() ?? 0,
      frame4Ball2: (json['frame_4_ball2'] as num?)?.toInt() ?? 0,
      frame5Ball1: (json['frame_5_ball1'] as num?)?.toInt() ?? 0,
      frame5Ball2: (json['frame_5_ball2'] as num?)?.toInt() ?? 0,
      frame6Ball1: (json['frame_6_ball1'] as num?)?.toInt() ?? 0,
      frame6Ball2: (json['frame_6_ball2'] as num?)?.toInt() ?? 0,
      frame7Ball1: (json['frame_7_ball1'] as num?)?.toInt() ?? 0,
      frame7Ball2: (json['frame_7_ball2'] as num?)?.toInt() ?? 0,
      frame8Ball1: (json['frame_8_ball1'] as num?)?.toInt() ?? 0,
      frame8Ball2: (json['frame_8_ball2'] as num?)?.toInt() ?? 0,
      frame9Ball1: (json['frame_9_ball1'] as num?)?.toInt() ?? 0,
      frame9Ball2: (json['frame_9_ball2'] as num?)?.toInt() ?? 0,
      frame10Ball1: (json['frame_10_ball1'] as num?)?.toInt() ?? 0,
      frame10Ball2: (json['frame_10_ball2'] as num?)?.toInt() ?? 0,
      frame10Ball3: (json['frame_10_ball3'] as num?)?.toInt(),
      scoringMode: json['scoring_mode'] as String? ?? 'traditional',
      isCompleted: json['is_completed'] as bool? ?? false,
      currentFrame: (json['current_frame'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$LegacyGameImplToJson(_$LegacyGameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'training_session_id': instance.trainingSessionId,
      'game_number': instance.gameNumber,
      'total_score': instance.totalScore,
      'frame_scores': instance.frameScores,
      'strikes': instance.strikes,
      'spares': instance.spares,
      'notes': instance.notes,
      'balls_used': instance.ballsUsed,
      'detailed_rolls': instance.detailedRolls,
      'timestamp': instance.timestamp.toIso8601String(),
      'frame_1_ball1': instance.frame1Ball1,
      'frame_1_ball2': instance.frame1Ball2,
      'frame_2_ball1': instance.frame2Ball1,
      'frame_2_ball2': instance.frame2Ball2,
      'frame_3_ball1': instance.frame3Ball1,
      'frame_3_ball2': instance.frame3Ball2,
      'frame_4_ball1': instance.frame4Ball1,
      'frame_4_ball2': instance.frame4Ball2,
      'frame_5_ball1': instance.frame5Ball1,
      'frame_5_ball2': instance.frame5Ball2,
      'frame_6_ball1': instance.frame6Ball1,
      'frame_6_ball2': instance.frame6Ball2,
      'frame_7_ball1': instance.frame7Ball1,
      'frame_7_ball2': instance.frame7Ball2,
      'frame_8_ball1': instance.frame8Ball1,
      'frame_8_ball2': instance.frame8Ball2,
      'frame_9_ball1': instance.frame9Ball1,
      'frame_9_ball2': instance.frame9Ball2,
      'frame_10_ball1': instance.frame10Ball1,
      'frame_10_ball2': instance.frame10Ball2,
      'frame_10_ball3': instance.frame10Ball3,
      'scoring_mode': instance.scoringMode,
      'is_completed': instance.isCompleted,
      'current_frame': instance.currentFrame,
    };
