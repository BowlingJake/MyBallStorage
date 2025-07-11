import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:core_theme/src/brand_colors.dart';

/// 應用文字樣式定義
/// 
/// 提供統一的字體配置和主題特定的文字樣式
class AppTextStyles {
  AppTextStyles._();

  /// 基礎字體家族
  static const String primaryFont = 'Inter';
  static const List<String> fontFallback = ['Noto Sans TC'];

  /// 深色主題文字樣式
  static TextTheme buildDarkTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: GoogleFonts.inter(
        textStyle: base.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimaryDark,
          shadows: [const Shadow(blurRadius: 4, color: BrandColors.accentColorDark)],
        ),
      ),
      displayMedium: GoogleFonts.inter(
        textStyle: base.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimaryDark,
          shadows: [const Shadow(blurRadius: 4, color: BrandColors.accentColorDark)],
        ),
      ),
      displaySmall: GoogleFonts.inter(
        textStyle: base.displaySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimaryDark,
          shadows: [const Shadow(blurRadius: 4, color: BrandColors.accentColorDark)],
        ),
      ),
      headlineLarge: GoogleFonts.inter(
        textStyle: base.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimaryDark,
          shadows: [const Shadow(blurRadius: 3, color: BrandColors.accentColorDark)],
        ),
      ),
      headlineMedium: GoogleFonts.inter(
        textStyle: base.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimaryDark,
          shadows: [const Shadow(blurRadius: 3, color: BrandColors.accentColorDark)],
        ),
      ),
      headlineSmall: GoogleFonts.inter(
        textStyle: base.headlineSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: BrandColors.textPrimaryDark,
          shadows: [const Shadow(blurRadius: 3, color: BrandColors.accentColorDark)],
        ),
      ),
      titleLarge: GoogleFonts.inter(
        textStyle: base.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: BrandColors.textSecondaryDark,
        ),
      ),
      titleMedium: GoogleFonts.inter(
        textStyle: base.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: BrandColors.textSecondaryDark,
        ),
      ),
      titleSmall: GoogleFonts.inter(
        textStyle: base.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: BrandColors.textSecondaryDark,
        ),
      ),
      bodyLarge: GoogleFonts.inter(
        textStyle: base.bodyLarge?.copyWith(color: BrandColors.textSecondaryDark),
      ),
      bodyMedium: GoogleFonts.inter(
        textStyle: base.bodyMedium?.copyWith(color: BrandColors.textSecondaryDark),
      ),
      bodySmall: GoogleFonts.inter(
        textStyle: base.bodySmall?.copyWith(color: BrandColors.textDisabledDark),
      ),
      labelLarge: GoogleFonts.robotoMono(
        textStyle: base.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: BrandColors.accentColorDark,
          shadows: [const Shadow(blurRadius: 2, color: BrandColors.accentColorDark)],
        ),
      ),
      labelMedium: GoogleFonts.robotoMono(
        textStyle: base.labelMedium?.copyWith(color: BrandColors.textDisabledDark),
      ),
      labelSmall: GoogleFonts.robotoMono(
        textStyle: base.labelSmall?.copyWith(color: BrandColors.textDisabledDark),
      ),
    );
  }

  /// 淺色主題文字樣式
  static TextTheme buildLightTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: GoogleFonts.inter(
        textStyle: base.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimaryLight,
        ),
      ),
      displayMedium: GoogleFonts.inter(
        textStyle: base.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimaryLight,
        ),
      ),
      displaySmall: GoogleFonts.inter(
        textStyle: base.displaySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimaryLight,
        ),
      ),
      headlineLarge: GoogleFonts.inter(
        textStyle: base.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimaryLight,
        ),
      ),
      headlineMedium: GoogleFonts.inter(
        textStyle: base.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: BrandColors.textPrimaryLight,
        ),
      ),
      headlineSmall: GoogleFonts.inter(
        textStyle: base.headlineSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: BrandColors.textPrimaryLight,
        ),
      ),
      titleLarge: GoogleFonts.inter(
        textStyle: base.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: BrandColors.textSecondaryLight,
        ),
      ),
      titleMedium: GoogleFonts.inter(
        textStyle: base.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: BrandColors.textSecondaryLight,
        ),
      ),
      titleSmall: GoogleFonts.inter(
        textStyle: base.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: BrandColors.textSecondaryLight,
        ),
      ),
      bodyLarge: GoogleFonts.inter(
        textStyle: base.bodyLarge?.copyWith(color: BrandColors.textSecondaryLight),
      ),
      bodyMedium: GoogleFonts.inter(
        textStyle: base.bodyMedium?.copyWith(color: BrandColors.textSecondaryLight),
      ),
      bodySmall: GoogleFonts.inter(
        textStyle: base.bodySmall?.copyWith(color: BrandColors.textDisabledLight),
      ),
      labelLarge: GoogleFonts.robotoMono(
        textStyle: base.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: BrandColors.accentColorLight,
        ),
      ),
      labelMedium: GoogleFonts.robotoMono(
        textStyle: base.labelMedium?.copyWith(color: BrandColors.textDisabledLight),
      ),
      labelSmall: GoogleFonts.robotoMono(
        textStyle: base.labelSmall?.copyWith(color: BrandColors.textDisabledLight),
      ),
    );
  }

  /// 基礎文字大小定義
  static const TextTheme baseTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57),
    displayMedium: TextStyle(fontSize: 45),
    displaySmall: TextStyle(fontSize: 36),
    headlineLarge: TextStyle(fontSize: 32),
    headlineMedium: TextStyle(fontSize: 28),
    headlineSmall: TextStyle(fontSize: 24),
    titleLarge: TextStyle(fontSize: 22),
    titleMedium: TextStyle(fontSize: 16),
    titleSmall: TextStyle(fontSize: 14),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
    labelLarge: TextStyle(fontSize: 14),
    labelMedium: TextStyle(fontSize: 12),
    labelSmall: TextStyle(fontSize: 11),
  );
} 