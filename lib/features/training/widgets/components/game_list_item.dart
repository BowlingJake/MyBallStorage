import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:flutter/material.dart';

/// 單局遊戲列表項目組件
class GameListItem extends StatelessWidget {
  const GameListItem({
    required this.game,
    required this.theme,
    super.key,
    this.onGameTap,
    this.onGameDelete,
  });
  final GameRecord game;
  final ThemeData theme;
  final Function(GameRecord)? onGameTap;
  final Function(GameRecord)? onGameDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onGameTap?.call(game),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
        ),
        child: Row(
        children: [
          // 局數
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${game.gameNumber}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 分數和球具記錄
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 只顯示分數
                Text(
                  '${game.score}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // 顯示使用的球具
                if (game.ballUsed != null)
                  Text(
                    game.ballUsed!.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          
          // 刪除按鈕
          if (onGameDelete != null)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error.withOpacity(0.7),
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 18,
              tooltip: '刪除此遊戲',
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
    ),
    );
  }
  
  // 刪除確認對話框
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認刪除'),
        content: Text('您確定要刪除第 ${game.gameNumber} 局遊戲嗎？\n分數：${game.score}'),
        actions: [
          TextButton(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text(
              '刪除',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onGameDelete?.call(game);
            },
          ),
        ],
      ),
    );
  }
}
