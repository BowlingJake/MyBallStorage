import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_actions.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

/// Service for handling dialog operations
class ArsenalDialogService {
  /// Show more options bottom sheet
  static void showMoreOptionsBottomSheet({
    required BuildContext context,
    required WidgetRef ref,
    required NewArsenalState arsenalState,
  }) {
    final canMove = arsenalState.selectedBagNumber != 1;
    ArsenalActions.openMoreOptionsSheet(
      context: context,
      ref: ref,
      activeFilterCount: arsenalState.filters.activeFilterCount,
      sortOption: arsenalState.sortOption,
      canMove: canMove,
    );
  }

  /// Show add to current bag dialog
  static void showAddToCurrentBag({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ArsenalActions.showAddToCurrentBag(
      context: context,
      ref: ref,
    );
  }

  /// Show move selected dialog
  static void showMoveSelected({
    required BuildContext context,
    required WidgetRef ref,
    required List<Color> bagColors,
  }) {
    ArsenalActions.showMoveSelected(
      context: context,
      ref: ref,
      bagColors: bagColors,
    );
  }

  /// Show remove confirmation dialog
  static void confirmRemoveSelected({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ArsenalActions.confirmRemoveSelected(
      context: context,
      ref: ref,
    );
  }

  /// Show unlock bag dialog
  static Future<bool> showUnlockBagDialog({
    required BuildContext context,
    required WidgetRef ref,
    required int bagIndex,
    required Color accentColor,
  }) async {
    return await ArsenalActions.unlockBag(
      context: context,
      ref: ref,
      bagIndex: bagIndex,
      accentColor: accentColor,
    );
  }

  /// Show library selection dialog for adding balls
  static Future<void> showLibrarySelection({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    // This would open the library selection dialog
    // Implementation depends on existing library selection logic
    ref.read(newArsenalControllerProvider.notifier);
    // TODO: Implement library selection dialog opening
  }

  /// Show ball details dialog
  static void showBallDetails({
    required BuildContext context,
    required int instanceId,
  }) {
    // Implementation for showing ball instance details
    // TODO: Implement ball details dialog
  }

  /// Show confirmation dialog with custom message
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          AppStandardButton.secondary(
            text: cancelText,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          AppStandardButton(
            text: confirmText,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ?? false;
  }

  /// Show error dialog
  static void showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          AppStandardButton.secondary(
            text: 'OK',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Show success dialog
  static void showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          AppStandardButton(
            text: 'OK',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}