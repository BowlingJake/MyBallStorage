import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/tags/oval_tag.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:intl/intl.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/models/training_state.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';

class MyTrainingPage extends ConsumerStatefulWidget {
  const MyTrainingPage({super.key});
  
  @override
  ConsumerState<MyTrainingPage> createState() => _MyTrainingPageState();
}


class _MyTrainingPageState extends ConsumerState<MyTrainingPage>
    with TickerProviderStateMixin {
  // Summary 統計區塊的狀態變數
  String _selectedTimeRange = '7 days'; // '7 days', '30 days', '3 months', '6 months', '1 year'
  String _selectedDataType = 'strike_rate'; // 'strike_rate', 'spare_rate', 'split_rate', 'average_score'

  // Chart interaction state
  int _selectedBarIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();

    // 頁面載入時重新整理資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trainingControllerProvider.notifier).refreshTrainingData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 回到此頁時也嘗試刷新，確保剛建立的 session 會出現在 Recent Training
    ref.read(trainingControllerProvider.notifier).refreshTrainingData();
  }

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/my-arsenal')) return 2;
    if (location.startsWith('/training')) return 3;
    if (location.startsWith('/tournament')) return 4;
    return 0;
  }

  void _navigateToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/library');
        break;
      case 2:
        context.go('/my-arsenal');
        break;
      case 3:
        context.go('/training');
        break;
      case 4:
        context.go('/tournament');
        break;
    }
  }

  Widget _buildTrainingOverview(BuildContext context, ThemeData theme) {
    final state = ref.watch(trainingControllerProvider);
    
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 總覽卡片
          _buildSummaryCard(theme, state),
          const SizedBox(height: 28),

          // 快速操作區域
          Center(child: _buildQuickActions(context, theme)),
          const SizedBox(height: 32),

          // 歷史記錄入口
          _buildHistorySection(context, theme, state),
          const SizedBox(height: 32),

          // 統計摘要區塊
          _buildStatsSummarySection(context, theme, state),
        ],
      ),
    ),
  );
  }

  Widget _buildSummaryCard(ThemeData theme, TrainingState trainingState) {
    // 計算個人榮譽紀錄
    final achievements = _calculatePersonalRecords(trainingState);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Records 標題
        Text(
          'Personal Records',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        // 成就卡片
        Row(
          children: [
            _buildAchievementCard(theme, achievements, 'singleGame', 'High Game'),
            const SizedBox(width: 12),
            _buildAchievementCard(theme, achievements, 'threeGame', 'High Set'),
            const SizedBox(width: 12),
            _buildAchievementCard(theme, achievements, 'sixGame', 'High Series'),
          ],
        ),
      ],
    );
  }

  /// 計算個人紀錄（包含分數和日期）
  Map<String, Map<String, dynamic>> _calculatePersonalRecords(TrainingState trainingState) {
    if (trainingState.trainingDays.isEmpty) {
      return {
        'singleGame': {'score': 0, 'date': null},
        'threeGame': {'score': 0, 'date': null},
        'sixGame': {'score': 0, 'date': null},
      };
    }

    // 收集所有遊戲分數和對應日期
    final List<Map<String, dynamic>> gameData = [];
    for (final day in trainingState.trainingDays) {
      for (final game in day.games) {
        gameData.add({
          'score': game.score,
          'date': day.date,
          'dayId': day.id,
        });
      }
    }

    if (gameData.isEmpty) {
      return {
        'singleGame': {'score': 0, 'date': null},
        'threeGame': {'score': 0, 'date': null},
        'sixGame': {'score': 0, 'date': null},
      };
    }

    // 單局最高分
    var singleGameRecord = gameData.reduce((a, b) =>
        (a['score'] as int) > (b['score'] as int) ? a : b);

    // 三局最高分
    int threeGameHigh = 0;
    DateTime? threeGameDate;
    if (gameData.length >= 3) {
      for (int i = 0; i <= gameData.length - 3; i++) {
        final threeGameTotal = (gameData[i]['score'] as int) +
                              (gameData[i + 1]['score'] as int) +
                              (gameData[i + 2]['score'] as int);
        if (threeGameTotal > threeGameHigh) {
          threeGameHigh = threeGameTotal;
          threeGameDate = gameData[i]['date'] as DateTime;
        }
      }
    }

    // 六局最高分
    int sixGameHigh = 0;
    DateTime? sixGameDate;
    if (gameData.length >= 6) {
      for (int i = 0; i <= gameData.length - 6; i++) {
        int sixGameTotal = 0;
        for (int j = i; j < i + 6; j++) {
          sixGameTotal += gameData[j]['score'] as int;
        }
        if (sixGameTotal > sixGameHigh) {
          sixGameHigh = sixGameTotal;
          sixGameDate = gameData[i]['date'] as DateTime;
        }
      }
    }

    return {
      'singleGame': {
        'score': singleGameRecord['score'],
        'date': singleGameRecord['date'],
      },
      'threeGame': {
        'score': threeGameHigh,
        'date': threeGameDate,
      },
      'sixGame': {
        'score': sixGameHigh,
        'date': sixGameDate,
      },
    };
  }


  Widget _buildAchievementCard(ThemeData theme, Map<String, Map<String, dynamic>> achievements, String recordType, String label) {
    final recordData = achievements[recordType] ?? {'score': 0, 'date': null};
    final score = recordData['score']?.toString() ?? '0';
    final date = recordData['date'] as DateTime?;

    // 格式化日期
    String dateText = 'No record yet';
    if (date != null) {
      dateText = DateFormat('yyyy/MM/dd').format(date);
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF1E1E1E), // 深灰色背景
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 頂部：標籤文字
            Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 中部：大字體數值
            Center(
              child: Text(
                score,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 底部：日期記錄
            Center(
              child: Text(
                dateText,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
      child: AppStandardButton(
        text: 'Start New Training',
        onPressed: () => context.go('/training/create/step-1'),
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context, ThemeData theme, trainingState) {
    if (trainingState.trainingDays.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    // 過濾最近7天的訓練記錄
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentTrainings = trainingState.trainingDays
        .where((training) => training.date.isAfter(sevenDaysAgo) || training.date.isAtSameMomentAs(sevenDaysAgo))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Training',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
                fontSize: theme.textTheme.titleMedium?.fontSize != null
                    ? (theme.textTheme.titleMedium!.fontSize! - 2)
                    : null,
              ),
            ),
            // 查看全部連結
            GestureDetector(
              onTap: () => context.go('/training/history'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        recentTrainings.isEmpty
            ? _buildNoRecentRecordMessage(context, theme)
            : _buildRecentTrainingCarousel(context, theme, recentTrainings),
      ],
    );
  }

  Widget _buildNoRecentRecordMessage(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 280, // Same height as the carousel
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF1E1E1E), // Same background as achievement cards
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'No Recent Record Available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildRecentTrainingCardModern(BuildContext context, ThemeData theme, training) {
    final Color border = theme.colorScheme.primary.withOpacity(0.25);
    final Color bg = Colors.black.withOpacity(0.55);
    final Color glow = theme.colorScheme.primary.withOpacity(0.12);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
        boxShadow: [BoxShadow(color: glow, blurRadius: 12, offset: const Offset(0, 4))],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bg, bg.withOpacity(0.7)],
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        title: Row(
          children: [
            Expanded(
              child: Text(
                training.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  shadows: const <Shadow>[],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            OvalTag(
              text: '${training.totalGames} games',
              color: theme.colorScheme.primary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              horizontalPadding: 8,
              verticalPadding: 3,
              borderWidth: 1.2,
              backgroundOpacity: 0.12,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Text(
                'total ${training.totalGames * training.averageScore.toInt()}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  shadows: const <Shadow>[],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'avg ${training.averageScore.toStringAsFixed(0)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  shadows: const <Shadow>[],
                ),
              ),
            ],
          ),
        ),
        onTap: () => context.go('/training/detail/${training.id}', extra: training),
      ),
    );
  }

  /// 橫向滑動的直式卡片清單
  Widget _buildRecentTrainingCarousel(BuildContext context, ThemeData theme, List<TrainingDaySummary> trainings) {
    return SizedBox(
      height: 280, // 增加高度以容納更多內容
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: trainings.length,
        padding: const EdgeInsets.only(right: 4),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final t = trainings[index];
          return _buildTrainingStatCard(context, theme, t);
        },
      ),
    );
  }

  Widget _buildTrainingStatCard(BuildContext context, ThemeData theme, TrainingDaySummary training) {
    final dateStr = DateFormat('EEEE, dd MMM yyyy').format(training.date);
    final totalScore = training.games.fold<int>(0, (acc, g) => acc + g.score);
    final avg = training.averageScore;
    final high = training.highestScore;
    final strike = training.strikePercentage.clamp(0, 100).toDouble();
    final spare = training.sparePercentage.clamp(0, 100).toDouble();
    final open = (100 - strike - spare).clamp(0, 100).toDouble();

    // 與上方成就卡一致：無邊框、深灰背景、柔和陰影
    const Color cardBg = Color(0xFF1E1E1E);

    return InkWell(
      onTap: () => context.go('/training/detail/${training.id}', extra: training),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 220, // 增加卡片寬度
        padding: const EdgeInsets.all(18), // 增加內邊距
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: cardBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 日期
            Text(
              dateStr,
              style: TextStyle(color: Colors.grey[300], fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12), // 增加間距
            // 標題與分數匯總
            const Text('Total Score', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4), // 增加間距
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(90),  // Total Score 最多4位數
                1: FixedColumnWidth(48),  // Avg 最多3位數
                2: FixedColumnWidth(48),  // High 最多3位數
              },
              children: [
                TableRow(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '$totalScore',
                        style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildMetricColumn('Avg', '$avg'),
                    _buildMetricColumn('High', '$high'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16), // 增加間距
            // 三個指標條 - 移除圖標，添加百分比數字
            const Text('Strike %', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 6), // 增加間距
            Row(
              children: [
                Expanded(child: _buildThinProgressBar(theme, strike, activeColor: theme.colorScheme.primary)),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 36),
                  child: Text(
                    '${strike.toInt()}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12), // 增加間距
            const Text('Spare %', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 6), // 增加間距
            Row(
              children: [
                Expanded(child: _buildThinProgressBar(theme, spare, activeColor: theme.colorScheme.primary)),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 36),
                  child: Text(
                    '${spare.toInt()}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12), // 增加間距
            const Text('Open %', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 6), // 增加間距
            Row(
              children: [
                Expanded(child: _buildThinProgressBar(theme, open, activeColor: Colors.redAccent)),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 36),
                  child: Text(
                    '${open.toInt()}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThinProgressBar(ThemeData theme, double percent, {required Color activeColor}) {
    final p = percent.clamp(0, 100) / 100.0;
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: p,
        child: Container(
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  /// 上方 Avg/High 小欄位，確保等寬避免擠壓
  Widget _buildMetricColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        color: theme.colorScheme.primary.withOpacity(0.03),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'No training records yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start your first training session to begin tracking your progress',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          AppStandardButton(
            text: 'Start New Training',
            onPressed: () => context.go('/training/create/step-1'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _calculateCurrentIndex(location);
    final theme = Theme.of(context);
    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'My Training',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: theme.colorScheme.onSurface,
            onPressed: () => context.go('/'),
            tooltip: 'Back to Home',
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: _buildTrainingOverview(context, theme),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: currentIndex,
          onTap: (index) => _navigateToIndex(context, index),
        ),
      ),
    );
  }

  // 統計摘要區塊
  Widget _buildStatsSummarySection(BuildContext context, ThemeData theme, TrainingState trainingState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 標題列
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            // 切換按鈕
            GestureDetector(
              onTap: () => _showSummaryOptionsDialog(context, theme),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getDisplayText(),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 統計卡片
        _buildStatsCard(context, theme, trainingState),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, ThemeData theme, TrainingState trainingState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 數據類型標題
          Text(
            _getDataTypeTitle(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // 長條圖（提高高度）
          SizedBox(
            height: 260,
            child: _buildBarChart(context, theme, trainingState),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, ThemeData theme, TrainingState trainingState) {
    final chartData = _getChartData(trainingState);
    if (chartData.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Calculate average for reference line
    final averageValue = chartData.map((d) => d['value'] as double).reduce((a, b) => a + b) / chartData.length;
    final rawMaxValue = chartData.map((d) => d['value'] as double).reduce(math.max);
    final maxValue = math.max(rawMaxValue * 1.15, 10.0); // Ensure minimum maxValue of 10

    return SizedBox(
      height: 240,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return BarChart(
            BarChartData(
              maxY: maxValue,
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: true,
                touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
                  setState(() {
                    if (response != null &&
                        response.spot != null &&
                        event is FlTapUpEvent) {
                      _selectedBarIndex = response.spot!.touchedBarGroupIndex;
                    } else if (event is FlPanEndEvent || event is FlTapUpEvent) {
                      _selectedBarIndex = -1;
                    }
                  });
                },
                mouseCursorResolver: (FlTouchEvent event, BarTouchResponse? response) {
                  return response == null || response.spot == null
                      ? MouseCursor.defer
                      : SystemMouseCursors.click;
                },
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => const Color(0xFF2A2A2A),
                  tooltipRoundedRadius: 12,
                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final data = chartData[groupIndex];
                    final label = data['label'] as String;
                    final value = rod.toY;
                    return BarTooltipItem(
                      '$label\\n${_formatChartValue(value)}\\n${_getPerformanceIndicator(value, averageValue)}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: math.max(maxValue / 4, 1.0), // Ensure minimum interval of 1
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= chartData.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          chartData[index]['label'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: _selectedBarIndex == index
                                ? theme.colorScheme.primary
                                : Colors.grey[400],
                            fontWeight: _selectedBarIndex == index
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: math.max(maxValue / 4, 1.0), // Ensure minimum interval of 1
                getDrawingHorizontalLine: (value) {
                  // Average reference line
                  if ((value - averageValue).abs() < 0.1) {
                    return FlLine(
                      color: theme.colorScheme.secondary.withOpacity(0.8),
                      strokeWidth: 1.5,
                      dashArray: [6, 4],
                    );
                  }
                  // Regular grid lines
                  return FlLine(
                    color: Colors.grey.withOpacity(0.15),
                    strokeWidth: 0.8,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                  left: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
                ),
              ),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: averageValue,
                    color: theme.colorScheme.secondary.withOpacity(0.7),
                    strokeWidth: 1.5,
                    dashArray: [8, 4],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 8, bottom: 4),
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                      labelResolver: (line) => 'Avg: ${_formatChartValue(averageValue)}',
                    ),
                  ),
                ],
              ),
              barGroups: List.generate(chartData.length, (index) {
                final data = chartData[index];
                final value = data['value'] as double;
                final isSelected = _selectedBarIndex == index;
                final animatedValue = value * _animation.value;

                return BarChartGroupData(
                  x: index,
                  groupVertically: true,
                  barRods: [
                    BarChartRodData(
                      toY: animatedValue,
                      width: isSelected ? 20 : 16,
                      borderRadius: BorderRadius.circular(isSelected ? 8 : 6),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: isSelected
                            ? [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withOpacity(0.6),
                                Colors.white.withOpacity(0.3),
                              ]
                            : [
                                theme.colorScheme.primary.withOpacity(0.9),
                                theme.colorScheme.primary.withOpacity(0.7),
                                theme.colorScheme.primary.withOpacity(0.5),
                              ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxValue,
                        color: Colors.grey.withOpacity(0.05),
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  String _getPerformanceIndicator(double value, double average) {
    final diff = ((value - average) / average * 100);
    if (diff > 5) {
      return '+${diff.toStringAsFixed(0)}% vs avg';
    } else if (diff < -5) {
      return '${diff.toStringAsFixed(0)}% vs avg';
    } else {
      return '~average';
    }
  }


  String _formatChartValue(double value) {
    if (_selectedDataType.endsWith('rate')) {
      return '${value.toStringAsFixed(0)}%';
    }
    return value.toStringAsFixed(0);
  }

  void _showSummaryOptionsDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // 時間區間選擇
                Text(
                  'Time Range',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['7 days', '30 days', '3 months', '6 months', '1 year'].map((range) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeRange = range;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _selectedTimeRange == range
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          range,
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedTimeRange == range ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // 數據類型選擇
                Text(
                  'Data Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    {'key': 'strike_rate', 'label': 'Strike Rate (%)', 'icon': Icons.sports_baseball},
                    {'key': 'spare_rate', 'label': 'Spare Rate (%)', 'icon': Icons.sports_tennis},
                    {'key': 'split_rate', 'label': 'Split Rate (%)', 'icon': Icons.call_split},
                    {'key': 'average_score', 'label': 'Average Score', 'icon': Icons.analytics},
                  ].map((dataType) {
                    final key = dataType['key'] as String;
                    final label = dataType['label'] as String;
                    final icon = dataType['icon'] as IconData;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDataType = key;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _selectedDataType == key
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : Colors.transparent,
                          border: Border.all(
                            color: _selectedDataType == key
                                ? theme.colorScheme.primary
                                : Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: _selectedDataType == key
                                  ? theme.colorScheme.primary
                                  : Colors.grey[400],
                            ),
                            const SizedBox(width: 12),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 13,
                                color: _selectedDataType == key
                                    ? theme.colorScheme.primary
                                    : Colors.white,
                                fontWeight: _selectedDataType == key
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // 關閉按鈕
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDisplayText() {
    final dataTypeMap = {
      'strike_rate': 'Strike Rate',
      'spare_rate': 'Spare Rate',
      'split_rate': 'Split Rate',
      'average_score': 'Average',
    };
    return '${dataTypeMap[_selectedDataType]} • $_selectedTimeRange';
  }

  String _getDataTypeTitle() {
    final dataTypeMap = {
      'strike_rate': 'Strike Rate (%)',
      'spare_rate': 'Spare Rate (%)',
      'split_rate': 'Split Rate (%)',
      'average_score': 'Average Score',
    };
    return dataTypeMap[_selectedDataType] ?? 'Statistics';
  }

  List<Map<String, dynamic>> _getChartData(TrainingState trainingState) {
    // 模擬數據 - 實際實現時需要根據 _selectedTimeRange 和 _selectedDataType 從 trainingState 中獲取真實數據
    if (trainingState.trainingDays.isEmpty) {
      return [
        {'label': 'W1', 'value': 0.0},
        {'label': 'W2', 'value': 0.0},
        {'label': 'W3', 'value': 0.0},
        {'label': 'W4', 'value': 0.0},
        {'label': 'W5', 'value': 0.0},
      ];
    }

    // 簡化的模擬數據生成
    final random = math.Random(42); // 固定種子以保持一致性
    final baseValues = {
      'strike_rate': 25.0,
      'spare_rate': 60.0,
      'split_rate': 15.0,
      'average_score': 150.0,
    };

    final baseValue = baseValues[_selectedDataType] ?? 50.0;

    return List.generate(5, (index) {
      final variation = (random.nextDouble() - 0.5) * 0.4; // ±20% 變化
      final value = baseValue * (1 + variation);
      return {
        'label': _selectedTimeRange.contains('days') ? 'Day ${index + 1}' : 'W${index + 1}',
        'value': math.max(0.0, value),
      };
    });
  }

}
