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
      bagCategory1: json['bag_category_1'] as String?,
      bagCategory2: json['bag_category_2'] as String?,
      bagCategory3: json['bag_category_3'] as String?,
      bagCategory4: json['bag_category_4'] as String?,
      bagCategory5: json['bag_category_5'] as String?,
      bagCategory6: json['bag_category_6'] as String?,
      bagCategory7: json['bag_category_7'] as String?,
      bagCategory8: json['bag_category_8'] as String?,
      bagCategory9: json['bag_category_9'] as String?,
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
      'bag_category_1': instance.bagCategory1,
      'bag_category_2': instance.bagCategory2,
      'bag_category_3': instance.bagCategory3,
      'bag_category_4': instance.bagCategory4,
      'bag_category_5': instance.bagCategory5,
      'bag_category_6': instance.bagCategory6,
      'bag_category_7': instance.bagCategory7,
      'bag_category_8': instance.bagCategory8,
      'bag_category_9': instance.bagCategory9,
      'has_layout': instance.hasLayout,
      'layout_type': instance.layoutType,
      'layout_value_1': instance.layoutValue1,
      'layout_value_2': instance.layoutValue2,
      'layout_value_3': instance.layoutValue3,
      'bowling_ball_data':
          const BowlingBallConverter().toJson(instance.bowlingBall),
    };
