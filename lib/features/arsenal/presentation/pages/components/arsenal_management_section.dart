import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_actions.dart';
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
            child: AppStandardButton(
              text: isMove ? 'Confirm Move' : 'Confirm Remove ($count)',
              onPressed: () {
                if (isMove) {
                  ArsenalActions.showMoveSelected(
                    context: context,
                    ref: ref,
                    bagColors: bagColors,
                  );
                } else {
                  ArsenalActions.confirmRemoveSelected(
                    context: context,
                    ref: ref,
                  );
                }
              },
              customColor: isMove ? Colors.blue : Colors.red,
              isPrimary: true,
              whiteForeground: true,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppStandardButton(
              text: 'Exit',
              onPressed: () {
                if (isMove) {
                  ref.read(newArsenalControllerProvider.notifier).toggleMoveMode();
                } else {
                  ref.read(newArsenalControllerProvider.notifier).toggleRemoveMode();
                }
              },
            ),
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