// lib/main.dart
import 'dart:ui';

import 'package:bowlingarsenal_app/core/error/error_handler.dart';
import 'package:bowlingarsenal_app/routing/app_router_config.dart';
import 'package:bowlingarsenal_app/shared/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  AppErrorHandler.runGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const AppWithPreload()); // Use a preloading wrapper
  });
}

/// A wrapper widget to handle pre-caching of critical assets like fonts
/// before showing the main application.
class AppWithPreload extends StatefulWidget {
  const AppWithPreload({super.key});

  @override
  State<AppWithPreload> createState() => _AppWithPreloadState();
}

class _AppWithPreloadState extends State<AppWithPreload> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Pre-warm the main fonts to prevent text pop-in.
    // This works by creating a TextPainter for each critical font family,
    // which forces the engine to load and cache them.
    await _prewarmFont('Inter');
    await _prewarmFont('Noto Sans TC');
    // You can also precache images here if needed
    // await precacheImage(const AssetImage('assets/images/your_image.webp'), context);

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _prewarmFont(String fontFamily) async {
    final painter = TextPainter(
      text: TextSpan(text: ' ', style: TextStyle(fontFamily: fontFamily)),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialized) {
      return const ProviderScope(child: MyApp());
    }

    // Show a minimal loading screen during initialization
    return Container(
      color: const Color(0xFF1A1A1A),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}

/// The main application widget, now built after assets are pre-warmed.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(currentThemeModeProvider);
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'StrikeTrack - 保齡球管理應用',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
