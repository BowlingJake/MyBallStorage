import 'package:flutter/material.dart';
import '../../controllers/training_controller.dart';
import '../../models/training_record.dart';
import '../../shared/app_strings.dart';
import 'create_training_record_dialog.dart';
import 'edit_training_record_dialog.dart';
import 'delete_confirmation_dialog.dart';
import 'game_detail_dialog.dart';
import '../../views/training/add_game_choice_dialog.dart';

mixin TrainingPageDialogs<T extends StatefulWidget> on State<T> {
  
  void showCreateRecordDialog(TrainingController controller) {
    showCreateTrainingRecordDialog(
      context,
      (title, date, center, oilPatternName, oilPatternLength, isHousePattern, scoringMethod, inputMethod) async {
        try {
          final id = await controller.createTrainingRecord(
            title: title,
            date: date,
            center: center,
            oilPatternName: oilPatternName,
            oilPatternLength: oilPatternLength,
            isHousePattern: isHousePattern,
            scoringMethod: scoringMethod,
            inputMethod: inputMethod,
          );
          
          if (mounted && id != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.trainingRecordCreated),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('創建訓練記錄時發生錯誤: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  void showEditRecordDialog(String dayId, TrainingController controller) {
    final record = controller.getTrainingDay(dayId);
    if (record == null) return;

    showEditTrainingRecordDialog(
      context,
      record,
      (title, date, center, oilPatternName, oilPatternLength, isHousePattern, scoringMethod, inputMethod) async {
        try {
          final success = await controller.updateTrainingRecord(
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
          
          if (mounted && success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.trainingRecordUpdated),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('更新訓練記錄時發生錯誤: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  void showDeleteDayDialog(String dayId, TrainingController controller) {
    showTrainingDeleteDialog(
      context,
      title: AppStrings.deleteTrainingDay,
      message: AppStrings.confirmDeleteTrainingDay,
      onConfirm: () async {
        try {
          final success = await controller.deleteTrainingDay(dayId);
          if (mounted && success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.trainingDayDeleted),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('刪除訓練日時發生錯誤: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  void showDeleteConfirmationDialog(TrainingController controller) {
    final stats = controller.getSelectionStats();
    final selectedCount = stats['days']!;
    final totalGames = stats['games']!;
    
    showTrainingDeleteDialog(
      context,
      title: AppStrings.deleteTrainingDays,
      message: AppStrings.formatConfirmDeleteMultiple(selectedCount, totalGames),
      onConfirm: () async {
        try {
          final deletedCount = await controller.deleteSelectedDays();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.formatTrainingDaysDeleted(deletedCount)),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('批量刪除訓練日時發生錯誤: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  void showGameDetails(GameRecord game, TrainingController controller) {
    showGameDetailDialog(
      context,
      game,
      onGameDeleted: (deletedGame) async {
        try {
          final success = await controller.deleteGame(deletedGame);
          if (mounted && success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.gameDeleted),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('刪除遊戲時發生錯誤: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  void showAddGameDialog(String dayId, TrainingController controller) async {
    final record = controller.getTrainingDay(dayId);
    if (record == null) return;

    final result = await showDialog<GameRecord>(
      context: context,
      builder: (context) => AddGameChoiceDialog(
        dayId: dayId, 
        gameNumber: record.games.length + 1,
      ),
    );
    
    if (result != null && mounted) {
      try {
        final success = await controller.addGameRecordToDay(dayId, result);
        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('遊戲已新增'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('新增遊戲時發生錯誤: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
} 