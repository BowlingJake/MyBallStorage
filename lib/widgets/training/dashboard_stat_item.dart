import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class DashboardStatItem extends StatelessWidget {
  final ThemeData theme;
  final double value;
  final String label;
  final String unit;
  final Color progressColor;
  final bool isPercentage;

  const DashboardStatItem({
    Key? key,
    required this.theme,
    required this.value,
    required this.label,
    required this.unit,
    required this.progressColor,
    this.isPercentage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: isPercentage
              ? GFProgressBar(
                  percentage: value / 100,
                  radius: 80,
                  type: GFProgressType.circular,
                  circleWidth: 8,
                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                  progressBarColor: progressColor,
                  child: Text(
                    '${value.toStringAsFixed(0)}$unit',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                       value.toStringAsFixed(0),
                       style: theme.textTheme.headlineSmall?.copyWith(
                         fontWeight: FontWeight.bold,
                         color: progressColor,
                       ),
                     ),
                  ],
                ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
} 