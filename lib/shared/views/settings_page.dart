import 'package:bowlingarsenal_app/shared/providers/app_theme_provider.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:core_theme/core_theme.dart';

/// 通用設定頁範例，可直接放在 lib/views/settings_page.dart
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeState = ref.watch(appThemeProvider);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('設定'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle(theme, '外觀'),
            _buildSettingsCard(
              theme: theme,
              leadingIcon: Iconsax.brush_1,
              title: '主題',
              subtitle: Text(_getThemeModeDisplayName(themeState)),
              onTap: () => _showThemeDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final themeState = ref.read(appThemeProvider);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('選擇主題'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AppThemeMode>(
                title: const Text('淺色'),
                value: AppThemeMode.light,
                groupValue: themeState.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(appThemeProvider.notifier).setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<AppThemeMode>(
                title: const Text('深色'),
                value: AppThemeMode.dark,
                groupValue: themeState.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(appThemeProvider.notifier).setThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<AppThemeMode>(
                title: const Text('跟隨系統'),
                value: AppThemeMode.system,
                groupValue: themeState.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(appThemeProvider.notifier).setThemeMode(value);
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
      padding: const EdgeInsets.only(top: 24, bottom: 8, left: 8),
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

  String _getThemeModeDisplayName(ThemeState themeState) {
    switch (themeState.themeMode) {
      case AppThemeMode.light:
        return '淺色';
      case AppThemeMode.dark:
        return '深色';
      case AppThemeMode.system:
        return '跟隨系統';
    }
  }
}
