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
final ThemeData darkTheme = ThemeData(
  // 啟用 Material 3 設計語言
  useMaterial3: true,
  // 明確指定主題亮度為深色
  brightness: Brightness.dark,

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
  textTheme: TextTheme(
    displayLarge: GoogleFonts.lato(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white, shadows: [const Shadow(blurRadius: 4, color: accentColor)]),
    displayMedium: GoogleFonts.lato(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white, shadows: [const Shadow(blurRadius: 4, color: accentColor)]),
    displaySmall: GoogleFonts.lato(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, shadows: [const Shadow(blurRadius: 4, color: accentColor)]),
    
    headlineLarge: GoogleFonts.lato(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, shadows: [const Shadow(blurRadius: 3, color: accentColor)]),
    headlineMedium: GoogleFonts.lato(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, shadows: [const Shadow(blurRadius: 3, color: accentColor)]),
    headlineSmall: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white, shadows: [const Shadow(blurRadius: 3, color: accentColor)]),

    titleLarge: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w500, color: const Color(0xFFF5F5F5)),
    titleMedium: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: const Color(0xFFF5F5F5)),
    titleSmall: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: const Color(0xFFF5F5F5)),

    bodyLarge: GoogleFonts.lato(fontSize: 16, color: const Color(0xFFE0E0E0)),
    bodyMedium: GoogleFonts.lato(fontSize: 14, color: const Color(0xFFE0E0E0)),
    bodySmall: GoogleFonts.lato(fontSize: 12, color: const Color(0xFFBDBDBD)),

    // 這是關鍵：為「數據」和需要精準對齊的標籤建立一個專門的樣式
    labelLarge: GoogleFonts.robotoMono(fontSize: 14, fontWeight: FontWeight.w500, color: accentColor, shadows: [const Shadow(blurRadius: 2, color: accentColor)]),
    labelMedium: GoogleFonts.robotoMono(fontSize: 12, color: const Color(0xFFBDBDBD)),
    labelSmall: GoogleFonts.robotoMono(fontSize: 11, color: const Color(0xFFBDBDBD)),
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
    color: darkSurfaceColor,
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