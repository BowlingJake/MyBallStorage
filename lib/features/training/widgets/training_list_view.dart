import 'package:bowlingarsenal_app/features/training/controllers/training_controller.dart';
import 'package:bowlingarsenal_app/features/training/controllers/training_ui_actions.dart';
import 'package:bowlingarsenal_app/features/training/widgets/training_day_summary_card.dart';
import 'package:bowlingarsenal_app/features/training/widgets/training_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingListView extends ConsumerWidget {
  const TrainingListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainingControllerProvider);
    final controller = ref.read(trainingControllerProvider.notifier);
    final uiActions = ref.read(trainingUIActionsProvider);

    if (!state.hasTrainingData) {
      return SliverFillRemaining(
        child: Center(
          child: TrainingEmptyState(
            onAddRecord: () => uiActions.showCreateRecordDialogFromEmptyState(context),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final day = state.trainingDays[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TrainingDaySummaryCard(
              key: ValueKey(day.id),
              summary: day,
              isSelectionMode: state.isSelectionMode,
              isSelected: state.isDaySelected(day.id),
              onSelectionChanged: (selected) =>
                  controller.toggleDaySelection(day.id),
              onAddGame: () => uiActions.showAddGameDialog(context, day.id),
              onEdit: () => uiActions.showEditRecordDialog(context, day.id),
              onDelete: () => uiActions.showDeleteDayDialog(context, day.id),
              onGameTap: (game) => uiActions.showInteractiveScoringDialog(context, game),
              onGameDelete: (game) => controller.deleteGame(game),
            ),
          );
        },
        childCount: state.trainingDays.length,
      ),
    );
  }
}
