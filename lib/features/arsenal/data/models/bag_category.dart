import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:iconsax/iconsax.dart';

part 'bag_category.freezed.dart';
part 'bag_category.g.dart';

@freezed
class BagCategory with _$BagCategory {
  const factory BagCategory({
    @JsonKey(name: 'category_id') required String categoryId,
    required String name,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'icon_code_point') @Default(57669) int iconCodePoint,
    @JsonKey(name: 'icon_font_family') @Default('Iconsax') String iconFontFamily,
    @JsonKey(name: 'icon_font_package') @Default('iconsax') String? iconFontPackage,
    @JsonKey(name: 'theme_color') @ColorConverter() @Default(Color(0xFF2E7D32)) Color themeColor,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    String? description,
  }) = _BagCategory;

  factory BagCategory.fromJson(Map<String, dynamic> json) => 
      _$BagCategoryFromJson(json);
}


/// Custom converter for Color serialization
/// Converts Color to/from a signed 32-bit integer to avoid PostgreSQL range issues
class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) {
    // Convert signed int back to unsigned int for Color
    final unsignedValue = json < 0 ? json + 0x100000000 : json;
    return Color(unsignedValue);
  }

  @override
  int toJson(Color color) {
    // Convert unsigned int to signed int for PostgreSQL compatibility
    final value = color.value;
    return value > 0x7FFFFFFF ? value - 0x100000000 : value;
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
        iconCodePoint: 58394, // Iconsax.medal_star
        iconFontFamily: 'Iconsax',
        iconFontPackage: 'iconsax',
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
        iconCodePoint: 57669, // Iconsax.bag
        iconFontFamily: 'Iconsax',
        iconFontPackage: 'iconsax',
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
        iconCodePoint: 58155, // Iconsax.heart
        iconFontFamily: 'Iconsax',
        iconFontPackage: 'iconsax',
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
        iconCodePoint: 58108, // Iconsax.game
        iconFontFamily: 'Iconsax',
        iconFontPackage: 'iconsax',
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
  /// Get IconData from the stored icon properties
  IconData get icon => IconData(
    iconCodePoint,
    fontFamily: iconFontFamily,
    fontPackage: iconFontPackage,
  );
  
  /// Get a lighter shade of the theme color for backgrounds
  Color get lightColor => Color.lerp(themeColor, Colors.white, 0.8) ?? themeColor;
  
  /// Get a darker shade of the theme color for borders
  Color get darkColor => Color.lerp(themeColor, Colors.black, 0.2) ?? themeColor;
}