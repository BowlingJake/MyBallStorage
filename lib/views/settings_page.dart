import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/providers/theme_provider.dart';
import 'package:bowlingarsenal_app/widgets/common/professional_dark_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/text_styles.dart';
import '../services/theme_service.dart';

/// 通用設定頁範例，可直接放在 lib/views/settings_page.dart
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeState = ref.watch(themeProvider);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('設定'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // The theme settings card is now removed.
            // _buildSectionTitle(theme, '外觀'),
            // _buildSettingsCard(
            //   theme: theme,
            //   leadingIcon: Iconsax.moon,
            //   title: '主題模式',
            //   subtitle: Text('深色模式'), // Always dark
            //   onTap: null, // No action needed
            // ),
            // ... Other settings ...
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final themeState = ref.read(themeProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('選擇主題'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('淺色'),
                value: ThemeMode.light,
                groupValue: themeState.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeProvider.notifier).setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('深色'),
                value: ThemeMode.dark,
                groupValue: themeState.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeProvider.notifier).setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('跟隨系統'),
                value: ThemeMode.system,
                groupValue: themeState.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeProvider.notifier).setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0, left: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required ThemeData theme,
    required IconData leadingIcon,
    required String title,
    Widget? subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(leadingIcon, color: theme.colorScheme.secondary),
        title: Text(title),
        subtitle: subtitle,
        onTap: onTap,
        trailing: const Icon(Iconsax.arrow_right_3, size: 18),
      ),
    );
  }

  String _getThemeModeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return '淺色';
      case ThemeMode.dark:
        return '深色';
      case ThemeMode.system:
        return '跟隨系統';
    }
  }
}
