import 'dart:ui';
import 'package:flutter/material.dart';

// 刪除確認對話框
class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    required this.title,
    required this.message,
    required this.onConfirm,
    super.key,
  });
  final String title;
  final String message;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.red.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConfirm();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
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

// 顯示訓練相關刪除確認對話框的輔助函數
void showTrainingDeleteDialog(
  BuildContext context, {
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return DeleteConfirmationDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
      );
    },
  );
}
