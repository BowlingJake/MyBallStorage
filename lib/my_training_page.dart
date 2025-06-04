import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart'; // 導入 GetWidget
import 'models/training_record.dart';
import 'widgets/training/training_record_list_item.dart';
import 'widgets/training/training_dashboard_card.dart';

class MyTrainingPage extends StatefulWidget {
  const MyTrainingPage({Key? key}) : super(key: key);

  @override
  State<MyTrainingPage> createState() => _MyTrainingPageState();
}

class _MyTrainingPageState extends State<MyTrainingPage> {
  // 模擬的訓練記錄數據
  final List<TrainingRecord> _trainingRecords = [
    TrainingRecord(id: '1', date: DateTime(2025, 10, 20), centerName: '高手保齡球館', oilPattern: 'House Shot A'),
    TrainingRecord(id: '2', date: DateTime(2025, 10, 18), centerName: '中壢亞運保齡球館', oilPattern: 'PBA Shark 45ft'),
    TrainingRecord(id: '3', date: DateTime(2025, 10, 15), centerName: '高手保齡球館', oilPattern: 'Short Oil 32ft'),
  ];

  // 模擬儀表板數據
  final double strikePercentage = 65.0; // 假設 65%
  final double sparePercentage = 80.0; // 假設 80%
  final int averageScore = 200;

  void _navigateToCreateRecordPage() {
    // TODO: 導航到新增訓練記錄的頁面或彈出對話框
    print('導航到新增頁面');
    // 例如: Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTrainingPage()));
    // 或者彈出 showModalBottomSheet / showDialog
  }

  void _navigateToRecordDetail(TrainingRecord record) {
    // TODO: 導航到訓練記錄的詳細頁面
    print('查看記錄詳情: ${record.id}');
    // 例如: Navigator.push(context, MaterialPageRoute(builder: (context) => TrainingDetailPage(record: record)));
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: GFAppBar(
        // leading: GFIconButton( // 如果需要返回按鈕
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        //   type: GFButtonType.transparent,
        // ),
        title: Text('我的訓練', style: TextStyle(color: theme.colorScheme.onPrimaryContainer)),
        backgroundColor: theme.colorScheme.primaryContainer,
        actions: <Widget>[
          GFButton(
            onPressed: _navigateToCreateRecordPage,
            text: "新增訓練",
            icon: Icon(Icons.add_circle_outline, color: theme.colorScheme.onPrimaryContainer),
            type: GFButtonType.transparent,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _trainingRecords.length,
              itemBuilder: (context, index) {
                final record = _trainingRecords[index];
                return TrainingRecordListItem(
                  record: record,
                  theme: theme,
                  onTap: () => _navigateToRecordDetail(record),
                  isLastItem: index == _trainingRecords.length - 1,
                  index: index,
                );
              },
            ),
          ),
          TrainingDashboardCard(
            theme: theme,
            strikePercentage: strikePercentage,
            sparePercentage: sparePercentage,
            averageScore: averageScore,
          ),
        ],
      ),
      // floatingActionButton: GFFloatingWidget( // 如果 "Create" 按鈕想用 FAB
      //   child: Icon(Icons.add),
      //   onPressed: _navigateToCreateRecordPage,
      //   type: GFFloatingWidgetType.solid,
      //   shape: GFFloatingWidgetShape.circle,
      // ),
    );
  }
}

// Widget for displaying a single training record item
class _TrainingRecordListItem extends StatelessWidget {
  final TrainingRecord record;
  final ThemeData theme;
  final VoidCallback onTap;
  final bool isLastItem;

  const _TrainingRecordListItem({
    Key? key,
    required this.record,
    required this.theme,
    required this.onTap,
    required this.isLastItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GFListTile(
          title: Text(
            "${record.date.year}.${record.date.month.toString().padLeft(2, '0')}.${record.date.day.toString().padLeft(2, '0')} @ ${record.centerName}",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          subTitleText: "球道油型: ${record.oilPattern}",
          subTitle: Text(
             "球道油型: ${record.oilPattern}",
             style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          avatar: GFAvatar(
            child: Text((_trainingRecords.indexOf(record) + 1).toString(), style: TextStyle(color: theme.colorScheme.onPrimary)), // Use index from original list for numbering
            backgroundColor: theme.colorScheme.primary,
            shape: GFAvatarShape.standard,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: theme.cardColor,
          onTap: onTap,
        ),
        if (!isLastItem)
          Divider(height: 1, indent: 16 + 40 + 16, endIndent: 16, color: theme.dividerColor.withOpacity(0.5)), // Adjust indent to align with text after avatar
      ],
    );
  }
}

// Placeholder for the list of records to get index for avatar numbering
// This is a bit of a hack; ideally, the index should be passed or managed differently if items can be reordered/filtered.
// For a static list like this, it's okay.
final List<TrainingRecord> _trainingRecords = [
  TrainingRecord(id: '1', date: DateTime(2025, 10, 20), centerName: '高手保齡球館', oilPattern: 'House Shot A'),
  TrainingRecord(id: '2', date: DateTime(2025, 10, 18), centerName: '中壢亞運保齡球館', oilPattern: 'PBA Shark 45ft'),
  TrainingRecord(id: '3', date: DateTime(2025, 10, 15), centerName: '高手保齡球館', oilPattern: 'Short Oil 32ft'),
];

// Widget for the training dashboard
class _TrainingDashboardCard extends StatelessWidget {
  final ThemeData theme;
  final double strikePercentage;
  final double sparePercentage;
  final int averageScore;

  const _TrainingDashboardCard({
    Key? key,
    required this.theme,
    required this.strikePercentage,
    required this.sparePercentage,
    required this.averageScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFCard(
      boxFit: BoxFit.cover,
      color: theme.colorScheme.surfaceVariant,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      margin: const EdgeInsets.all(8.0),
      titlePosition: GFPosition.start,
      title: GFListTile(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        margin: EdgeInsets.zero,
        title: Text(
          '數據儀表板',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _DashboardStatItem(
            theme: theme,
            value: strikePercentage,
            label: '好球率',
            unit: '%',
            progressColor: theme.colorScheme.primary,
            isPercentage: true,
          ),
          _DashboardStatItem(
            theme: theme,
            value: sparePercentage,
            label: '補中率',
            unit: '%',
            progressColor: theme.colorScheme.secondary,
            isPercentage: true,
          ),
          _DashboardStatItem(
            theme: theme,
            value: averageScore.toDouble(),
            label: '平均分',
            unit: '',
            progressColor: theme.colorScheme.tertiary, // Or another distinct color
            isPercentage: false,
          ),
        ],
      ),
    );
  }
}

// Widget for a single statistic item in the dashboard
class _DashboardStatItem extends StatelessWidget {
  final ThemeData theme;
  final double value;
  final String label;
  final String unit;
  final Color progressColor;
  final bool isPercentage;

  const _DashboardStatItem({
    Key? key,
    required this.theme,
    required this.value,
    required this.label,
    required this.unit,
    required this.progressColor,
    this.isPercentage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: isPercentage
              ? GFProgressBar(
                  percentage: value / 100,
                  radius: 80,
                  type: GFProgressType.circular,
                  circleWidth: 8,
                  backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                  progressBarColor: progressColor,
                  child: Text(
                    '${value.toStringAsFixed(0)}$unit',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Column( // For non-percentage values like average score
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                       value.toStringAsFixed(0),
                       style: theme.textTheme.headlineSmall?.copyWith(
                         fontWeight: FontWeight.bold,
                         color: progressColor, // Use progress color for the value itself
                       ),
                     ),
                  ],
                ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
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
