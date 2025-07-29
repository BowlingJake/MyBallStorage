import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

// 刪除確認對話框 - 統一樣式設計
class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });
  
  final String title;
  final String message;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: size.width * 0.85,
          constraints: const BoxConstraints(
            maxWidth: 380,
            maxHeight: 300,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x33000000), // 20% 不透明度的純黑色
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(theme),
                    _buildContent(theme),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          // 警告圖標
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
              ),
            ),
            child: const Icon(
              Icons.warning,
              color: Colors.red,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // 標題
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),

          // 關閉按鈕
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                size: 20,
              ),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surface.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Builder(
        builder: (context) => Row(
          children: [
            // 取消按鈕
            Expanded(
              child: AppStandardButton(
                text: 'Cancel',
                icon: Icons.cancel,
                onPressed: () => Navigator.of(context).pop(),
                height: 40,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // 確認刪除按鈕
            Expanded(
              child: AppStandardButton(
                text: 'Delete',
                icon: Icons.delete,
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                customColor: Colors.red,
                isPrimary: false,
                height: 40,
              ),
            ),
          ],
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
