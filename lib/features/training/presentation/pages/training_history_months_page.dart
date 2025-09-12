import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:intl/intl.dart';

class TrainingHistoryMonthsPage extends ConsumerWidget {
  final int year;
  
  const TrainingHistoryMonthsPage({
    required this.year,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainingControllerProvider);
    final theme = Theme.of(context);

    // 從訓練數據中提取該年份的月份數據
    final months = _extractMonths(state.trainingDays, year);
    
    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '$year Training History',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: theme.colorScheme.onSurface,
            onPressed: () => context.go('/training/history'),
            tooltip: 'Back to Years',
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: months.isEmpty
            ? _buildEmptyState(context, theme)
            : _buildMonthsList(context, theme, months),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No training found for $year',
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

  Widget _buildMonthsList(BuildContext context, ThemeData theme, List<MonthData> months) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: months.length,
      itemBuilder: (context, index) {
        final monthData = months[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go('/training/history/$year/${monthData.month}'),
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
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getMonthIcon(monthData.month),
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMMM').format(DateTime(year, monthData.month)),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${monthData.sessionCount} sessions',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${monthData.totalGames} games',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
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
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getMonthIcon(int month) {
    // 為每個月份返回不同的圖標
    switch (month) {
      case 1: return Icons.ac_unit; // January - snowflake
      case 2: return Icons.favorite; // February - heart
      case 3: return Icons.local_florist; // March - flower
      case 4: return Icons.wb_sunny; // April - sun
      case 5: return Icons.eco; // May - leaf
      case 6: return Icons.beach_access; // June - umbrella
      case 7: return Icons.wb_sunny_outlined; // July - sun
      case 8: return Icons.wb_sunny; // August - sun
      case 9: return Icons.spa; // September - leaf
      case 10: return Icons.emoji_nature; // October - pumpkin
      case 11: return Icons.cloudy_snowing; // November - autumn
      case 12: return Icons.ac_unit_outlined; // December - snowflake
      default: return Icons.calendar_month;
    }
  }

  List<MonthData> _extractMonths(List<dynamic> trainingDays, int targetYear) {
    if (trainingDays.isEmpty) return [];

    final monthCounts = <int, MonthData>{};
    
    for (final day in trainingDays) {
      if (day.date.year == targetYear) {
        final month = day.date.month as int;
        if (monthCounts.containsKey(month)) {
          monthCounts[month] = MonthData(
            month: month,
            sessionCount: monthCounts[month]!.sessionCount + 1,
            totalGames: monthCounts[month]!.totalGames + (day.totalGames as int),
          );
        } else {
          monthCounts[month] = MonthData(
            month: month,
            sessionCount: 1,
            totalGames: day.totalGames as int,
          );
        }
      }
    }

    final months = monthCounts.values.toList();
    
    // 按月份降序排列（最新的在上面）
    months.sort((a, b) => b.month.compareTo(a.month));
    
    return months;
  }
}

class MonthData {
  const MonthData({
    required this.month,
    required this.sessionCount,
    required this.totalGames,
  });

  final int month;
  final int sessionCount;
  final int totalGames;
}