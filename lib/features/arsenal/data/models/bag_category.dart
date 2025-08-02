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
      // Create a default "My Balls" category (not "All My Arsenal")
      BagCategory(
        categoryId: 'my_balls',
        name: 'My Balls',
        userId: '', // Will be set when creating for specific user
        iconCodePoint: 57669, // Iconsax.bag
        iconFontFamily: 'Iconsax',
        iconFontPackage: 'iconsax',
        themeColor: const Color(0xFF1976D2), // Blue
        displayOrder: 0,
        isDefault: true,
        createdAt: now,
        description: 'Default category for your bowling balls',
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