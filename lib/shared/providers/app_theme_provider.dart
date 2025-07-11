import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_theme/core_theme.dart';

/// 使用core_theme的主題狀態Notifier
class AppThemeNotifier extends StateNotifier<ThemeState> {
  AppThemeNotifier() : super(ThemeState.defaultState) {
    _initializeTheme();
  }

  final ThemeManager _themeManager = ThemeManager.instance;

  /// 初始化主題
  Future<void> _initializeTheme() async {
    await _themeManager.initialize();
    state = _themeManager.state;
    
    // 監聽主題管理器的變化
    _themeManager.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    state = _themeManager.state;
  }

  /// 切換主題
  Future<void> toggleTheme() async {
    await _themeManager.toggleTheme();
  }

  /// 設置特定主題模式
  Future<void> setThemeMode(AppThemeMode mode) async {
    await _themeManager.setThemeMode(mode);
  }

  /// 設置是否跟隨系統主題
  Future<void> setUseSystemTheme(bool useSystem) async {
    await _themeManager.setUseSystemTheme(useSystem);
  }

  /// 重置為預設主題
  Future<void> resetToDefault() async {
    await _themeManager.resetToDefault();
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }
}

/// 主題狀態Provider
final appThemeProvider = StateNotifierProvider<AppThemeNotifier, ThemeState>((ref) {
  return AppThemeNotifier();
});

/// 當前Flutter ThemeMode Provider
final currentThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeState = ref.watch(appThemeProvider);
  return themeState.flutterThemeMode;
});

/// 是否為深色模式Provider
final isDarkModeProvider = Provider.family<bool, BuildContext>((ref, context) {
  final themeState = ref.watch(appThemeProvider);
  return themeState.isDarkMode(context);
});

/// 深色主題數據Provider
final darkThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.darkTheme;
});

/// 淺色主題數據Provider
final lightThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.lightTheme;
});

/// 主題顯示名稱Provider
final themeDisplayNameProvider = Provider<String>((ref) {
  final themeState = ref.watch(appThemeProvider);
  return ThemeManager.instance.getThemeDisplayName();
}); 