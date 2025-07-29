import 'package:flutter/material.dart';

/// 計分對話框標題組件
class ScoringDialogHeader extends StatelessWidget {
  const ScoringDialogHeader({
    required this.gameNumber,
    required this.onClose,
    this.accentColor,
    super.key,
  });

  final int gameNumber;
  final VoidCallback onClose;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveAccentColor = accentColor ?? theme.colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: effectiveAccentColor.withOpacity(0.3),
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