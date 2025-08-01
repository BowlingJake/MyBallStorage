import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iconsax/iconsax.dart';

part 'bag_category.freezed.dart';
part 'bag_category.g.dart';

@freezed
class BagCategory with _$BagCategory {
  const factory BagCategory({
    required String categoryId,
    required String name,
    required String userId,
    @Default(Iconsax.bag) @IconDataConverter() IconData icon,
    @ColorConverter() @Default(Color(0xFF2E7D32)) Color themeColor,
    @Default(0) int displayOrder,
    @Default(false) bool isDefault,
    required DateTime createdAt,
    String? description,
  }) = _BagCategory;

  factory BagCategory.fromJson(Map<String, dynamic> json) => 
      _$BagCategoryFromJson(json);
}

/// Custom converter for IconData serialization
class IconDataConverter implements JsonConverter<IconData, Map<String, dynamic>> {
  const IconDataConverter();

  @override
  IconData fromJson(Map<String, dynamic> json) {
    return IconData(
      json['codePoint'] as int,
      fontFamily: json['fontFamily'] as String?,
      fontPackage: json['fontPackage'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson(IconData iconData) {
    return {
      'codePoint': iconData.codePoint,
      'fontFamily': iconData.fontFamily,
      'fontPackage': iconData.fontPackage,
    };
  }
}

/// Custom converter for Color serialization
class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) {
    return Color(json);
  }

  @override
  int toJson(Color color) {
    return color.value;
  }
}

/// Predefined default categories
class DefaultBagCategories {
  static List<BagCategory> get defaults {
    final now = DateTime.now();
    return [
      BagCategory(
        categoryId: 'competition',
        name: '比賽球袋',
        userId: '', // Will be set when creating for specific user
        icon: Iconsax.medal_star,
        themeColor: const Color(0xFFFFD700), // Gold
        displayOrder: 0,
        isDefault: true,
        createdAt: now,
        description: '比賽時使用的球具',
      ),
      BagCategory(
        categoryId: 'practice',
        name: '練習球袋',
        userId: '',
        icon: Iconsax.bag,
        themeColor: const Color(0xFF1976D2), // Blue
        displayOrder: 1,
        isDefault: true,
        createdAt: now,
        description: '練習時使用的球具',
      ),
      BagCategory(
        categoryId: 'collection',
        name: '收藏球袋',
        userId: '',
        icon: Iconsax.heart,
        themeColor: const Color(0xFF9C27B0), // Purple
        displayOrder: 2,
        isDefault: true,
        createdAt: now,
        description: '收藏的球具',
      ),
      BagCategory(
        categoryId: 'testing',
        name: '新球測試',
        userId: '',
        icon: Iconsax.game,
        themeColor: const Color(0xFFFF8F00), // Orange
        displayOrder: 3,
        isDefault: true,
        createdAt: now,
        description: '測試中的新球具',
      ),
    ];
  }
  
  /// Create default categories for a specific user
  static List<BagCategory> createForUser(String userId) {
    final now = DateTime.now();
    return defaults.map((category) => category.copyWith(
      categoryId: '${category.categoryId}_$userId',
      userId: userId,
      createdAt: now,
    )).toList();
  }
}

extension BagCategoryExtension on BagCategory {
  /// Get a lighter shade of the theme color for backgrounds
  Color get lightColor => Color.lerp(themeColor, Colors.white, 0.8) ?? themeColor;
  
  /// Get a darker shade of the theme color for borders
  Color get darkColor => Color.lerp(themeColor, Colors.black, 0.2) ?? themeColor;
}