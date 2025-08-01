// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ball_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BallLayoutImpl _$$BallLayoutImplFromJson(Map<String, dynamic> json) =>
    _$BallLayoutImpl(
      layoutId: json['layoutId'] as String,
      userId: json['userId'] as String,
      pinToPap: (json['pinToPap'] as num?)?.toDouble() ?? 0.0,
      papToMb: (json['papToMb'] as num?)?.toDouble() ?? 0.0,
      psaAngle: (json['psaAngle'] as num?)?.toDouble() ?? 0.0,
      valAngle: (json['valAngle'] as num?)?.toDouble() ?? 0.0,
      layoutType:
          $enumDecodeNullable(_$LayoutTypeEnumMap, json['layoutType']) ??
              LayoutType.control,
      layoutImage: json['layoutImage'] as String?,
      drillerName: json['drillerName'] as String?,
      drilledDate: json['drilledDate'] == null
          ? null
          : DateTime.parse(json['drilledDate'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BallLayoutImplToJson(_$BallLayoutImpl instance) =>
    <String, dynamic>{
      'layoutId': instance.layoutId,
      'userId': instance.userId,
      'pinToPap': instance.pinToPap,
      'papToMb': instance.papToMb,
      'psaAngle': instance.psaAngle,
      'valAngle': instance.valAngle,
      'layoutType': _$LayoutTypeEnumMap[instance.layoutType]!,
      'layoutImage': instance.layoutImage,
      'drillerName': instance.drillerName,
      'drilledDate': instance.drilledDate?.toIso8601String(),
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$LayoutTypeEnumMap = {
  LayoutType.aggressive: 'aggressive',
  LayoutType.control: 'control',
  LayoutType.straight: 'straight',
  LayoutType.skidFlip: 'skid_flip',
  LayoutType.smoothArc: 'smooth_arc',
  LayoutType.length: 'length',
};
