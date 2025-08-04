// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      username: json['username'] as String?,
      bag1Name: json['bag_1_name'] as String? ?? 'All My Arsenal',
      bag2Name: json['bag_2_name'] as String?,
      bag3Name: json['bag_3_name'] as String?,
      bag4Name: json['bag_4_name'] as String?,
      bag5Name: json['bag_5_name'] as String?,
      bag6Name: json['bag_6_name'] as String?,
      bag7Name: json['bag_7_name'] as String?,
      bag8Name: json['bag_8_name'] as String?,
      bag9Name: json['bag_9_name'] as String?,
      bag1Unlocked: json['bag_1_unlocked'] as bool? ?? true,
      bag2Unlocked: json['bag_2_unlocked'] as bool? ?? false,
      bag3Unlocked: json['bag_3_unlocked'] as bool? ?? false,
      bag4Unlocked: json['bag_4_unlocked'] as bool? ?? false,
      bag5Unlocked: json['bag_5_unlocked'] as bool? ?? false,
      bag6Unlocked: json['bag_6_unlocked'] as bool? ?? false,
      bag7Unlocked: json['bag_7_unlocked'] as bool? ?? false,
      bag8Unlocked: json['bag_8_unlocked'] as bool? ?? false,
      bag9Unlocked: json['bag_9_unlocked'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'username': instance.username,
      'bag_1_name': instance.bag1Name,
      'bag_2_name': instance.bag2Name,
      'bag_3_name': instance.bag3Name,
      'bag_4_name': instance.bag4Name,
      'bag_5_name': instance.bag5Name,
      'bag_6_name': instance.bag6Name,
      'bag_7_name': instance.bag7Name,
      'bag_8_name': instance.bag8Name,
      'bag_9_name': instance.bag9Name,
      'bag_1_unlocked': instance.bag1Unlocked,
      'bag_2_unlocked': instance.bag2Unlocked,
      'bag_3_unlocked': instance.bag3Unlocked,
      'bag_4_unlocked': instance.bag4Unlocked,
      'bag_5_unlocked': instance.bag5Unlocked,
      'bag_6_unlocked': instance.bag6Unlocked,
      'bag_7_unlocked': instance.bag7Unlocked,
      'bag_8_unlocked': instance.bag8Unlocked,
      'bag_9_unlocked': instance.bag9Unlocked,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$BagInfoImpl _$$BagInfoImplFromJson(Map<String, dynamic> json) =>
    _$BagInfoImpl(
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
      isUnlocked: json['isUnlocked'] as bool,
    );

Map<String, dynamic> _$$BagInfoImplToJson(_$BagInfoImpl instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'isUnlocked': instance.isUnlocked,
    };
