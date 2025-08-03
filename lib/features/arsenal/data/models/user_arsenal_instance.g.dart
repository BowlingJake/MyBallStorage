// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_arsenal_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserArsenalInstanceImpl _$$UserArsenalInstanceImplFromJson(
        Map<String, dynamic> json) =>
    _$UserArsenalInstanceImpl(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      ballId: (json['ball_id'] as num).toInt(),
      notes: json['notes'] as String?,
      addedDate: DateTime.parse(json['added_date'] as String),
      gamesUsed: (json['games_used'] as num?)?.toInt() ?? 0,
      bag1: json['bag_1'] as bool?,
      bag2: json['bag_2'] as bool?,
      bag3: json['bag_3'] as bool?,
      bag4: json['bag_4'] as bool?,
      bag5: json['bag_5'] as bool?,
      bag6: json['bag_6'] as bool?,
      bag7: json['bag_7'] as bool?,
      bag8: json['bag_8'] as bool?,
      bag9: json['bag_9'] as bool?,
      hasLayout: json['has_layout'] as bool? ?? false,
      layoutType: json['layout_type'] as String?,
      layoutValue1: (json['layout_value_1'] as num?)?.toDouble(),
      layoutValue2: (json['layout_value_2'] as num?)?.toDouble(),
      layoutValue3: (json['layout_value_3'] as num?)?.toDouble(),
      bowlingBall: const BowlingBallConverter()
          .fromJson(json['bowling_ball_data'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$$UserArsenalInstanceImplToJson(
        _$UserArsenalInstanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'ball_id': instance.ballId,
      'notes': instance.notes,
      'added_date': instance.addedDate.toIso8601String(),
      'games_used': instance.gamesUsed,
      'bag_1': instance.bag1,
      'bag_2': instance.bag2,
      'bag_3': instance.bag3,
      'bag_4': instance.bag4,
      'bag_5': instance.bag5,
      'bag_6': instance.bag6,
      'bag_7': instance.bag7,
      'bag_8': instance.bag8,
      'bag_9': instance.bag9,
      'has_layout': instance.hasLayout,
      'layout_type': instance.layoutType,
      'layout_value_1': instance.layoutValue1,
      'layout_value_2': instance.layoutValue2,
      'layout_value_3': instance.layoutValue3,
      'bowling_ball_data':
          const BowlingBallConverter().toJson(instance.bowlingBall),
    };
