import 'package:flutter/material.dart';
import '../../logic/scoring_logic.dart';

class FrameWidget extends StatelessWidget {
  final int frameNumber;
  final Frame frame;
  final VoidCallback onTap;

  const FrameWidget({
    Key? key,
    required this.frameNumber,
    required this.frame,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
            left: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
            bottom: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
            right: frameNumber == 10 ? BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)) : BorderSide.none,
          ),
        ),
        child: Column(
          children: [
            // Frame Number
            Container(
              padding: const EdgeInsets.all(4.0),
              width: double.infinity,
              color: theme.colorScheme.primary.withOpacity(0.1),
              child: Text(
                '$frameNumber',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
              ),
            ),
            // Rolls
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(child: _buildRollCell(context, _getRollDisplay(frame.firstRoll, 1))),
                  Expanded(child: _buildRollCell(context, _getRollDisplay(frame.secondRoll, 2))),
                  if (frame.isTenthFrame) Expanded(child: _buildRollCell(context, _getRollDisplay(frame.thirdRoll, 3))),
                ],
              ),
            ),
            // Score
            Expanded(
              flex: 3,
              child: Container(
                 width: double.infinity,
                color: theme.colorScheme.primary.withOpacity(0.05),
                child: Center(
                  child: Text(
                    frame.score?.toString() ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRollCell(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: theme.colorScheme.primary.withOpacity(0.2)),
          bottom: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
        ),
      ),
      child: Center(child: Text(text, style: TextStyle(fontSize: 18, color: theme.colorScheme.onSurface))),
    );
  }

  String _getRollDisplay(int? roll, int rollPosition) {
    if (roll == null) return '';
    
    // First roll
    if (rollPosition == 1) {
      if (roll == 10) return 'X';
    }

    // Second roll
    if (rollPosition == 2) {
      if (!frame.isTenthFrame && frame.isSpare) return '/';
      if (frame.isTenthFrame && frame.firstRoll != 10 && frame.isSpare) return '/';
      if (roll == 10) return 'X';
    }
    
    // Third roll (only for 10th frame)
    if (rollPosition == 3) {
      if (roll == 10) return 'X';
      // If second roll was a strike, or first+second was a spare, this is a bonus
      bool previousSpare = (frame.firstRoll ?? 0) != 10 && (frame.firstRoll ?? 0) + (frame.secondRoll ?? 0) == 10;
      if( (frame.secondRoll ?? 0) + roll == 10 && !previousSpare) return '/';
    }
    
    return roll.toString();
  }
} 