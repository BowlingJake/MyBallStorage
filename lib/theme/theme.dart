// lib/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===========================================================================
// 1. 設計 DNA：定義你的核心顏色
// 你可以在這裡輕鬆更換整個 App 的主色調
// ===========================================================================

// --- 深色主題用的顏色 ---
/// 強調色，用於所有可互動的元素和圖表，柔和的護眼藍綠色
const Color accentColor = Color(0xFF4A9EAF); // 柔和的藍綠色

/// App 的主要背景色，Professional Dark風格的深色背景
const Color darkBackgroundColor = Color(0xFF0F0F0F);

/// 卡片、對話框等元件的表面顏色，比背景稍亮以創造層次
const Color darkSurfaceColor = Color(0xFF1E1E1E);


// --- 淺色主題用的顏色 (來自你的原始檔案) ---
/// 一個清新、健康的顏色，適合做為淺色模式的主題色
const Color primaryColorLight = Color(0xFFA3D5DC);


// ===========================================================================
// 2. 深色主題 (Dark Theme)：數據驅動機能美學
// ===========================================================================

// --- 混合字體主題 ---
// 建立一個基礎的 TextTheme，英文字體使用 Inter，並將 Noto Sans TC 作為備用
TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: GoogleFonts.inter(textStyle: base.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white, shadows: [const Shadow(blurRadius: 4, color: accentColor)])),
    displayMedium: GoogleFonts.inter(textStyle: base.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white, shadows: [const Shadow(blurRadius: 4, color: accentColor)])),
    displaySmall: GoogleFonts.inter(textStyle: base.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white, shadows: [const Shadow(blurRadius: 4, color: accentColor)])),
    headlineLarge: GoogleFonts.inter(textStyle: base.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white, shadows: [const Shadow(blurRadius: 3, color: accentColor)])),
    headlineMedium: GoogleFonts.inter(textStyle: base.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white, shadows: [const Shadow(blurRadius: 3, color: accentColor)])),
    headlineSmall: GoogleFonts.inter(textStyle: base.headlineSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.white, shadows: [const Shadow(blurRadius: 3, color: accentColor)])),
    titleLarge: GoogleFonts.inter(textStyle: base.titleLarge?.copyWith(fontWeight: FontWeight.w500, color: const Color(0xFFF5F5F5))),
    titleMedium: GoogleFonts.inter(textStyle: base.titleMedium?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.15, color: const Color(0xFFF5F5F5))),
    titleSmall: GoogleFonts.inter(textStyle: base.titleSmall?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.1, color: const Color(0xFFF5F5F5))),
    bodyLarge: GoogleFonts.inter(textStyle: base.bodyLarge?.copyWith(color: const Color(0xFFE0E0E0))),
    bodyMedium: GoogleFonts.inter(textStyle: base.bodyMedium?.copyWith(color: const Color(0xFFE0E0E0))),
    bodySmall: GoogleFonts.inter(textStyle: base.bodySmall?.copyWith(color: const Color(0xFFBDBDBD))),
    labelLarge: GoogleFonts.robotoMono(textStyle: base.labelLarge?.copyWith(fontWeight: FontWeight.w500, color: accentColor, shadows: [const Shadow(blurRadius: 2, color: accentColor)])),
    labelMedium: GoogleFonts.robotoMono(textStyle: base.labelMedium?.copyWith(color: const Color(0xFFBDBDBD))),
    labelSmall: GoogleFonts.robotoMono(textStyle: base.labelSmall?.copyWith(color: const Color(0xFFBDBDBD))),
  );
}

final ThemeData darkTheme = ThemeData(
  // 啟用 Material 3 設計語言
  useMaterial3: true,
  // 明確指定主題亮度為深色
  brightness: Brightness.dark,
  // 這裡設定主要字體，Noto Sans TC 作為後備
  fontFamily: 'Inter',
  fontFamilyFallback: const ['Noto Sans TC'],

  // --- 核心顏色配置 ---
  scaffoldBackgroundColor: Colors.transparent, // 背景由 ProfessionalDarkBackground 提供
  colorScheme: const ColorScheme.dark(
    primary: accentColor,
    onPrimary: Color(0xFFFFFFFF), // 在強調色上的文字改為純白
    secondary: accentColor, 
    onSecondary: Color(0xFFFFFFFF), // 在強調色上的文字改為純白
    background: darkBackgroundColor,
    onBackground: Color(0xFFF5F5F5), // 主要文字改為更亮的灰白
    surface: darkSurfaceColor,
    onSurface: Color(0xFFFFFFFF), // 卡片上的文字改為純白
    error: Color(0xFFE57373), // 稍亮的紅色以提高可見度
    onError: Color(0xFF000000), // 錯誤訊息上的文字用黑色
  ),

  // --- 文字排版主題 ---
  textTheme: _buildTextTheme(
    ThemeData.dark().textTheme.copyWith(
      displayLarge: const TextStyle(fontSize: 57),
      displayMedium: const TextStyle(fontSize: 45),
      displaySmall: const TextStyle(fontSize: 36),
      headlineLarge: const TextStyle(fontSize: 32),
      headlineMedium: const TextStyle(fontSize: 28),
      headlineSmall: const TextStyle(fontSize: 24),
      titleLarge: const TextStyle(fontSize: 22),
      titleMedium: const TextStyle(fontSize: 16),
      titleSmall: const TextStyle(fontSize: 14),
      bodyLarge: const TextStyle(fontSize: 16),
      bodyMedium: const TextStyle(fontSize: 14),
      bodySmall: const TextStyle(fontSize: 12),
      labelLarge: const TextStyle(fontSize: 14),
      labelMedium: const TextStyle(fontSize: 12),
      labelSmall: const TextStyle(fontSize: 11),
    )
  ),

  // --- 元件主題 ---

  // App Bar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent, // AppBar 背景設為透明
    elevation: 0,
    foregroundColor: Colors.white, // AppBar 上的圖示和文字顏色
  ),

  // 卡片
  cardTheme: CardTheme(
    color: Colors.transparent, // 全域卡片背景設為透明
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  // 圖示
  iconTheme: const IconThemeData(
    color: accentColor,
    size: 24,
  ),

  // 按鈕
  // 1. 線框按鈕 (主要的行動呼籲 Call-to-Action)
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: accentColor,
      side: const BorderSide(color: accentColor, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  // 2. 實心按鈕 (次要的、但仍需突出的操作)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentColor,
      foregroundColor: Colors.black, // 在亮的 Accent 色上用黑色文字
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  // 3. 文字按鈕 (最次要的操作)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
);


// ===========================================================================
// 3. 淺色主題 (Light Theme)：清新健康風 (來自你的原始檔案，稍作整理)
// ===========================================================================
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColorLight,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColorLight,
    foregroundColor: Colors.white,
    elevation: 0.5,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColorLight,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 2,
      shadowColor: Colors.black26,
    ),
  ),
);

// ===========================================================================
// 4. 設計 Token：Glow 效果
// 建立統一的光暈效果，確保整個App的視覺一致性
// ===========================================================================
class AppGlows {
  static final Color _glowColor = accentColor.withOpacity(0.3);

  /// 小光暈 - 用於按鈕等小型元件
  static List<BoxShadow> get small => [
    BoxShadow(
      color: _glowColor,
      blurRadius: 8,
      spreadRadius: 2,
    ),
  ];

  /// 中光暈 - 用於卡片、彈窗等中型元件
  static List<BoxShadow> get medium => [
    BoxShadow(
      color: _glowColor.withOpacity(0.2), // 稍微降低不透明度
      blurRadius: 16,
      spreadRadius: 5,
    ),
  ];

  /// 大光暈 - 用於頁面背景或需要強烈視覺效果的場景
  static List<BoxShadow> get large => [
    BoxShadow(
      color: _glowColor.withOpacity(0.15),
      blurRadius: 30,
      spreadRadius: 10,
    ),
  ];
}