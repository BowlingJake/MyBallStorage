// 檔案路徑： confirmation_dialog.dart

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:core_theme/core_theme.dart';
import '../buttons/app_standard_button.dart'; // 請確認您的按鈕元件路徑

/// 顯示一個功能完善、通用的確認 Dialog (最終修正版)
/// 使用現代化的 outlined 樣式設計
Future<bool?> showAppConfirmationDialog({
  required BuildContext context,
  required String confirmText,
  String? title,
  String? message,
  Widget? content,
  String cancelText = 'Cancel',
  bool isDangerous = false,
  bool barrierDismissible = false,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (BuildContext dialogContext) {
      return _ConfirmationDialog(
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        isDangerous: isDangerous,
      );
    },
  );
}

/// Dialog 的內部實作 Widget (私有)
class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({
    this.title,
    this.message,
    this.content,
    required this.confirmText,
    required this.cancelText,
    required this.isDangerous,
    super.key,
  });

  final String? title;
  final String? message;
  final Widget? content;
  final String confirmText;
  final String cancelText;
  final bool isDangerous;

  @override
  Widget build(BuildContext context) {
    // 如果是危險操作，確認按鈕使用紅色，否則使用品牌色
    final Color confirmButtonColor = isDangerous
        ? Colors.red
        : BrandColors.accentColorDark;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: confirmButtonColor.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            // Message or Custom Content
            if (message != null) ...[
              Text(
                message!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ] else if (content != null) ...[
              content!,
              const SizedBox(height: 24),
            ],
            // Buttons
            Row(
              children: [
                Expanded(
                  child: AppStandardButton(
                    text: cancelText,
                    height: 32,
                    fontSize: 12,
                    customColor: Colors.grey,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppStandardButton(
                    text: confirmText,
                    height: 32,
                    fontSize: 12,
                    customColor: confirmButtonColor,
                    isPrimary: true,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}