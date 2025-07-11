import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_theme/core_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeManager', () {
    late ThemeManager themeManager;

    setUp(() {
      // 重置SharedPreferences
      SharedPreferences.setMockInitialValues({});
      themeManager = ThemeManager.instance;
    });

    group('initialization', () {
      test('should start with default theme state', () {
        expect(themeManager.state, equals(ThemeState.defaultState));
        expect(themeManager.state.themeMode, equals(AppThemeMode.dark));
        expect(themeManager.state.isSystemDefault, isFalse);
      });

      test('should initialize from preferences', () async {
        // 預設保存淺色主題
        SharedPreferences.setMockInitialValues({
          'app_theme_mode': AppThemeMode.light.index,
          'app_use_system_theme': false,
        });

        await themeManager.initialize();

        expect(themeManager.state.themeMode, equals(AppThemeMode.light));
        expect(themeManager.state.isSystemDefault, isFalse);
      });
    });

    group('theme switching', () {
      test('toggleTheme should switch between dark and light', () async {
        // 開始時是深色模式
        expect(themeManager.state.themeMode, equals(AppThemeMode.dark));

        // 切換到淺色模式
        await themeManager.toggleTheme();
        expect(themeManager.state.themeMode, equals(AppThemeMode.light));

        // 再次切換回深色模式
        await themeManager.toggleTheme();
        expect(themeManager.state.themeMode, equals(AppThemeMode.dark));
      });

      test('setThemeMode should update theme correctly', () async {
        await themeManager.setThemeMode(AppThemeMode.system);
        
        expect(themeManager.state.themeMode, equals(AppThemeMode.system));
        expect(themeManager.state.isSystemDefault, isTrue);
      });

      test('setUseSystemTheme should update system preference', () async {
        await themeManager.setUseSystemTheme(true);
        
        expect(themeManager.state.themeMode, equals(AppThemeMode.system));
        expect(themeManager.state.isSystemDefault, isTrue);

        await themeManager.setUseSystemTheme(false);
        
        expect(themeManager.state.themeMode, equals(AppThemeMode.dark));
        expect(themeManager.state.isSystemDefault, isFalse);
      });
    });

    group('persistence', () {
      test('should save theme preferences', () async {
        await themeManager.setThemeMode(AppThemeMode.light);
        
        // 重新創建並初始化管理器以測試持久化
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('app_theme_mode'), equals(AppThemeMode.light.index));
        expect(prefs.getBool('app_use_system_theme'), isFalse);
      });
    });

    group('utility methods', () {
      test('getThemeDisplayName should return correct names', () {
        themeManager.setThemeMode(AppThemeMode.dark);
        expect(themeManager.getThemeDisplayName(), equals('深色模式'));

        themeManager.setThemeMode(AppThemeMode.light);
        expect(themeManager.getThemeDisplayName(), equals('淺色模式'));

        themeManager.setThemeMode(AppThemeMode.system);
        expect(themeManager.getThemeDisplayName(), equals('跟隨系統'));
      });

      test('resetToDefault should restore default state', () async {
        await themeManager.setThemeMode(AppThemeMode.light);
        await themeManager.resetToDefault();
        
        expect(themeManager.state, equals(ThemeState.defaultState));
      });
    });
  });

  group('ThemeState', () {
    test('should convert to correct Flutter ThemeMode', () {
      const lightState = ThemeState(
        themeMode: AppThemeMode.light,
        isSystemDefault: false,
      );
      expect(lightState.flutterThemeMode, equals(ThemeMode.light));

      const darkState = ThemeState(
        themeMode: AppThemeMode.dark,
        isSystemDefault: false,
      );
      expect(darkState.flutterThemeMode, equals(ThemeMode.dark));

      const systemState = ThemeState(
        themeMode: AppThemeMode.system,
        isSystemDefault: true,
      );
      expect(systemState.flutterThemeMode, equals(ThemeMode.system));
    });

    test('copyWith should work correctly', () {
      const original = ThemeState(
        themeMode: AppThemeMode.dark,
        isSystemDefault: false,
      );

      final updated = original.copyWith(themeMode: AppThemeMode.light);
      
      expect(updated.themeMode, equals(AppThemeMode.light));
      expect(updated.isSystemDefault, equals(false)); // 未變更
    });

    test('equality should work correctly', () {
      const state1 = ThemeState(
        themeMode: AppThemeMode.dark,
        isSystemDefault: false,
      );

      const state2 = ThemeState(
        themeMode: AppThemeMode.dark,
        isSystemDefault: false,
      );

      const state3 = ThemeState(
        themeMode: AppThemeMode.light,
        isSystemDefault: false,
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });
} 