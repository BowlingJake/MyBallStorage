import 'dart:developer';

import 'package:bowlingarsenal_app/ball_library_page.dart';
import 'package:bowlingarsenal_app/controllers/training_controller.dart';
import 'package:bowlingarsenal_app/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/app_strings.dart';
import 'package:bowlingarsenal_app/shared/enums.dart';
import 'package:bowlingarsenal_app/widgets/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/widgets/professional_dark_background.dart';
// Dialog Imports
import 'package:bowlingarsenal_app/widgets/training/create_training_record_dialog.dart';
import 'package:bowlingarsenal_app/widgets/training/delete_confirmation_dialog.dart';
import 'package:bowlingarsenal_app/widgets/training/edit_training_record_dialog.dart';
import 'package:bowlingarsenal_app/widgets/training/game_detail_dialog.dart';
import 'package:bowlingarsenal_app/widgets/training/training_list_view.dart';
import 'package:bowlingarsenal_app/widgets/training/training_page_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trainingTabProvider = StateProvider<BottomNavTab>((ref) => BottomNavTab.training);

class MyTrainingPage extends ConsumerWidget {
  const MyTrainingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trainingControllerProvider);
    final currentTab = ref.watch(trainingTabProvider);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            TrainingPageAppBar(
              controller: controller,
              onCreateRecord: () => _showCreateRecordDialog(context, ref),
              onShowDeleteDialog: () => _showDeleteConfirmationDialog(context, controller),
            ),
            TrainingListView(
              controller: controller,
              onCreateRecord: () => _showCreateRecordDialog(context, ref),
              onAddGame: (dayId) => _showAddGameDialog(context, dayId, controller),
              onEditRecord: (dayId) => _showEditRecordDialog(context, dayId, controller),
              onDeleteDay: (dayId) => _showDeleteDayDialog(context, dayId, controller),
              onGameTap: (game) => _showGameDetails(context, game, controller),
              onGameDelete: (game) => _onGameDelete(context, game, controller),
            ),
          ],
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: currentTab.index,
          onTap: (index) => _onBottomNavTapped(context, index, ref),
        ),
      ),
    );
  }

  void _onBottomNavTapped(BuildContext context, int index, WidgetRef ref) {
    final tab = BottomNavTab.values[index];
    final notifier = ref.read(trainingTabProvider.notifier);
    
    switch (tab) {
      case BottomNavTab.home:
        notifier.state = BottomNavTab.home;
        Navigator.of(context).pop();
      case BottomNavTab.library:
        notifier.state = tab;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BallLibraryPage()),
        );
      case BottomNavTab.add:
        notifier.state = tab;
        _showCreateRecordDialog(context, ref);
      case BottomNavTab.training:
        notifier.state = BottomNavTab.training;
      case BottomNavTab.profile:
        notifier.state = tab;
        if (kDebugMode) {
          log('Profile button tapped in Training');
        }
    }
  }

  Future<void> _onGameDelete(BuildContext context, GameRecord game, TrainingController controller) async {
    try {
      final success = await controller.deleteGame(game);
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('遊戲已刪除'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('刪除遊戲時發生錯誤: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- Dialog Methods ---

  void _showCreateRecordDialog(BuildContext context, WidgetRef ref) {
    final controller = ref.read(trainingControllerProvider);
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
          
          if (context.mounted && id.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.trainingRecordCreated),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
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

  void _showEditRecordDialog(BuildContext context, String dayId, TrainingController controller) {
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
          
          if (context.mounted && success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.trainingRecordUpdated),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
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

  void _showDeleteDayDialog(BuildContext context, String dayId, TrainingController controller) {
    showTrainingDeleteDialog(
      context,
      title: AppStrings.deleteTrainingDay,
      message: AppStrings.confirmDeleteTrainingDay,
      onConfirm: () async {
        try {
          final success = await controller.deleteTrainingDay(dayId);
          if (context.mounted && success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.trainingDayDeleted),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
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

  void _showDeleteConfirmationDialog(BuildContext context, TrainingController controller) {
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
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.formatTrainingDaysDeleted(deletedCount)),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
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

  void _showGameDetails(BuildContext context, GameRecord game, TrainingController controller) {
    showGameDetailDialog(
      context,
      game,
      onGameDeleted: (deletedGame) async {
        try {
          final success = await controller.deleteGame(deletedGame);
          if (context.mounted && success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.gameDeleted),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
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

  Future<void> _showAddGameDialog(BuildContext context, String dayId, TrainingController controller) async {
    final record = controller.getTrainingDay(dayId);
    if (record == null) return;

    final newGameNumber = record.games.length + 1;
    final blankGame = GameRecord(
      id: '${dayId}_game_${DateTime.now().millisecondsSinceEpoch}',
      gameNumber: newGameNumber,
      score: 0,
      frameScores: List.filled(10, 0),
      strikes: 0,
      spares: 0,
      timestamp: DateTime.now(),
    );

    try {
      final success = await controller.addGameRecordToDay(dayId, blankGame);
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已添加新的遊戲卡片，請編輯分數'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
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
