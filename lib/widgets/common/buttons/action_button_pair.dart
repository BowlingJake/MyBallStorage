import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

/// A reusable widget that displays two action buttons side by side.
/// Can be used across different pages for consistent button styling.
class ActionButtonPair extends StatelessWidget {

  const ActionButtonPair({
    required this.primaryButtonText, required this.secondaryButtonText, super.key,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.spacing = 12,
    this.borderRadius = 20,
  });
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final double spacing;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: GFButton(
            onPressed: onPrimaryPressed,
            text: primaryButtonText,
            color: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            borderShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: GFButton(
            onPressed: onSecondaryPressed,
            text: secondaryButtonText,
            type: GFButtonType.outline,
            color: colorScheme.primary,
            textColor: colorScheme.primary,
            borderShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ],
    );
  }
} 