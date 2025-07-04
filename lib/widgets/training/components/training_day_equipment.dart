import 'package:bowlingarsenal_app/models/training_record.dart';
import 'package:flutter/material.dart';

/// 訓練日球具使用情況組件
class TrainingDayEquipment extends StatelessWidget {

  const TrainingDayEquipment({
    required this.summary, required this.theme, super.key,
  });
  final TrainingDaySummary summary;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final equipmentUsage = summary.equipmentUsage;
    
    if (equipmentUsage.isEmpty) {
      return Row(
        children: [
          Icon(
            Icons.sports_baseball_outlined,
            size: 16,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Text(
            'No equipment recorded',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: equipmentUsage.entries.map((entry) {
        final ball = entry.key;
        final games = entry.value;
        games.sort(); // 排序局數
        
        // 解析品牌顏色
        Color brandColor;
        try {
          brandColor = Color(int.parse(ball.brandColor.replaceFirst('#', '0xFF')));
        } catch (e) {
          brandColor = theme.colorScheme.primary;
        }
        
        return _buildEquipmentItem(
          ball: ball,
          games: games,
          brandColor: brandColor,
          theme: theme,
        );
      }).toList(),
    );
  }

  Widget _buildEquipmentItem({
    required BallInfo ball,
    required List<int> games,
    required Color brandColor,
    required ThemeData theme,
  }) {
    // 格式化局數顯示
    String gamesText;
    if (games.length == 1) {
      gamesText = '(game ${games.first})';
    } else if (games.length <= 3) {
      gamesText = '(games ${games.join(', ')})';
    } else {
      gamesText = '(games ${games.take(2).join(', ')} +${games.length - 2})';
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: ball.name,
            style: theme.textTheme.bodySmall?.copyWith(
              color: brandColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          TextSpan(
            text: ' $gamesText',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
} 