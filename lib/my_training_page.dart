import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'models/training_record.dart';
import 'widgets/training/training_record_list_item.dart';
import 'widgets/training/training_dashboard_card.dart';
import 'widgets/training/create_training_record_dialog.dart';
import 'widgets/training/training_session_card.dart';
import 'widgets/training/training_day_summary_card.dart';
import 'widgets/training/delete_confirmation_dialog.dart';
import 'widgets/training/training_detail_dialog.dart';
import 'widgets/training/training_empty_state.dart';
import 'widgets/training/game_detail_dialog.dart';
import 'widgets/training/add_game_simple_dialog.dart';
import 'widgets/training/add_game_advanced_dialog.dart';
import 'widgets/training/edit_training_record_dialog.dart';
import 'widgets/professional_dark_background.dart';
import 'widgets/modern_bottom_navigation.dart';
import 'widgets/app_standard_button.dart';
import 'ball_library_page.dart';
import 'views/training/add_game_choice_dialog.dart';
import 'views/training/training_page_app_bar_actions.dart';
import 'views/training/training_page_body.dart';

class MyTrainingPage extends StatefulWidget {
  const MyTrainingPage({Key? key}) : super(key: key);

  @override
  State<MyTrainingPage> createState() => _MyTrainingPageState();
}

class _MyTrainingPageState extends State<MyTrainingPage> {
  // 使用新的分層資料結構
  final List<TrainingDaySummary> _trainingDays = [];

  // 批量刪除功能狀態
  bool _isSelectionMode = false;
  final Set<String> _selectedDayIds = {};

  // 底部導覽列相關狀態和方法
  int _bottomNavIndex = 3; // Training在第3個位置

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  // 創建示例資料來展示新設計
  void _loadMockData() {
    // 只有當沒有訓練記錄時才載入Mock數據
    if (_trainingDays.isNotEmpty) return;
    
    final now = DateTime.now();
    
    // 示例：今天練了5局，使用不同球具
    final phaseII = BallInfo(
      id: 'ball_1',
      name: 'Phaze II',
      brand: 'Storm',
      brandColor: '#FF6B35', // Storm 橘色
    );
    
    final purpleHammer = BallInfo(
      id: 'ball_2',
      name: 'Purple Hammer',
      brand: 'Hammer',
      brandColor: '#8B5A96', // Hammer 紫色
    );
    
    final idol = BallInfo(
      id: 'ball_3',
      name: 'Idol',
      brand: 'Roto Grip',
      brandColor: '#E31F26', // Roto Grip 紅色
    );

    final todayGames = [
      GameRecord(
        id: 'game_1',
        gameNumber: 1,
        score: 185,
        frameScores: [10, 9, 8, 10, 7, 10, 8, 9, 10, 9],
        strikes: 4,
        spares: 3,
        notes: 'Good start, need to work on 7-10 split',
        timestamp: now.subtract(Duration(hours: 2)),
        ballUsed: phaseII,
      ),
      GameRecord(
        id: 'game_2',
        gameNumber: 2,
        score: 201,
        frameScores: [10, 10, 9, 10, 8, 10, 10, 8, 10, 10],
        strikes: 7,
        spares: 2,
        notes: 'Great improvement on strikes',
        timestamp: now.subtract(Duration(hours: 1, minutes: 45)),
        ballUsed: phaseII,
      ),
      GameRecord(
        id: 'game_3',
        gameNumber: 3,
        score: 178,
        frameScores: [8, 7, 10, 9, 6, 10, 7, 10, 9, 8],
        strikes: 4,
        spares: 4,
        notes: 'Focus on spare conversion',
        timestamp: now.subtract(Duration(hours: 1, minutes: 30)),
        ballUsed: purpleHammer,
      ),
      GameRecord(
        id: 'game_4',
        gameNumber: 4,
        score: 195,
        frameScores: [10, 8, 10, 10, 7, 9, 10, 8, 10, 10],
        strikes: 6,
        spares: 2,
        notes: 'Consistent performance',
        timestamp: now.subtract(Duration(hours: 1, minutes: 15)),
        ballUsed: purpleHammer,
      ),
      GameRecord(
        id: 'game_5',
        gameNumber: 5,
        score: 212,
        frameScores: [10, 10, 10, 8, 9, 10, 10, 10, 9, 10],
        strikes: 8,
        spares: 1,
        notes: 'Personal best today!',
        timestamp: now.subtract(Duration(hours: 1)),
        ballUsed: phaseII,
      ),
    ];

    final todaySummary = TrainingDaySummary(
      id: 'day_today',
      title: 'Morning Practice', // 添加標題
      date: now,
      center: 'Bowl City Lanes',
      oilPatternName: 'House Pattern',
      oilPatternLength: null,
      isHousePattern: true,
      scoringMethod: 'Standard',
      inputMethod: 'simple', // 示例數據預設為 simple
      games: todayGames,
      createdAt: now,
    );

    // 示例：昨天練了3局，使用不同球具
    final astroPhysix = BallInfo(
      id: 'ball_4',
      name: 'Astro PhysiX',
      brand: 'Storm',
      brandColor: '#FF6B35', // Storm 橘色
    );

    final yesterdayGames = [
      GameRecord(
        id: 'game_y1',
        gameNumber: 1,
        score: 168,
        frameScores: [8, 7, 9, 8, 10, 7, 8, 9, 8, 10],
        strikes: 2,
        spares: 5,
        notes: 'Working on consistency',
        timestamp: now.subtract(Duration(days: 1, hours: 3)),
        ballUsed: idol,
      ),
      GameRecord(
        id: 'game_y2',
        gameNumber: 2,
        score: 189,
        frameScores: [10, 8, 10, 9, 7, 10, 9, 8, 10, 8],
        strikes: 4,
        spares: 3,
        notes: 'Better approach timing',
        timestamp: now.subtract(Duration(days: 1, hours: 2, minutes: 45)),
        ballUsed: astroPhysix,
      ),
      GameRecord(
        id: 'game_y3',
        gameNumber: 3,
        score: 203,
        frameScores: [10, 10, 8, 10, 10, 9, 8, 10, 10, 10],
        strikes: 7,
        spares: 1,
        notes: 'Great finish!',
        timestamp: now.subtract(Duration(days: 1, hours: 2, minutes: 30)),
        ballUsed: astroPhysix,
      ),
    ];

    final yesterdaySummary = TrainingDaySummary(
      id: 'day_yesterday',
      title: 'Evening Tournament Prep', // 添加標題
      date: now.subtract(Duration(days: 1)),
      center: 'Strike Zone Pro',
      oilPatternName: 'Cheetah',
      oilPatternLength: '35',
      isHousePattern: false,
      scoringMethod: 'Standard',
      inputMethod: 'advanced', // 示例數據使用 advanced
      games: yesterdayGames,
      createdAt: now.subtract(Duration(days: 1)),
    );

    setState(() {
      _trainingDays.addAll([todaySummary, yesterdaySummary]);
    });
  }
  
  void _onBottomNavTapped(int index) {
    switch (index) {
      case 0: // 首頁
        Navigator.of(context).pop(); // 返回首頁
        break;
      case 1: // 社群 (Ball Library)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BallLibraryPage()),
        );
        break;
      case 2: // 中央按鈕 (新增)
        setState(() {
          _bottomNavIndex = index;
        });
        _showCreateRecordDialog();
        break;
      case 3: // 訓練
        // 已經在訓練頁面，不需要導航
        setState(() {
          _bottomNavIndex = 3;
        });
        break;
      case 4: // 個人
        setState(() {
          _bottomNavIndex = index;
        });
        print('Profile button tapped in Training');
        // TODO: 導航到個人頁面
        break;
    }
    
    print('Bottom Nav Tapped in Training: $index');
  }

  void _showCreateRecordDialog() {
    showCreateTrainingRecordDialog(context, _onRecordCreated);
  }

  void _onRecordCreated(String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern, String scoringMethod, String inputMethod) {
    final newDay = TrainingDaySummary(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title, // 使用用戶輸入的標題
      date: date,
      center: center,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
      isHousePattern: isHousePattern,
      scoringMethod: scoringMethod,
      inputMethod: inputMethod, // 使用傳入的輸入方式
      games: [], // 開始時沒有遊戲記錄
      createdAt: DateTime.now(),
    );

    setState(() {
      _trainingDays.insert(0, newDay); // 新記錄放在最前面
    });
  }

  void _showEditRecordDialog(String dayId) {
    final day = _trainingDays.firstWhere((d) => d.id == dayId);
    showEditTrainingRecordDialog(
      context,
      day,
      (title, date, center, oilPatternName, oilPatternLength, isHousePattern, scoringMethod, inputMethod) {
        _onRecordUpdated(dayId, title, date, center, oilPatternName, oilPatternLength, isHousePattern, scoringMethod, inputMethod);
      },
    );
  }

  void _onRecordUpdated(String dayId, String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern, String scoringMethod, String inputMethod) {
    setState(() {
      final dayIndex = _trainingDays.indexWhere((d) => d.id == dayId);
      if (dayIndex != -1) {
        final originalDay = _trainingDays[dayIndex];
        
        // 創建更新的訓練日，保留原有的遊戲記錄
        final updatedDay = TrainingDaySummary(
          id: originalDay.id,
          title: title,
          date: date,
          center: center,
          oilPatternName: oilPatternName,
          oilPatternLength: oilPatternLength,
          isHousePattern: isHousePattern,
          scoringMethod: scoringMethod,
          inputMethod: inputMethod, // 使用傳入的輸入方式
          games: originalDay.games, // 保留原有的遊戲記錄
          createdAt: originalDay.createdAt,
        );
        
        _trainingDays[dayIndex] = updatedDay;
      }
    });
  }

  void _deleteDay(String dayId) {
    final day = _trainingDays.firstWhere((d) => d.id == dayId);
    showDeleteConfirmationDialog(
      context,
      title: 'Delete Training Day',
      message: 'Are you sure you want to delete this training day with ${day.totalGames} games? This action cannot be undone.',
      onConfirm: () {
        setState(() {
          _trainingDays.removeWhere((day) => day.id == dayId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Training day deleted'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  // 批量刪除相關方法
  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedDayIds.clear();
      }
    });
  }

  void _toggleDaySelection(String dayId) {
    setState(() {
      if (_selectedDayIds.contains(dayId)) {
        _selectedDayIds.remove(dayId);
      } else {
        _selectedDayIds.add(dayId);
      }
    });
  }

  void _selectAllDays() {
    setState(() {
      _selectedDayIds.clear();
      _selectedDayIds.addAll(_trainingDays.map((day) => day.id));
    });
  }

  void _clearAllSelections() {
    setState(() {
      _selectedDayIds.clear();
    });
  }

  void _deleteSelectedDays() {
    if (_selectedDayIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one training day to delete'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final selectedCount = _selectedDayIds.length;
    final totalGames = _trainingDays
        .where((day) => _selectedDayIds.contains(day.id))
        .map((day) => day.totalGames)
        .fold(0, (a, b) => a + b);

    showDeleteConfirmationDialog(
      context,
      title: 'Delete Training Days',
      message: 'Are you sure you want to delete $selectedCount training day${selectedCount > 1 ? 's' : ''} with $totalGames total games? This action cannot be undone.',
      onConfirm: () {
        setState(() {
          _trainingDays.removeWhere((day) => _selectedDayIds.contains(day.id));
          _selectedDayIds.clear();
          _isSelectionMode = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$selectedCount training day${selectedCount > 1 ? 's' : ''} deleted'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  void _addGameToDay(String dayId) {
    final day = _trainingDays.firstWhere((d) => d.id == dayId);
    final nextGameNumber = day.games.length + 1;

    // 直接創建預設的遊戲記錄，不顯示對話框
    final newGame = _createDefaultGame(dayId, nextGameNumber);

    setState(() {
      final dayIndex = _trainingDays.indexWhere((d) => d.id == dayId);
      if (dayIndex != -1) {
        // 創建新的遊戲列表
        final updatedGames = <GameRecord>[..._trainingDays[dayIndex].games, newGame];
        
        // 創建更新的訓練日
        final updatedDay = TrainingDaySummary(
          id: _trainingDays[dayIndex].id,
          title: _trainingDays[dayIndex].title,
          date: _trainingDays[dayIndex].date,
          center: _trainingDays[dayIndex].center,
          oilPatternName: _trainingDays[dayIndex].oilPatternName,
          oilPatternLength: _trainingDays[dayIndex].oilPatternLength,
          isHousePattern: _trainingDays[dayIndex].isHousePattern,
          scoringMethod: _trainingDays[dayIndex].scoringMethod,
          inputMethod: _trainingDays[dayIndex].inputMethod, // 保留原有的輸入方式
          games: updatedGames,
          createdAt: _trainingDays[dayIndex].createdAt,
        );
        
        _trainingDays[dayIndex] = updatedDay;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('第 $nextGameNumber 局已新增成功！總共 ${day.games.length + 1} 局'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // 創建預設的遊戲記錄
  GameRecord _createDefaultGame(String dayId, int gameNumber) {
    final now = DateTime.now();
    
    // 生成模擬的隨機分數資料
    final random = math.Random();
    final scores = [150, 165, 178, 185, 192, 201, 210, 225, 240, 255];
    final score = scores[random.nextInt(scores.length)];
    
    // 根據分數生成相應的 strikes 和 spares
    int strikes = 0;
    int spares = 0;
    
    if (score >= 240) {
      strikes = random.nextInt(3) + 8; // 8-10 strikes
      spares = random.nextInt(2); // 0-1 spares
    } else if (score >= 200) {
      strikes = random.nextInt(3) + 5; // 5-7 strikes
      spares = random.nextInt(3) + 1; // 1-3 spares
    } else if (score >= 170) {
      strikes = random.nextInt(3) + 3; // 3-5 strikes
      spares = random.nextInt(4) + 2; // 2-5 spares
    } else {
      strikes = random.nextInt(3) + 1; // 1-3 strikes
      spares = random.nextInt(5) + 3; // 3-7 spares
    }
    
    // 生成簡化的 frame scores
    final averagePerFrame = score / 10;
    final frameScores = List.generate(10, (index) => averagePerFrame.round());
    
    // 生成隨機備註
    final notes = _generateRandomNote(score, strikes, spares);
    
    // 生成隨機球具
    final ballUsed = _generateRandomBall(random);
    
    return GameRecord(
      id: '${dayId}_game_${now.millisecondsSinceEpoch}',
      gameNumber: gameNumber,
      score: score,
      frameScores: frameScores,
      strikes: strikes,
      spares: spares,
      notes: notes,
      timestamp: now,
      ballUsed: ballUsed,
    );
  }

  // 生成隨機球具
  BallInfo _generateRandomBall(math.Random random) {
    final balls = [
      BallInfo(
        id: 'ball_1',
        name: 'Phaze II',
        brand: 'Storm',
        brandColor: '#FF6B35',
      ),
      BallInfo(
        id: 'ball_2',
        name: 'Purple Hammer',
        brand: 'Hammer',
        brandColor: '#8B5A96',
      ),
      BallInfo(
        id: 'ball_3',
        name: 'Idol',
        brand: 'Roto Grip',
        brandColor: '#E31F26',
      ),
      BallInfo(
        id: 'ball_4',
        name: 'Astro PhysiX',
        brand: 'Storm',
        brandColor: '#FF6B35',
      ),
      BallInfo(
        id: 'ball_5',
        name: 'Hustle Ink',
        brand: 'Roto Grip',
        brandColor: '#E31F26',
      ),
      BallInfo(
        id: 'ball_6',
        name: 'IQ Tour Emerald',
        brand: 'Storm',
        brandColor: '#FF6B35',
      ),
    ];
    
    return balls[random.nextInt(balls.length)];
  }

  // 生成隨機備註
  String _generateRandomNote(int score, int strikes, int spares) {
    final excellentNotes = [
      'Personal best today!',
      'Great improvement!',
      'Excellent performance',
      'Amazing consistency',
      'Perfect timing!'
    ];
    
    final goodNotes = [
      'Great improvement on strikes',
      'Consistent performance',
      'Good ball control',
      'Nice spare conversions',
      'Solid fundamentals'
    ];
    
    final averageNotes = [
      'Good start, need to work on 7-10 split',
      'Focus on spare conversion',
      'Working on consistency',
      'Better approach timing',
      'Need more practice on spares'
    ];
    
    final random = math.Random();
    
    if (score >= 200) {
      return excellentNotes[random.nextInt(excellentNotes.length)];
    } else if (score >= 170) {
      return goodNotes[random.nextInt(goodNotes.length)];
    } else {
      return averageNotes[random.nextInt(averageNotes.length)];
    }
  }

  void _onGameTap(GameRecord game) {
    showGameDetailDialog(
      context,
      game,
      onGameUpdated: (updatedGame) {
        _updateGameInDay(updatedGame);
      },
      onGameDeleted: (deletedGame) {
        _removeGameFromDay(deletedGame);
      },
    );
  }

  void _onGameDelete(GameRecord game) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('刪除遊戲'),
        content: Text('確定要刪除第${game.gameNumber}局嗎？此操作無法復原。'),
        actions: [
          AppStandardButton(
            text: '取消',
            onPressed: () => Navigator.pop(context),
          ),
          AppStandardButton(
            text: '刪除',
            onPressed: () {
              Navigator.pop(context);
              _removeGameFromDay(game);
            },
            customColor: Colors.red,
          ),
        ],
      ),
    );
  }

  void _updateGameInDay(GameRecord updatedGame) {
    setState(() {
      for (int dayIndex = 0; dayIndex < _trainingDays.length; dayIndex++) {
        final dayGames = _trainingDays[dayIndex].games;
        final gameIndex = dayGames.indexWhere((g) => g.id == updatedGame.id);
        
        if (gameIndex != -1) {
          final updatedGames = <GameRecord>[...dayGames];
          updatedGames[gameIndex] = updatedGame;
          
          final updatedDay = TrainingDaySummary(
            id: _trainingDays[dayIndex].id,
            title: _trainingDays[dayIndex].title,
            date: _trainingDays[dayIndex].date,
            center: _trainingDays[dayIndex].center,
            oilPatternName: _trainingDays[dayIndex].oilPatternName,
            oilPatternLength: _trainingDays[dayIndex].oilPatternLength,
            isHousePattern: _trainingDays[dayIndex].isHousePattern,
            scoringMethod: _trainingDays[dayIndex].scoringMethod,
            inputMethod: _trainingDays[dayIndex].inputMethod, // 保留原有的輸入方式
            games: updatedGames,
            createdAt: _trainingDays[dayIndex].createdAt,
          );
          
          _trainingDays[dayIndex] = updatedDay;
          break;
        }
      }
    });
  }

  void _removeGameFromDay(GameRecord gameToRemove) {
    setState(() {
      for (int dayIndex = 0; dayIndex < _trainingDays.length; dayIndex++) {
        final dayGames = _trainingDays[dayIndex].games;
        final gameIndex = dayGames.indexWhere((g) => g.id == gameToRemove.id);
        
        if (gameIndex != -1) {
          final updatedGames = <GameRecord>[...dayGames];
          updatedGames.removeAt(gameIndex);
          
          // 重新編號剩餘的遊戲
          for (int i = 0; i < updatedGames.length; i++) {
            updatedGames[i] = GameRecord(
              id: updatedGames[i].id,
              gameNumber: i + 1,
              score: updatedGames[i].score,
              frameScores: updatedGames[i].frameScores,
              strikes: updatedGames[i].strikes,
              spares: updatedGames[i].spares,
              notes: updatedGames[i].notes,
              timestamp: updatedGames[i].timestamp,
            );
          }
          
          final updatedDay = TrainingDaySummary(
            id: _trainingDays[dayIndex].id,
            title: _trainingDays[dayIndex].title,
            date: _trainingDays[dayIndex].date,
            center: _trainingDays[dayIndex].center,
            oilPatternName: _trainingDays[dayIndex].oilPatternName,
            oilPatternLength: _trainingDays[dayIndex].oilPatternLength,
            isHousePattern: _trainingDays[dayIndex].isHousePattern,
            scoringMethod: _trainingDays[dayIndex].scoringMethod,
            inputMethod: _trainingDays[dayIndex].inputMethod, // 保留原有的輸入方式
            games: updatedGames,
            createdAt: _trainingDays[dayIndex].createdAt,
          );
          
          _trainingDays[dayIndex] = updatedDay;
          break;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('遊戲已刪除'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProfessionalDarkBackground(
      backgroundImage: 'images/Sport_Tech_Background.png',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // Professional Dark 風格的透明AppBar
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.onSurface,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Text(
            _isSelectionMode 
              ? '${_selectedDayIds.length} selected'
              : 'My Training',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: _isSelectionMode 
            ? IconButton(
                onPressed: _toggleSelectionMode,
                icon: Icon(
                  Icons.close,
                  color: theme.colorScheme.onSurface,
                ),
                tooltip: 'Cancel Selection',
              )
            : IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onSurface,
                ),
              ),
          actions: [
            TrainingPageAppBarActions(
              isSelectionMode: _isSelectionMode,
              selectedCount: _selectedDayIds.length,
              totalCount: _trainingDays.length,
              onClearAll: _clearAllSelections,
              onSelectAll: _selectAllDays,
              onDeleteSelected: _deleteSelectedDays,
              onToggleSelectionMode: _toggleSelectionMode,
            ),
          ],
          // 添加細微的底部邊框
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    theme.colorScheme.outlineVariant.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        body: _trainingDays.isEmpty
            ? TrainingEmptyState(onAddRecord: _showCreateRecordDialog)
            : TrainingPageBody(
                trainingDays: _trainingDays,
                selectedDayIds: _selectedDayIds,
                isSelectionMode: _isSelectionMode,
                onAddRecord: _showCreateRecordDialog,
                onToggleSelectionMode: _toggleSelectionMode,
                onToggleDaySelection: _toggleDaySelection,
                onDeleteDay: _deleteDay,
                onAddGame: _addGameToDay,
                onEditRecord: _showEditRecordDialog,
                onGameTap: _onGameTap,
                onGameDelete: _onGameDelete,
                onSelectionChanged: (dayId, selected) {
                  if (selected) {
                    _selectedDayIds.add(dayId);
                  } else {
                    _selectedDayIds.remove(dayId);
                  }
                  setState(() {});
                },
              ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: _bottomNavIndex,
          onTap: _onBottomNavTapped,
        ),
      ),
    );
  }
}

// --- 如何在你的 App 中使用這個頁面 (範例) ---
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My Training App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         brightness: Brightness.light, // 或 Brightness.dark
//         // 你可以定義一個深色主題
//         // darkTheme: ThemeData.dark().copyWith(
//         //   // ... 自訂深色主題 ...
//         // ),
//       ),
//       home: MyTrainingPage(), // 將 MyTrainingPage 設為首頁或其中一個頁面
//     );
//   }
// }
