// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ball_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BallLayoutImpl _$$BallLayoutImplFromJson(Map<String, dynamic> json) =>
    _$BallLayoutImpl(
      layoutId: json['layout_id'] as String,
      userId: json['user_id'] as String,
      pinToPap: (json['pin_to_pap'] as num?)?.toDouble() ?? 0.0,
      papToMb: (json['pap_to_mb'] as num?)?.toDouble() ?? 0.0,
      psaAngle: (json['psa_angle'] as num?)?.toDouble() ?? 0.0,
      valAngle: (json['val_angle'] as num?)?.toDouble() ?? 0.0,
      layoutType:
          $enumDecodeNullable(_$LayoutTypeEnumMap, json['layout_type']) ??
              LayoutType.control,
      layoutImage: json['layout_image'] as String?,
      drillerName: json['driller_name'] as String?,
      drilledDate: json['drilled_date'] == null
          ? null
          : DateTime.parse(json['drilled_date'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$BallLayoutImplToJson(_$BallLayoutImpl instance) =>
    <String, dynamic>{
      'layout_id': instance.layoutId,
      'user_id': instance.userId,
      'pin_to_pap': instance.pinToPap,
      'pap_to_mb': instance.papToMb,
      'psa_angle': instance.psaAngle,
      'val_angle': instance.valAngle,
      'layout_type': _$LayoutTypeEnumMap[instance.layoutType]!,
      'layout_image': instance.layoutImage,
      'driller_name': instance.drillerName,
      'drilled_date': instance.drilledDate?.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$LayoutTypeEnumMap = {
  LayoutType.aggressive: 'aggressive',
  LayoutType.control: 'control',
  LayoutType.straight: 'straight',
  LayoutType.skidFlip: 'skid_flip',
  LayoutType.smoothArc: 'smooth_arc',
  LayoutType.length: 'length',
};
