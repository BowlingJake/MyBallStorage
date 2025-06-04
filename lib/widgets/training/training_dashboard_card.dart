import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
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
    return GFCard(
      boxFit: BoxFit.cover,
      color: theme.colorScheme.surfaceVariant,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      margin: const EdgeInsets.all(8.0),
      titlePosition: GFPosition.start,
      title: GFListTile(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        margin: EdgeInsets.zero,
        title: Text(
          '數據儀表板',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      content: Row(
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
            isPercentage: false,
          ),
        ],
      ),
    );
  }
} 