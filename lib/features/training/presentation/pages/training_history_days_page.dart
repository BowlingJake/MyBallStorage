import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:intl/intl.dart';

class TrainingHistoryDaysPage extends ConsumerWidget {
  final int year;
  final int month;
  
  const TrainingHistoryDaysPage({
    required this.year,
    required this.month,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainingControllerProvider);
    final theme = Theme.of(context);

    // 從訓練數據中提取該月份的日期數據
    final days = _extractDays(state.trainingDays, year, month);
    
    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '${DateFormat('MMMM yyyy').format(DateTime(year, month))}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: theme.colorScheme.onSurface,
            onPressed: () => context.go('/training/history/$year'),
            tooltip: 'Back to Months',
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: days.isEmpty
            ? _buildEmptyState(context, theme)
            : _buildDaysList(context, theme, days),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    final monthName = DateFormat('MMMM yyyy').format(DateTime(year, month));
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No training found for $monthName',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Training sessions will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysList(BuildContext context, ThemeData theme, List<DayData> days) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final dayData = days[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go(
                '/training/detail/${dayData.trainingSession.id}',
                extra: dayData.trainingSession,
              ),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.05),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              dayData.day.toString(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE, MMM d').format(dayData.date),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dayData.trainingSession.title as String,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 訓練統計卡片
                    Row(
                      children: [
                        _buildStatCard(
                          theme,
                          '${dayData.trainingSession.totalGames as int}',
                          'Games',
                          Icons.sports,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          theme,
                          '${dayData.trainingSession.averageScore as int}',
                          'Avg Score',
                          Icons.trending_up,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          theme,
                          '${dayData.trainingSession.highestScore as int}',
                          'High Score',
                          Icons.emoji_events,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(ThemeData theme, String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DayData> _extractDays(List<dynamic> trainingDays, int targetYear, int targetMonth) {
    if (trainingDays.isEmpty) return [];

    final days = <DayData>[];
    
    for (final day in trainingDays) {
      if (day.date.year == targetYear && day.date.month == targetMonth) {
        days.add(DayData(
          day: day.date.day as int,
          date: day.date as DateTime,
          trainingSession: day,
        ));
      }
    }
    
    // 按日期降序排列（最新的在上面）
    days.sort((a, b) => b.day.compareTo(a.day));
    
    return days;
  }
}

class DayData {
  const DayData({
    required this.day,
    required this.date,
    required this.trainingSession,
  });

  final int day;
  final DateTime date;
  final dynamic trainingSession; // TrainingDaySummary from the original model
}