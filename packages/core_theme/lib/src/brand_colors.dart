import 'package:flutter/material.dart';

/// 品牌核心顏色定義
///
/// 定義應用的核心色彩系統，包含深色和淺色模式的顏色配置
class BrandColors {
  BrandColors._();

  // ===========================================================================
  // 設計 DNA：定義核心顏色
  // ===========================================================================

  // --- 深色主題用的顏色 ---
  /// 強調色，用於所有可互動的元素和圖表，頂級的鈦金黃色
  static const Color accentColorDark = Color(0xFFFFD700);

  /// 次要顏色，用於浮動按鈕、選擇器等元素，提供視覺對比
  static const Color secondaryColorDark = Color(0xFF00B2A9);

  /// App 的主要背景色，Professional Dark 風格的深色背景
  static const Color darkBackgroundColor = Color(0xFF0F0F0F);

  /// 卡片、對話框等元件的表面顏色，比背景稍亮以創造層次
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);

  // --- 淺色主題用的顏色 ---
  /// 強調色，在淺色背景上需要更深的金色以保證對比度
  static const Color accentColorLight = Color(0xFFB8860B);

  /// 次要顏色，在淺色模式下通常需要更飽和或稍暗以確保清晰
  static const Color secondaryColorLight = Color(0xFF00897B);

  /// App 的主要背景色
  static const Color lightBackgroundColor = Color(0xFFF5F5F7);

  /// 卡片、對話框等元件的表面顏色
  static const Color lightSurfaceColor = Color(0xFFFFFFFF);

  // --- 語義顏色 ---
  static const Color errorColor = Color(0xFFDC2626); // 更深的鮮紅色
  static const Color successColor = Color(0xFF81C784);
  static const Color warningColor = Color(0xFFFFB74D);
  static const Color infoColor = Color(0xFF6495ED);

  // --- 文字顏色 ---
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFE0E0E0);
  static const Color textDisabledDark = Color(0xFFBDBDBD);

  static const Color textPrimaryLight = Color(0xFF000000);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textDisabledLight = Color(0xFF999999);

  // --- 效果顏色 ---
  /// 發光效果顏色，用於陰影和發光特效
  static const Color glowColor = Color(0x33FFD700);

  // --- 計分模式顏色 ---
  /// 傳統計分模式顏色（青色）
  static const Color traditionalScoringColor = Color(0xFF00B2A9);

  /// Current 計分模式顏色（橘色）
  static const Color currentScoringColor = Color(0xFFFF6B35);

  /// 獲取深色模式的顏色配置
  static ColorScheme get darkColorScheme => const ColorScheme.dark(
        primary: accentColorDark,
        onPrimary: Colors.black,
        secondary: secondaryColorDark,
        onSecondary: Colors.white,
        surface: darkSurfaceColor,
        onSurface: textPrimaryDark,
        error: errorColor,
        onError: textPrimaryDark,
        // 確保 background 也被定義，以保持一致性
        background: darkBackgroundColor,
        onBackground: textPrimaryDark,
      );

  /// 獲取淺色模式的顏色配置
  static ColorScheme get lightColorScheme => const ColorScheme.light(
        primary: accentColorLight,
        onPrimary: textPrimaryLight,
        secondary: secondaryColorLight,
        onSecondary: Colors.white,
        surface: lightSurfaceColor,
        onSurface: textPrimaryLight,
        error: errorColor,
        onError: textPrimaryLight,
        // 確保 background 也被定義，以保持一致性
        background: darkBackgroundColor,
        onBackground: textPrimaryDark,
      );
}

/// 根據品牌名稱獲取品牌調色板
///
/// 為不同的保齡球品牌提供特定的顏色調色板
MaterialColor getBrandTonalPalette(String brand, ThemeData theme) {
  // 定義各品牌的主色調（依討論最終版）
  final brandColors = <String, Color>{
    'Storm': Color(0xFF00685E),
    'Roto Grip': Color(0xFFD7182A),
    '900 Global': Color(0xFFFFB800),
    'Global 900': Color(0xFFFFB800), // 同一品牌額外兼容名稱
    'Brunswick': Color(0xFF003C72),
    'Hammer': Color(0xFFF37021),
    'Ebonite': Color(0xFF003366),
    'Columbia 300': Color(0xFFC8102E),
    'Motiv': Color(0xFFFF6A00),
    'Track': Color(0xFF005BAB),
    'Radical': Color(0xFFFFE100),
    'DV8': Color(0xFF1C7C6D),
    'SWAG': Color(0xFFC6FF00),
    'ABS': Color(0xFFC8102E),
  };

  // 取出品牌主色；若品牌不在清單中則回退到全局強調色
  final brandColor = brandColors[brand] ??
      (theme.brightness == Brightness.dark
          ? BrandColors.accentColorDark
          : BrandColors.accentColorLight);

  // 以主色創建 MaterialColor
  return _createMaterialColor(brandColor);
}

/// 根據單一顏色創建 MaterialColor
MaterialColor _createMaterialColor(Color color) {
  final hsl = HSLColor.fromColor(color);

  return MaterialColor(color.value, {
    50: _lighten(hsl, 0.4).toColor(),
    100: _lighten(hsl, 0.3).toColor(),
    200: _lighten(hsl, 0.2).toColor(),
    300: _lighten(hsl, 0.1).toColor(),
    400: color,
    500: _darken(hsl, 0.1).toColor(),
    600: _darken(hsl, 0.2).toColor(),
    700: _darken(hsl, 0.3).toColor(),
    800: _darken(hsl, 0.4).toColor(),
    900: _darken(hsl, 0.5).toColor(),
  });
}

/// 讓顏色變亮
HSLColor _lighten(HSLColor hsl, double amount) =>
    hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

/// 讓顏色變暗
HSLColor _darken(HSLColor hsl, double amount) =>
    hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
