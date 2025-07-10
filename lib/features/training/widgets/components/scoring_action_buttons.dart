import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

/// 計分對話框操作按鈕組件
class ScoringActionButtons extends StatelessWidget {
  const ScoringActionButtons({
    required this.onUndo,
    required this.onReset,
    required this.onSave,
    required this.canUndo,
    required this.canReset,
    required this.canSave,
    super.key,
  });

  final VoidCallback onUndo;
  final VoidCallback onReset;
  final VoidCallback onSave;
  final bool canUndo;
  final bool canReset;
  final bool canSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        // Undo按鈕
        Expanded(
          child: AppStandardButton(
            text: 'Undo',
            icon: Icons.undo,
            onPressed: onUndo,
            customColor: Colors.orange,
            enabled: canUndo,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Reset按鈕
        Expanded(
          child: AppStandardButton(
            text: 'Reset',
            icon: Icons.restart_alt,
            onPressed: onReset,
            customColor: Colors.red,
            enabled: canReset,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Save按鈕
        Expanded(
          child: AppStandardButton(
            text: 'Save Game',
            icon: Icons.save,
            onPressed: onSave,
            customColor: theme.colorScheme.primary,
            isPrimary: canSave,
            enabled: canSave,
          ),
        ),
      ],
    );
  }
} 