import 'package:flutter/material.dart';

/// 全應用程式統一的標準卡片元件
/// 提供了基於 "Professional Analytics" 設計風格的標準外觀：
/// - 深色半透明背景
/// - 強調色邊框
/// - 強調色光暈
///
/// 接受一個 `child` 元件來顯示卡片內容。
class StandardAppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const StandardAppCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final borderRadius = BorderRadius.circular(16.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          // 1. 統一樣式 - 圓角
          borderRadius: borderRadius,
          
          // 2. 統一樣式 - 背景
          // 使用非常低的透明度來創造深度感
          color: Colors.white.withOpacity(0.05),
          
          // 3. 統一樣式 - 邊框
          // 使用強調色，但降低透明度使其不至於太刺眼
          border: Border.all(
            color: accentColor.withOpacity(0.5),
            width: 1.5,
          ),
          
          // 4. 統一樣式 - 光暈效果
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
} 