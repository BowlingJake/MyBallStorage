import 'package:flutter/material.dart';

/// 計分對話框標題組件
class ScoringDialogHeader extends StatelessWidget {
  const ScoringDialogHeader({
    required this.gameNumber,
    required this.onClose,
    super.key,
  });

  final int gameNumber;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          // 標題
          Expanded(
            child: Text(
              'Game $gameNumber',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // 關閉按鈕
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }
} 