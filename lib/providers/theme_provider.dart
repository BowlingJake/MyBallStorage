import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Defines the state for the theme, which is now always dark.
class ThemeState {
  const ThemeState(this.themeMode);
  final ThemeMode themeMode;
}

/// Manages the theme mode of the application.
///
/// This notifier holds the current [ThemeMode] and provides a method to toggle
/// between dark and light mode.
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark); // Default to dark mode

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

/// Provides the [ThemeNotifier] to the widget tree.
///
/// Widgets can use this provider to access the [ThemeNotifier] instance
/// to read the current theme mode or to call the `toggleTheme` method.
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// 便利的計算型 Provider - 獲取當前主題模式
final currentThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeState = ref.watch(themeProvider);
  return themeState;
});

/// 便利的計算型 Provider - 檢查是否為深色模式
final isDarkModeProvider = Provider.family<bool, BuildContext>((ref, context) {
  final themeState = ref.watch(themeProvider);
  switch (themeState) {
    case ThemeMode.light:
      return false;
    case ThemeMode.dark:
      return true;
    case ThemeMode.system:
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}); 