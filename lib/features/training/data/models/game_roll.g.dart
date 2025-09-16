// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_roll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameRollImpl _$$GameRollImplFromJson(Map<String, dynamic> json) =>
    _$GameRollImpl(
      rollNumber: (json['roll_number'] as num).toInt(),
      pinsKnocked: (json['pins_knocked'] as num).toInt(),
      pinStates:
          (json['pin_states'] as List<dynamic>).map((e) => e as bool).toList(),
      ballUsed: json['ball_used'] as String?,
    );

Map<String, dynamic> _$$GameRollImplToJson(_$GameRollImpl instance) =>
    <String, dynamic>{
      'roll_number': instance.rollNumber,
      'pins_knocked': instance.pinsKnocked,
      'pin_states': instance.pinStates,
      'ball_used': instance.ballUsed,
    };

_$GameFrameImpl _$$GameFrameImplFromJson(Map<String, dynamic> json) =>
    _$GameFrameImpl(
      frameNumber: (json['frame_number'] as num).toInt(),
      rolls: (json['rolls'] as List<dynamic>)
          .map((e) => GameRoll.fromJson(e as Map<String, dynamic>))
          .toList(),
      frameScore: (json['frame_score'] as num?)?.toInt(),
      isSpare: json['is_spare'] as bool? ?? false,
      isStrike: json['is_strike'] as bool? ?? false,
    );

Map<String, dynamic> _$$GameFrameImplToJson(_$GameFrameImpl instance) =>
    <String, dynamic>{
      'frame_number': instance.frameNumber,
      'rolls': instance.rolls,
      'frame_score': instance.frameScore,
      'is_spare': instance.isSpare,
      'is_strike': instance.isStrike,
    };

_$GameEquipmentImpl _$$GameEquipmentImplFromJson(Map<String, dynamic> json) =>
    _$GameEquipmentImpl(
      ballId: json['ball_id'] as String,
      ballName: json['ball_name'] as String,
      weight: (json['weight'] as num).toInt(),
      surface: json['surface'] as String,
      usageCount: (json['usage_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$GameEquipmentImplToJson(_$GameEquipmentImpl instance) =>
    <String, dynamic>{
      'ball_id': instance.ballId,
      'ball_name': instance.ballName,
      'weight': instance.weight,
      'surface': instance.surface,
      'usage_count': instance.usageCount,
    };
