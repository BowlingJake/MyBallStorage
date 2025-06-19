import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/text_styles.dart';
import '../services/theme_service.dart';

/// 通用設定頁範例，可直接放在 lib/views/settings_page.dart
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  String _language = '中文';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getBool('notifications') ?? true;
      _language = prefs.getString('language') ?? '中文';
    });
  }

  Future<void> _updateBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _updateLanguage(String newLang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', newLang);
  }

  String _getThemeModeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return '淺色模式';
      case ThemeMode.dark:
        return '深色模式';
      case ThemeMode.system:
        return '跟隨系統';
    }
  }

  void _showThemeDialog(BuildContext context, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('選擇主題模式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('淺色模式'),
              value: ThemeMode.light,
              groupValue: themeService.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeService.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('深色模式'),
              value: ThemeMode.dark,
              groupValue: themeService.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeService.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('跟隨系統'),
              value: ThemeMode.system,
              groupValue: themeService.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeService.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = provider.Provider.of<ThemeService>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('設定', style: AppTextStyles.title)),
      body: ListView(
        children: [
          // 主題模式選擇
          ListTile(
            title: const Text('主題模式', style: AppTextStyles.body),
            subtitle: Text(_getThemeModeDisplayName(themeService.themeMode)),
            trailing: const Icon(Icons.brightness_6),
            onTap: () => _showThemeDialog(context, themeService),
          ),

          // 推播通知切換
          ListTile(
            title: const Text('推播通知', style: AppTextStyles.body),
            trailing: Switch(
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                  _updateBool('notifications', value);
                });
              },
            ),
          ),

          // 語言選擇
          ListTile(
            title: const Text('語言', style: AppTextStyles.body),
            trailing: const Text('繁體中文', style: AppTextStyles.caption),
            onTap: () async {
              final selected = await showModalBottomSheet<String>(
                context: context,
                builder: (ctx) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ['中文', 'English', '日本語']
                      .map((lang) => ListTile(
                            title: Text(lang),
                            onTap: () => Navigator.pop(ctx, lang),
                          ))
                      .toList(),
                ),
              );
              if (selected != null) {
                setState(() => _language = selected);
                _updateLanguage(selected);
              }
            },
          ),

          const Divider(),

          // 關於
          ListTile(
            title: const Text('關於', style: AppTextStyles.body),
            subtitle: const Text('版本 1.0.0', style: AppTextStyles.caption),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'My Ball Storage',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Jake Cheng',
              );
            },
          ),

          // 登出
          ListTile(
            title: const Text('登出', style: AppTextStyles.body),
            textColor: Colors.red,
            onTap: () async {
              // 清除登入狀態並跳回 LoginPage
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
