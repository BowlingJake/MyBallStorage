// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainingSessionImpl _$$TrainingSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$TrainingSessionImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      center: json['center'] as String,
      isHousePattern: json['is_house_pattern'] as bool,
      oilPatternName: json['oil_pattern_name'] as String?,
      oilPatternLength: (json['oil_pattern_length'] as num?)?.toInt(),
      scoringMethod: json['scoring_method'] as String,
      inputMethod: json['input_method'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TrainingSessionImplToJson(
        _$TrainingSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'center': instance.center,
      'is_house_pattern': instance.isHousePattern,
      'oil_pattern_name': instance.oilPatternName,
      'oil_pattern_length': instance.oilPatternLength,
      'scoring_method': instance.scoringMethod,
      'input_method': instance.inputMethod,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
