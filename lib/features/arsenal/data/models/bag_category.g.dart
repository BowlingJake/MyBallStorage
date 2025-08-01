// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bag_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BagCategoryImpl _$$BagCategoryImplFromJson(Map<String, dynamic> json) =>
    _$BagCategoryImpl(
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      userId: json['user_id'] as String,
      iconCodePoint: (json['icon_code_point'] as num?)?.toInt() ?? 57669,
      iconFontFamily: json['icon_font_family'] as String? ?? 'Iconsax',
      iconFontPackage: json['icon_font_package'] as String? ?? 'iconsax',
      themeColor: json['theme_color'] == null
          ? const Color(0xFF2E7D32)
          : const ColorConverter()
              .fromJson((json['theme_color'] as num).toInt()),
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$BagCategoryImplToJson(_$BagCategoryImpl instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'name': instance.name,
      'user_id': instance.userId,
      'icon_code_point': instance.iconCodePoint,
      'icon_font_family': instance.iconFontFamily,
      'icon_font_package': instance.iconFontPackage,
      'theme_color': const ColorConverter().toJson(instance.themeColor),
      'display_order': instance.displayOrder,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt.toIso8601String(),
      'description': instance.description,
    };
