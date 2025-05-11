import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/text_styles.dart';

/// 通用設定頁範例，可直接放在 lib/views/settings_page.dart
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
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
      _darkMode = prefs.getBool('darkMode') ?? false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定', style: AppTextStyles.title)),
      body: ListView(
        children: [
          // 深色模式切換
          ListTile(
            title: const Text('深色模式', style: AppTextStyles.body),
            trailing: Switch(
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                  _updateBool('darkMode', value);
                });
              },
            ),
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
