import 'package:flutter/material.dart';

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
    final buttonColor = customColor ?? theme.colorScheme.primary;
    final Color effectiveBackground =
        backgroundColor ?? (isPrimary && enabled ? buttonColor : Colors.transparent);
    final Color effectiveBorder = enabled
        ? (outlineColor ?? buttonColor.withOpacity(isPrimary ? 0.8 : 0.5))
        : (disabledOutlineColor ?? theme.colorScheme.onSurface.withOpacity(0.3));
    final Color effectiveForeground = enabled
        ? (foregroundColor ?? (isPrimary
            ? (whiteForeground ? Colors.white : Colors.black)
            : buttonColor))
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
                enabled ? buttonColor.withOpacity(0.1) : Colors.transparent,
            highlightColor:
                enabled ? buttonColor.withOpacity(0.05) : Colors.transparent,
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
