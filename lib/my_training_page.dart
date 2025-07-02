import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/training_record.dart';
import 'controllers/training_controller.dart';
import 'widgets/training/training_day_summary_card.dart';
import 'widgets/training/create_training_record_dialog.dart';
import 'widgets/training/delete_confirmation_dialog.dart';
import 'widgets/training/training_empty_state.dart';
import 'widgets/training/game_detail_dialog.dart';
import 'widgets/training/edit_training_record_dialog.dart';
import 'widgets/professional_dark_background.dart';
import 'widgets/modern_bottom_navigation.dart';
import 'widgets/app_standard_button.dart';
import 'shared/enums.dart';
import 'shared/app_strings.dart';
import 'ball_library_page.dart';

class MyTrainingPage extends StatefulWidget {
  const MyTrainingPage({Key? key}) : super(key: key);

  @override
  State<MyTrainingPage> createState() => _MyTrainingPageState();
}

class _MyTrainingPageState extends State<MyTrainingPage> {
  // 使用 enum 替代硬編碼數字
  BottomNavTab _currentTab = BottomNavTab.training;

  @override
  Widget build(BuildContext context) {
    // 使用 ChangeNotifierProvider.create 讓 Provider 管理 controller 生命週期
    return ChangeNotifierProvider(
      create: (context) => TrainingController(),
      child: Consumer<TrainingController>(
        builder: (context, controller, child) {
          return ProfessionalDarkBackground(
            backgroundImage: 'images/Sport_Tech_Background.png',
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: _buildAppBar(controller),
              body: _buildBody(controller),
              bottomNavigationBar: ModernBottomNavigation(
                currentIndex: _currentTab.index,
                onTap: _onBottomNavTapped,
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(TrainingController controller) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: controller.isSelectionMode
          ? IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => controller.toggleSelectionMode(),
            )
          : null,
      title: Text(
        controller.isSelectionMode
            ? AppStrings.formatSelectedItems(controller.selectedCount)
            : AppStrings.myTraining,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: _buildAppBarActions(controller),
    );
  }

  List<Widget> _buildAppBarActions(TrainingController controller) {
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
          onPressed: controller.selectedCount > 0
              ? () => _showDeleteConfirmationDialog(controller)
              : null,
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
          onPressed: () => _showCreateRecordDialog(controller),
        ),
      ];
    }
  }

  Widget _buildBody(TrainingController controller) {
    if (!controller.hasTrainingData) {
      return Center(
        child: TrainingEmptyState(
          onAddRecord: () => _showCreateRecordDialog(controller),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: controller.trainingDays.length,
      itemBuilder: (context, index) {
        final day = controller.trainingDays[index];
        return TrainingDaySummaryCard(
          key: ValueKey(day.id), // 添加唯一 key 避免重建動畫問題
          summary: day,
          isSelectionMode: controller.isSelectionMode,
          isSelected: controller.isDaySelected(day.id),
          onSelectionChanged: (selected) => controller.toggleDaySelection(day.id),
          onAddGame: () => _onAddGame(day.id, controller),
          onEdit: () => _showEditRecordDialog(day.id, controller),
          onDelete: () => _onDeleteDay(day.id, controller),
          onGameTap: (game) => _onGameTap(game, controller),
          onGameDelete: (game) => _onGameDelete(game, controller),
        );
      },
    );
  }

  void _onBottomNavTapped(int index) {
    final tab = BottomNavTab.values[index];
    
    switch (tab) {
      case BottomNavTab.home:
        // 修正：返回首頁前同步底部導航狀態
        setState(() {
          _currentTab = BottomNavTab.home;
        });
        Navigator.of(context).pop(); // 返回首頁
        break;
      case BottomNavTab.library:
        setState(() {
          _currentTab = tab;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BallLibraryPage()),
        );
        break;
      case BottomNavTab.add:
        setState(() {
          _currentTab = tab;
        });
        final controller = Provider.of<TrainingController>(context, listen: false);
        _showCreateRecordDialog(controller);
        break;
      case BottomNavTab.training:
        // 已經在訓練頁面，不需要導航
        setState(() {
          _currentTab = BottomNavTab.training;
        });
        break;
      case BottomNavTab.profile:
        setState(() {
          _currentTab = tab;
        });
        print('Profile button tapped in Training');
        break;
    }
  }

  void _showCreateRecordDialog(TrainingController controller) {
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
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.formatTrainingRecordCreated(title)),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('建立訓練記錄時發生錯誤: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  void _showEditRecordDialog(String dayId, TrainingController controller) {
    final day = controller.getTrainingDay(dayId);
    if (day == null) return;
    
    showEditTrainingRecordDialog(
      context,
      day,
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

  void _onDeleteDay(String dayId, TrainingController controller) {
    showDeleteConfirmationDialog(
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

  void _showDeleteConfirmationDialog(TrainingController controller) {
    final stats = controller.getSelectionStats();
    final selectedCount = stats['days']!;
    final totalGames = stats['games']!;
    
    showDeleteConfirmationDialog(
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

  void _onAddGame(String dayId, TrainingController controller) async {
    try {
      final success = await controller.addGameToDay(dayId);
      if (mounted && success) {
        final day = controller.getTrainingDay(dayId);
        final gameCount = day?.games.length ?? 0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.formatGameAddedSuccess(gameCount)),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
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

  void _onGameTap(GameRecord game, TrainingController controller) {
    showGameDetailDialog(
      context,
      game,
      onGameUpdated: (updatedGame) async {
        try {
          await controller.updateGame(updatedGame);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('更新遊戲時發生錯誤: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      onGameDeleted: (deletedGame) async {
        try {
          await controller.deleteGame(deletedGame);
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

  void _onGameDelete(GameRecord game, TrainingController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.deleteGame),
        content: Text(AppStrings.formatConfirmDeleteGame(game.gameNumber)),
        actions: [
          AppStandardButton(
            text: AppStrings.cancel,
            onPressed: () => Navigator.pop(context),
          ),
          AppStandardButton(
            text: AppStrings.delete,
            onPressed: () async {
              Navigator.pop(context);
              try {
                final success = await controller.deleteGame(game);
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
            customColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
