import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/widgets/training/components/scoring_action_buttons.dart';

/// 計分對話框內容組件
class ScoringDialogContent extends StatelessWidget {
  const ScoringDialogContent({
    required this.frames,
    required this.onFrameTapped,
    required this.onUndo,
    required this.onReset,
    required this.onSave,
    required this.canUndo,
    required this.canReset,
    required this.canSave,
    super.key,
  });

  final List<BowlingFrame> frames;
  final Function(int frameIndex) onFrameTapped;
  final VoidCallback onUndo;
  final VoidCallback onReset;
  final VoidCallback onSave;
  final bool canUndo;
  final bool canReset;
  final bool canSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 計分表格
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: BowlingScoreCardWidget(
              frames: frames,
              accentColor: theme.colorScheme.primary,
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              onFrameTapped: onFrameTapped,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 操作按鈕
          ScoringActionButtons(
            onUndo: onUndo,
            onReset: onReset,
            onSave: onSave,
            canUndo: canUndo,
            canReset: canReset,
            canSave: canSave,
          ),
        ],
      ),
    );
  }
} 