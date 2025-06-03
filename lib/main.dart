// lib/main.dart
import 'package:flutter/material.dart';
import 'home_page.dart'; // 引入您的 home_page.dart
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Bowling App', // 您的應用程式標題
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomePage(), // 將 HomePage 設為首頁
      debugShowCheckedModeBanner: false, // 移除右上角的 Debug 標籤 (可選)
    );
  }
}