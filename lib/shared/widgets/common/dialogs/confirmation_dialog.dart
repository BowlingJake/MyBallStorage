// 檔案路徑： confirmation_dialog.dart

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../buttons/app_standard_button.dart'; // 請確認您的按鈕元件路徑

/// 顯示一個功能完善、通用的確認 Dialog (最終修正版)
Future<void> showAppConfirmationDialog({
  required BuildContext context,
  required String confirmText,
  required VoidCallback onConfirm,
  String? title,
  Widget? content,
  String cancelText = 'Cancel',
  VoidCallback? onCancel, // 1. 新增 onCancel 參數，使其可選
  bool isDangerous = false,   // 2. 新增 isDangerous 參數
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      // 如果外部傳入了 onCancel，就使用它；否則預設行為是關閉 Dialog
      final VoidCallback onCancelHandler = onCancel ?? () => Navigator.of(dialogContext).pop();

      // 點擊確認按鈕時，先關閉 Dialog 再執行後續動作
      final VoidCallback onConfirmHandler = () {
        Navigator.of(dialogContext).pop();
        onConfirm();
      };

      return _ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        onConfirm: onConfirmHandler,
        cancelText: cancelText,
        onCancel: onCancelHandler,
        isDangerous: isDangerous,
      );
    },
  );
}

/// Dialog 的內部實作 Widget (私有)
class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({
    this.title,
    this.content,
    required this.confirmText,
    required this.onConfirm,
    required this.cancelText,
    required this.onCancel,
    required this.isDangerous,
  });

  final String? title;
  final Widget? content;
  final String confirmText;
  final VoidCallback onConfirm;
  final String cancelText;
  final VoidCallback onCancel;
  final bool isDangerous;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 如果是危險操作，確認按鈕使用紅色，否則使用主題色
    final Color confirmButtonColor = isDangerous
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return Dialog(
      elevation: 0,
      backgroundColor: theme.cardColor.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: content != null ? 8 : 24),
            ],
            if (content != null) ...[
              content!,
              const SizedBox(height: 24),
            ],
            Row(
              children: [
                Expanded(child: AppStandardButton(text: cancelText, isPrimary: false, onPressed: onCancel)),
                const SizedBox(width: 16),
                Expanded(
                  child: AppStandardButton(
                    text: confirmText,
                    isPrimary: true,
                    onPressed: onConfirm,
                    customColor: confirmButtonColor,
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