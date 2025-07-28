import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:flutter/material.dart';

class ScoreDetailsDisplay extends StatelessWidget {
  const ScoreDetailsDisplay({
    required this.game,
    super.key,
  });

  final GameRecord game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Score Details',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < game.frameScores.length; i++)
                  _buildFrameScore(i, game.frameScores[i]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFrameScore(int frameIndex, int score) {
    return Container(
      width: 60,
      height: 80,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
            child: Center(
              child: Text(
                '${frameIndex + 1}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                score.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}