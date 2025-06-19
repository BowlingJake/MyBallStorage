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
    return provider.Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          title: 'My Bowling App', // 您的應用程式標題
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeService.themeMode, // 使用主題服務的設定
          home: const HomePage(), // 將 HomePage 設為首頁
          debugShowCheckedModeBanner: false, // 移除右上角的 Debug 標籤 (可選)
        );
      },
    );
  }
}