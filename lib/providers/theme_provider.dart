import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主題模式狀態
class ThemeState {
  final ThemeMode themeMode;
  final bool isLoading;

  const ThemeState({
    required this.themeMode,
    this.isLoading = false,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isLoading,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 主題 Provider - 管理深色/淺色主題切換
class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeNotifier() : super(const ThemeState(themeMode: ThemeMode.system)) {
    _initialize();
  }

  /// 初始化，從本地存儲載入主題設定
  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      ThemeMode themeMode;
      switch (savedTheme) {
        case 'light':
          themeMode = ThemeMode.light;
          break;
        case 'dark':
          themeMode = ThemeMode.dark;
          break;
        default:
          themeMode = ThemeMode.system;
      }
      
      state = ThemeState(themeMode: themeMode, isLoading: false);
    } catch (e) {
      // 如果載入失敗，使用系統預設
      state = const ThemeState(themeMode: ThemeMode.system, isLoading: false);
    }
  }

  /// 設定主題模式
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.themeMode == mode) return;
    
    state = state.copyWith(themeMode: mode);
    
    // 保存到本地存儲
    try {
      final prefs = await SharedPreferences.getInstance();
      String modeString;
      switch (mode) {
        case ThemeMode.light:
          modeString = 'light';
          break;
        case ThemeMode.dark:
          modeString = 'dark';
          break;
        case ThemeMode.system:
          modeString = 'system';
          break;
      }
      await prefs.setString(_themeKey, modeString);
    } catch (e) {
      // 如果保存失敗，記錄錯誤但不影響UI狀態
      debugPrint('Failed to save theme preference: $e');
    }
  }

  /// 切換到淺色主題
  Future<void> setLightTheme() => setThemeMode(ThemeMode.light);

  /// 切換到深色主題
  Future<void> setDarkTheme() => setThemeMode(ThemeMode.dark);

  /// 跟隨系統主題
  Future<void> setSystemTheme() => setThemeMode(ThemeMode.system);

  /// 判斷當前是否為深色模式（根據系統和設定）
  bool isDarkMode(BuildContext context) {
    switch (state.themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }
}

/// 主題 Provider
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