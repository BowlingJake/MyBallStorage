import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/common/view_mode_toggle.dart';

class ManagementSection extends ConsumerWidget {
  const ManagementSection({super.key, required this.getSelectedBagText, required this.onMore});

  final String Function(NewArsenalState) getSelectedBagText;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final bool selectionMode = arsenalState.isMoveMode || arsenalState.isRemoveMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (!selectionMode) const ViewModeToggle(),
          if (!selectionMode) const Spacer(),
          if (!selectionMode)
            Text(
              getSelectedBagText(arsenalState),
              style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }
}

