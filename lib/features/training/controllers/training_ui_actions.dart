import 'package:bowlingarsenal_app/features/training/controllers/training_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/widgets/create_training_record_dialog.dart';
import 'package:bowlingarsenal_app/features/training/widgets/delete_confirmation_dialog.dart';
import 'package:bowlingarsenal_app/features/training/widgets/edit_training_record_dialog.dart';
import 'package:bowlingarsenal_app/features/training/widgets/interactive_scoring_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 訓練頁面 UI 互動處理器
/// 此類處理所有與 UI（例如顯示對話框）相關的操作
class TrainingUIActions {
  const TrainingUIActions(this.ref);
  
  final ProviderRef ref;

  /// 從空狀態顯示創建訓練記錄對話框
  void showCreateRecordDialogFromEmptyState(BuildContext context) {
    showCreateTrainingRecordDialog(
      context,
      onRecordCreated: (formState) async {
        final controller = ref.read(trainingControllerProvider.notifier);
        await controller.createTrainingRecord(
          title: formState.title,
          date: formState.date!,
          center: formState.centerName,
          oilPatternName: formState.oilPatternName.isEmpty ? null : formState.oilPatternName,
          oilPatternLength: formState.oilPatternLength.isEmpty ? null : formState.oilPatternLength,
          isHousePattern: formState.isHousePattern,
          scoringMethod: formState.selectedScoringMethod,
          inputMethod: formState.selectedInputMethod,
        );
      },
    );
  }

  /// 顯示編輯訓練記錄對話框
  void showEditRecordDialog(BuildContext context, String dayId) {
    final state = ref.read(trainingControllerProvider);
    final record = state.getTrainingDay(dayId);
    if (record == null) return;

    showCreateTrainingRecordDialog(
      context,
      initialData: record,
      onRecordCreated: (formState) async {
        final controller = ref.read(trainingControllerProvider.notifier);
        await controller.updateTrainingRecord(
          dayId,
          title: formState.title,
          date: formState.date!,
          center: formState.centerName,
          oilPatternName: formState.oilPatternName.isEmpty ? null : formState.oilPatternName,
          oilPatternLength: formState.oilPatternLength.isEmpty ? null : formState.oilPatternLength,
          isHousePattern: formState.isHousePattern,
          scoringMethod: formState.selectedScoringMethod,
          inputMethod: formState.selectedInputMethod,
        );
      },
    );
  }

  /// 顯示刪除訓練日對話框
  void showDeleteDayDialog(BuildContext context, String dayId) {
    showTrainingDeleteDialog(
      context,
      title: '刪除訓練日記錄',
      message: '確定要刪除這個訓練日記錄嗎？所有相關的遊戲數據都將被刪除，且無法恢復。',
      onConfirm: () async {
        final controller = ref.read(trainingControllerProvider.notifier);
        await controller.deleteTrainingDay(dayId);
      },
    );
  }

  /// 顯示互動式計分對話框
  void showInteractiveScoringDialog(BuildContext context, GameRecord game) {
    final state = ref.read(trainingControllerProvider);
    
    // 找到包含此遊戲的訓練日記錄
    TrainingDaySummary? trainingDay;
    for (final day in state.trainingDays) {
      if (day.games.any((g) => g.id == game.id)) {
        trainingDay = day;
        break;
      }
    }

    if (trainingDay == null) return;
    
    final scoringMethod = trainingDay.scoringMethod;
    final dayId = trainingDay.id;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InteractiveScoringDialog(
        game: game,
        scoringMethod: scoringMethod,
        onGameSaved: (updatedGame) async {
          final controller = ref.read(trainingControllerProvider.notifier);
          await controller.updateGame(dayId, updatedGame);
        },
      ),
    );
  }

  /// 顯示新增遊戲對話框
  Future<void> showAddGameDialog(BuildContext context, String dayId) async {
    final controller = ref.read(trainingControllerProvider.notifier);
    await controller.addGameToDay(dayId);
    // 如果需要額外的 UI 邏輯，可以在此添加
  }
}

/// 提供 TrainingUIActions 的 Provider
final trainingUIActionsProvider = Provider<TrainingUIActions>((ref) {
  return TrainingUIActions(ref);
}); 