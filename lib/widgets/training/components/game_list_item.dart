import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/training_record.dart';

/// 單局遊戲列表項目組件
class GameListItem extends StatelessWidget {
  final GameRecord game;
  final ThemeData theme;
  final Function(GameRecord)? onGameTap;
  final Function(GameRecord)? onGameDelete;

  const GameListItem({
    Key? key,
    required this.game,
    required this.theme,
    this.onGameTap,
    this.onGameDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
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
          SizedBox(width: 12),

          // 分數和統計
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${game.score}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'S: ${game.strikes}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'SP: ${game.spares}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                if (game.notes?.isNotEmpty == true)
                  Text(
                    game.notes!,
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

          // 時間和操作
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('HH:mm').format(game.timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 查看詳情
                  GestureDetector(
                    onTap: () => onGameTap?.call(game),
                    child: Icon(
                      Icons.visibility_outlined,
                      size: 16,
                      color: theme.colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(width: 8),
                  // 刪除
                  GestureDetector(
                    onTap: () => onGameDelete?.call(game),
                    child: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.red.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
} 