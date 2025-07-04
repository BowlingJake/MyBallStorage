import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Defines the state for the theme, which is now always dark.
class ThemeState {
  const ThemeState(this.themeMode);
  final ThemeMode themeMode;
}

/// Manages the theme state of the application, forcing dark mode.
class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState(ThemeMode.dark)); // Always start in dark mode

  /// This method is now redundant but kept for API consistency if needed later.
  /// It will always set the theme to dark mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.themeMode == ThemeMode.dark) return;
    state = const ThemeState(ThemeMode.dark);
  }
}

/// Provider for accessing the ThemeNotifier.
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

/// 便利的計算型 Provider - 獲取當前主題模式
final currentThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeState = ref.watch(themeProvider);
  return themeState.themeMode;
});

/// 便利的計算型 Provider - 檢查是否為深色模式
final isDarkModeProvider = Provider.family<bool, BuildContext>((ref, context) {
  final themeState = ref.watch(themeProvider);
  switch (themeState.themeMode) {
    case ThemeMode.light:
      return false;
    case ThemeMode.dark:
      return true;
    case ThemeMode.system:
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}); 