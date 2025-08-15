import 'package:flutter/material.dart';
import 'package:core_theme/core_theme.dart';

class AppStandardButton extends StatelessWidget {
  // 預設主要按鈕樣式（金色實心）
  const AppStandardButton({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.width,
    this.height = 36.0,
    this.enabled = true,
    this.customColor, // 新增自訂顏色參數
    this.isPrimary = false, // 新增是否為主要按鈕樣式
    this.fontSize = 14.0, // 新增字體大小參數
    this.whiteForeground = false, // 主要按鈕時改用白色前景（深色背景）
    this.backgroundColor,
    this.outlineColor,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.disabledOutlineColor,
    this.primaryOutlined = false,
  });

  /// 次要動作按鈕 - 中性色線框樣式
  /// 用於取消、返回、查看詳情等輔助操作
  const AppStandardButton.secondary({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.width,
    this.height = 36.0,
    this.enabled = true,
    this.fontSize = 14.0,
  }) : customColor = Colors.white, // 白色線框和文字
       isPrimary = false,
       whiteForeground = true, // 透明背景用白色前景
       backgroundColor = Colors.transparent,
       outlineColor = Colors.white, // 白色線框
       foregroundColor = Colors.white, // 白色文字
       disabledForegroundColor = null,
       disabledOutlineColor = null,
       primaryOutlined = false;

  /// 創造/特殊功能按鈕 - 青色實心樣式
  /// 用於新增、創建、特殊功能入口等操作
  const AppStandardButton.creative({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.width,
    this.height = 36.0,
    this.enabled = true,
    this.fontSize = 14.0,
  }) : customColor = null, // 將在build中設定為次要顏色
       isPrimary = false,
       whiteForeground = true, // 標記為次要色樣式（用於選擇底色）
       backgroundColor = null, // 將在build中設定為次要顏色
       outlineColor = null,
       foregroundColor = null,
       disabledForegroundColor = null,
       disabledOutlineColor = null,
       primaryOutlined = false;

  /// 破壞性動作按鈕 - 紅色實心樣式
  /// 用於刪除、清除等不可逆操作
  const AppStandardButton.destructive({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.width,
    this.height = 36.0,
    this.enabled = true,
    this.fontSize = 14.0,
  }) : customColor = BrandColors.errorColor,
       isPrimary = false,
       whiteForeground = false, // 紅色背景用黑色前景（更好對比度）
       backgroundColor = BrandColors.errorColor,
       outlineColor = BrandColors.errorColor,
       foregroundColor = Colors.black, // 改為黑色前景
       disabledForegroundColor = null,
       disabledOutlineColor = null,
       primaryOutlined = false;

  /// 主要色線框樣式（不硬編顏色，使用品牌主色）
  const AppStandardButton.primaryOutlined({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.width,
    this.height = 36.0,
    this.enabled = true,
    this.fontSize = 14.0,
  }) : customColor = null,
       isPrimary = false,
       whiteForeground = false,
       backgroundColor = Colors.transparent,
       outlineColor = null,
       foregroundColor = null,
       disabledForegroundColor = null,
       disabledOutlineColor = null,
       primaryOutlined = true;

  /// 次要色線框樣式（使用品牌次要色作為邊框顏色）
  const AppStandardButton.secondaryOutlined({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.width,
    this.height = 36.0,
    this.enabled = true,
    this.fontSize = 14.0,
  }) : customColor = BrandColors.secondaryColorDark,
       isPrimary = false,
       whiteForeground = true,
       backgroundColor = Colors.transparent,
       outlineColor = BrandColors.secondaryColorDark,
       foregroundColor = null,
       disabledForegroundColor = null,
       disabledOutlineColor = null,
       primaryOutlined = true;

  /// 破壞性線框樣式（紅色線框）
  const AppStandardButton.destructiveOutlined({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.width,
    this.height = 36.0,
    this.enabled = true,
    this.fontSize = 14.0,
  }) : customColor = BrandColors.errorColor,
       isPrimary = false,
       whiteForeground = false,
       backgroundColor = Colors.transparent,
       outlineColor = BrandColors.errorColor,
       foregroundColor = BrandColors.errorColor,
       disabledForegroundColor = null,
       disabledOutlineColor = null,
       primaryOutlined = false;

  /// 中性白色線框樣式（白線 + 白字）
  const AppStandardButton.neutralOutlined({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.width,
    this.height = 36.0,
    this.enabled = true,
    this.fontSize = 14.0,
  }) : customColor = Colors.white,
       isPrimary = false,
       whiteForeground = true,
       backgroundColor = Colors.transparent,
       outlineColor = Colors.white,
       foregroundColor = Colors.white,
       disabledForegroundColor = null,
       disabledOutlineColor = null,
       primaryOutlined = false;
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final bool enabled;
  final Color? customColor; // 新增自訂顏色參數
  final bool isPrimary;
  final double fontSize; // 新增字體大小參數
  final bool whiteForeground;
  final Color? backgroundColor;
  final Color? outlineColor;
  final Color? foregroundColor;
  final Color? disabledForegroundColor;
  final Color? disabledOutlineColor;
  final bool primaryOutlined;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // creative（次要色實心）判斷：沿用 whiteForeground 作為標記，避免誤判主要色
    final bool isCreativeButton = whiteForeground && backgroundColor == null && customColor == null && !primaryOutlined;
    
    // 設定基礎顏色
    Color baseColor;
    if (isCreativeButton) {
      // Creative 按鈕使用次要顏色
      baseColor = theme.brightness == Brightness.dark
          ? BrandColors.secondaryColorDark
          : BrandColors.secondaryColorLight;
    } else {
      // 其他按鈕使用自訂顏色或默認金色
      final Color defaultGoldColor = theme.brightness == Brightness.dark
          ? BrandColors.accentColorDark
          : BrandColors.accentColorLight;
      baseColor = customColor ?? defaultGoldColor;
    }
    
    // 設定有效的背景顏色
    final Color effectiveBackground;
    if (!enabled) {
      // disabled 狀態：所有實心按鈕都使用灰色背景
      effectiveBackground = primaryOutlined ? Colors.transparent : Colors.grey[600]!;
    } else {
      effectiveBackground = primaryOutlined ? Colors.transparent : (backgroundColor ?? baseColor);
    }
    
    // 設定有效的邊框顏色
    final Color effectiveBorder = enabled
        ? (primaryOutlined ? baseColor : (outlineColor ?? baseColor))
        : (disabledOutlineColor ?? theme.colorScheme.onSurface.withOpacity(0.3));
    
    // 設定有效的前景顏色
    final Color effectiveForeground;
    if (!enabled) {
      // disabled 狀態：統一使用灰色文字
      effectiveForeground = Colors.grey[400]!;
    } else if (effectiveBackground == Colors.transparent) {
      // 所有透明背景（線框按鈕）都使用白色前景，因為背景是深色
      effectiveForeground = Colors.white;
    } else if (foregroundColor != null) {
      // 如果明確指定前景色，使用指定的顏色
      effectiveForeground = foregroundColor!;
    } else if (effectiveBackground == BrandColors.errorColor) {
      // 紅色背景使用黑色字體，確保更好的對比度
      effectiveForeground = Colors.black;
    } else if (isCreativeButton) {
      // 次要色實心：改為黑色字（統一視覺）
      effectiveForeground = Colors.black;
    } else {
      // 金色背景使用黑色前景，確保對比度
      effectiveForeground = Colors.black;
    }

    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: effectiveBackground,
          border: Border.all(color: effectiveBorder, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(20),
            splashColor:
                enabled ? baseColor.withOpacity(0.1) : Colors.transparent,
            highlightColor:
                enabled ? baseColor.withOpacity(0.05) : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 18,
                      color: effectiveForeground,
                    ),
                    if (text != null) const SizedBox(width: 8),
                  ],
                  if (text != null)
                    Flexible(
                      child: Text(
                        text!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: effectiveForeground,
                          fontWeight: FontWeight.w500,
                          fontSize: fontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
