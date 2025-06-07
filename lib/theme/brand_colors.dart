// lib/theme/brand_colors.dart
import 'package:flutter/material.dart';

/// 品牌色調色板類，包含完整的明度變化
class BrandTonalPalette {
  final Color primary;
  final Color shade50;   // 最淺
  final Color shade100;
  final Color shade200;
  final Color shade300;
  final Color shade400;
  final Color shade500;  // 基準色
  final Color shade600;
  final Color shade700;
  final Color shade800;
  final Color shade900;  // 最深

  const BrandTonalPalette({
    required this.primary,
    required this.shade50,
    required this.shade100,
    required this.shade200,
    required this.shade300,
    required this.shade400,
    required this.shade500,
    required this.shade600,
    required this.shade700,
    required this.shade800,
    required this.shade900,
  });

  /// 從基準色生成完整的色調調色板
  factory BrandTonalPalette.fromBaseColor(Color baseColor) {
    final HSLColor hsl = HSLColor.fromColor(baseColor);
    
    return BrandTonalPalette(
      primary: baseColor,
      shade50: hsl.withLightness(0.95).toColor(),
      shade100: hsl.withLightness(0.9).toColor(),
      shade200: hsl.withLightness(0.8).toColor(),
      shade300: hsl.withLightness(0.7).toColor(),
      shade400: hsl.withLightness(0.6).toColor(),
      shade500: baseColor,
      shade600: hsl.withLightness(0.5).toColor(),
      shade700: hsl.withLightness(0.4).toColor(),
      shade800: hsl.withLightness(0.3).toColor(),
      shade900: hsl.withLightness(0.2).toColor(),
    );
  }

  /// 獲取適合背景的漸層色
  List<Color> getBackgroundGradient() {
    return [shade300, shade400];
  }

  /// 獲取適合卡片的漸層色
  List<Color> getCardGradient() {
    return [shade400, shade500];
  }

  /// 獲取適合強調的漸層色
  List<Color> getAccentGradient() {
    return [shade400, shade500];
  }

  /// 檢查是否為暖色系（橙、紅、黃），需要額外遮罩
  bool isWarmColor() {
    final HSLColor hsl = HSLColor.fromColor(primary);
    final double hue = hsl.hue;
    // 橙色(30-60°)、紅色(0-30°, 330-360°)、黃色(60-90°)
    return (hue >= 0 && hue <= 90) || (hue >= 330 && hue <= 360);
  }
}

// 根據實際品牌顏色更新的漸層色配置
// 鍵：品牌名稱 (String)
// 值：List<Color> 代表漸層色 (至少兩種顏色)
Map<String, List<Color>> brandGradientColors = {
  // STORM - 青綠色
  'Storm': [const Color(0xFF00A693), const Color(0xFF00D4B8)],
  'Storm Bowling': [const Color(0xFF00A693), const Color(0xFF00D4B8)],
  
  // MOTIV - 橘色
  'Motiv': [const Color(0xFFFF6B35), const Color(0xFFFF8C42)],
  'Motiv Bowling': [const Color(0xFFFF6B35), const Color(0xFFFF8C42)],
  
  // Brunswick - 亮藍色（更鮮豔的藍色，區別於其他深藍）
  'Brunswick': [const Color(0xFF2563EB), const Color(0xFF3B82F6)],
  'Brunswick Bowling': [const Color(0xFF2563EB), const Color(0xFF3B82F6)],
  
  // 900 GLOBAL - 黃色
  '900 Global': [const Color(0xFFFFB000), const Color(0xFFFFC933)],
  
  // HAMMER - 橘紅色
  'Hammer': [const Color(0xFFFF4500), const Color(0xFFFF6B35)],
  'Hammer Bowling': [const Color(0xFFFF4500), const Color(0xFFFF6B35)],
  
  // Roto Grip - 深紅/紫紅色
  'Roto Grip': [const Color(0xFFDC143C), const Color(0xFFFF1744)],
  
  // EBONITE - 深海藍色（偏紫的深藍，獨特辨識）
  'Ebonite': [const Color(0xFF1B2B5E), const Color(0xFF3B4B82)],
  
  // DV8 - 黑色/深灰色
  'DV8 Bowling': [const Color(0xFF1F1F1F), const Color(0xFF4A4A4A)],
  'DV8': [const Color(0xFF1F1F1F), const Color(0xFF4A4A4A)],
  
  // 其他品牌根據實際 LOGO 顏色更新
  // Track - 海軍藍色（更深的藍色，與橘色對比）
  'Track': [const Color(0xFF1A365D), const Color(0xFFFF6B35)],
  'Track Bowling': [const Color(0xFF1A365D), const Color(0xFFFF6B35)],
  
  // Columbia 300 - 紅色配深色
  'Columbia 300': [const Color(0xFFDC2626), const Color(0xFF991B1B)],
  
  // Radical - 黃色配黑色
  'Radical': [const Color(0xFFFDDD00), const Color(0xFF1F1F1F)],
  'Radical Bowling': [const Color(0xFFFDDD00), const Color(0xFF1F1F1F)],
  
  // SWAG - 螢光綠色系
  'SWAG': [const Color(0xFF84CC16), const Color(0xFFBEF264)],
  'SWAG Bowling': [const Color(0xFF84CC16), const Color(0xFFBEF264)],
  
  'Pyramid': [const Color(0xFFFFAA00), const Color(0xFFFFDD66)],
};

/// 品牌色調色板映射（基於正確的品牌顏色）
final Map<String, BrandTonalPalette> brandTonalPalettes = {
  // STORM - 青綠色系
  'Storm': BrandTonalPalette.fromBaseColor(const Color(0xFF00A693)),
  'Storm Bowling': BrandTonalPalette.fromBaseColor(const Color(0xFF00A693)),
  
  // MOTIV - 橘色系
  'Motiv': BrandTonalPalette.fromBaseColor(const Color(0xFFFF6B35)),
  'Motiv Bowling': BrandTonalPalette.fromBaseColor(const Color(0xFFFF6B35)),
  
  // Brunswick - 亮藍色系
  'Brunswick': BrandTonalPalette.fromBaseColor(const Color(0xFF2563EB)),
  'Brunswick Bowling': BrandTonalPalette.fromBaseColor(const Color(0xFF2563EB)),
  
  // 900 GLOBAL - 黃色系
  '900 Global': BrandTonalPalette.fromBaseColor(const Color(0xFFFFB000)),
  
  // HAMMER - 橘紅色系
  'Hammer': BrandTonalPalette.fromBaseColor(const Color(0xFFFF4500)),
  'Hammer Bowling': BrandTonalPalette.fromBaseColor(const Color(0xFFFF4500)),
  
  // Roto Grip - 深紅色系
  'Roto Grip': BrandTonalPalette.fromBaseColor(const Color(0xFFDC143C)),
  
  // EBONITE - 深海藍色系
  'Ebonite': BrandTonalPalette.fromBaseColor(const Color(0xFF1B2B5E)),
  
  // DV8 - 深灰色系
  'DV8 Bowling': BrandTonalPalette.fromBaseColor(const Color(0xFF1F1F1F)),
  'DV8': BrandTonalPalette.fromBaseColor(const Color(0xFF1F1F1F)),
  
  // Track - 海軍藍色系
  'Track': BrandTonalPalette.fromBaseColor(const Color(0xFF1A365D)),
  'Track Bowling': BrandTonalPalette.fromBaseColor(const Color(0xFF1A365D)),
  
  // Columbia 300 - 紅色系
  'Columbia 300': BrandTonalPalette.fromBaseColor(const Color(0xFFDC2626)),
  
  // Radical - 黃色系
  'Radical': BrandTonalPalette.fromBaseColor(const Color(0xFFFDDD00)),
  'Radical Bowling': BrandTonalPalette.fromBaseColor(const Color(0xFFFDDD00)),
  
  // SWAG - 螢光綠色系
  'SWAG': BrandTonalPalette.fromBaseColor(const Color(0xFF84CC16)),
  'SWAG Bowling': BrandTonalPalette.fromBaseColor(const Color(0xFF84CC16)),
  
  // Pyramid - 橙色系
  'Pyramid': BrandTonalPalette.fromBaseColor(const Color(0xFFFFAA00)),
};

/// 獲取預設調色板
BrandTonalPalette getDefaultTonalPalette(ThemeData theme) {
  return BrandTonalPalette.fromBaseColor(theme.colorScheme.primary);
}

// 如果品牌未找到或沒有特定顏色，則使用預設漸層色
List<Color> getDefaultGradient(ThemeData theme) {
  return [
    theme.colorScheme.primaryContainer.withOpacity(0.7), // 使用 Container 顏色可能更適合背景
    theme.colorScheme.secondaryContainer.withOpacity(0.8),
  ];
}

// 根據品牌名稱獲取漸層顏色
List<Color> getGradientColorsForBrand(String brandName, ThemeData theme) {
  // 首先嘗試直接匹配
  if (brandGradientColors.containsKey(brandName)) {
    print('找到品牌顏色: $brandName');
    return brandGradientColors[brandName]!;
  }
  
  // 如果直接匹配失敗，嘗試不區分大小寫的匹配
  final String lowerBrandName = brandName.toLowerCase();
  for (final entry in brandGradientColors.entries) {
    if (entry.key.toLowerCase() == lowerBrandName) {
      print('找到品牌顏色(不區分大小寫): $brandName -> ${entry.key}');
      return entry.value;
    }
  }
  
  // 如果還是找不到，嘗試部分匹配（去掉 "Bowling" 後綴）
  final String simplifiedBrandName = brandName.replaceAll(' Bowling', '').trim();
  if (brandGradientColors.containsKey(simplifiedBrandName)) {
    print('找到品牌顏色(簡化名稱): $brandName -> $simplifiedBrandName');
    return brandGradientColors[simplifiedBrandName]!;
  }
  
  print('未找到品牌顏色，使用預設: $brandName');
  return getDefaultGradient(theme);
}

/// 根據品牌名稱獲取色調調色板
BrandTonalPalette getBrandTonalPalette(String brandName, ThemeData theme) {
  // 首先嘗試直接匹配
  if (brandTonalPalettes.containsKey(brandName)) {
    return brandTonalPalettes[brandName]!;
  }
  
  // 如果直接匹配失敗，嘗試不區分大小寫的匹配
  final String lowerBrandName = brandName.toLowerCase();
  for (final entry in brandTonalPalettes.entries) {
    if (entry.key.toLowerCase() == lowerBrandName) {
      return entry.value;
    }
  }
  
  // 如果還是找不到，嘗試部分匹配（去掉 "Bowling" 後綴）
  final String simplifiedBrandName = brandName.replaceAll(' Bowling', '').trim();
  if (brandTonalPalettes.containsKey(simplifiedBrandName)) {
    return brandTonalPalettes[simplifiedBrandName]!;
  }
  
  return getDefaultTonalPalette(theme);
}

/// 根據品牌名稱獲取背景漸層顏色
List<Color> getBackgroundGradientForBrand(String brandName, ThemeData theme) {
  final palette = getBrandTonalPalette(brandName, theme);
  return palette.getBackgroundGradient();
}

/// 根據品牌名稱獲取強調漸層顏色
List<Color> getAccentGradientForBrand(String brandName, ThemeData theme) {
  final palette = getBrandTonalPalette(brandName, theme);
  return palette.getAccentGradient();
}
