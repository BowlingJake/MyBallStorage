import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/foundation.dart';

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
  final VoidCallback? onReset;
  final VoidCallback onSave;
  final bool canUndo;
  final bool canReset;
  final bool canSave;
  final Color? accentColor;
  final bool isEditMode; // 新增：是否處於修改模式
  final VoidCallback? onToggleEdit; // 新增：切換修改模式的回調

  @override
  Widget build(BuildContext context) {
    debugPrint('[ScoringActionButtons] Building. onToggleEdit is ${onToggleEdit == null ? "null" : "not null"}');
    final theme = Theme.of(context);
    final effectiveAccentColor = accentColor ?? theme.colorScheme.primary;
    
    return Row(
      children: [
        // Fix按鈕（原Undo按鈕）
        Expanded(
          child: AppStandardButton(
            text: isEditMode ? 'Exit Edit' : 'Edit',
            icon: isEditMode ? Icons.exit_to_app : Icons.edit,
            onPressed: onToggleEdit ?? () {},
            customColor: isEditMode ? Colors.green : Colors.orange,
            enabled: onToggleEdit != null,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Save按鈕
        Expanded(
          child: AppStandardButton(
            text: 'Save',
            icon: Icons.save,
            onPressed: onSave,
            customColor: effectiveAccentColor,
            isPrimary: false, // 修改為 false，使用輪廓樣式而非填充樣式
            enabled: canSave,
          ),
        ),
      ],
    );
  }
} 