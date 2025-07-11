import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core_theme/src/theme_state.dart';

/// 主題管理器
/// 
/// 負責主題狀態的管理、持久化和業務邏輯
class ThemeManager extends ChangeNotifier {
  ThemeManager._();

  static ThemeManager? _instance;
  static ThemeManager get instance => _instance ??= ThemeManager._();

  static const String _themeKey = 'app_theme_mode';
  static const String _systemKey = 'app_use_system_theme';

  ThemeState _state = ThemeState.defaultState;

  /// 當前主題狀態
  ThemeState get state => _state;

  /// 初始化主題管理器
  Future<void> initialize() async {
    await _loadThemeFromPreferences();
  }

  /// 切換主題模式
  Future<void> toggleTheme() async {
    AppThemeMode newMode;
    switch (_state.themeMode) {
      case AppThemeMode.light:
        newMode = AppThemeMode.dark;
        break;
      case AppThemeMode.dark:
        newMode = AppThemeMode.light;
        break;
      case AppThemeMode.system:
        newMode = AppThemeMode.light;
        break;
    }

    await setThemeMode(newMode);
  }

  /// 設置主題模式
  Future<void> setThemeMode(AppThemeMode mode) async {
    _state = _state.copyWith(
      themeMode: mode,
      isSystemDefault: mode == AppThemeMode.system,
    );
    
    await _saveThemeToPreferences();
    notifyListeners();
  }

  /// 設置是否跟隨系統
  Future<void> setUseSystemTheme(bool useSystem) async {
    if (useSystem) {
      _state = _state.copyWith(
        themeMode: AppThemeMode.system,
        isSystemDefault: true,
      );
    } else {
      // 如果不跟隨系統，根據當前系統主題設置具體模式
      _state = _state.copyWith(
        themeMode: AppThemeMode.dark, // 預設為深色
        isSystemDefault: false,
      );
    }
    
    await _saveThemeToPreferences();
    notifyListeners();
  }

  /// 從偏好設定載入主題
  Future<void> _loadThemeFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final themeIndex = prefs.getInt(_themeKey);
      final useSystem = prefs.getBool(_systemKey) ?? false;

      if (themeIndex != null && themeIndex < AppThemeMode.values.length) {
        final mode = AppThemeMode.values[themeIndex];
        _state = ThemeState(
          themeMode: mode,
          isSystemDefault: useSystem,
        );
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load theme preferences: $e');
      // 使用預設主題
      _state = ThemeState.defaultState;
    }
  }

  /// 保存主題到偏好設定
  Future<void> _saveThemeToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _state.themeMode.index);
      await prefs.setBool(_systemKey, _state.isSystemDefault);
    } catch (e) {
      debugPrint('Failed to save theme preferences: $e');
    }
  }

  /// 重置為預設主題
  Future<void> resetToDefault() async {
    _state = ThemeState.defaultState;
    await _saveThemeToPreferences();
    notifyListeners();
  }

  /// 獲取主題顯示名稱
  String getThemeDisplayName() {
    switch (_state.themeMode) {
      case AppThemeMode.light:
        return '淺色模式';
      case AppThemeMode.dark:
        return '深色模式';
      case AppThemeMode.system:
        return '跟隨系統';
    }
  }

  @override
  void dispose() {
    // ThemeManager是單例，通常不需要dispose
    super.dispose();
  }
} 