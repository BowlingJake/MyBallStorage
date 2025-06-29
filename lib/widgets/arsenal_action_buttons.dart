import 'package:flutter/material.dart';
import 'app_standard_button.dart';

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
          child: AppStandardButton(
            text: 'Add from Library',
            onPressed: onAddPressed ?? () {},
            customColor: colorScheme.primary,
            isPrimary: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppStandardButton(
            text: 'Analyze Chart',
            onPressed: onAnalyzePressed ?? () {},
            customColor: colorScheme.primary,
            isPrimary: false,
          ),
        ),
      ],
    );
  }
}
