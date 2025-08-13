import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';

Future<String?> showAddToBagDialog({
  required BuildContext context,
  required bool isMainBag,
  required String currentBagName,
}) async {
  return ArsenalDialog.show<String>(
    context: context,
    title: isMainBag ? 'Add to Arsenal' : 'Add to ' + currentBagName,
    content: _AddToBagContent(
      isMainBag: isMainBag,
      currentBagName: currentBagName,
    ),
    barrierDismissible: false,
    actions: [
      AppStandardButton(
        text: 'Cancel',
        height: DialogDefaults.buttonHeight,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
}

/// Add To Bag Dialog with unified style
class _AddToBagContent extends StatelessWidget {
  const _AddToBagContent({
    required this.isMainBag,
    required this.currentBagName,
  });

  final bool isMainBag;
  final String currentBagName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isMainBag
              ? 'Choose where to add new balls:'
              : 'Choose source to add balls from:',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        if (isMainBag) ...[
          AppStandardButton(
            text: 'Ball Library',
            height: DialogDefaults.buttonHeight,
            fontSize: DialogDefaults.buttonFontSize,
            customColor: BrandColors.accentColorDark,
            isPrimary: true,
            width: double.infinity,
            onPressed: () => Navigator.of(context).pop('library'),
          ),
        ] else ...[
          AppStandardButton(
            text: 'Ball Library',
            height: DialogDefaults.buttonHeight,
            fontSize: DialogDefaults.buttonFontSize,
            outlineColor: Colors.white.withOpacity(0.6),
            foregroundColor: Colors.white.withOpacity(0.9),
            onPressed: () => Navigator.of(context).pop('library'),
            width: double.infinity,
          ),
          const SizedBox(height: DialogDefaults.spacing),
          AppStandardButton(
            text: 'All My Arsenal',
            height: DialogDefaults.buttonHeight,
            fontSize: DialogDefaults.buttonFontSize,
            outlineColor: Colors.white.withOpacity(0.6),
            foregroundColor: Colors.white.withOpacity(0.9),
            onPressed: () => Navigator.of(context).pop('main_bag'),
            width: double.infinity,
          ),
        ],
      ],
    );
  }
}

