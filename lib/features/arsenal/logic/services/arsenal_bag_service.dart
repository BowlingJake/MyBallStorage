import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_sort_service.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';

part 'arsenal_bag_service.g.dart';

/// Service for handling ball bag operations
@riverpod
class ArsenalBagService extends _$ArsenalBagService {
  @override
  void build() {
    // This service doesn't need to maintain state
  }

  /// Add selected balls from library to arsenal
  Future<AddBallsResult> addSelectedBallsToArsenal({
    required List<int> ballIds,
  }) async {
    try {
      // Get user ID
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        return AddBallsResult.failure('Please log in to add balls to arsenal');
      }
      final userId = authState.value!.id;

      // Get current arsenal state to determine category
      final arsenalState = ref.read(newArsenalControllerProvider);
      
      // Use "My Balls" as default category, or first existing category
      String categoryName = 'My Balls';
      if (arsenalState.userCategories.isNotEmpty) {
        categoryName = arsenalState.userCategories.first;
      }

      // Add each selected ball to arsenal
      int successCount = 0;
      int failCount = 0;
      
      for (final ballId in ballIds) {
        try {
          await ref.read(newArsenalControllerProvider.notifier).addBallFromLibrary(
            userId: userId,
            ballId: ballId,
            categoryName: categoryName,
          );
          successCount++;
        } catch (e) {
          print('Failed to add ball ID: $ballId, Error: $e');
          failCount++;
        }
      }

      return AddBallsResult.success(
        successCount: successCount,
        failCount: failCount,
      );
      
    } catch (e) {
      return AddBallsResult.failure('Failed to add balls to arsenal: $e');
    }
  }

  /// Get display text for currently selected bag
  String getSelectedBagDisplayText(NewArsenalState arsenalState) {
    final userProfileState = ref.read(userProfileControllerProvider);
    final selectedBag = arsenalState.selectedBagNumber;
    
    if (selectedBag == 1) {
      return 'Viewing: All My Arsenal';
    } else if (userProfileState.profile != null) {
      final bagName = userProfileState.profile!.displayNameForBag(selectedBag);
      return 'Viewing: $bagName';
    }
    
    return 'Viewing: Bag $selectedBag';
  }

  /// Check if there are active filters
  bool hasActiveFilters(NewArsenalState arsenalState) {
    return arsenalState.filters.activeFilterCount > 0 || 
           arsenalState.sortOption != SortOption.nameAZ;
  }

  /// Check if current bag has data
  bool bagHasData(NewArsenalState arsenalState) {
    final currentBagNumber = arsenalState.selectedBagNumber;
    final isMainBag = currentBagNumber == 1;
    
    return arsenalState.allInstances.any((instance) => 
        isMainBag ? true : instance.isInBag(currentBagNumber));
  }

  /// Check if current bag allows move operations
  bool canMoveFromBag(NewArsenalState arsenalState) {
    return arsenalState.selectedBagNumber != 1;
  }
}

/// Result class for add balls operation
class AddBallsResult {
  final bool isSuccess;
  final String? errorMessage;
  final int successCount;
  final int failCount;

  const AddBallsResult._({
    required this.isSuccess,
    this.errorMessage,
    this.successCount = 0,
    this.failCount = 0,
  });

  factory AddBallsResult.success({
    required int successCount,
    required int failCount,
  }) {
    return AddBallsResult._(
      isSuccess: true,
      successCount: successCount,
      failCount: failCount,
    );
  }

  factory AddBallsResult.failure(String errorMessage) {
    return AddBallsResult._(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }

  String getSuccessMessage() {
    if (successCount > 0) {
      return 'Successfully added $successCount ball${successCount != 1 ? 's' : ''} to arsenal!';
    }
    return '';
  }

  String getErrorMessage() {
    if (failCount > 0) {
      return 'Failed to add $failCount ball${failCount != 1 ? 's' : ''}. Some balls may already be in your arsenal.';
    }
    return errorMessage ?? 'Unknown error occurred';
  }
}