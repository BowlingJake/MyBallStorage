import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/models/training_state.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';

enum DateSelectionLevel { year, month, day }

class TrainingHistorySlidingPage extends ConsumerStatefulWidget {
  const TrainingHistorySlidingPage({super.key});

  @override
  ConsumerState<TrainingHistorySlidingPage> createState() => _TrainingHistorySlidingPageState();
}

class _TrainingHistorySlidingPageState extends ConsumerState<TrainingHistorySlidingPage>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  DateSelectionLevel _currentLevel = DateSelectionLevel.year;
  int? _selectedYear;
  int? _selectedMonth;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _animateToNextLevel() {
    _slideController.forward().then((_) {
      setState(() {
        switch (_currentLevel) {
          case DateSelectionLevel.year:
            _currentLevel = DateSelectionLevel.month;
            break;
          case DateSelectionLevel.month:
            _currentLevel = DateSelectionLevel.day;
            break;
          case DateSelectionLevel.day:
            break;
        }
      });
      _slideController.reset();
    });
  }

  void _animateToPreviousLevel() {
    _slideController.forward().then((_) {
      setState(() {
        switch (_currentLevel) {
          case DateSelectionLevel.year:
            break;
          case DateSelectionLevel.month:
            _currentLevel = DateSelectionLevel.year;
            _selectedYear = null;
            break;
          case DateSelectionLevel.day:
            _currentLevel = DateSelectionLevel.month;
            _selectedMonth = null;
            break;
        }
      });
      _slideController.reset();
    });
  }

  String _getHeaderTitle() {
    switch (_currentLevel) {
      case DateSelectionLevel.year:
        return 'Training History';
      case DateSelectionLevel.month:
        return '$_selectedYear Training History';
      case DateSelectionLevel.day:
        return DateFormat('MMMM yyyy').format(DateTime(_selectedYear!, _selectedMonth!));
    }
  }

  bool _canGoBack() {
    return _currentLevel != DateSelectionLevel.year;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trainingControllerProvider);
    final theme = Theme.of(context);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _getHeaderTitle(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: Icon(_canGoBack() ? Icons.arrow_back : Icons.close),
            color: theme.colorScheme.onSurface,
            onPressed: () {
              if (_canGoBack()) {
                _animateToPreviousLevel();
              } else {
                context.go('/training');
              }
            },
            tooltip: _canGoBack() ? 'Back' : 'Close',
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: _buildCurrentLevelContent(state, theme),
        ),
      ),
    );
  }


  Widget _buildCurrentLevelContent(TrainingState state, ThemeData theme) {
    switch (_currentLevel) {
      case DateSelectionLevel.year:
        return _buildYearsContent(state, theme);
      case DateSelectionLevel.month:
        return _buildMonthsContent(state, theme);
      case DateSelectionLevel.day:
        return _buildDaysContent(state, theme);
    }
  }

  Widget _buildYearsContent(TrainingState state, ThemeData theme) {
    final years = _extractYears(state.trainingDays);

    if (years.isEmpty) {
      return _buildEmptyState(
        context: context,
        theme: theme,
        icon: Icons.history,
        title: 'No training history found',
        subtitle: 'Start training to build your history',
      );
    }

    return ListView.builder(
      key: const ValueKey('years'),
      padding: const EdgeInsets.all(16),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final yearData = years[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedYear = yearData.year;
                });
                _animateToNextLevel();
              },
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
                        Icons.calendar_month,
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
                            yearData.year.toString(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${yearData.sessionCount} training sessions',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthsContent(TrainingState state, ThemeData theme) {
    final months = _extractMonths(state.trainingDays, _selectedYear!);

    if (months.isEmpty) {
      return _buildEmptyState(
        context: context,
        theme: theme,
        icon: Icons.calendar_month_outlined,
        title: 'No training found for $_selectedYear',
        subtitle: 'Training sessions will appear here',
      );
    }

    return ListView.builder(
      key: const ValueKey('months'),
      padding: const EdgeInsets.all(16),
      itemCount: months.length,
      itemBuilder: (context, index) {
        final monthData = months[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedMonth = monthData.month;
                });
                _animateToNextLevel();
              },
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
                            DateFormat('MMMM').format(DateTime(_selectedYear!, monthData.month)),
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

  Widget _buildDaysContent(TrainingState state, ThemeData theme) {
    final days = _extractDays(state.trainingDays, _selectedYear!, _selectedMonth!);

    if (days.isEmpty) {
      final monthName = DateFormat('MMMM yyyy').format(DateTime(_selectedYear!, _selectedMonth!));
      return _buildEmptyState(
        context: context,
        theme: theme,
        icon: Icons.calendar_today_outlined,
        title: 'No training found for $monthName',
        subtitle: 'Training sessions will appear here',
      );
    }

    return ListView.builder(
      key: const ValueKey('days'),
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
                                dayData.trainingSession.title,
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
                    Row(
                      children: [
                        _buildStatCard(
                          theme,
                          '${dayData.trainingSession.totalGames}',
                          'Games',
                          Icons.sports,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          theme,
                          '${dayData.trainingSession.averageScore}',
                          'Avg Score',
                          Icons.trending_up,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          theme,
                          '${dayData.trainingSession.highestScore}',
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

  Widget _buildEmptyState({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
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

  IconData _getMonthIcon(int month) {
    switch (month) {
      case 1: return Icons.ac_unit;
      case 2: return Icons.favorite;
      case 3: return Icons.local_florist;
      case 4: return Icons.wb_sunny;
      case 5: return Icons.eco;
      case 6: return Icons.beach_access;
      case 7: return Icons.wb_sunny_outlined;
      case 8: return Icons.wb_sunny;
      case 9: return Icons.spa;
      case 10: return Icons.emoji_nature;
      case 11: return Icons.cloudy_snowing;
      case 12: return Icons.ac_unit_outlined;
      default: return Icons.calendar_month;
    }
  }

  List<YearData> _extractYears(List<TrainingDaySummary> trainingDays) {
    if (trainingDays.isEmpty) return [];

    final Map<int, int> yearCounts = {};

    for (final day in trainingDays) {
      final year = day.date.year;
      yearCounts[year] = (yearCounts[year] ?? 0) + 1;
    }

    final years = yearCounts.entries
        .map((entry) => YearData(year: entry.key, sessionCount: entry.value))
        .toList();

    years.sort((a, b) => b.year.compareTo(a.year));

    return years;
  }

  List<MonthData> _extractMonths(List<TrainingDaySummary> trainingDays, int targetYear) {
    if (trainingDays.isEmpty) return [];

    final monthCounts = <int, MonthData>{};

    for (final day in trainingDays) {
      if (day.date.year == targetYear) {
        final month = day.date.month;
        if (monthCounts.containsKey(month)) {
          monthCounts[month] = MonthData(
            month: month,
            sessionCount: monthCounts[month]!.sessionCount + 1,
            totalGames: monthCounts[month]!.totalGames + day.totalGames,
          );
        } else {
          monthCounts[month] = MonthData(
            month: month,
            sessionCount: 1,
            totalGames: day.totalGames,
          );
        }
      }
    }

    final months = monthCounts.values.toList();
    months.sort((a, b) => b.month.compareTo(a.month));

    return months;
  }

  List<DayData> _extractDays(List<TrainingDaySummary> trainingDays, int targetYear, int targetMonth) {
    if (trainingDays.isEmpty) return [];

    final days = <DayData>[];

    for (final day in trainingDays) {
      if (day.date.year == targetYear && day.date.month == targetMonth) {
        days.add(DayData(
          day: day.date.day,
          date: day.date,
          trainingSession: day,
        ));
      }
    }

    days.sort((a, b) => b.day.compareTo(a.day));

    return days;
  }
}

class YearData {
  const YearData({
    required this.year,
    required this.sessionCount,
  });

  final int year;
  final int sessionCount;
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

class DayData {
  const DayData({
    required this.day,
    required this.date,
    required this.trainingSession,
  });

  final int day;
  final DateTime date;
  final TrainingDaySummary trainingSession;
}
