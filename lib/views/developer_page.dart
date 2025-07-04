import 'package:bowlingarsenal_app/widgets/app_standard_button.dart';
import 'package:bowlingarsenal_app/widgets/glow_border_button.dart';
import 'package:flutter/material.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('開發者測試頁'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(context, 'APP 標準按鈕 (App Standard Button)'),
          const SizedBox(height: 16),

          // 僅文字按鈕
          AppStandardButton(
            text: '僅文字按鈕',
            onPressed: () => _showSnackBar(context, '文字按鈕被點擊'),
          ),
          const SizedBox(height: 12),

          // 僅圖示按鈕
          AppStandardButton(
            icon: Icons.star,
            onPressed: () => _showSnackBar(context, '圖示按鈕被點擊'),
            width: 60,
          ),
          const SizedBox(height: 12),

          // 圖示 + 文字按鈕
          AppStandardButton(
            text: 'Filter',
            icon: Icons.tune,
            onPressed: () => _showSnackBar(context, 'Filter 按鈕被點擊'),
            width: 120,
          ),
          const SizedBox(height: 12),

          // 停用狀態按鈕
          AppStandardButton(
            text: '停用按鈕',
            icon: Icons.block,
            onPressed: () {},
            enabled: false,
          ),
          const SizedBox(height: 12),

          // 自適應寬度按鈕
          AppStandardButton(
            text: '這是一個很長的按鈕文字範例',
            icon: Icons.text_fields,
            onPressed: () => _showSnackBar(context, '長文字按鈕被點擊'),
          ),

          const SizedBox(height: 32),

          _buildSectionTitle(context, 'Glow Border Button (原型)'),
          const SizedBox(height: 16),
          GlowBorderButton(
            onTap: () => _showSnackBar(context, 'GlowBorderButton 被點擊'),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, '顏色 (Colors)'),
          const SizedBox(height: 8),
          _buildColorSwatch(
            context,
            'Primary/Accent',
            theme.colorScheme.primary,
          ),
          _buildColorSwatch(context, 'Background', theme.colorScheme.surface),
          _buildColorSwatch(context, 'Surface', theme.colorScheme.surface),
          _buildColorSwatch(context, 'On Primary', theme.colorScheme.onPrimary),
          _buildColorSwatch(
            context,
            'On Background',
            theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, '文字樣式 (Typography)'),
          const SizedBox(height: 8),
          _buildTextStyleExample('Display Large', textTheme.displayLarge),
          _buildTextStyleExample('Display Medium', textTheme.displayMedium),
          _buildTextStyleExample('Display Small', textTheme.displaySmall),
          _buildTextStyleExample('Headline Medium', textTheme.headlineMedium),
          _buildTextStyleExample('Title Large', textTheme.titleLarge),
          _buildTextStyleExample('Body Large', textTheme.bodyLarge),
          _buildTextStyleExample('Body Medium (Default)', textTheme.bodyMedium),
          _buildTextStyleExample('Label Large (Data)', textTheme.labelLarge),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }

  Widget _buildColorSwatch(BuildContext context, String name, Color color) {
    return Card(
      color: color,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          name,
          style: TextStyle(
            color:
                ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextStyleExample(String name, TextStyle? style) {
    if (style == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(name, style: style),
    );
  }
}
