import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class DashboardStatItem extends StatelessWidget {
  final ThemeData theme;
  final double value;
  final String label;
  final String unit;
  final Color progressColor;
  final bool isPercentage;
  final bool glow;

  const DashboardStatItem({
    Key? key,
    required this.theme,
    required this.value,
    required this.label,
    required this.unit,
    required this.progressColor,
    this.isPercentage = false,
    this.glow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 68,
          height: 68,
          child: isPercentage
              ? GFProgressBar(
                  percentage: value / 100,
                  radius: 68,
                  type: GFProgressType.circular,
                  circleWidth: 5,
                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.08),
                  progressBarColor: progressColor,
                  child: Text(
                    '${value.toStringAsFixed(0)}$unit',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      fontSize: 18,
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    value.toStringAsFixed(0),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
} 