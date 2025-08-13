// 檔案路徑： confirmation_dialog.dart

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
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
  // 改為統一走 AppBaseDialog，以集中樣式控制
  final Color confirmColor = isDangerous ? Colors.red : Colors.white;
  return AppBaseDialog.show<bool>(
    context: context,
    title: title,
    barrierDismissible: barrierDismissible,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message != null) ...[
          Text(
            message,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ] else if (content != null) ...[
          content,
        ],
      ],
    ),
    actions: [
      AppStandardButton(
        text: cancelText,
        height: 44,
        outlineColor: Colors.white.withOpacity(0.6),
        foregroundColor: Colors.white.withOpacity(0.9),
        onPressed: () => Navigator.of(context).pop(false),
      ),
      AppStandardButton(
        text: confirmText,
        height: 44,
        outlineColor: confirmColor,
        foregroundColor: isDangerous ? confirmColor : Colors.white.withOpacity(0.9),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ],
  );
}

/// Dialog 的內部實作 Widget (私有)
// 舊的內部 Widget 不再使用，保留 _buildDialogButton 以維持外觀一致