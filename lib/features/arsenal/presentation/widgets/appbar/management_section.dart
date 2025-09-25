import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/common/view_mode_toggle.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_selection_state_provider.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

class ManagementSection extends ConsumerWidget {
  const ManagementSection({super.key, required this.getSelectedBagText, required this.onMore});

  final String Function(NewArsenalState) getSelectedBagText;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final selectionState = ref.watch(arsenalSelectionStateProviderProvider);
    final bool selectionMode = selectionState.isInSelectionMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (!selectionMode) const ViewModeToggle(),
          if (!selectionMode) const Spacer(),
          if (!selectionMode)
            IconButton(
              icon: const Icon(
                Icons.checklist,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                ref.read(arsenalSelectionStateProviderProvider.notifier).toggleSelectionMode();
              },
              tooltip: 'Selection Mode',
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          if (!selectionMode) const SizedBox(width: 8),
          if (!selectionMode)
            Text(
              getSelectedBagText(arsenalState),
              style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500),
            ),
          if (selectionMode) const Spacer(),
          if (selectionMode)
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.redAccent,
                size: 20,
              ),
              onPressed: () {
                // 退出選取模式（通用）
                ref.read(arsenalSelectionStateProviderProvider.notifier).exitSelectionMode();
                // 退出控制器內的移動/移除模式並清空集合
                ref.read(newArsenalControllerProvider.notifier).exitAllSelectionModes();
              },
              tooltip: 'Cancel Selection',
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }

}

