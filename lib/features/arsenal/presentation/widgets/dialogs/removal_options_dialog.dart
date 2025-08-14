import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:flutter/material.dart';

Future<String?> showRemovalOptionsDialog({
  required BuildContext context,
  required int selectedCount,
  required String currentBagName,
}) async {
  return AppBaseDialog.show<String>(
    context: context,
    title: 'Remove $selectedCount Ball${selectedCount != 1 ? 's' : ''}',
    borderColor: Colors.red.withOpacity(0.7),
    barrierDismissible: false,
    content: _RemovalOptionsContent(
      selectedCount: selectedCount,
      currentBagName: currentBagName,
    ),
    actions: [
      AppStandardButton(
        text: 'Cancel',
        height: DialogDefaults.buttonHeight,
        fontSize: DialogDefaults.buttonFontSize,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
}

/// Removal Options Dialog content with unified style
class _RemovalOptionsContent extends StatelessWidget {
  const _RemovalOptionsContent({
    required this.selectedCount,
    required this.currentBagName,
  });

  final int selectedCount;
  final String currentBagName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Choose removal option:',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // 使用 Column 替代 Row，符合手機優先設計
        AppStandardButton(
          text: 'Remove from $currentBagName Only',
          height: DialogDefaults.buttonHeight,
          fontSize: DialogDefaults.buttonFontSize,
          customColor: Colors.grey,
          width: double.infinity,
          onPressed: () => Navigator.of(context).pop('bag_only'),
        ),
        const SizedBox(height: DialogDefaults.spacing),
        AppStandardButton(
          text: 'Remove from All Arsenal',
          height: DialogDefaults.buttonHeight,
          fontSize: DialogDefaults.buttonFontSize,
          customColor: Colors.red,
          isPrimary: true,
          width: double.infinity,
          onPressed: () => Navigator.of(context).pop('complete'),
        ),
        const SizedBox(height: 8),
        Text(
          'This action will permanently remove the ball${selectedCount != 1 ? 's' : ''} from your arsenal.',
          style: TextStyle(
            color: Colors.red.withOpacity(0.7),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// tiles 改為並排按鈕，已移除

