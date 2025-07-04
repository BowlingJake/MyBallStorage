// lib/main.dart
import 'package:bowlingarsenal_app/app_router.dart';
import 'package:bowlingarsenal_app/core/error/error_handler.dart';
import 'package:bowlingarsenal_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppErrorHandler.initialize();

  AppErrorHandler.runGuarded(() {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrikeTrack - 保齡球管理應用',
      theme: darkTheme, // Always use dark theme
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark, // Force dark mode
      home: const AppRouter(),
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}