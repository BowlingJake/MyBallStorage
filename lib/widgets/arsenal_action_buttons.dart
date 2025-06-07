import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

/// Two action buttons shown on the MyArsenalPage.
class ArsenalActionButtons extends StatelessWidget {
  final VoidCallback? onAddPressed;
  final VoidCallback? onAnalyzePressed;

  const ArsenalActionButtons({
    super.key,
    this.onAddPressed,
    this.onAnalyzePressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: GFButton(
            onPressed: onAddPressed,
            text: 'Add from Library',
            shape: GFButtonShape.standard,
            size: GFSize.MEDIUM,
            color: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            borderShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GFButton(
            onPressed: onAnalyzePressed,
            text: 'Analyze Chart',
            type: GFButtonType.outline,
            shape: GFButtonShape.standard,
            size: GFSize.MEDIUM,
            color: colorScheme.primary,
            textColor: colorScheme.primary,
            borderShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
