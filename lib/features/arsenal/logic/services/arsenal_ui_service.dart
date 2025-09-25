import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_bag_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_dialog_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_selection_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/use_cases/add_balls_use_case.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/use_cases/move_balls_use_case.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/use_cases/remove_balls_use_case.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_selection_state_provider.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_tabs_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';

part 'arsenal_ui_service.g.dart';

/// Unified Arsenal UI Service that manages all UI-related operations
/// This service integrates functionality from all Handler classes
@riverpod
class ArsenalUIService extends _$ArsenalUIService {
  @override
  void build() {
    // No initial state needed for this service
  }

  // === Bag Management Operations ===

  /// Show dialog to unlock a bag
  Future<void> showUnlockBagDialog({
    required BuildContext context,
    required WidgetRef widgetRef,
    required int bagIndex,
    required List<Color> bagColors,
    required TickerProvider vsync,
    required Function(TabController?) onTabControllerUpdate,
  }) async {
    final ok = await ArsenalDialogService.showUnlockBagDialog(
      context: context,
      ref: widgetRef,
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

  /// Add selected balls to arsenal
  Future<void> addSelectedBallsToArsenal({
    required BuildContext context,
    required List<int> ballIds,
  }) async {
    final addBallsUseCase = ref.read(addBallsUseCaseProvider.notifier);
    await addBallsUseCase.executeWithValidation(
      context: context,
      ballIds: ballIds,
    );
  }

  /// Get display text for selected bag
  String getSelectedBagDisplayText(NewArsenalState arsenalState) {
    final bagService = ref.read(arsenalBagServiceProvider.notifier);
    return bagService.getSelectedBagDisplayText(arsenalState);
  }

  /// Check if there are active filters
  bool hasActiveFilters(NewArsenalState arsenalState) {
    final bagService = ref.read(arsenalBagServiceProvider.notifier);
    return bagService.hasActiveFilters(arsenalState);
  }

  /// Check if bag has data
  bool bagHasData(NewArsenalState arsenalState) {
    final bagService = ref.read(arsenalBagServiceProvider.notifier);
    return bagService.bagHasData(arsenalState);
  }

  /// Check if items can be moved from current bag
  bool canMoveFromBag(NewArsenalState arsenalState) {
    final bagService = ref.read(arsenalBagServiceProvider.notifier);
    return bagService.canMoveFromBag(arsenalState);
  }

  // === Selection Management Operations ===

  /// Toggle move mode
  void toggleMoveMode() {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.toggleMoveMode();
  }

  /// Toggle remove mode
  void toggleRemoveMode() {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.toggleRemoveMode();
  }

  /// Exit selection mode
  void exitSelectionMode(NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.exitSelectionMode(arsenalState);
  }

  /// Check if in selection mode
  bool isInSelectionMode(NewArsenalState arsenalState) {
    return arsenalState.isMoveMode || arsenalState.isRemoveMode;
  }

  /// Get number of selected items
  int getSelectionCount(NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    return selectionService.getSelectionCount(arsenalState);
  }

  /// Get selection mode display text
  String getSelectionModeText(NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    return selectionService.getSelectionModeText(arsenalState);
  }

  /// Get selection mode color
  SelectionModeColor getSelectionModeColor(NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    return selectionService.getSelectionModeColor(arsenalState);
  }

  /// Toggle instance for move
  void toggleInstanceForMove(int instanceId) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.toggleInstanceForMove(instanceId);
  }

  /// Toggle instance for removal
  void toggleInstanceForRemoval(int instanceId) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.toggleInstanceForRemoval(instanceId);
  }

  /// Clear all selections
  void clearSelections(NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.clearSelections(arsenalState);
  }

  /// Check if instance is selected
  bool isInstanceSelected(NewArsenalState arsenalState, int instanceId) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    return selectionService.isInstanceSelected(arsenalState, instanceId);
  }

  /// Get set of selected instances
  Set<int> getSelectedInstances(NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    return selectionService.getSelectedInstances(arsenalState);
  }

  // === Dialog Management Operations ===

  /// Show more options bottom sheet
  void showMoreOptionsBottomSheet({
    required BuildContext context,
    required WidgetRef widgetRef,
    required NewArsenalState arsenalState,
  }) {
    ArsenalDialogService.showMoreOptionsBottomSheet(
      context: context,
      ref: widgetRef,
      arsenalState: arsenalState,
    );
  }

  /// Show add to current bag dialog
  void showAddToCurrentBag({
    required BuildContext context,
    required WidgetRef widgetRef,
  }) {
    ArsenalDialogService.showAddToCurrentBag(
      context: context,
      ref: widgetRef,
    );
  }

  /// Show move selected items dialog
  Future<void> showMoveSelected({
    required BuildContext context,
    required List<Color> bagColors,
  }) async {
    final moveBallsUseCase = ref.read(moveBallsUseCaseProvider.notifier);
    final targetBag = await moveBallsUseCase.showBagSelectionDialog(
      context: context,
      bagColors: bagColors,
    );
    
    if (targetBag != null) {
      // 若目前是通用選取模式（非 moveMode），也透過 selectionService 的集合
      await moveBallsUseCase.execute(
        context: context,
        targetBagNumber: targetBag,
      );
      // 動作完成後，統一清空兩側狀態，避免底部按鈕仍為 enabled
      ref.read(arsenalSelectionStateProviderProvider.notifier).exitSelectionMode();
      ref.read(newArsenalControllerProvider.notifier).exitAllSelectionModes();
    }
  }

  /// Confirm and remove selected items
  Future<void> confirmRemoveSelected({
    required BuildContext context,
    required WidgetRef widgetRef,
  }) async {
    final removeBallsUseCase = ref.read(removeBallsUseCaseProvider.notifier);
    await removeBallsUseCase.execute(context: context, widgetRef: widgetRef);
  }

  /// Show library selection dialog
  void showLibrarySelection({
    required BuildContext context,
    required WidgetRef widgetRef,
  }) {
    ArsenalDialogService.showLibrarySelection(
      context: context,
      ref: widgetRef,
    );
  }

  /// Show ball details dialog
  void showBallDetails({
    required BuildContext context,
    required int instanceId,
  }) {
    ArsenalDialogService.showBallDetails(
      context: context,
      instanceId: instanceId,
    );
  }

  // === Composite Operations ===

  /// Handle tab controller update with bag unlock
  Future<void> handleBagUnlock({
    required BuildContext context,
    required WidgetRef widgetRef,
    required int bagIndex,
    required List<Color> bagColors,
    required TickerProvider vsync,
    required Function(TabController?) onTabControllerUpdate,
  }) async {
    await showUnlockBagDialog(
      context: context,
      widgetRef: widgetRef,
      bagIndex: bagIndex,
      bagColors: bagColors,
      vsync: vsync,
      onTabControllerUpdate: onTabControllerUpdate,
    );
  }

  /// Handle selection mode toggle with automatic exit
  void handleSelectionModeToggle({
    required String mode, // 'move' or 'remove'
    required NewArsenalState arsenalState,
  }) {
    if (isInSelectionMode(arsenalState)) {
      exitSelectionMode(arsenalState);
    } else {
      if (mode == 'move') {
        toggleMoveMode();
      } else if (mode == 'remove') {
        toggleRemoveMode();
      }
    }
  }

  /// Handle instance selection with mode awareness
  void handleInstanceSelection({
    required int instanceId,
    required NewArsenalState arsenalState,
  }) {
    if (arsenalState.isMoveMode) {
      toggleInstanceForMove(instanceId);
    } else if (arsenalState.isRemoveMode) {
      toggleInstanceForRemoval(instanceId);
    }
  }

  /// Handle bulk operations with confirmation
  Future<void> handleBulkOperation({
    required BuildContext context,
    required String operation, // 'move' or 'remove'
    required NewArsenalState arsenalState,
    required WidgetRef widgetRef, // Required for operations
    List<Color>? bagColors, // Required for move operation
  }) async {
    final selectedCount = getSelectionCount(arsenalState);
    
    if (selectedCount == 0) {
      // Show message that no items are selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items selected'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    switch (operation) {
      case 'move':
        if (bagColors != null) {
          await showMoveSelected(
            context: context,
            bagColors: bagColors,
          );
        }
        break;
      case 'remove':
        await confirmRemoveSelected(context: context, widgetRef: widgetRef);
        break;
    }
  }

  // === UI State Utilities ===

  /// Get comprehensive UI state for widgets
  ArsenalUIState getUIState(NewArsenalState arsenalState) {
    return ArsenalUIState(
      isInSelectionMode: isInSelectionMode(arsenalState),
      selectionCount: getSelectionCount(arsenalState),
      selectionModeText: getSelectionModeText(arsenalState),
      selectionModeColor: getSelectionModeColor(arsenalState),
      selectedBagDisplayText: getSelectedBagDisplayText(arsenalState),
      hasActiveFilters: hasActiveFilters(arsenalState),
      bagHasData: bagHasData(arsenalState),
      canMoveFromBag: canMoveFromBag(arsenalState),
    );
  }

  /// Check if UI operations are available
  bool canPerformBulkOperations(NewArsenalState arsenalState) {
    return isInSelectionMode(arsenalState) && 
           getSelectionCount(arsenalState) > 0;
  }

  /// Get available actions for current state
  List<String> getAvailableActions(NewArsenalState arsenalState) {
    final actions = <String>[];
    
    if (bagHasData(arsenalState)) {
      if (!isInSelectionMode(arsenalState)) {
        actions.addAll(['select_move', 'select_remove', 'filter', 'sort']);
      } else {
        if (arsenalState.isMoveMode && canMoveFromBag(arsenalState)) {
          actions.add('move_selected');
        }
        if (arsenalState.isRemoveMode) {
          actions.add('remove_selected');
        }
        actions.add('clear_selection');
      }
    }
    
    actions.add('add_balls');
    
    return actions;
  }
}

/// UI State data class for comprehensive UI state management
class ArsenalUIState {
  final bool isInSelectionMode;
  final int selectionCount;
  final String selectionModeText;
  final SelectionModeColor selectionModeColor;
  final String selectedBagDisplayText;
  final bool hasActiveFilters;
  final bool bagHasData;
  final bool canMoveFromBag;

  const ArsenalUIState({
    required this.isInSelectionMode,
    required this.selectionCount,
    required this.selectionModeText,
    required this.selectionModeColor,
    required this.selectedBagDisplayText,
    required this.hasActiveFilters,
    required this.bagHasData,
    required this.canMoveFromBag,
  });

  /// Check if bulk operations are available
  bool get canPerformBulkOperations => isInSelectionMode && selectionCount > 0;

  /// Get status text for UI display
  String get statusText {
    if (isInSelectionMode) {
      return '$selectionModeText ($selectionCount selected)';
    }
    if (hasActiveFilters) {
      return 'Filtered view - $selectedBagDisplayText';
    }
    return selectedBagDisplayText;
  }

  /// Get primary action color
  Color get primaryActionColor {
    switch (selectionModeColor) {
      case SelectionModeColor.remove:
        return Colors.red;
      case SelectionModeColor.move:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// Get secondary action color
  Color get secondaryActionColor {
    switch (selectionModeColor) {
      case SelectionModeColor.remove:
        return Colors.red.withOpacity(0.7);
      case SelectionModeColor.move:
        return Colors.blue.withOpacity(0.7);
      default:
        return Colors.grey.withOpacity(0.7);
    }
  }
}