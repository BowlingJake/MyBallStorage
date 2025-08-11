import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/outlined_content_dialog.dart';
import 'package:flutter/material.dart';

Future<String?> showRemovalOptionsDialog({
  required BuildContext context,
  required int selectedCount,
  required String currentBagName,
}) async {
  return showOutlinedContentDialog<String>(
    context: context,
    title: 'Remove $selectedCount Ball${selectedCount != 1 ? 's' : ''}',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Choose removal option:',
          style: TextStyle(color: Colors.grey[300], fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppStandardButton(
                text: 'Remove from $currentBagName',
                onPressed: () => Navigator.of(context).pop('bag_only'),
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
                text: 'Remove from All Arsenal',
                onPressed: () => Navigator.of(context).pop('complete'),
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
    ),
  );
}

// tiles 改為並排按鈕，已移除

