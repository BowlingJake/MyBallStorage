import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_bag_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_dialog_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/use_cases/add_balls_use_case.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_tabs_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';

class ArsenalBagHandler {
  static Future<void> showUnlockBagDialog({
    required BuildContext context,
    required WidgetRef ref,
    required int bagIndex,
    required List<Color> bagColors,
    required TickerProvider vsync,
    required Function(TabController?) onTabControllerUpdate,
  }) async {
    final ok = await ArsenalDialogService.showUnlockBagDialog(
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
    final addBallsUseCase = ref.read(addBallsUseCaseProvider.notifier);
    await addBallsUseCase.executeWithValidation(
      context: context,
      ballIds: ballIds,
    );
  }

  static String getSelectedBagDisplayText(WidgetRef ref, NewArsenalState arsenalState) {
    final bagService = ref.read(arsenalBagServiceProvider.notifier);
    return bagService.getSelectedBagDisplayText(arsenalState);
  }

  static bool hasActiveFilters(WidgetRef ref, NewArsenalState arsenalState) {
    final bagService = ref.read(arsenalBagServiceProvider.notifier);
    return bagService.hasActiveFilters(arsenalState);
  }

  static bool bagHasData(WidgetRef ref, NewArsenalState arsenalState) {
    final bagService = ref.read(arsenalBagServiceProvider.notifier);
    return bagService.bagHasData(arsenalState);
  }

  static bool canMoveFromBag(WidgetRef ref, NewArsenalState arsenalState) {
    final bagService = ref.read(arsenalBagServiceProvider.notifier);
    return bagService.canMoveFromBag(arsenalState);
  }
}