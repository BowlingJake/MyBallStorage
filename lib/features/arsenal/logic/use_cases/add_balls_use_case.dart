import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_bag_service.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';

part 'add_balls_use_case.g.dart';

/// Use case for adding balls to arsenal
@riverpod
class AddBallsUseCase extends _$AddBallsUseCase {
  @override
  void build() {
    // This use case doesn't need to maintain state
  }

  /// Execute the add balls use case
  Future<void> execute({
    required BuildContext context,
    required List<int> ballIds,
  }) async {
    if (ballIds.isEmpty) {
      TopNotification.showError(
        context,
        'No balls selected to add',
      );
      return;
    }

    try {
      final bagService = ref.read(arsenalBagServiceProvider.notifier);
      final result = await bagService.addSelectedBallsToArsenal(ballIds: ballIds);
      
      if (result.isSuccess) {
        // Show success message if any balls were added
        if (result.successCount > 0) {
          TopNotification.showSuccess(
            context,
            result.getSuccessMessage(),
          );
        }
        
        // Show error message for failed additions
        if (result.failCount > 0) {
          TopNotification.showError(
            context,
            result.getErrorMessage(),
          );
        }
      } else {
        // Show general error message
        TopNotification.showError(
          context,
          result.getErrorMessage(),
        );
      }
    } catch (e) {
      TopNotification.showError(
        context,
        'Unexpected error occurred while adding balls: $e',
      );
    }
  }

  /// Validate the request before execution
  bool _validateRequest(List<int> ballIds) {
    if (ballIds.isEmpty) {
      return false;
    }
    
    // Check for duplicate IDs
    final uniqueIds = ballIds.toSet();
    if (uniqueIds.length != ballIds.length) {
      return false;
    }
    
    return true;
  }

  /// Execute with validation
  Future<void> executeWithValidation({
    required BuildContext context,
    required List<int> ballIds,
  }) async {
    if (!_validateRequest(ballIds)) {
      TopNotification.showError(
        context,
        'Invalid ball selection',
      );
      return;
    }
    
    await execute(context: context, ballIds: ballIds);
  }
}