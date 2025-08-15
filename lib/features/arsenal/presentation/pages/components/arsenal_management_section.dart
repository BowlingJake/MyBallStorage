import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_ui_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/appbar/management_section.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';

class ArsenalManagementSection extends ConsumerWidget {
  final List<Color> bagColors;
  final VoidCallback onShowMoreOptions;

  const ArsenalManagementSection({
    super.key,
    required this.bagColors,
    required this.onShowMoreOptions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    
    return Builder(builder: (context) {
      final isMove = arsenalState.isMoveMode;
      final isRemove = arsenalState.isRemoveMode;
      final selectionMode = isMove || isRemove;
      
      if (selectionMode) {
        return _buildSelectionModeBar(context, ref, isMove, isRemove);
      }
      
      return ManagementSection(
        getSelectedBagText: (state) => _getSelectedBagDisplayText(ref, state),
        onMore: onShowMoreOptions,
      );
    });
  }

  Widget _buildSelectionModeBar(BuildContext context, WidgetRef ref, bool isMove, bool isRemove) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final count = isMove
        ? arsenalState.selectedForMove.length
        : arsenalState.selectedForRemoval.length;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: (isMove
                // Move 模式：左邊使用次要色實心
                ? AppStandardButton.creative(
                    text: 'Confirm Move',
                    onPressed: () {
                      ref.read(arsenalUIServiceProvider.notifier).showMoveSelected(
                            context: context,
                            bagColors: bagColors,
                          );
                    },
                  )
                // Remove 模式：沿用破壞性按鈕
                : AppStandardButton.destructive(
                    text: 'Confirm Remove ($count)',
                    onPressed: () {
                      ref.read(arsenalUIServiceProvider.notifier).confirmRemoveSelected(
                            context: context,
                          );
                    },
                  )),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: (isMove
                // Move 模式：Exit 使用次要色線框
                ? AppStandardButton.secondaryOutlined(
                    text: 'Exit',
                    onPressed: () {
                      ref.read(arsenalUIServiceProvider.notifier).toggleMoveMode();
                    },
                  )
                // Remove 模式：Exit 使用紅色線框
                : AppStandardButton.destructiveOutlined(
                    text: 'Exit',
                    onPressed: () {
                      ref.read(arsenalUIServiceProvider.notifier).toggleRemoveMode();
                    },
                  )),
          ),
        ],
      ),
    );
  }

  String _getSelectedBagDisplayText(WidgetRef ref, NewArsenalState arsenalState) {
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
}