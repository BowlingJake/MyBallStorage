// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oil_pattern.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OilPatternImpl _$$OilPatternImplFromJson(Map<String, dynamic> json) =>
    _$OilPatternImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      length: (json['length'] as num?)?.toInt(),
      volume: (json['volume'] as num?)?.toInt(),
      difficultyLevel: (json['difficulty_level'] as num?)?.toInt(),
      description: json['description'] as String?,
      patternType: json['pattern_type'] as String? ?? 'house',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$OilPatternImplToJson(_$OilPatternImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'length': instance.length,
      'volume': instance.volume,
      'difficulty_level': instance.difficultyLevel,
      'description': instance.description,
      'pattern_type': instance.patternType,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$UserFavoritePatternImpl _$$UserFavoritePatternImplFromJson(
        Map<String, dynamic> json) =>
    _$UserFavoritePatternImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      oilPatternId: json['oil_pattern_id'] as String,
      notes: json['notes'] as String?,
      performanceRating: (json['performance_rating'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      oilPattern: json['oil_pattern'] == null
          ? null
          : OilPattern.fromJson(json['oil_pattern'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserFavoritePatternImplToJson(
        _$UserFavoritePatternImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'oil_pattern_id': instance.oilPatternId,
      'notes': instance.notes,
      'performance_rating': instance.performanceRating,
      'created_at': instance.createdAt?.toIso8601String(),
      'oil_pattern': instance.oilPattern,
    };
