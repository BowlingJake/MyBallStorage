// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arsenal_ball.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArsenalBallImpl _$$ArsenalBallImplFromJson(Map<String, dynamic> json) =>
    _$ArsenalBallImpl(
      name: json['name'] as String,
      core: json['core'] as String,
      cover: json['cover'] as String,
      layout: json['layout'] as String,
      imagePath: json['imagePath'] as String,
      brand: json['brand'] as String,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      bagType: $enumDecode(_$BallBagTypeEnumMap, json['bagType']),
    );

Map<String, dynamic> _$$ArsenalBallImplToJson(_$ArsenalBallImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'core': instance.core,
      'cover': instance.cover,
      'layout': instance.layout,
      'imagePath': instance.imagePath,
      'brand': instance.brand,
      'dateAdded': instance.dateAdded.toIso8601String(),
      'bagType': _$BallBagTypeEnumMap[instance.bagType]!,
    };

const _$BallBagTypeEnumMap = {
  BallBagType.all: 'all',
  BallBagType.competition: 'competition',
  BallBagType.practice: 'practice',
};
