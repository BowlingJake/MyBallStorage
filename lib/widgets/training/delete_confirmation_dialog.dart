import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:ui';

// 刪除確認對話框
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              width: size.width * 0.8,
              constraints: BoxConstraints(
                maxWidth: 350,
                minWidth: 280,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                  ),
                  // 內容
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 標題與關閉按鈕
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 28),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // 說明文字
                        Text(
                          message,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // 按鈕
                        Row(
                          children: [
                            Expanded(
                              child: GFButton(
                                onPressed: () => Navigator.of(context).pop(),
                                text: "Cancel",
                                type: GFButtonType.outline,
                                color: Colors.white,
                                size: GFSize.MEDIUM,
                                shape: GFButtonShape.pills,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: GFButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  onConfirm();
                                },
                                text: "Delete",
                                type: GFButtonType.outline,
                                color: Colors.red,
                                size: GFSize.MEDIUM,
                                shape: GFButtonShape.pills,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 顯示刪除確認對話框的輔助函數
void showDeleteConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: DeleteConfirmationDialog(
          title: title,
          message: message,
          onConfirm: onConfirm,
        ),
      );
    },
  );
} 