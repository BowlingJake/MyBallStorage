import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/tags/oval_tag.dart';

class ArsenalTabs extends StatefulWidget {
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
  State<ArsenalTabs> createState() => _ArsenalTabsState();
}

class _ArsenalTabsState extends State<ArsenalTabs> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userProfileState.profile == null) {
      return const SizedBox.shrink();
    }

    final unlockedBags = widget.userProfileState.profile!.unlockedBags;
    final nextBagToUnlock = widget.userProfileState.profile!.nextBagToUnlock;

    return Container(
      padding: const EdgeInsets.only(left: 8, right: 16, top: 0, bottom: 8),
      child: TabBar(
        controller: widget.controller,
        isScrollable: true,
        indicatorColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
        tabs: [
          for (int i = 0; i < unlockedBags.length; i++)
            Tab(
              child: OvalTag(
                text: i == 0 ? 'All My Arsenal' : unlockedBags[i].name,
                color: widget.controller.index == i
                    ? const Color(0xFFFFD700) // Brand yellow for selected
                    : Colors.grey[600]!, // Dark gray for unselected
              ),
            ),
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
          if (widget.selectionMode) {
            widget.onBlockedSwitch?.call();
            // 阻止切換
            widget.controller.index = widget.controller.previousIndex;
            return;
          }
          final unlockButtonIndex = nextBagToUnlock != null ? 1 + (unlockedBags.length - 1) : -1;
          if (nextBagToUnlock != null && index == unlockButtonIndex) {
            widget.onUnlockTap(nextBagToUnlock - 1);
          }
        },
      ),
    );
  }
}

