import 'package:flutter/material.dart';
import '../../controllers/training_controller.dart';
import '../../models/training_record.dart';
import '../../shared/app_strings.dart';
import 'create_training_record_dialog.dart';
import 'edit_training_record_dialog.dart';
import 'delete_confirmation_dialog.dart';
import 'game_detail_dialog.dart';
import 'add_game_simple_dialog.dart';
import 'add_game_advanced_dialog.dart';

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

    // 直接創建空白的遊戲記錄並添加到列表中
    final newGameNumber = record.games.length + 1;
    final blankGame = GameRecord(
      id: '${dayId}_game_${DateTime.now().millisecondsSinceEpoch}',
      gameNumber: newGameNumber,
      score: 0,
      frameScores: List.filled(10, 0), // 10格空白分數
      strikes: 0,
      spares: 0,
      notes: null,
      timestamp: DateTime.now(),
      ballUsed: null,
    );

    // 將空白遊戲記錄添加到訓練日
    try {
      final success = await controller.addGameRecordToDay(dayId, blankGame);
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已添加新的遊戲卡片，請編輯分數'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('添加遊戲時發生錯誤: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 