import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameStatsOverview extends StatelessWidget {
  const GameStatsOverview({
    required this.game,
    super.key,
  });

  final GameRecord game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total Score',
            game.score.toString(),
            theme,
          ),
          _buildStatItem(
            'Strikes',
            game.strikes.toString(),
            theme,
          ),
          _buildStatItem(
            'Spares',
            game.spares.toString(),
            theme,
          ),
          _buildStatItem(
            'Time',
            DateFormat('HH:mm').format(game.timestamp),
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}