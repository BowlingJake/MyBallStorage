import 'package:flutter/material.dart';
import 'package:core_theme/core_theme.dart';

/// 全應用程式統一的標準卡片元件
/// 提供了基於 "Professional Analytics" 設計風格的標準外觀：
/// - 深色半透明背景
/// - 強調色邊框
/// - 強調色光暈 (可選)
///
/// 接受一個 `child` 元件來顯示卡片內容。
/// 支援不同的變體以適應不同的使用場景。
enum StandardAppCardVariant {
  /// 標準卡片 - 用於獨立顯示
  standard,

  /// 嵌套卡片 - 用於在容器內顯示，具有更強的視覺對比
  nested,
}

class StandardAppCard extends StatelessWidget {
  // 卡片變體

  const StandardAppCard({
    required this.child,
    super.key,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.padding = const EdgeInsets.all(16),
    this.constraints,
    this.enableGlow = true, // 預設啟用光暈，保持向後相容
    this.variant = StandardAppCardVariant.standard, // 預設為標準變體
  });
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final bool enableGlow; // 是否啟用光暈效果
  final StandardAppCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final borderRadius = BorderRadius.circular(16);

    // 根據變體調整樣式強度
    final isNested = variant == StandardAppCardVariant.nested;
    final borderOpacity = isNested ? 0.7 : 0.5; // 嵌套卡片的邊框更明顯
    final glowIntensity = isNested ? 1.5 : 1.0; // 嵌套卡片的光暈更強

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        constraints: constraints,
        decoration: BoxDecoration(
          // 1. 統一樣式 - 圓角
          borderRadius: borderRadius,

          // 2. 新樣式 - 背景完全透明
          color: Colors.transparent,

          // 3. 可調樣式 - 邊框 (嵌套卡片更明顯)
          border: Border.all(
            color: accentColor.withOpacity(borderOpacity),
            width: 1.5,
          ),

          // 4. 可選樣式 - 光暈效果 (使用統一的 Glow Token)
          boxShadow: enableGlow ? AppGlows.medium : null,
        ),
        child: child,
      ),
    );
  }
}
