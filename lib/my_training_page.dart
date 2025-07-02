import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';
import 'package:provider/provider.dart';
import 'models/training_record.dart';
import 'controllers/training_controller.dart';
import 'widgets/training/training_day_summary_card.dart';
import 'widgets/training/create_training_record_dialog.dart';
import 'widgets/training/delete_confirmation_dialog.dart';
import 'widgets/training/training_empty_state.dart';
import 'widgets/training/game_detail_dialog.dart';
import 'widgets/training/edit_training_record_dialog.dart';
import 'widgets/training/training_page_app_bar.dart';
import 'widgets/training/training_list_view.dart';
import 'widgets/training/training_page_dialogs.dart';
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

class _MyTrainingPageState extends State<MyTrainingPage> with TrainingPageDialogs {
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
              body: CustomScrollView(
                slivers: [
                  TrainingPageAppBar(
                    controller: controller,
                    onCreateRecord: () => showCreateRecordDialog(controller),
                    onShowDeleteDialog: () => showDeleteConfirmationDialog(controller),
                  ),
                  TrainingListView(
                    controller: controller,
                    onCreateRecord: () => showCreateRecordDialog(controller),
                    onAddGame: (dayId) => showAddGameDialog(dayId, controller),
                    onEditRecord: (dayId) => showEditRecordDialog(dayId, controller),
                    onDeleteDay: (dayId) => showDeleteDayDialog(dayId, controller),
                    onGameTap: (game) => showGameDetails(game, controller),
                    onGameDelete: (game) => _onGameDelete(game, controller),
                  ),
                ],
              ),
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
        showCreateRecordDialog(controller);
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
        if (kDebugMode) {
          log('Profile button tapped in Training');
        }
        break;
    }
  }

  Future<void> _onGameDelete(GameRecord game, TrainingController controller) async {
    try {
      final success = await controller.deleteGame(game);
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('遊戲已刪除'),
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
  }
}
