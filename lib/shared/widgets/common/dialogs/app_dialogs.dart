// 檔案路徑： app_dialogs.dart

import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteConfirmationDialog(
  BuildContext context, {
  required int itemCount,
  required VoidCallback onConfirm,
}) async {
  // 直接呼叫我們新的輔助函式，而不是 showDialog
  return showAppConfirmationDialog(
    context: context,
    title: 'Confirm Delete',
    content: Text(
      'Are you sure you want to delete ${itemCount > 1 ? 'these $itemCount' : 'this'} training records? This action cannot be undone.',
      textAlign: TextAlign.center,
    ),
    confirmText: 'Delete',
    onConfirm: onConfirm,
    isDangerous: true, // 新版 Dialog 現在支援這個參數了！
  );
}