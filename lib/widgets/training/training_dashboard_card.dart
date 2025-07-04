import 'package:bowlingarsenal_app/widgets/training/dashboard_stat_item.dart';
import 'package:flutter/material.dart';

class TrainingDashboardCard extends StatelessWidget {
  const TrainingDashboardCard({
    required this.theme,
    required this.strikePercentage,
    required this.sparePercentage,
    required this.averageScore,
    super.key,
  });
  final ThemeData theme;
  final double strikePercentage;
  final double sparePercentage;
  final int averageScore;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
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
                ),
                DashboardStatItem(
                  theme: theme,
                  value: sparePercentage,
                  label: '補中率',
                  unit: '%',
                  progressColor: theme.colorScheme.secondary,
                  isPercentage: true,
                ),
                DashboardStatItem(
                  theme: theme,
                  value: averageScore.toDouble(),
                  label: '平均分',
                  unit: '',
                  progressColor: theme.colorScheme.tertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
