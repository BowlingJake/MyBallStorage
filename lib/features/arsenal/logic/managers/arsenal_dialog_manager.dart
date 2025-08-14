import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/mixins/arsenal_error_handling_mixin.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/mixins/arsenal_notification_mixin.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

part 'arsenal_dialog_manager.g.dart';

/// Unified dialog manager for all Arsenal-related dialogs
@riverpod
class ArsenalDialogManager extends _$ArsenalDialogManager 
    with ArsenalErrorHandlingMixin, ArsenalNotificationMixin {
  
  @override
  void build() {
    // This manager doesn't need to maintain state
  }

  // === Confirmation Dialogs ===

  /// Show confirmation dialog for ball removal
  Future<RemovalConfirmation?> showRemovalConfirmationDialog({
    required BuildContext context,
    required int ballCount,
    required bool isFromMainBag,
    required String currentBagName,
  }) async {
    if (isFromMainBag) {
      // Main bag - only complete removal option
      final confirmed = await _showStandardConfirmationDialog(
        context: context,
        title: 'Remove from Arsenal',
        message: 'Are you sure you want to permanently remove $ballCount ball${ballCount != 1 ? 's' : ''} from your arsenal?',
        confirmText: 'Remove',
        confirmColor: Colors.red,
      );
      
      return confirmed 
          ? RemovalConfirmation.complete 
          : null;
    } else {
      // Sub bag - show tiered options
      return await _showTieredRemovalDialog(
        context: context,
        ballCount: ballCount,
        bagName: currentBagName,
      );
    }
  }

  /// Show confirmation dialog for ball move operation
  Future<int?> showMoveConfirmationDialog({
    required BuildContext context,
    required int ballCount,
    required List<BagInfo> availableBags,
    required List<Color> bagColors,
    required int currentBagNumber,
  }) async {
    return await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Move $ballCount Ball${ballCount != 1 ? 's' : ''}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select the target bag for moving $ballCount ball${ballCount != 1 ? 's' : ''}:'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                children: availableBags
                    .where((bag) => bag.number != currentBagNumber && bag.number != 1)
                    .map((bag) => _buildBagOptionTile(context, bag, bagColors))
                    .toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog for bag unlock
  Future<bool> showBagUnlockConfirmationDialog({
    required BuildContext context,
    required int bagNumber,
    required Color bagColor,
    required int unlockCost,
  }) async {
    return await _showStandardConfirmationDialog(
      context: context,
      title: 'Unlock Bag $bagNumber',
      message: 'Do you want to unlock Bag $bagNumber for $unlockCost coins?',
      confirmText: 'Unlock',
      confirmColor: bagColor,
    );
  }

  // === Information Dialogs ===

  /// Show ball details dialog
  Future<void> showBallDetailsDialog({
    required BuildContext context,
    required UserArsenalInstance ballInstance,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ballInstance.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Brand', ballInstance.brandName),
            _buildDetailRow('Added Date', _formatDate(ballInstance.addedDate)),
            _buildDetailRow('Games Used', '${ballInstance.gamesUsed}'),
            const SizedBox(height: 16),
            Text(
              'Active in Bags: ${ballInstance.activeBagNumbers.join(', ')}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog with detailed information
  Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? details,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (details != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Details:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                details,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
        actions: [
          AppStandardButton(
            text: 'OK',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Show success dialog with celebration
  Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    Widget? customIcon,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            customIcon ?? const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          AppStandardButton(
            text: 'Great!',
            onPressed: () => Navigator.of(context).pop(),
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  // === Helper Methods ===

  /// Show standard confirmation dialog
  Future<bool> _showStandardConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          AppStandardButton(
            text: confirmText,
            onPressed: () => Navigator.of(context).pop(true),
            customColor: confirmColor,
            isPrimary: true,
          ),
        ],
      ),
    ) ?? false;
  }

  /// Show tiered removal dialog for sub-bags
  Future<RemovalConfirmation?> _showTieredRemovalDialog({
    required BuildContext context,
    required int ballCount,
    required String bagName,
  }) async {
    return await showDialog<RemovalConfirmation>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Remove Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How would you like to remove $ballCount ball${ballCount != 1 ? 's' : ''} from $bagName?',
            ),
            const SizedBox(height: 16),
            _buildRemovalOptionTile(
              context: context,
              title: 'Remove from Bag Only',
              subtitle: 'Keep in arsenal, remove from this bag',
              icon: Icons.remove_circle_outline,
              color: Colors.orange,
              onTap: () => Navigator.of(context).pop(RemovalConfirmation.bagOnly),
            ),
            const SizedBox(height: 8),
            _buildRemovalOptionTile(
              context: context,
              title: 'Remove from Arsenal',
              subtitle: 'Permanently remove from entire arsenal',
              icon: Icons.delete_forever,
              color: Colors.red,
              onTap: () => Navigator.of(context).pop(RemovalConfirmation.complete),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Build bag option tile for move dialog
  Widget _buildBagOptionTile(BuildContext context, BagInfo bag, List<Color> bagColors) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: bagColors[bag.number - 1],
        child: Text(
          '${bag.number}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(bag.name),
      onTap: () => Navigator.of(context).pop(bag.number),
    );
  }

  /// Build removal option tile
  Widget _buildRemovalOptionTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build detail row for ball details
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Enum for removal confirmation types
enum RemovalConfirmation {
  bagOnly,    // Remove from bag only
  complete,   // Remove from entire arsenal
}

extension RemovalConfirmationExtension on RemovalConfirmation {
  String get displayName {
    switch (this) {
      case RemovalConfirmation.bagOnly:
        return 'Remove from Bag';
      case RemovalConfirmation.complete:
        return 'Remove from Arsenal';
    }
  }
  
  String get actionText {
    switch (this) {
      case RemovalConfirmation.bagOnly:
        return 'removed from bag';
      case RemovalConfirmation.complete:
        return 'removed from arsenal';
    }
  }
}