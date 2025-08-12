import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_tabs_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_actions.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';

class ArsenalBagHandler {
  static Future<void> showUnlockBagDialog({
    required BuildContext context,
    required WidgetRef ref,
    required int bagIndex,
    required List<Color> bagColors,
    required TickerProvider vsync,
    required Function(TabController?) onTabControllerUpdate,
  }) async {
    final ok = await ArsenalActions.unlockBag(
      context: context,
      ref: ref,
      bagIndex: bagIndex,
      accentColor: bagColors[bagIndex],
    );
    
    if (ok) {
      // Recreate tab controller after unlocking bag
      final userProfileState = ref.read(userProfileControllerProvider);
      final newTabController = ArsenalTabsController.createTabController(
        vsync: vsync,
        userProfileState: userProfileState,
        onBagSelected: (bag) => ref.read(newArsenalControllerProvider.notifier).selectBag(bag),
      );
      onTabControllerUpdate(newTabController);
    }
  }

  static Future<void> addSelectedBallsToArsenal({
    required BuildContext context,
    required WidgetRef ref,
    required List<int> ballIds,
  }) async {
    try {
      // Get user ID
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        TopNotification.showError(
          context,
          'Please log in to add balls to arsenal',
        );
        return;
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

      // Show success/error notification
      if (successCount > 0) {
        TopNotification.showSuccess(
          context,
          'Successfully added $successCount ball${successCount != 1 ? 's' : ''} to arsenal!',
        );
      }
      
      if (failCount > 0) {
        TopNotification.showError(
          context,
          'Failed to add $failCount ball${failCount != 1 ? 's' : ''}. Some balls may already be in your arsenal.',
        );
      }
      
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to add balls to arsenal: $e',
      );
    }
  }

  static String getSelectedBagDisplayText(WidgetRef ref, NewArsenalState arsenalState) {
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

  static bool hasActiveFilters(NewArsenalState arsenalState) {
    return arsenalState.filters.activeFilterCount > 0 || 
           arsenalState.sortOption != SortOption.nameAZ;
  }
}