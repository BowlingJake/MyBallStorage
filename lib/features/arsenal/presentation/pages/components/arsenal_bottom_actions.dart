import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_ui_service.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

class ArsenalBottomActions extends ConsumerWidget {
  final VoidCallback onToggleMoveMode;
  final VoidCallback onToggleRemoveMode;

  const ArsenalBottomActions({
    super.key,
    required this.onToggleMoveMode,
    required this.onToggleRemoveMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final isMove = arsenalState.isMoveMode;
    final isRemove = arsenalState.isRemoveMode;
    
    // Hide bottom actions when in selection mode
    if (isMove || isRemove) {
      return const SizedBox.shrink();
    }

    final currentBagNumber = arsenalState.selectedBagNumber;
    final isMainBag = currentBagNumber == 1;
    final hasData = arsenalState.allInstances
        .any((i) => isMainBag ? true : i.isInBag(currentBagNumber));

    final double width = MediaQuery.of(context).size.width - 24; // 左右各留 12px
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom == 0 ? 0 : 2,
      ),
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            Expanded(
              // 左邊按鈕：主要色實心填滿
              child: AppStandardButton(
                text: isMainBag ? 'Add from Library' : 'Add to This Bag',
                height: 36,
                fontSize: 12,
                onPressed: () => ref.read(arsenalUIServiceProvider.notifier).showAddToCurrentBag(
                  context: context,
                  widgetRef: ref,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              // 中間按鈕：主色填滿，無 icon
              child: AppStandardButton(
                text: 'Move',
                height: 36,
                fontSize: 12,
                enabled: !isMainBag && hasData,
                onPressed: onToggleMoveMode,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              // 右邊按鈕：紅色實心填滿，無 icon
              child: AppStandardButton.destructive(
                text: 'Remove',
                height: 36,
                fontSize: 12,
                enabled: hasData,
                onPressed: onToggleRemoveMode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}