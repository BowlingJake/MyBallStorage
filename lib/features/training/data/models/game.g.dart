// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameImpl _$$GameImplFromJson(Map<String, dynamic> json) => _$GameImpl(
      id: json['id'] as String,
      trainingSessionId: json['training_session_id'] as String,
      gameNumber: (json['game_number'] as num).toInt(),
      frames: (json['frames'] as List<dynamic>?)
              ?.map((e) => GameFrame.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      equipment: (json['equipment'] as List<dynamic>?)
              ?.map((e) => GameEquipment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalScore: (json['total_score'] as num?)?.toInt() ?? 0,
      strikes: (json['strikes'] as num?)?.toInt() ?? 0,
      spares: (json['spares'] as num?)?.toInt() ?? 0,
      scoringMode: json['scoring_mode'] as String? ?? 'current',
      isCompleted: json['is_completed'] as bool? ?? false,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$GameImplToJson(_$GameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'training_session_id': instance.trainingSessionId,
      'game_number': instance.gameNumber,
      'frames': instance.frames,
      'equipment': instance.equipment,
      'total_score': instance.totalScore,
      'strikes': instance.strikes,
      'spares': instance.spares,
      'scoring_mode': instance.scoringMode,
      'is_completed': instance.isCompleted,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
