import 'package:bowlingarsenal_app/features/training/controllers/training_controller.dart';
import 'package:bowlingarsenal_app/features/training/controllers/training_ui_actions.dart';
import 'package:bowlingarsenal_app/shared/app_strings.dart';
import 'package:bowlingarsenal_app/utils/ui_helpers.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingPageAppBar extends ConsumerWidget {
  const TrainingPageAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainingControllerProvider);
    final controller = ref.watch(trainingControllerProvider.notifier);
    final theme = Theme.of(context);

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      expandedHeight: 120,
      leading: state.isSelectionMode
          ? IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: controller.toggleSelectionMode,
            )
          : null,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          state.isSelectionMode
              ? AppStrings.formatSelectedItems(state.selectedCount)
              : AppStrings.myTraining,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        titlePadding: EdgeInsets.only(
          left: state.isSelectionMode ? 72 : 16,
          bottom: 16,
        ),
      ),
      actions: _buildAppBarActions(context, ref, state, controller),
    );
  }

  List<Widget> _buildAppBarActions(
    BuildContext context,
    WidgetRef ref,
    TrainingState state,
    TrainingController controller,
  ) {
    if (state.isSelectionMode) {
      return [
        TextButton(
          onPressed: () {
            if (state.selectedCount == state.trainingDays.length) {
              controller.clearAllSelections();
            } else {
              controller.selectAllDays();
            }
          },
          child: Text(
            state.selectedCount == state.trainingDays.length
                ? AppStrings.cancelSelection
                : AppStrings.selectAll,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: state.selectedCount > 0
              ? () => _showDeleteConfirmationDialog(context, ref)
              : null,
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.select_all, color: Colors.white),
          onPressed: state.hasTrainingData
              ? controller.toggleSelectionMode
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () => _showCreateRecordDialog(context, ref),
        ),
      ];
    }
  }

  void _showCreateRecordDialog(BuildContext context, WidgetRef ref) {
    final uiActions = ref.read(trainingUIActionsProvider);
    uiActions.showCreateRecordDialogFromEmptyState(context);
  }

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref) {
    final controller = ref.read(trainingControllerProvider.notifier);
    final state = ref.read(trainingControllerProvider);
    showDeleteConfirmationDialog(
      context,
      itemCount: state.selectedCount,
      onConfirm: () async {
        await handleApiCall(
          context: context,
          future: controller.deleteSelectedDays(),
          successMessage: AppStrings.trainingRecordsDeleted,
        );
      },
    );
  }
}
