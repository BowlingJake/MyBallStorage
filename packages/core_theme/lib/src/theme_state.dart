import 'package:flutter/material.dart';

/// 主題狀態枚舉
enum AppThemeMode {
  light,
  dark,
  system,
}

/// 主題狀態管理
/// 
/// 封裝主題相關的狀態和業務邏輯
class ThemeState {
  const ThemeState({
    required this.themeMode,
    required this.isSystemDefault,
  });

  /// 當前主題模式
  final AppThemeMode themeMode;

  /// 是否使用系統預設
  final bool isSystemDefault;

  /// 複製並修改狀態
  ThemeState copyWith({
    AppThemeMode? themeMode,
    bool? isSystemDefault,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isSystemDefault: isSystemDefault ?? this.isSystemDefault,
    );
  }

  /// 轉換為Flutter的ThemeMode
  ThemeMode get flutterThemeMode {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// 是否為深色模式
  bool isDarkMode(BuildContext context) {
    switch (themeMode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  /// 預設狀態
  static const ThemeState defaultState = ThemeState(
    themeMode: AppThemeMode.dark,
    isSystemDefault: false,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeState &&
        other.themeMode == themeMode &&
        other.isSystemDefault == isSystemDefault;
  }

  @override
  int get hashCode => themeMode.hashCode ^ isSystemDefault.hashCode;

  @override
  String toString() {
    return 'ThemeState(themeMode: $themeMode, isSystemDefault: $isSystemDefault)';
  }
} 