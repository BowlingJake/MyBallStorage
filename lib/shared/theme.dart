import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      primaryColor: const Color(0xFF005BEA),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
      ),
        colorScheme: ColorScheme.light(
        primary: Color(0xFF005BEA),
        secondary: Color(0xFF00C6FB),
        background: Color(0xFFF7F9FC),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Color(0xFF1F2937),
        surface: Colors.white,
        onSurface: Color(0xFF6B7280),
      ),
      useMaterial3: true,
    );
  }
}
