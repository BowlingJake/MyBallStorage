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
    this.accentColor,
    this.isEditMode = false, // 新增：是否處於修改模式
    this.onToggleEdit, // 新增：切換修改模式的回調
    super.key,
  });

  final VoidCallback onUndo;
  final VoidCallback onReset;
  final VoidCallback onSave;
  final bool canUndo;
  final bool canReset;
  final bool canSave;
  final Color? accentColor;
  final bool isEditMode; // 新增：是否處於修改模式
  final VoidCallback? onToggleEdit; // 新增：切換修改模式的回調

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveAccentColor = accentColor ?? theme.colorScheme.primary;
    
    return Row(
      children: [
        // Fix按鈕（原Undo按鈕）
        Expanded(
          child: AppStandardButton(
            text: isEditMode ? 'Exit Edit' : 'Fix',
            icon: isEditMode ? Icons.exit_to_app : Icons.edit,
            onPressed: onToggleEdit ?? () {},
            customColor: isEditMode ? Colors.green : Colors.orange,
            enabled: onToggleEdit != null,
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
            customColor: effectiveAccentColor,
            isPrimary: canSave,
            enabled: canSave,
          ),
        ),
      ],
    );
  }
} 