import 'package:flutter/material.dart';
import 'dashboard_stat_item.dart';

class TrainingDashboardCard extends StatelessWidget {
  final ThemeData theme;
  final double strikePercentage;
  final double sparePercentage;
  final int averageScore;

  const TrainingDashboardCard({
    Key? key,
    required this.theme,
    required this.strikePercentage,
    required this.sparePercentage,
    required this.averageScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: theme.colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '數據儀表板',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                DashboardStatItem(
                  theme: theme,
                  value: strikePercentage,
                  label: '好球率',
                  unit: '%',
                  progressColor: theme.colorScheme.primary,
                  isPercentage: true,
                  glow: false,
                ),
                DashboardStatItem(
                  theme: theme,
                  value: sparePercentage,
                  label: '補中率',
                  unit: '%',
                  progressColor: theme.colorScheme.secondary,
                  isPercentage: true,
                  glow: false,
                ),
                DashboardStatItem(
                  theme: theme,
                  value: averageScore.toDouble(),
                  label: '平均分',
                  unit: '',
                  progressColor: theme.colorScheme.tertiary,
                  isPercentage: false,
                  glow: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 