import 'package:flutter/material.dart';

class AppStandardButton extends StatelessWidget {
  // 新增是否為主要按鈕樣式

  const AppStandardButton({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.width,
    this.height = 44.0,
    this.enabled = true,
    this.customColor, // 新增自訂顏色參數
    this.isPrimary = false, // 新增是否為主要按鈕樣式
  });
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final bool enabled;
  final Color? customColor; // 新增自訂顏色參數
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = customColor ?? theme.colorScheme.primary;

    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color:
              isPrimary && enabled
                  ? buttonColor
                  : Colors.transparent, // 主要按鈕有背景色，次要按鈕透明
          border: Border.all(
            color:
                enabled
                    ? buttonColor.withOpacity(isPrimary ? 0.8 : 0.5)
                    : theme.colorScheme.onSurface.withOpacity(0.3),
            width: 1.5,
          ),
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
                      color:
                          enabled
                              ? (isPrimary ? Colors.white : buttonColor)
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    if (text != null) const SizedBox(width: 8),
                  ],
                  if (text != null)
                    Flexible(
                      child: Text(
                        text!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              enabled
                                  ? (isPrimary ? Colors.white : buttonColor)
                                  : theme.colorScheme.onSurface.withOpacity(
                                    0.5,
                                  ),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
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
