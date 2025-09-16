import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/tags/oval_tag.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

class MyTrainingPage extends ConsumerStatefulWidget {
  const MyTrainingPage({super.key});
  
  @override
  ConsumerState<MyTrainingPage> createState() => _MyTrainingPageState();
}

class _MyTrainingPageState extends ConsumerState<MyTrainingPage> {
  @override
  void initState() {
    super.initState();
    // 頁面載入時重新整理資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trainingControllerProvider.notifier).refreshTrainingData();
    });
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
          const SizedBox(height: 12),
          
          // 快速操作區域
          _buildQuickActions(context, theme),
          const SizedBox(height: 16),
          
          // 歷史記錄入口
          _buildHistorySection(context, theme, state),
        ],
      ),
    ),
  );
  }

  Widget _buildSummaryCard(ThemeData theme, trainingState) {
    final totalSessions = trainingState.trainingDays.length;
    final totalGames = trainingState.trainingDays.fold<int>(0, (int sum, dynamic day) => sum + (day.totalGames as int));
    final avgScore = totalGames > 0 ?
        trainingState.trainingDays.fold<double>(0.0, (double sum, dynamic day) => sum + (day.averageScore as double)) / trainingState.trainingDays.length : 0.0;

    // 固定三色（深色調），避免受 theme 影響
    const Color colorSessions = Color(0xFF1E2B3D); // 深藍灰
    const Color colorGames = Color(0xFF2B1E3D); // 深紫
    const Color colorAvg = Color(0xFF1E3D2B); // 深綠

    // 移除標題，讓統計三框緊貼頂部
    return Row(
      children: [
        _buildColoredStatItem(theme, totalSessions.toString(), 'Total Sessions', colorSessions),
        const SizedBox(width: 12),
        _buildColoredStatItem(theme, totalGames.toString(), 'Total Games', colorGames),
        const SizedBox(width: 12),
        _buildColoredStatItem(theme, avgScore.toStringAsFixed(1), 'Average Score', colorAvg),
      ],
    );
  }

  Widget _buildStatItem(ThemeData theme, String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColoredStatItem(ThemeData theme, String value, String label, Color baseColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          // 外框與光暈：使用雙層陰影，形成柔和發光環
          border: Border.all(color: baseColor.withOpacity(0.60), width: 1),
          boxShadow: [
            // 近距離亮邊
            BoxShadow(color: baseColor.withOpacity(0.35), blurRadius: 14, spreadRadius: 1, offset: const Offset(0, 4)),
            // 遠距離柔光
            BoxShadow(color: baseColor.withOpacity(0.18), blurRadius: 30, spreadRadius: 8, offset: const Offset(0, 8)),
          ],
          color: baseColor.withOpacity(0.85),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              // 使用專案的字型設定，僅移除任何文字光暈
              style: theme.textTheme.headlineMedium?.copyWith(shadows: const <Shadow>[]),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(shadows: const <Shadow>[]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: AppStandardButton(
            text: 'Start Training',
            onPressed: () => context.go('/training/create/step-1'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppStandardButton.secondary(
            text: 'View All Training',
            onPressed: () => context.go('/training/history'),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context, ThemeData theme, trainingState) {
    if (trainingState.trainingDays.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    // 提取最近的訓練記錄
    final recentTrainings = trainingState.trainingDays.take(4).toList();

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
          ],
        ),
        const SizedBox(height: 16),
        ...recentTrainings.map((training) => _buildRecentTrainingCardModern(context, theme, training)),
      ],
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
            text: 'Start First Training',
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

}
