import 'package:flutter/material.dart';

class TrainingPageAppBarActions extends StatelessWidget {
  const TrainingPageAppBarActions({
    required this.isSelectionMode,
    required this.selectedCount,
    required this.totalCount,
    required this.onToggleSelectionMode,
    required this.onSelectAll,
    required this.onClearAll,
    required this.onDeleteSelected,
    super.key,
  });
  final bool isSelectionMode;
  final int selectedCount;
  final int totalCount;
  final VoidCallback onToggleSelectionMode;
  final VoidCallback onSelectAll;
  final VoidCallback onClearAll;
  final VoidCallback onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!isSelectionMode) {
      return Container(); // Not in selection mode, show nothing
    }

    return Row(
      children: [
        IconButton(
          onPressed: selectedCount == totalCount ? onClearAll : onSelectAll,
          icon: Icon(
            selectedCount == totalCount ? Icons.deselect : Icons.select_all,
            color: theme.colorScheme.primary,
          ),
          tooltip: selectedCount == totalCount ? 'Deselect All' : 'Select All',
        ),
        IconButton(
          onPressed: onDeleteSelected,
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: 'Delete Selected',
        ),
      ],
    );
  }
}
