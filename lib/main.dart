// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'app_router.dart'; // 引入新的應用路由器
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
    return MaterialApp(
      title: 'StrikeTrack - 保齡球管理應用',
      theme: darkTheme, // 固定使用深色主題
      home: const AppRouter(), // 使用智能路由器作為首頁
      onGenerateRoute: AppRoutes.generateRoute, // 設定路由生成器
      debugShowCheckedModeBanner: false,
    );
  }
}