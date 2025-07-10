import 'package:bowlingarsenal_app/features/training/controllers/training_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/app_strings.dart';
import 'package:bowlingarsenal_app/utils/ui_helpers.dart';
import 'package:bowlingarsenal_app/widgets/common/dialogs/app_dialogs.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_training_record_dialog.dart';
import 'package:bowlingarsenal_app/features/training/widgets/delete_confirmation_dialog.dart';
import 'package:bowlingarsenal_app/features/training/widgets/edit_training_record_dialog.dart';
import 'package:bowlingarsenal_app/features/training/widgets/game_detail_dialog.dart';
import 'package:bowlingarsenal_app/features/training/widgets/interactive_scoring_dialog.dart';
import 'package:bowlingarsenal_app/features/training/widgets/training_day_summary_card.dart';
import 'package:bowlingarsenal_app/features/training/widgets/training_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingListView extends ConsumerWidget {
  const TrainingListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trainingControllerProvider);

    if (!controller.hasTrainingData) {
      return SliverFillRemaining(
        child: Center(
          child: TrainingEmptyState(
            onAddRecord: () =>
                _showCreateRecordDialogFromEmptyState(context, ref),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final day = controller.trainingDays[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TrainingDaySummaryCard(
              key: ValueKey(day.id),
              summary: day,
              isSelectionMode: controller.isSelectionMode,
              isSelected: controller.isDaySelected(day.id),
              onSelectionChanged: (selected) =>
                  controller.toggleDaySelection(day.id),
              onAddGame: () => _showAddGameDialog(context, day.id, ref),
              onEdit: () => _showEditRecordDialog(context, day.id, ref),
              onDelete: () => _showDeleteDayDialog(context, day.id, ref),
              onGameTap: (game) => _showInteractiveScoring(context, game, ref),
              onGameDelete: (game) => _onGameDelete(context, game, ref),
            ),
          );
        },
        childCount: controller.trainingDays.length,
      ),
    );
  }

  // --- Methods moved from MyTrainingPage ---

  void _showCreateRecordDialogFromEmptyState(
      BuildContext context, WidgetRef ref) {
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

  Future<void> _onGameDelete(
    BuildContext context,
    GameRecord game,
    WidgetRef ref,
  ) async {
    final controller = ref.read(trainingControllerProvider);
    await handleApiCall(
      context: context,
      future: controller.deleteGame(game),
      successMessage: '遊戲已刪除',
    );
  }

  void _showEditRecordDialog(
      BuildContext context, String dayId, WidgetRef ref) {
    final controller = ref.read(trainingControllerProvider);
    final record = controller.getTrainingDay(dayId);
    if (record == null) return;

    showEditTrainingRecordDialog(context, record, (
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
        future: controller.updateTrainingRecord(
          dayId,
          title: title,
          date: date,
          center: center,
          oilPatternName: oilPatternName,
          oilPatternLength: oilPatternLength,
          isHousePattern: isHousePattern,
          scoringMethod: scoringMethod,
          inputMethod: inputMethod,
        ),
        successMessage: AppStrings.trainingRecordUpdated,
      );
    });
  }

  void _showDeleteDayDialog(BuildContext context, String dayId, WidgetRef ref) {
    final controller = ref.read(trainingControllerProvider);
    showDeleteConfirmationDialog(
      context,
      itemCount: 1,
      onConfirm: () async {
        await handleApiCall(
          context: context,
          future: controller.deleteTrainingDay(dayId),
          successMessage: AppStrings.trainingRecordDeleted,
        );
      },
    );
  }

  void _showInteractiveScoring(BuildContext context, GameRecord game, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InteractiveScoringDialog(
        game: game,
        onGameSaved: (updatedGame) async {
          final controller = ref.read(trainingControllerProvider);
          await handleApiCall(
            context: context,
            future: controller.updateGame(updatedGame),
            successMessage: '遊戲分數已更新',
          );
        },
      ),
    );
  }

  void _showAddGameDialog(BuildContext context, String dayId, WidgetRef ref) async {
    final controller = ref.read(trainingControllerProvider);
    await handleApiCall(
      context: context,
      future: controller.addGameToDay(dayId),
      successMessage: '遊戲已新增',
    );
  }
}
