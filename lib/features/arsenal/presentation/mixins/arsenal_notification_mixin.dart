import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';

/// Mixin for standardized notifications in Arsenal feature
mixin ArsenalNotificationMixin {
  /// Show success message for Arsenal operations
  void showArsenalSuccess(
    BuildContext context, 
    String message, {
    Duration? duration,
  }) {
    TopNotification.showSuccess(context, message);
  }

  /// Show error message for Arsenal operations
  void showArsenalError(
    BuildContext context, 
    String message, {
    Duration? duration,
  }) {
    TopNotification.showError(context, message);
  }

  /// Show info message for Arsenal operations
  void showArsenalInfo(
    BuildContext context, 
    String message, {
    Duration? duration,
  }) {
    // If TopNotification has info method, use it, otherwise use a custom implementation
    TopNotification.showSuccess(context, message); // Fallback to success style
  }

  /// Show warning message for Arsenal operations
  void showArsenalWarning(
    BuildContext context, 
    String message, {
    Duration? duration,
  }) {
    TopNotification.showError(context, message); // Use error style for warnings
  }

  // === Ball Operation Notifications ===

  /// Show notification for successful ball addition
  void showBallAddedSuccess(
    BuildContext context, 
    int count, {
    String? ballName,
  }) {
    final ballText = ballName ?? 'ball${count != 1 ? 's' : ''}';
    showArsenalSuccess(
      context,
      'Successfully added $count $ballText to arsenal!',
    );
  }

  /// Show notification for failed ball addition
  void showBallAddedError(
    BuildContext context, 
    int count, {
    String? reason,
  }) {
    final message = reason != null 
        ? 'Failed to add $count ball${count != 1 ? 's' : ''}: $reason'
        : 'Failed to add $count ball${count != 1 ? 's' : ''}';
    showArsenalError(context, message);
  }

  /// Show notification for successful ball removal
  void showBallRemovedSuccess(
    BuildContext context, 
    int count, 
    String removalType,
  ) {
    showArsenalSuccess(
      context,
      'Successfully $removalType $count ball${count != 1 ? 's' : ''}!',
    );
  }

  /// Show notification for failed ball removal
  void showBallRemovedError(
    BuildContext context, 
    int count, {
    String? reason,
  }) {
    final message = reason != null 
        ? 'Failed to remove $count ball${count != 1 ? 's' : ''}: $reason'
        : 'Failed to remove $count ball${count != 1 ? 's' : ''}';
    showArsenalError(context, message);
  }

  /// Show notification for successful ball move
  void showBallMovedSuccess(
    BuildContext context, 
    int count, 
    int targetBag,
  ) {
    showArsenalSuccess(
      context,
      'Successfully moved $count ball${count != 1 ? 's' : ''} to Bag $targetBag!',
    );
  }

  /// Show notification for failed ball move
  void showBallMovedError(
    BuildContext context, 
    int count, {
    String? reason,
  }) {
    final message = reason != null 
        ? 'Failed to move $count ball${count != 1 ? 's' : ''}: $reason'
        : 'Failed to move $count ball${count != 1 ? 's' : ''}';
    showArsenalError(context, message);
  }

  // === Bag Operation Notifications ===

  /// Show notification for successful bag unlock
  void showBagUnlockedSuccess(
    BuildContext context, 
    int bagNumber,
  ) {
    showArsenalSuccess(
      context,
      'Successfully unlocked Bag $bagNumber!',
    );
  }

  /// Show notification for failed bag unlock
  void showBagUnlockedError(
    BuildContext context, 
    int bagNumber, {
    String? reason,
  }) {
    final message = reason != null 
        ? 'Failed to unlock Bag $bagNumber: $reason'
        : 'Failed to unlock Bag $bagNumber';
    showArsenalError(context, message);
  }

  /// Show notification for bag selection change
  void showBagSelected(
    BuildContext context, 
    String bagName,
  ) {
    showArsenalInfo(
      context,
      'Viewing: $bagName',
    );
  }

  // === Selection Mode Notifications ===

  /// Show notification for entering selection mode
  void showSelectionModeEntered(
    BuildContext context, 
    String modeType,
  ) {
    showArsenalInfo(
      context,
      '$modeType mode activated. Select balls to proceed.',
    );
  }

  /// Show notification for exiting selection mode
  void showSelectionModeExited(
    BuildContext context, 
    String modeType,
  ) {
    showArsenalInfo(
      context,
      '$modeType mode deactivated.',
    );
  }

  /// Show notification for selection count update
  void showSelectionCount(
    BuildContext context, 
    int count, 
    String modeType,
  ) {
    if (count == 0) {
      showArsenalInfo(
        context,
        'No balls selected for $modeType',
      );
    } else {
      showArsenalInfo(
        context,
        '$count ball${count != 1 ? 's' : ''} selected for $modeType',
      );
    }
  }

  // === Validation Notifications ===

  /// Show notification for validation errors
  void showValidationError(
    BuildContext context, 
    String field, 
    String message,
  ) {
    showArsenalError(
      context,
      'Validation Error - $field: $message',
    );
  }

  /// Show notification for empty selection
  void showEmptySelectionWarning(
    BuildContext context, 
    String operation,
  ) {
    showArsenalWarning(
      context,
      'No balls selected for $operation',
    );
  }

  /// Show notification for invalid operation
  void showInvalidOperationWarning(
    BuildContext context, 
    String operation, 
    String reason,
  ) {
    showArsenalWarning(
      context,
      'Cannot $operation: $reason',
    );
  }

  // === Loading and Status Notifications ===

  /// Show notification for operation in progress
  void showOperationInProgress(
    BuildContext context, 
    String operation,
  ) {
    showArsenalInfo(
      context,
      '$operation in progress...',
    );
  }

  /// Show notification for operation completed
  void showOperationCompleted(
    BuildContext context, 
    String operation,
  ) {
    showArsenalSuccess(
      context,
      '$operation completed successfully!',
    );
  }

  /// Show notification for operation cancelled
  void showOperationCancelled(
    BuildContext context, 
    String operation,
  ) {
    showArsenalInfo(
      context,
      '$operation cancelled',
    );
  }

  // === Batch Operation Notifications ===

  /// Show comprehensive batch operation results
  void showBatchOperationResult(
    BuildContext context, {
    required String operation,
    required int successCount,
    required int failCount,
    required int totalCount,
  }) {
    if (failCount == 0) {
      // All successful
      showArsenalSuccess(
        context,
        'Successfully $operation $successCount/$totalCount ball${totalCount != 1 ? 's' : ''}!',
      );
    } else if (successCount == 0) {
      // All failed
      showArsenalError(
        context,
        'Failed to $operation all $totalCount ball${totalCount != 1 ? 's' : ''}',
      );
    } else {
      // Partial success
      showArsenalWarning(
        context,
        'Partially completed: $operation $successCount/$totalCount ball${totalCount != 1 ? 's' : ''}. $failCount failed.',
      );
    }
  }
}