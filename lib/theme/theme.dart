// lib/theme.dart
import 'package:flutter/material.dart';

// 1. 定義您的主色調
const Color primaryColor = Color(0xFFA3D5DC); // 您提供的主色

// 2. 建立淺色主題 (Light Theme)
final ThemeData lightTheme = ThemeData(
  useMaterial3: true, // 啟用 Material 3
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor, // 使用您的主色作為種子顏色
    brightness: Brightness.light, // 明確指定是淺色主題
    // 您可以在這裡覆蓋 fromSeed 生成的特定顏色，例如：
    // primary: primaryColor, // 通常 fromSeed 會處理好
    // secondary: Colors.amber, // 如果您想指定一個特定的輔助色
    // surface: Color(0xFFFAFAFA), // 頁面背景色
  ),
  // 您還可以定義其他主題屬性，例如：
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor, // AppBar 背景使用主色
    foregroundColor: Colors.white, // AppBar 上的文字和圖示顏色
    elevation: 0.5,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor, // TextButton 文字顏色
    ),
  ),
  // 其他如 textTheme, inputDecorationTheme 等等
  // fontFamily: 'YourCustomFont', // 如果您有自訂字體
);

// 3. (可選) 建立深色主題 (Dark Theme)
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor, // 也可以基於同一個種子顏色生成深色主題
    brightness: Brightness.dark, // 明確指定是深色主題
    // 您可以在這裡覆蓋 fromSeed 生成的特定顏色，例如：
    // secondary: Colors.tealAccent,
  ),
  // 針對深色主題的特定 AppBarTheme, ElevatedButtonTheme 等設定
  // appBarTheme: AppBarTheme(
  //   backgroundColor: Color(0xFF2C3E50), // 深色 AppBar 範例
  //   foregroundColor: Colors.white,
  // ),
);