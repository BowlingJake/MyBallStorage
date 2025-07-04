import 'package:flutter/material.dart';

/// 功能區域容器卡片
/// 用於包裹各個功能區域（如 Arsenal、Tournament），
/// 創造清晰的資訊分組和視覺層次
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    required this.title,
    required this.child,
    super.key,
    this.onSeeAllPressed,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });
  final String title;
  final Widget child;
  final VoidCallback? onSeeAllPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        // 容器使用較淡的背景，與內部小卡片形成層次對比
        color: theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        // 容器的邊框較細且更透明
        border: Border.all(color: accentColor.withOpacity(0.2)),
        // 容器的光暈較淡
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Padding(
        padding: padding!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題和 "See All" 按鈕
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onSeeAllPressed != null)
                  TextButton(
                    onPressed: onSeeAllPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: accentColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('See All'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // 內容區域
            child,
          ],
        ),
      ),
    );
  }
}
