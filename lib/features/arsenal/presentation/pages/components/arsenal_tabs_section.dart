import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/tabs/arsenal_tabs.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_selection_state_provider.dart';

class ArsenalTabsSection extends ConsumerWidget {
  final TabController? tabController;
  final List<Color> bagColors;
  final Function(int) onUnlockTap;
  final void Function(int tappedIndex)? onBlockedSwitch;

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
    final selectionState = ref.watch(arsenalSelectionStateProviderProvider);
    final userProfileState = ref.watch(userProfileControllerProvider);
    
    if (tabController == null) {
      return const SizedBox.shrink();
    }
    
    return ArsenalTabs(
      controller: tabController!,
      userProfileState: userProfileState,
      bagColors: bagColors,
      onUnlockTap: onUnlockTap,
      selectionMode: selectionState.isInSelectionMode || arsenalState.isMoveMode || arsenalState.isRemoveMode,
      onBlockedSwitch: onBlockedSwitch ?? (int tappedIndex) {
        // 預設阻擋行為：維持原袋不變，不做任何切換
        // 若需要：可以在上層接到 tappedIndex 後自動退出選取並切換
      },
    );
  }
}