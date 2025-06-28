import 'package:flutter/material.dart';
import '../../../models/training_record.dart';

/// 訓練日統計資訊組件
class TrainingDayStats extends StatelessWidget {
  final TrainingDaySummary summary;
  final ThemeData theme;

  const TrainingDayStats({
    Key? key,
    required this.summary,
    required this.theme,
  }) : super(key: key);

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
            '${summary.averageScore.toStringAsFixed(0)}',
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

  Widget _buildStatItem(ThemeData theme, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        SizedBox(height: 4),
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