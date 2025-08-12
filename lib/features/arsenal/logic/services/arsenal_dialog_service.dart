import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_actions.dart';

part 'arsenal_dialog_service.g.dart';

/// Service for handling dialog operations
@riverpod
class ArsenalDialogService extends _$ArsenalDialogService {
  @override
  void build() {
    // This service doesn't need to maintain state
  }

  /// Show more options bottom sheet
  void showMoreOptionsBottomSheet({
    required BuildContext context,
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
  void showAddToCurrentBag({
    required BuildContext context,
  }) {
    ArsenalActions.showAddToCurrentBag(
      context: context,
      ref: ref,
    );
  }

  /// Show move selected dialog
  void showMoveSelected({
    required BuildContext context,
    required List<Color> bagColors,
  }) {
    ArsenalActions.showMoveSelected(
      context: context,
      ref: ref,
      bagColors: bagColors,
    );
  }

  /// Show remove confirmation dialog
  void confirmRemoveSelected({
    required BuildContext context,
  }) {
    ArsenalActions.confirmRemoveSelected(
      context: context,
      ref: ref,
    );
  }

  /// Show unlock bag dialog
  Future<bool> showUnlockBagDialog({
    required BuildContext context,
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
  Future<void> showLibrarySelection({
    required BuildContext context,
  }) async {
    // This would open the library selection dialog
    // Implementation depends on existing library selection logic
    ref.read(newArsenalControllerProvider.notifier);
    // TODO: Implement library selection dialog opening
  }

  /// Show ball details dialog
  void showBallDetails({
    required BuildContext context,
    required int instanceId,
  }) {
    // Implementation for showing ball instance details
    // TODO: Implement ball details dialog
  }

  /// Show confirmation dialog with custom message
  Future<bool> showConfirmationDialog({
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    ) ?? false;
  }

  /// Show error dialog
  void showErrorDialog({
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show success dialog
  void showSuccessDialog({
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}