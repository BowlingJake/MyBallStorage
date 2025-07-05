import 'package:flutter/material.dart';

/// 統一處理非同步操作後的 UI 反饋（如 SnackBar）。
///
/// [context]: 當前的 BuildContext。
/// [future]: 要執行的非同步操作。
/// [successMessage]: 操作成功時顯示的消息。
Future<void> handleApiCall({
  required BuildContext context,
  required Future<void> future,
  required String successMessage,
}) async {
  try {
    await future;
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successMessage),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('操作失敗: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
} 