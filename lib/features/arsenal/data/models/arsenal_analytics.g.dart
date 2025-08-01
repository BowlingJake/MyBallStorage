// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arsenal_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArsenalAnalyticsImpl _$$ArsenalAnalyticsImplFromJson(
        Map<String, dynamic> json) =>
    _$ArsenalAnalyticsImpl(
      userId: json['userId'] as String,
      totalBalls: (json['totalBalls'] as num).toInt(),
      customBalls: (json['customBalls'] as num).toInt(),
      brandDistribution:
          Map<String, int>.from(json['brandDistribution'] as Map),
      categoryDistribution:
          Map<String, int>.from(json['categoryDistribution'] as Map),
      layoutTypeDistribution:
          Map<String, int>.from(json['layoutTypeDistribution'] as Map),
      rgDiffDistribution: RGDiffDistribution.fromJson(
          json['rgDiffDistribution'] as Map<String, dynamic>),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$ArsenalAnalyticsImplToJson(
        _$ArsenalAnalyticsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'totalBalls': instance.totalBalls,
      'customBalls': instance.customBalls,
      'brandDistribution': instance.brandDistribution,
      'categoryDistribution': instance.categoryDistribution,
      'layoutTypeDistribution': instance.layoutTypeDistribution,
      'rgDiffDistribution': instance.rgDiffDistribution,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

_$RGDiffDistributionImpl _$$RGDiffDistributionImplFromJson(
        Map<String, dynamic> json) =>
    _$RGDiffDistributionImpl(
      dataPoints: (json['dataPoints'] as List<dynamic>)
          .map((e) => BallDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      avgRG: (json['avgRG'] as num).toDouble(),
      avgDiff: (json['avgDiff'] as num).toDouble(),
      minRG: (json['minRG'] as num).toDouble(),
      maxRG: (json['maxRG'] as num).toDouble(),
      minDiff: (json['minDiff'] as num).toDouble(),
      maxDiff: (json['maxDiff'] as num).toDouble(),
    );

Map<String, dynamic> _$$RGDiffDistributionImplToJson(
        _$RGDiffDistributionImpl instance) =>
    <String, dynamic>{
      'dataPoints': instance.dataPoints,
      'avgRG': instance.avgRG,
      'avgDiff': instance.avgDiff,
      'minRG': instance.minRG,
      'maxRG': instance.maxRG,
      'minDiff': instance.minDiff,
      'maxDiff': instance.maxDiff,
    };

_$BallDataPointImpl _$$BallDataPointImplFromJson(Map<String, dynamic> json) =>
    _$BallDataPointImpl(
      instanceId: json['instanceId'] as String,
      ballName: json['ballName'] as String,
      brand: json['brand'] as String,
      rg: (json['rg'] as num).toDouble(),
      diff: (json['diff'] as num).toDouble(),
      quadrant: $enumDecode(_$BallQuadrantEnumMap, json['quadrant']),
    );

Map<String, dynamic> _$$BallDataPointImplToJson(_$BallDataPointImpl instance) =>
    <String, dynamic>{
      'instanceId': instance.instanceId,
      'ballName': instance.ballName,
      'brand': instance.brand,
      'rg': instance.rg,
      'diff': instance.diff,
      'quadrant': _$BallQuadrantEnumMap[instance.quadrant]!,
    };

const _$BallQuadrantEnumMap = {
  BallQuadrant.hookMonster: 'hook_monster',
  BallQuadrant.lengthHook: 'length_hook',
  BallQuadrant.control: 'control',
  BallQuadrant.straight: 'straight',
};
