// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bowling_center.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BowlingCenterImpl _$$BowlingCenterImplFromJson(Map<String, dynamic> json) =>
    _$BowlingCenterImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$BowlingCenterImplToJson(_$BowlingCenterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'country': instance.country,
      'phone': instance.phone,
      'website': instance.website,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$UserFavoriteCenterImpl _$$UserFavoriteCenterImplFromJson(
        Map<String, dynamic> json) =>
    _$UserFavoriteCenterImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      bowlingCenterId: json['bowling_center_id'] as String,
      notes: json['notes'] as String?,
      visitCount: (json['visit_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      bowlingCenter: json['bowling_center'] == null
          ? null
          : BowlingCenter.fromJson(
              json['bowling_center'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserFavoriteCenterImplToJson(
        _$UserFavoriteCenterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'bowling_center_id': instance.bowlingCenterId,
      'notes': instance.notes,
      'visit_count': instance.visitCount,
      'created_at': instance.createdAt?.toIso8601String(),
      'bowling_center': instance.bowlingCenter,
    };
