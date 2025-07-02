import 'package:flutter/material.dart';

/// Placeholder card for a bowling ball in the arsenal grid.
class BallPlaceholderCard extends StatelessWidget {
  const BallPlaceholderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Icon(
            Icons.sports_handball,
            size: 48,
          ),
        ),
      ),
    );
  }
}
