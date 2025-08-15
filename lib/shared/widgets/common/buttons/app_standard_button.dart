import 'package:flutter/material.dart';
import 'package:core_theme/core_theme.dart';

class AppStandardButton extends StatelessWidget {
  // 新增是否為主要按鈕樣式

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
    // 預設使用金色背景和黑色前景，符合設計要求的醒目金色按鈕
    final Color defaultGoldColor = theme.brightness == Brightness.dark
        ? BrandColors.accentColorDark
        : BrandColors.accentColorLight;
    
    final Color baseColor = customColor ?? defaultGoldColor;
    // 預設為金色填滿背景（重要交互點必須醒目）
    final Color effectiveBackground = backgroundColor ?? baseColor;
    final Color effectiveBorder = enabled
        ? (outlineColor ?? baseColor)
        : (disabledOutlineColor ?? theme.colorScheme.onSurface.withOpacity(0.3));
    final Color effectiveForeground = enabled
        ? (foregroundColor ?? Colors.black) // 金色背景用黑色前景更清晰
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
