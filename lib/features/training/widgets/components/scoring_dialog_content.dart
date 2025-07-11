import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/scoring_action_buttons.dart';

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
    this.accentColor,
    this.scoringModeName, // 新增：計分模式名稱
    this.isEditMode = false, // 新增：是否處於修改模式
    this.onToggleEdit, // 新增：切換修改模式的回調
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
  final Color? accentColor;
  final String? scoringModeName; // 新增：計分模式名稱
  final bool isEditMode; // 新增：是否處於修改模式
  final VoidCallback? onToggleEdit; // 新增：切換修改模式的回調

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveAccentColor = accentColor ?? theme.colorScheme.primary;
    
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
                color: effectiveAccentColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                // 計分模式名稱顯示
                if (scoringModeName != null)
                  Row(
                    children: [
                      Text(
                        scoringModeName!,
                        style: TextStyle(
                          color: effectiveAccentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // 修改模式指示器
                      if (isEditMode)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: const Text(
                            'Edit Mode',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                if (scoringModeName != null) const SizedBox(height: 8),
                
                // 計分板
                BowlingScoreCardWidget(
                  frames: frames,
                  accentColor: effectiveAccentColor,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  onFrameTapped: onFrameTapped,
                ),
              ],
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
            accentColor: effectiveAccentColor,
            isEditMode: isEditMode,
            onToggleEdit: onToggleEdit,
          ),
        ],
      ),
    );
  }
} 