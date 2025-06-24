// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'home_page.dart'; // 引入您的 home_page.dart
import 'theme/theme.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化主題服務
  final themeService = ThemeService();
  await themeService.initialize();
  
  runApp(
    ProviderScope(
      child: provider.ChangeNotifierProvider.value(
        value: themeService,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 直接使用並固定為深色主題
    return MaterialApp(
      title: 'My Bowling App', // 您的應用程式標題
      theme: darkTheme, // 固定使用深色主題
      // darkTheme: darkTheme, // 不需要分別設定
      // themeMode: themeService.themeMode, // 不需要主題模式切換
      home: const HomePage(), // 將 HomePage 設為首頁
      debugShowCheckedModeBanner: false, // 移除右上角的 Debug 標籤 (可選)
    );
  }
}