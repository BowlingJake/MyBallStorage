import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主題服務 - 管理深色/淺色主題切換
class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  /// 初始化，從本地存儲載入主題設定
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    
    switch (savedTheme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    
    notifyListeners();
  }
  
  /// 設定主題模式
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    // 保存到本地存儲
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
  }
  
  /// 切換到淺色主題
  Future<void> setLightTheme() => setThemeMode(ThemeMode.light);
  
  /// 切換到深色主題
  Future<void> setDarkTheme() => setThemeMode(ThemeMode.dark);
  
  /// 跟隨系統主題
  Future<void> setSystemTheme() => setThemeMode(ThemeMode.system);
  
  /// 判斷當前是否為深色模式（根據系統和設定）
  bool isDarkMode(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }
} 