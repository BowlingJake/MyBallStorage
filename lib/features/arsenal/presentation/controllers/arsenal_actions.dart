import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_sort_service.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/library_selection_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/add_to_bag_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/move_target_bag_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/removal_options_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/instance_details_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/bottom_sheet/arsenal_more_bottom_sheet.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/sort_options_sheet.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/unlock_bag_dialog.dart' as unlock_dialog;
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/bag_management_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/filters/filter_popout.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/all_my_arsenal_selection_dialog.dart';

class ArsenalActions {
  const ArsenalActions._();

  static Future<void> showAddToCurrentBag({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final isMainBag = currentBagNumber == 1;

    // 在主球袋直接開啟 Library 選擇對話框
    if (isMainBag) {
      await _showLibrarySelectionForCurrentBag(context: context, ref: ref);
      return;
    }

    final userProfileState = ref.read(userProfileControllerProvider);
    String currentBagName = 'All My Arsenal';
    if (userProfileState.profile != null && !isMainBag) {
      currentBagName = userProfileState.profile!.getBagName(currentBagNumber) ?? 'Bag $currentBagNumber';
    }

    final result = await showAddToBagDialog(
      context: context,
      isMainBag: isMainBag,
      currentBagName: currentBagName,
    );

    if (result == null) return;
    switch (result) {
      case 'library':
        await _showLibrarySelectionForCurrentBag(context: context, ref: ref);
        break;
      case 'main_bag':
        await _showMainBagSelectionForCurrentBag(context: context, ref: ref);
        break;
    }
  }

  static Future<void> confirmRemoveSelected({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final selectedCount = arsenalState.selectedForRemoval.length;
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final isMainBag = currentBagNumber == 1;

    if (isMainBag) {
      final result = await showAppConfirmationDialog(
        context: context,
        title: 'Remove Selected Balls',
        message: 'Are you sure you want to completely remove $selectedCount ball${selectedCount != 1 ? 's' : ''} from your arsenal?',
        confirmText: 'Remove',
        isDangerous: true,
      );
      if (result == true) {
        await _performCompleteRemoval(context: context, ref: ref, selectedCount: selectedCount);
      }
      return;
    }

    final userProfileState = ref.read(userProfileControllerProvider);
    String currentBagName = 'Bag $currentBagNumber';
    if (userProfileState.profile != null) {
      currentBagName = userProfileState.profile!.getBagName(currentBagNumber) ?? 'Bag $currentBagNumber';
    }
    final result = await showRemovalOptionsDialog(
      context: context,
      selectedCount: selectedCount,
      currentBagName: currentBagName,
    );
    if (result == 'bag_only') {
      final confirmed = await showAppConfirmationDialog(
        context: context,
        title: 'Confirm Remove from $currentBagName',
        message: 'Remove $selectedCount ball${selectedCount != 1 ? 's' : ''} from $currentBagName only? They will remain in All My Arsenal.',
        confirmText: 'Remove',
        isDangerous: true,
      );
      if (confirmed == true) {
        await _performBagOnlyRemoval(
          context: context,
          ref: ref,
          selectedCount: selectedCount,
          bagNumber: currentBagNumber,
        );
      }
    } else if (result == 'complete') {
      final confirmed = await showAppConfirmationDialog(
        context: context,
        title: 'Confirm Complete Removal',
        message: 'Completely remove $selectedCount ball${selectedCount != 1 ? 's' : ''} from all bags and your arsenal?',
        confirmText: 'Remove',
        isDangerous: true,
      );
      if (confirmed == true) {
        await _performCompleteRemoval(
          context: context,
          ref: ref,
          selectedCount: selectedCount,
        );
      }
    }
  }

  static Future<void> showMoveSelected({
    required BuildContext context,
    required WidgetRef ref,
    required List<Color> bagColors,
  }) async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final selectedCount = arsenalState.selectedForMove.length;
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;

    final userProfileState = ref.read(userProfileControllerProvider);
    if (userProfileState.profile == null) {
      TopNotification.showError(context, 'Failed to load user profile');
      return;
    }
    final profile = userProfileState.profile!;
    // 只在子球袋間移動：排除主球袋，且排除目前所在子球袋
    final subBags = profile.unlockedBags.where((bag) => bag.number != 1).toList();
    if (subBags.where((b) => b.number != currentBagNumber).isEmpty) {
      TopNotification.showError(context, 'No other bags available for moving balls');
      return;
    }

    // 決定每顆選中球已在哪些袋（為避免多顆不同狀態，這裡取 OR 後的集合，UI 顯示「也在」資訊，並禁用已在之袋）
    final selectedInstances = arsenalState.allInstances
        .where((inst) => arsenalState.selectedForMove.contains(inst.id))
        .toList();
    final alreadyInBags = <int>{};
    for (final inst in selectedInstances) {
      alreadyInBags.addAll(inst.activeBagNumbers);
    }

    final targetBagNumber = await showMoveTargetBagDialog(
      context: context,
      subBags: subBags,
      bagColors: bagColors,
      currentBagNumber: currentBagNumber,
      selectedCount: selectedCount,
      alreadyInBags: alreadyInBags.toList(),
      userProfile: profile,
    );
    if (targetBagNumber == null) return;

    String targetBagName = 'Bag $targetBagNumber';
    targetBagName = profile.getBagName(targetBagNumber) ?? targetBagName;

    final confirmed = await showAppConfirmationDialog(
      context: context,
      title: 'Confirm Move',
      message: 'Move $selectedCount ball${selectedCount != 1 ? 's' : ''} to $targetBagName?',
      confirmText: 'Move',
    );
    if (confirmed != true) return;

    try {
      final authState = ref.read(authControllerProvider);
      if (authState.hasValue && authState.value != null) {
        final userId = authState.value!.id;
        await ref.read(newArsenalControllerProvider.notifier).moveSelectedInstancesToBag(targetBagNumber, userId);
        TopNotification.showSuccess(context, 'Successfully moved $selectedCount ball${selectedCount != 1 ? 's' : ''} to $targetBagName');
      }
    } catch (e) {
      TopNotification.showError(context, 'Failed to move balls: $e');
    }
  }

  static void openMoreOptionsSheet({
    required BuildContext context,
    required WidgetRef ref,
    required int activeFilterCount,
    required SortOption sortOption,
    required bool canMove,
  }) {
    final notifier = ref.read(newArsenalControllerProvider.notifier);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ArsenalMoreBottomSheet(
        canMove: canMove,
        onFilter: () {
          Navigator.of(context).pop();
          // 直接在這裡呼叫過濾彈窗
          final arsenalState = ref.read(newArsenalControllerProvider);
          showFilterPopout(
            context,
            initialFilters: arsenalState.filters,
            onFiltersChanged: (newFilters) {
              notifier.updateFilters(newFilters);
            },
          );
        },
        onSort: () {
          Navigator.of(context).pop();
          showSortOptionsSheet(
            context: context,
            selected: sortOption,
            onSelect: (opt) => notifier.setSortOption(opt),
          );
        },
        onOpenBagManagement: () {
          Navigator.of(context).pop();
          showBagManagementDialog(context);
        },
        onClearAll: activeFilterCount > 0 || sortOption != SortOption.nameAZ
            ? () {
                Navigator.of(context).pop();
                notifier.clearFilters();
                notifier.setSortOption(SortOption.nameAZ);
              }
            : null,
        activeFilterCount: activeFilterCount,
        sortLabel: sortOption != SortOption.nameAZ ? sortOption.displayName : null,
      ),
    );
  }

  static Future<void> showInstanceDetails({
    required BuildContext context,
    required WidgetRef ref,
    required UserArsenalInstance instance,
  }) async {
    await showInstanceDetailsDialog(
      context: context,
      instance: instance,
      onRemove: () => _confirmRemoveInstance(context: context, ref: ref, instance: instance),
    );
  }

  static void navigateToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        return;
      case 1:
        context.go('/library');
        return;
      case 2:
        context.go('/my-arsenal');
        return;
      case 3:
        context.go('/training');
        return;
      case 4:
        context.go('/tournament');
        return;
    }
  }

  static Future<bool> unlockBag({
    required BuildContext context,
    required WidgetRef ref,
    required int bagIndex,
    required Color accentColor,
  }) async {
    final bagName = await unlock_dialog.showUnlockBagDialog(
      context: context,
      bagIndex: bagIndex,
      accentColor: accentColor,
    );
    if (bagName == null || bagName.isEmpty) return false;
    try {
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        throw Exception('User not authenticated');
      }
      final userId = authState.value!.id;
      await ref.read(userProfileControllerProvider.notifier).unlockBag(
            userId: userId,
            bagNumber: bagIndex + 1,
            bagName: bagName,
          );
      TopNotification.showSuccess(context, 'Bag ${bagIndex + 1} unlocked successfully!');
      return true;
    } catch (e) {
      TopNotification.showError(context, 'Failed to unlock bag: $e');
      return false;
    }
  }

  // ---------- internals ----------

  static Future<void> _showLibrarySelectionForCurrentBag({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final selectedBallIds = await showLibrarySelectionDialog(context);
    if (selectedBallIds != null && selectedBallIds.isNotEmpty) {
      await _addSelectedBallsToSpecificBag(context: context, ref: ref, ballIds: selectedBallIds, targetBagNumber: currentBagNumber);
    }
  }

  static Future<void> _showMainBagSelectionForCurrentBag({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final selectedInstanceIds = await showAllMyArsenalSelectionDialog(context);
    if (selectedInstanceIds == null || selectedInstanceIds.isEmpty) return;
    // 直接以 instanceId 更新 bag 指派，避免複製新增
    final authState = ref.read(authControllerProvider);
    if (!authState.hasValue || authState.value == null) {
      TopNotification.showError(context, 'Please log in to add balls to bag');
      return;
    }
    final userId = authState.value!.id;
    await ref.read(newArsenalControllerProvider.notifier).addExistingInstancesToBag(
      instanceIds: selectedInstanceIds,
      bagNumber: currentBagNumber,
      userId: userId,
    );
    final userProfileState = ref.read(userProfileControllerProvider);
    String bagName = 'All My Arsenal';
    if (userProfileState.profile != null && currentBagNumber != 1) {
      bagName = userProfileState.profile!.getBagName(currentBagNumber) ?? 'Bag $currentBagNumber';
    }
    TopNotification.showSuccess(context, 'Added ${selectedInstanceIds.length} ball${selectedInstanceIds.length != 1 ? 's' : ''} to $bagName');
  }

  static Future<void> _addSelectedBallsToSpecificBag({
    required BuildContext context,
    required WidgetRef ref,
    required List<int> ballIds,
    required int targetBagNumber,
  }) async {
    try {
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        TopNotification.showError(context, 'Please log in to add balls to arsenal');
        return;
      }
      final userId = authState.value!.id;

      final arsenalState = ref.read(newArsenalControllerProvider);
      String categoryName = 'My Balls';
      if (arsenalState.userCategories.isNotEmpty) {
        categoryName = arsenalState.userCategories.first;
      }

      final bagNumbers = targetBagNumber == 1 ? [1] : [1, targetBagNumber];
      int successCount = 0;
      int failCount = 0;
      for (final ballId in ballIds) {
        try {
          await ref.read(newArsenalControllerProvider.notifier).addBallFromLibraryToMultipleBags(
                userId: userId,
                ballId: ballId,
                categoryName: categoryName,
                bagNumbers: bagNumbers,
              );
          successCount++;
        } catch (e) {
          failCount++;
        }
      }

      if (successCount > 0) {
        final userProfileState = ref.read(userProfileControllerProvider);
        String bagName = 'All My Arsenal';
        if (userProfileState.profile != null && targetBagNumber != 1) {
          bagName = userProfileState.profile!.getBagName(targetBagNumber) ?? 'Bag $targetBagNumber';
        }
        TopNotification.showSuccess(context, 'Successfully added $successCount ball${successCount != 1 ? 's' : ''} to $bagName!');
      }
      if (failCount > 0) {
        TopNotification.showError(context, 'Failed to add $failCount ball${failCount != 1 ? 's' : ''}. Some balls may already be in your arsenal.');
      }
    } catch (e) {
      TopNotification.showError(context, 'Failed to add balls to bag: $e');
    }
  }

  static Future<void> _performBagOnlyRemoval({
    required BuildContext context,
    required WidgetRef ref,
    required int selectedCount,
    required int bagNumber,
  }) async {
    try {
      final authState = ref.read(authControllerProvider);
      if (authState.hasValue && authState.value != null) {
        final userId = authState.value!.id;
        await ref.read(newArsenalControllerProvider.notifier).removeSelectedInstancesFromBag(bagNumber, userId);
        final userProfileState = ref.read(userProfileControllerProvider);
        String bagName = 'Bag $bagNumber';
        if (userProfileState.profile != null) {
          bagName = userProfileState.profile!.getBagName(bagNumber) ?? 'Bag $bagNumber';
        }
        TopNotification.showSuccess(context, 'Successfully removed $selectedCount ball${selectedCount != 1 ? 's' : ''} from $bagName');
      }
    } catch (e) {
      TopNotification.showError(context, 'Failed to remove balls from bag: $e');
    }
  }

  static Future<void> _performCompleteRemoval({
    required BuildContext context,
    required WidgetRef ref,
    required int selectedCount,
  }) async {
    try {
      final authState = ref.read(authControllerProvider);
      if (authState.hasValue && authState.value != null) {
        final userId = authState.value!.id;
        await ref.read(newArsenalControllerProvider.notifier).removeSelectedInstances(userId);
        TopNotification.showSuccess(context, 'Successfully removed $selectedCount ball${selectedCount != 1 ? 's' : ''} from arsenal');
      }
    } catch (e) {
      TopNotification.showError(context, 'Failed to remove balls: $e');
    }
  }

  static Future<void> _confirmRemoveInstance({
    required BuildContext context,
    required WidgetRef ref,
    required UserArsenalInstance instance,
  }) async {
    final confirmed = await showAppConfirmationDialog(
      context: context,
      title: 'Remove Ball',
      message: 'Are you sure you want to remove "${instance.bowlingBall?.name ?? 'this ball'}" from your arsenal?',
      confirmText: 'Remove',
      isDangerous: true,
    );
    if (confirmed == true) {
      try {
        final authState = ref.read(authControllerProvider);
        if (authState.hasValue && authState.value != null) {
          final userId = authState.value!.id;
          await ref.read(newArsenalControllerProvider.notifier).removeInstance(instance.id, userId);
          TopNotification.showSuccess(context, 'Ball removed successfully');
        }
      } catch (e) {
        TopNotification.showError(context, 'Failed to remove ball: $e');
      }
    }
  }
}

