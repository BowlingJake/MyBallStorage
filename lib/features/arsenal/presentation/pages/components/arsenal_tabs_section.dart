import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/tabs/arsenal_tabs.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';

class ArsenalTabsSection extends ConsumerWidget {
  final TabController? tabController;
  final List<Color> bagColors;
  final Function(int) onUnlockTap;
  final VoidCallback? onBlockedSwitch;

  const ArsenalTabsSection({
    super.key,
    required this.tabController,
    required this.bagColors,
    required this.onUnlockTap,
    this.onBlockedSwitch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final userProfileState = ref.watch(userProfileControllerProvider);
    
    if (tabController == null) {
      return const SizedBox.shrink();
    }
    
    return ArsenalTabs(
      controller: tabController!,
      userProfileState: userProfileState,
      bagColors: bagColors,
      onUnlockTap: onUnlockTap,
      selectionMode: arsenalState.isMoveMode || arsenalState.isRemoveMode,
      onBlockedSwitch: onBlockedSwitch ?? () {
        // Default behavior: exit selection mode when trying to switch tabs
        if (arsenalState.isMoveMode) {
          ref.read(newArsenalControllerProvider.notifier).toggleMoveMode();
        } else if (arsenalState.isRemoveMode) {
          ref.read(newArsenalControllerProvider.notifier).toggleRemoveMode();
        }
      },
    );
  }
}