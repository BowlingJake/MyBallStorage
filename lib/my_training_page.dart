import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart'; // 導入 GetWidget
import 'models/training_record.dart';
import 'widgets/training/training_record_list_item.dart';
import 'widgets/training/training_dashboard_card.dart';
import 'widgets/training/create_training_record_dialog.dart';
import 'widgets/training/training_session_card.dart';
import 'widgets/training/delete_confirmation_dialog.dart';
import 'widgets/training/training_detail_dialog.dart';
import 'widgets/training/training_empty_state.dart';
import 'widgets/professional_dark_background.dart';
import 'widgets/modern_bottom_navigation.dart';
import 'ball_library_page.dart';
import 'views/training_card_test_page.dart';

class MyTrainingPage extends StatefulWidget {
  const MyTrainingPage({Key? key}) : super(key: key);

  @override
  State<MyTrainingPage> createState() => _MyTrainingPageState();
}

class _MyTrainingPageState extends State<MyTrainingPage> {
  // 清空訓練記錄數據
  final List<TrainingRecord> _trainingRecords = [];
  final List<TrainingSession> _trainingSessions = [];

  // 模擬儀表板數據 (暫時隱藏)
  final double strikePercentage = 65.0;
  final double sparePercentage = 80.0;
  final int averageScore = 200;

  // 底部導覽列相關狀態和方法
  int _bottomNavIndex = 3; // Training在第3個位置
  
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
    final newSession = TrainingSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: date,
      center: center,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
      isHousePattern: isHousePattern,
      scoringMethod: scoringMethod, // 添加計分方式
      createdAt: DateTime.now(),
    );

    setState(() {
      _trainingSessions.insert(0, newSession); // 新記錄放在最前面
    });
  }



  void _deleteSession(String sessionId) {
    showDeleteConfirmationDialog(
      context,
      title: 'Delete Training Session',
      message: 'Are you sure you want to delete this training session? This action cannot be undone.',
      onConfirm: () {
        setState(() {
          _trainingSessions.removeWhere((session) => session.id == sessionId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Training session deleted'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  void _navigateToRecordDetail(TrainingRecord record) {
    print('查看記錄詳情: ${record.id}');
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
          'My Training',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
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
      body: _trainingSessions.isEmpty 
        ? TrainingEmptyState(onAddRecord: _showCreateRecordDialog)
        : Column(
            children: [
              // 新增訓練按鈕
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GFButton(
                  onPressed: _showCreateRecordDialog,
                  text: "Add Training Record",
                  icon: Icon(Icons.add_circle_outline, color: Colors.white),
                  type: GFButtonType.solid,
                  color: theme.colorScheme.primary,
                  size: GFSize.MEDIUM,
                  shape: GFButtonShape.pills,
                  fullWidthButton: true,
                ),
              ),
              
              // 訓練記錄列表
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  itemCount: _trainingSessions.length,
                  itemBuilder: (context, index) {
                    final session = _trainingSessions[index];
                                      return TrainingSessionCard(
                    session: session,
                    onTap: () => print('Tap session: ${session.title}'),
                    onDelete: () => _deleteSession(session.id),
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
