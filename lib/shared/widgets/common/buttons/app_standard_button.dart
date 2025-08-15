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
  }) : customColor = null,
       isPrimary = false,
       whiteForeground = false,
       backgroundColor = Colors.transparent,
       outlineColor = null, // 將使用白色線框
       foregroundColor = null, // 將使用白色文字
       disabledForegroundColor = null,
       disabledOutlineColor = null;

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
       whiteForeground = true, // 青色背景用白色前景
       backgroundColor = null, // 將在build中設定為次要顏色
       outlineColor = null,
       foregroundColor = Colors.white,
       disabledForegroundColor = null,
       disabledOutlineColor = null;

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
       whiteForeground = true, // 紅色背景用白色前景
       backgroundColor = BrandColors.errorColor,
       outlineColor = BrandColors.errorColor,
       foregroundColor = Colors.white,
       disabledForegroundColor = null,
       disabledOutlineColor = null;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // 判斷是否為 creative 按鈕（通過檢查 whiteForeground 和 backgroundColor 為 null）
    final bool isCreativeButton = whiteForeground && backgroundColor == null && customColor == null;
    
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
    final Color effectiveBackground = backgroundColor ?? baseColor;
    
    // 設定有效的邊框顏色
    final Color effectiveBorder = enabled
        ? (outlineColor ?? baseColor)
        : (disabledOutlineColor ?? theme.colorScheme.onSurface.withOpacity(0.3));
    
    // 設定有效的前景顏色
    final Color effectiveForeground = enabled
        ? (foregroundColor ?? (whiteForeground ? Colors.white : Colors.black))
        : (disabledForegroundColor ?? theme.colorScheme.onSurface.withOpacity(0.5));

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
