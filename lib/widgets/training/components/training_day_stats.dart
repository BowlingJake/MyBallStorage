import 'package:bowlingarsenal_app/models/training_record.dart';
import 'package:flutter/material.dart';

/// 訓練日統計資訊組件
class TrainingDayStats extends StatelessWidget {
  const TrainingDayStats({
    required this.summary,
    required this.theme,
    super.key,
  });
  final TrainingDaySummary summary;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 平均分數
        Expanded(
          child: _buildStatItem(
            theme,
            Icons.analytics,
            'AVG',
            summary.averageScore.toStringAsFixed(0),
          ),
        ),
        // 最高分
        Expanded(
          child: _buildStatItem(
            theme,
            Icons.trending_up,
            'HIGH',
            '${summary.highestScore}',
          ),
        ),
        // Strike %
        Expanded(
          child: _buildStatItem(
            theme,
            Icons.gps_fixed,
            'STR',
            '${summary.strikePercentage.toStringAsFixed(0)}%',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
