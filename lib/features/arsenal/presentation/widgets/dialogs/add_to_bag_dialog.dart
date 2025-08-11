import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/outlined_content_dialog.dart';
import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';

Future<String?> showAddToBagDialog({
  required BuildContext context,
  required bool isMainBag,
  required String currentBagName,
}) async {
  return showOutlinedContentDialog<String>(
    context: context,
    title: isMainBag ? 'Add to Arsenal' : 'Add to $currentBagName',
    maxWidth: 420,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isMainBag
              ? 'Choose where to add new balls:'
              : 'Choose source to add balls from:',
          style: TextStyle(color: Colors.grey[300], fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        if (isMainBag) ...[
          AppStandardButton(
            text: 'Ball Library',
            onPressed: () => Navigator.of(context).pop('library'),
            outlineColor: Colors.white,
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            isPrimary: false,
            width: double.infinity,
            fontSize: 12,
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: AppStandardButton(
                  text: 'Ball Library',
                  onPressed: () => Navigator.of(context).pop('library'),
                  outlineColor: Colors.white,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  isPrimary: false,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppStandardButton(
                  text: 'All My Arsenal',
                  onPressed: () => Navigator.of(context).pop('main_bag'),
                  outlineColor: Colors.white,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  isPrimary: false,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

