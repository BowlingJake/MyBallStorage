import 'package:flutter/material.dart';
import 'models/training_record.dart';
import 'widgets/training/training_record_list_item.dart';
import 'widgets/training/training_dashboard_card.dart';
import 'widgets/training/create_training_record_dialog.dart';
import 'widgets/training/training_session_card.dart';
import 'widgets/training/training_day_summary_card.dart';
import 'widgets/training/delete_confirmation_dialog.dart';
import 'widgets/training/training_detail_dialog.dart';
import 'widgets/training/training_empty_state.dart';
import 'widgets/professional_dark_background.dart';
import 'widgets/modern_bottom_navigation.dart';
import 'widgets/app_standard_button.dart';
import 'ball_library_page.dart';
import 'views/training_card_test_page.dart';

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
    final now = DateTime.now();
    
    // 示例：今天練了5局
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
      ),
    ];

    final todaySummary = TrainingDaySummary(
      id: 'day_today',
      date: now,
      center: 'Bowl City Lanes',
      oilPatternName: 'House Pattern',
      oilPatternLength: null,
      isHousePattern: true,
      scoringMethod: 'Standard',
      games: todayGames,
      createdAt: now,
    );

    // 示例：昨天練了3局
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
      ),
    ];

    final yesterdaySummary = TrainingDaySummary(
      id: 'day_yesterday',
      date: now.subtract(Duration(days: 1)),
      center: 'Strike Zone Pro',
      oilPatternName: 'Cheetah',
      oilPatternLength: '35',
      isHousePattern: false,
      scoringMethod: 'Standard',
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

  void _onRecordCreated(String title, DateTime date, String center, String? oilPatternName, String? oilPatternLength, bool isHousePattern, String scoringMethod) {
    final newDay = TrainingDaySummary(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: date,
      center: center,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
      isHousePattern: isHousePattern,
      scoringMethod: scoringMethod,
      games: [], // 開始時沒有遊戲記錄
      createdAt: DateTime.now(),
    );

    setState(() {
      _trainingDays.insert(0, newDay); // 新記錄放在最前面
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
    // TODO: 實現新增遊戲功能
    print('Add game to day: $dayId');
  }

  void _onGameTap(GameRecord game) {
    // TODO: 導航到遊戲詳情頁面
    print('View game details: ${game.id}');
  }

  void _onGameDelete(GameRecord game) {
    // TODO: 實現刪除單局功能
    print('Delete game: ${game.id}');
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
            if (_isSelectionMode) ...[
              // 全選按鈕
              IconButton(
                onPressed: _selectedDayIds.length == _trainingDays.length 
                  ? _clearAllSelections 
                  : _selectAllDays,
                icon: Icon(
                  _selectedDayIds.length == _trainingDays.length 
                    ? Icons.deselect 
                    : Icons.select_all,
                  color: theme.colorScheme.primary,
                ),
                tooltip: _selectedDayIds.length == _trainingDays.length 
                  ? 'Deselect All' 
                  : 'Select All',
              ),
              // 刪除按鈕
              IconButton(
                onPressed: _deleteSelectedDays,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                tooltip: 'Delete Selected',
              ),
            ] else ...[
              // 測試按鈕
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainingCardTestPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.design_services,
                  color: theme.colorScheme.primary,
                ),
                tooltip: 'Card Design Test',
              ),
            ],
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
          : Column(
              children: [
                // 按鈕區域
                if (!_isSelectionMode)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Add Training Record 按鈕
                        Expanded(
                          child: AppStandardButton(
                            text: "Add Training Day",
                            icon: Icons.add_circle_outline,
                            onPressed: _showCreateRecordDialog,
                          ),
                        ),
                        SizedBox(width: 12),
                        // Delete Training Record 按鈕
                        Expanded(
                          child: AppStandardButton(
                            text: "Delete Days",
                            icon: Icons.delete_outline,
                            onPressed: _toggleSelectionMode,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // 訓練日列表
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    itemCount: _trainingDays.length,
                    itemBuilder: (context, index) {
                      final day = _trainingDays[index];
                      final isSelected = _selectedDayIds.contains(day.id);
                      
                      return TrainingDaySummaryCard(
                        summary: day,
                        isSelectionMode: _isSelectionMode,
                        isSelected: isSelected,
                        onTap: _isSelectionMode 
                          ? () => _toggleDaySelection(day.id)
                          : () => print('Tap day: ${day.id}'),
                        onDelete: () => _deleteDay(day.id),
                        onAddGame: () => _addGameToDay(day.id),
                        onGameTap: _onGameTap,
                        onGameDelete: _onGameDelete,
                        onSelectionChanged: (selected) {
                          if (selected) {
                            _selectedDayIds.add(day.id);
                          } else {
                            _selectedDayIds.remove(day.id);
                          }
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ],
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
