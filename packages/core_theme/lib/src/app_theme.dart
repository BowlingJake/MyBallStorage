import 'package:flutter/material.dart';
import 'package:core_theme/src/brand_colors.dart';
import 'package:core_theme/src/text_styles.dart';

/// 應用主題配置
/// 
/// 提供完整的深色和淺色主題配置
class AppTheme {
  AppTheme._();

  /// 深色主題
  static ThemeData get darkTheme {
    return ThemeData(
      // 啟用 Material 3 設計語言
      useMaterial3: true,
      // 明確指定主題亮度為深色
      brightness: Brightness.dark,
      // 字體配置
      fontFamily: AppTextStyles.primaryFont,
      fontFamilyFallback: AppTextStyles.fontFallback,

      // 核心顏色配置
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: BrandColors.darkColorScheme,

      // 文字排版主題
      textTheme: AppTextStyles.buildDarkTextTheme(AppTextStyles.baseTextTheme),

      // === 元件主題配置 ===

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: BrandColors.textPrimaryDark,
        centerTitle: true,
      ),

      // 卡片
      cardTheme: CardThemeData(
        color: BrandColors.darkSurfaceColor.withValues(alpha: 0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      // 圖示
      iconTheme: const IconThemeData(
        color: BrandColors.accentColorDark,
        size: 24,
      ),

      // 按鈕主題
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BrandColors.accentColorDark,
          side: const BorderSide(color: BrandColors.accentColorDark, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BrandColors.accentColorDark,
          foregroundColor: BrandColors.textPrimaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BrandColors.accentColorDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // 輸入框
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrandColors.darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BrandColors.accentColorDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: BrandColors.textDisabledDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BrandColors.accentColorDark, width: 2),
        ),
        labelStyle: const TextStyle(color: BrandColors.textSecondaryDark),
        hintStyle: const TextStyle(color: BrandColors.textDisabledDark),
      ),

      // 對話框
      dialogTheme: DialogThemeData(
        backgroundColor: BrandColors.darkSurfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: AppTextStyles.buildDarkTextTheme(AppTextStyles.baseTextTheme).titleLarge,
        contentTextStyle: AppTextStyles.buildDarkTextTheme(AppTextStyles.baseTextTheme).bodyMedium,
      ),

      // 底部導航
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: BrandColors.darkSurfaceColor,
        selectedItemColor: BrandColors.accentColorDark,
        unselectedItemColor: BrandColors.textDisabledDark,
        type: BottomNavigationBarType.fixed,
      ),

      // 浮動操作按鈕
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: BrandColors.accentColorDark,
        foregroundColor: BrandColors.textPrimaryDark,
      ),
    );
  }

  /// 淺色主題
  static ThemeData get lightTheme {
    return ThemeData(
      // 啟用 Material 3 設計語言
      useMaterial3: true,
      // 明確指定主題亮度為淺色
      brightness: Brightness.light,
      // 字體配置
      fontFamily: AppTextStyles.primaryFont,
      fontFamilyFallback: AppTextStyles.fontFallback,

      // 核心顏色配置
      scaffoldBackgroundColor: BrandColors.lightBackgroundColor,
      colorScheme: BrandColors.lightColorScheme,

      // 文字排版主題
      textTheme: AppTextStyles.buildLightTextTheme(AppTextStyles.baseTextTheme),

      // === 元件主題配置 ===

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: BrandColors.lightSurfaceColor,
        elevation: 1,
        foregroundColor: BrandColors.textPrimaryLight,
        centerTitle: true,
      ),

      // 卡片
      cardTheme: CardThemeData(
        color: BrandColors.lightSurfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      // 圖示
      iconTheme: const IconThemeData(
        color: BrandColors.accentColorLight,
        size: 24,
      ),

      // 按鈕主題
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BrandColors.accentColorLight,
          side: const BorderSide(color: BrandColors.accentColorLight, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BrandColors.accentColorLight,
          foregroundColor: BrandColors.textPrimaryLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BrandColors.accentColorLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // 輸入框
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrandColors.lightSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BrandColors.accentColorLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: BrandColors.textDisabledLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BrandColors.accentColorLight, width: 2),
        ),
        labelStyle: const TextStyle(color: BrandColors.textSecondaryLight),
        hintStyle: const TextStyle(color: BrandColors.textDisabledLight),
      ),

      // 對話框
      dialogTheme: DialogThemeData(
        backgroundColor: BrandColors.lightSurfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: AppTextStyles.buildLightTextTheme(AppTextStyles.baseTextTheme).titleLarge,
        contentTextStyle: AppTextStyles.buildLightTextTheme(AppTextStyles.baseTextTheme).bodyMedium,
      ),

      // 底部導航
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: BrandColors.lightSurfaceColor,
        selectedItemColor: BrandColors.accentColorLight,
        unselectedItemColor: BrandColors.textDisabledLight,
        type: BottomNavigationBarType.fixed,
      ),

      // 浮動操作按鈕
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: BrandColors.accentColorLight,
        foregroundColor: BrandColors.textPrimaryLight,
      ),
    );
  }
} 

/// 應用程式發光效果定義
class AppGlows {
  AppGlows._(); // 私有建構子，防止實例化

  /// 小型發光效果
  static const List<BoxShadow> small = [
    BoxShadow(
      color: BrandColors.glowColor,
      blurRadius: 8,
      spreadRadius: 1,
      offset: Offset(0, 2),
    ),
  ];

  /// 中型發光效果
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: BrandColors.glowColor,
      blurRadius: 16,
      spreadRadius: 2,
      offset: Offset(0, 4),
    ),
  ];

  /// 大型發光效果
  static const List<BoxShadow> large = [
    BoxShadow(
      color: BrandColors.glowColor,
      blurRadius: 24,
      spreadRadius: 3,
      offset: Offset(0, 6),
    ),
  ];
} 