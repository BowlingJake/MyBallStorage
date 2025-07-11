import 'package:bowlingarsenal_app/features/training/controllers/training_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/app_strings.dart';
import 'package:bowlingarsenal_app/utils/ui_helpers.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/app_dialogs.dart';
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
      await controller.createTrainingRecord(
        title: title,
        date: date,
        center: center,
        oilPatternName: oilPatternName,
        oilPatternLength: oilPatternLength,
        isHousePattern: isHousePattern,
        scoringMethod: scoringMethod,
        inputMethod: inputMethod,
      );
    });
  }

  Future<void> _onGameDelete(
    BuildContext context,
    GameRecord game,
    WidgetRef ref,
  ) async {
    final controller = ref.read(trainingControllerProvider);
    await controller.deleteGame(game);
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
      await controller.updateTrainingRecord(
        dayId,
        title: title,
        date: date,
        center: center,
        oilPatternName: oilPatternName,
        oilPatternLength: oilPatternLength,
        isHousePattern: isHousePattern,
        scoringMethod: scoringMethod,
        inputMethod: inputMethod,
      );
    });
  }

  void _showDeleteDayDialog(BuildContext context, String dayId, WidgetRef ref) {
    final controller = ref.read(trainingControllerProvider);
    showDeleteConfirmationDialog(
      context,
      itemCount: 1,
      onConfirm: () async {
        await controller.deleteTrainingDay(dayId);
      },
    );
  }

  void _showInteractiveScoring(BuildContext context, GameRecord game, WidgetRef ref) {
    final controller = ref.read(trainingControllerProvider);
    
    // 找到包含此遊戲的訓練日記錄
    TrainingDaySummary? trainingDay;
    for (final day in controller.trainingDays) {
      if (day.games.any((g) => g.id == game.id)) {
        trainingDay = day;
        break;
      }
    }

    if (trainingDay == null) {
      return;
    }
    
    // 如果找不到對應的訓練日，使用預設計分方式
    final scoringMethod = trainingDay.scoringMethod;
    final dayId = trainingDay.id;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InteractiveScoringDialog(
        game: game,
        scoringMethod: scoringMethod, // 傳遞計分方式
        onGameSaved: (updatedGame) async {
          final controller = ref.read(trainingControllerProvider);
          await controller.updateGame(dayId, updatedGame);
        },
      ),
    );
  }

  void _showAddGameDialog(BuildContext context, String dayId, WidgetRef ref) async {
    final controller = ref.read(trainingControllerProvider);
    final success = await controller.addGameToDay(dayId);
    
    if (success) {
      // 成功添加新遊戲，但不自動打開計分對話框
      // 使用者需要點擊遊戲記錄才會打開互動式計分對話框
    }
  }
}
