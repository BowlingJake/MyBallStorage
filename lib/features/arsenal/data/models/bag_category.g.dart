// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bag_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BagCategoryImpl _$$BagCategoryImplFromJson(Map<String, dynamic> json) =>
    _$BagCategoryImpl(
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      userId: json['userId'] as String,
      icon: json['icon'] == null
          ? Iconsax.bag
          : const IconDataConverter()
              .fromJson(json['icon'] as Map<String, dynamic>),
      themeColor: json['themeColor'] == null
          ? const Color(0xFF2E7D32)
          : const ColorConverter()
              .fromJson((json['themeColor'] as num).toInt()),
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$BagCategoryImplToJson(_$BagCategoryImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'name': instance.name,
      'userId': instance.userId,
      'icon': const IconDataConverter().toJson(instance.icon),
      'themeColor': const ColorConverter().toJson(instance.themeColor),
      'displayOrder': instance.displayOrder,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'description': instance.description,
    };
