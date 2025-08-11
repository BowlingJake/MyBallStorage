import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';

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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bagColors[0].withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: bagColors[0], width: 1.5),
              ),
              child: Text(
                'All My Arsenal',
                style: TextStyle(
                  color: bagColors[0],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          ...unlockedBags.skip(1).map((bagInfo) {
            final bagIndex = bagInfo.number - 1;
            final bagColor = bagIndex < bagColors.length ? bagColors[bagIndex] : Colors.grey;
            return Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: bagColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: bagColor, width: 1.5),
                ),
                child: Text(
                  bagInfo.name,
                  style: TextStyle(color: bagColor, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            );
          }).toList(),
          if (nextBagToUnlock != null)
            Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Unlock Bag',
                      style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
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

