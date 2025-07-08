import 'package:flutter/material.dart';

/// 計分對話框底部組件
class ScoringDialogFooter extends StatelessWidget {
  const ScoringDialogFooter({
    required this.rollsCount,
    required this.totalScore,
    super.key,
  });

  final int rollsCount;
  final int totalScore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rolls: $rollsCount',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          Text(
            'Score: $totalScore',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 