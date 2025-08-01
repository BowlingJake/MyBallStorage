// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arsenal_ball_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArsenalBallInstanceImpl _$$ArsenalBallInstanceImplFromJson(
        Map<String, dynamic> json) =>
    _$ArsenalBallInstanceImpl(
      instanceId: json['instanceId'] as String,
      ballId: json['ballId'] as String,
      userId: json['userId'] as String,
      nickname: json['nickname'] as String? ?? '',
      addedDate: DateTime.parse(json['addedDate'] as String),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      bagCategoryId: json['bagCategoryId'] as String,
      layout: json['layout'] == null
          ? null
          : BallLayout.fromJson(json['layout'] as Map<String, dynamic>),
      instanceNumber: (json['instanceNumber'] as num?)?.toInt() ?? 1,
      notes: json['notes'] as String?,
      bowlingBall: const BowlingBallConverter()
          .fromJson(json['bowling_ball_data'] as Map<String, dynamic>?),
      isCustomBall: json['isCustomBall'] as bool? ?? false,
      localImagePath: json['localImagePath'] as String?,
    );

Map<String, dynamic> _$$ArsenalBallInstanceImplToJson(
        _$ArsenalBallInstanceImpl instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'ballId': instance.ballId,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'addedDate': instance.addedDate.toIso8601String(),
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'bagCategoryId': instance.bagCategoryId,
      'layout': instance.layout,
      'instanceNumber': instance.instanceNumber,
      'notes': instance.notes,
      'bowling_ball_data':
          const BowlingBallConverter().toJson(instance.bowlingBall),
      'isCustomBall': instance.isCustomBall,
      'localImagePath': instance.localImagePath,
    };
