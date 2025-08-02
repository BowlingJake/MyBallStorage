// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arsenal_ball_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArsenalBallInstanceImpl _$$ArsenalBallInstanceImplFromJson(
        Map<String, dynamic> json) =>
    _$ArsenalBallInstanceImpl(
      instanceId: json['instance_id'] as String,
      ballId: json['ball_id'] as String,
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String? ?? '',
      addedDate: DateTime.parse(json['added_date'] as String),
      purchaseDate: json['purchase_date'] == null
          ? null
          : DateTime.parse(json['purchase_date'] as String),
      bagCategoryId: json['bag_category_id'] as String,
      layout: json['layout'] == null
          ? null
          : BallLayout.fromJson(json['layout'] as Map<String, dynamic>),
      instanceNumber: (json['instance_number'] as num?)?.toInt() ?? 1,
      notes: json['notes'] as String?,
      gamesUsed: (json['games_used'] as num?)?.toInt() ?? 0,
      bowlingBall: const BowlingBallConverter()
          .fromJson(json['bowling_ball_data'] as Map<String, dynamic>?),
      isCustomBall: json['is_custom_ball'] as bool? ?? false,
      localImagePath: json['local_image_path'] as String?,
    );

Map<String, dynamic> _$$ArsenalBallInstanceImplToJson(
        _$ArsenalBallInstanceImpl instance) =>
    <String, dynamic>{
      'instance_id': instance.instanceId,
      'ball_id': instance.ballId,
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'added_date': instance.addedDate.toIso8601String(),
      'purchase_date': instance.purchaseDate?.toIso8601String(),
      'bag_category_id': instance.bagCategoryId,
      'layout': instance.layout,
      'instance_number': instance.instanceNumber,
      'notes': instance.notes,
      'games_used': instance.gamesUsed,
      'bowling_ball_data':
          const BowlingBallConverter().toJson(instance.bowlingBall),
      'is_custom_ball': instance.isCustomBall,
      'local_image_path': instance.localImagePath,
    };
