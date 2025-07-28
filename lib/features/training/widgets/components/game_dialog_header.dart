import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:flutter/material.dart';

class GameDialogHeader extends StatelessWidget {
  const GameDialogHeader({
    required this.game,
    required this.onClose,
    super.key,
  });

  final GameRecord game;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          // 遊戲圖標
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              Icons.sports,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // 標題
          Expanded(
            child: Text(
              'Game ${game.gameNumber} Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 關閉按鈕
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}