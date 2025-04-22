import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          // 深色模式切換
          SwitchListTile(
            title: const Text('深色模式'),
            value: _darkMode,
            onChanged: (val) {
              setState(() => _darkMode = val);
              _updateBool('darkMode', val);
            },
          ),

          // 推播通知切換
          SwitchListTile(
            title: const Text('推播通知'),
            value: _notifications,
            onChanged: (val) {
              setState(() => _notifications = val);
              _updateBool('notifications', val);
            },
          ),

          // 語言選擇
          ListTile(
            title: const Text('語言'),
            subtitle: Text(_language),
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

          // 關於
          ListTile(
            title: const Text('關於'),
            subtitle: const Text('版本 1.0.0'),
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
            title: const Text('登出'),
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
