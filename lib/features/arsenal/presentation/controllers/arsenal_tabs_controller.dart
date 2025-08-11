import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';

class ArsenalTabsController {
  const ArsenalTabsController._();

  static TabController? createTabController({
    required TickerProvider vsync,
    required UserProfileState userProfileState,
    required void Function(int bagNumber) onBagSelected,
  }) {
    if (userProfileState.profile == null) return null;
    final unlockedBags = userProfileState.profile!.unlockedBags;
    final int? nextBagToUnlock = userProfileState.profile!.nextBagToUnlock;

    int tabCount = 1 + (unlockedBags.length - 1);
    if (nextBagToUnlock != null) {
      tabCount += 1;
    }

    final controller = TabController(length: tabCount, vsync: vsync, initialIndex: 0);
    controller.addListener(() {
      if (!controller.indexIsChanging) {
        final selectedIndex = controller.index;
        if (selectedIndex == 0) {
          onBagSelected(1);
        } else if (selectedIndex <= unlockedBags.length - 1) {
          final bagInfo = unlockedBags.skip(1).toList()[selectedIndex - 1];
          onBagSelected(bagInfo.number);
        }
      }
    });
    return controller;
  }
}

