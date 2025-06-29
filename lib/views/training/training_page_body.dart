import 'package:flutter/material.dart';
import '../../models/training_record.dart';
import '../../widgets/app_standard_button.dart';
import '../../widgets/training/training_day_summary_card.dart';

class TrainingPageBody extends StatelessWidget {
  final List<TrainingDaySummary> trainingDays;
  final Set<String> selectedDayIds;
  final bool isSelectionMode;
  final VoidCallback onAddRecord;
  final VoidCallback onToggleSelectionMode;
  final Function(String) onToggleDaySelection;
  final Function(String) onDeleteDay;
  final Function(String) onAddGame;
  final Function(String) onEditRecord;
  final Function(GameRecord) onGameTap;
  final Function(GameRecord) onGameDelete;
  final Function(String, bool) onSelectionChanged;

  const TrainingPageBody({
    Key? key,
    required this.trainingDays,
    required this.selectedDayIds,
    required this.isSelectionMode,
    required this.onAddRecord,
    required this.onToggleSelectionMode,
    required this.onToggleDaySelection,
    required this.onDeleteDay,
    required this.onAddGame,
    required this.onEditRecord,
    required this.onGameTap,
    required this.onGameDelete,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isSelectionMode)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: AppStandardButton(
                    text: "Add Training Day",
                    icon: Icons.add_circle_outline,
                    onPressed: onAddRecord,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppStandardButton(
                    text: "Delete Days",
                    icon: Icons.delete_outline,
                    onPressed: onToggleSelectionMode,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            itemCount: trainingDays.length,
            itemBuilder: (context, index) {
              final day = trainingDays[index];
              final isSelected = selectedDayIds.contains(day.id);

              return TrainingDaySummaryCard(
                summary: day,
                isSelectionMode: isSelectionMode,
                isSelected: isSelected,
                onTap: isSelectionMode
                    ? () => onToggleDaySelection(day.id)
                    : () => print('Tap day: ${day.id}'),
                onDelete: () => onDeleteDay(day.id),
                onAddGame: () => onAddGame(day.id),
                onEdit: () => onEditRecord(day.id),
                onGameTap: onGameTap,
                onGameDelete: onGameDelete,
                onSelectionChanged: (selected) =>
                    onSelectionChanged(day.id, selected),
              );
            },
          ),
        ),
      ],
    );
  }
} 