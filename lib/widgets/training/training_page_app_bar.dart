import 'package:flutter/material.dart';
import '../../controllers/training_controller.dart';
import '../../shared/app_strings.dart';

class TrainingPageAppBar extends StatelessWidget {
  final TrainingController controller;
  final VoidCallback onCreateRecord;
  final VoidCallback onShowDeleteDialog;

  const TrainingPageAppBar({
    Key? key,
    required this.controller,
    required this.onCreateRecord,
    required this.onShowDeleteDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      expandedHeight: 120,
      leading: controller.isSelectionMode
          ? IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => controller.toggleSelectionMode(),
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
            style: TextStyle(color: Colors.white),
          ),
        ),
        // 刪除按鈕
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: controller.selectedCount > 0 ? onShowDeleteDialog : null,
        ),
      ];
    } else {
      return [
        // 選擇模式按鈕
        IconButton(
          icon: Icon(Icons.select_all, color: Colors.white),
          onPressed: controller.hasTrainingData
              ? () => controller.toggleSelectionMode()
              : null,
        ),
        // 新增按鈕
        IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: onCreateRecord,
        ),
      ];
    }
  }
} 