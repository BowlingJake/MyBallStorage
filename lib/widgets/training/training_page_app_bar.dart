import 'package:bowlingarsenal_app/controllers/training_controller.dart';
import 'package:bowlingarsenal_app/shared/app_strings.dart';
import 'package:bowlingarsenal_app/utils/ui_helpers.dart';
import 'package:bowlingarsenal_app/widgets/common/dialogs/app_dialogs.dart';
import 'package:bowlingarsenal_app/widgets/training/create_training_record_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingPageAppBar extends ConsumerWidget {
  const TrainingPageAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trainingControllerProvider);
    final theme = Theme.of(context);

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      expandedHeight: 120,
      leading: controller.isSelectionMode
          ? IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: controller.toggleSelectionMode,
            )
          : null,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          controller.isSelectionMode
              ? AppStrings.formatSelectedItems(controller.selectedCount)
              : AppStrings.myTraining,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        titlePadding: EdgeInsets.only(
          left: controller.isSelectionMode ? 72 : 16,
          bottom: 16,
        ),
      ),
      actions: _buildAppBarActions(context, ref, controller),
    );
  }

  List<Widget> _buildAppBarActions(
    BuildContext context,
    WidgetRef ref,
    TrainingController controller,
  ) {
    if (controller.isSelectionMode) {
      return [
        TextButton(
          onPressed: () {
            if (controller.selectedCount == controller.trainingDays.length) {
              controller.clearAllSelections();
            } else {
              controller.selectAllDays();
            }
          },
          child: Text(
            controller.selectedCount == controller.trainingDays.length
                ? AppStrings.cancelSelection
                : AppStrings.selectAll,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: controller.selectedCount > 0
              ? () => _showDeleteConfirmationDialog(context, ref)
              : null,
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.select_all, color: Colors.white),
          onPressed: controller.hasTrainingData
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
    final controller = ref.read(trainingControllerProvider);
    showCreateTrainingRecordDialog(context, (
      title,
      date,
      center,
      oilPatternName,
      oilPatternLength,
      isHousePattern,
      scoringMethod,
      inputMethod,
    ) async {
      await handleApiCall(
        context: context,
        future: controller.createTrainingRecord(
          title: title,
          date: date,
          center: center,
          oilPatternName: oilPatternName,
          oilPatternLength: oilPatternLength,
          isHousePattern: isHousePattern,
          scoringMethod: scoringMethod,
          inputMethod: inputMethod,
        ),
        successMessage: AppStrings.trainingRecordCreated,
      );
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref) {
    final controller = ref.read(trainingControllerProvider);
    showDeleteConfirmationDialog(
      context,
      itemCount: controller.selectedCount,
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
