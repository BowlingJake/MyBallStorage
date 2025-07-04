import 'package:bowlingarsenal_app/controllers/training_controller.dart';
import 'package:bowlingarsenal_app/shared/app_strings.dart';
import 'package:flutter/material.dart';

class TrainingPageAppBar extends StatelessWidget {
  const TrainingPageAppBar({
    required this.controller,
    required this.onCreateRecord,
    required this.onShowDeleteDialog,
    super.key,
  });
  final TrainingController controller;
  final VoidCallback onCreateRecord;
  final VoidCallback onShowDeleteDialog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      expandedHeight: 120,
      leading:
          controller.isSelectionMode
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
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (controller.isSelectionMode) {
      return [
        // 全選/取消全選
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
        // 刪除按鈕
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: controller.selectedCount > 0 ? onShowDeleteDialog : null,
        ),
      ];
    } else {
      return [
        // 選擇模式按鈕
        IconButton(
          icon: const Icon(Icons.select_all, color: Colors.white),
          onPressed:
              controller.hasTrainingData
                  ? controller.toggleSelectionMode
                  : null,
        ),
        // 新增按鈕
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: onCreateRecord,
        ),
      ];
    }
  }
}
