import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/tags/oval_tag.dart';

class ArsenalTabs extends StatelessWidget {
  const ArsenalTabs({
    super.key,
    required this.controller,
    required this.userProfileState,
    required this.bagColors,
    required this.onUnlockTap,
    this.selectionMode = false,
    this.onBlockedSwitch,
  });

  final TabController controller;
  final UserProfileState userProfileState;
  final List<Color> bagColors;
  final void Function(int unlockIndex) onUnlockTap;
  final bool selectionMode;
  final VoidCallback? onBlockedSwitch;


  @override
  Widget build(BuildContext context) {
    if (userProfileState.profile == null) {
      return const SizedBox.shrink();
    }

    final unlockedBags = userProfileState.profile!.unlockedBags;
    final nextBagToUnlock = userProfileState.profile!.nextBagToUnlock;

    return Container(
      padding: const EdgeInsets.only(left: 8, right: 16, top: 0, bottom: 8),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        indicatorColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
        tabs: [
          Tab(
            child: OvalTag(
              text: 'All My Arsenal',
              color: bagColors[0],
            ),
          ),
          ...unlockedBags.skip(1).map((bagInfo) {
            final bagIndex = bagInfo.number - 1;
            final bagColor = bagIndex < bagColors.length ? bagColors[bagIndex] : Colors.grey;
            return Tab(
              child: OvalTag(
                text: bagInfo.name,
                color: bagColor,
              ),
            );
          }).toList(),
          if (nextBagToUnlock != null)
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  OvalTag(
                    text: 'Unlock Bag',
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    backgroundOpacity: 0.2,
                    borderWidth: 1,
                  ),
                ],
              ),
            ),
        ],
        onTap: (index) {
          if (selectionMode) {
            onBlockedSwitch?.call();
            // 阻止切換
            controller.index = controller.previousIndex;
            return;
          }
          final unlockButtonIndex = nextBagToUnlock != null ? 1 + (unlockedBags.length - 1) : -1;
          if (nextBagToUnlock != null && index == unlockButtonIndex) {
            onUnlockTap(nextBagToUnlock - 1);
          }
        },
      ),
    );
  }
}

