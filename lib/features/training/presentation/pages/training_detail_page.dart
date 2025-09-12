import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/training_day_stats.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/training_day_equipment.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/enhanced_game_item.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:intl/intl.dart';

enum TrainingDetailTab { games, equipment, statistics }

class TrainingDetailPage extends ConsumerStatefulWidget {
  final String sessionId;
  final TrainingDaySummary trainingSession;

  const TrainingDetailPage({
    required this.sessionId,
    required this.trainingSession,
    super.key,
  });

  @override
  ConsumerState<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends ConsumerState<TrainingDetailPage>
    with SingleTickerProviderStateMixin {
  TrainingDetailTab _selectedTab = TrainingDetailTab.games;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabChanged(TrainingDetailTab tab) {
    if (_selectedTab != tab) {
      setState(() {
        _selectedTab = tab;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context, theme),
        body: Column(
          children: [
            _buildHeader(theme),
            const SizedBox(height: 20),
            _buildTabSelector(theme),
            const SizedBox(height: 20),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildTabContent(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      centerTitle: true,
      title: Text(
        widget.trainingSession.title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: theme.colorScheme.onSurface,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/training');
          }
        },
        tooltip: 'Back',
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // 日期和地點
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(widget.trainingSession.date),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                widget.trainingSession.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  widget.trainingSession.oilPatternDisplay,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildTabButton(
            theme,
            'Games',
            Icons.sports,
            TrainingDetailTab.games,
          ),
          _buildTabButton(
            theme,
            'Equipment',
            Icons.sports_basketball,
            TrainingDetailTab.equipment,
          ),
          _buildTabButton(
            theme,
            'Statistics',
            Icons.analytics,
            TrainingDetailTab.statistics,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    ThemeData theme,
    String label,
    IconData icon,
    TrainingDetailTab tab,
  ) {
    final isSelected = _selectedTab == tab;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabChanged(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(ThemeData theme) {
    switch (_selectedTab) {
      case TrainingDetailTab.games:
        return _buildGamesTab(theme);
      case TrainingDetailTab.equipment:
        return _buildEquipmentTab(theme);
      case TrainingDetailTab.statistics:
        return _buildStatisticsTab(theme);
    }
  }

  Widget _buildGamesTab(ThemeData theme) {
    if (widget.trainingSession.games.isEmpty) {
      return _buildEmptyState(
        theme,
        Icons.sports,
        'No games recorded',
        'Games will appear here once recorded',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: widget.trainingSession.games.length,
      itemBuilder: (context, index) {
        final game = widget.trainingSession.games[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: EnhancedGameItem(
            game: game,
            theme: theme,
            onTap: () {
              // TODO: Navigate to game detail or scoring dialog
            },
            onDelete: () {
              // TODO: Handle game deletion
            },
          ),
        );
      },
    );
  }

  Widget _buildEquipmentTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TrainingDayEquipment(
        summary: widget.trainingSession,
        theme: theme,
      ),
    );
  }

  Widget _buildStatisticsTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TrainingDayStats(
        summary: widget.trainingSession,
        theme: theme,
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeData theme,
    IconData icon,
    String title,
    String subtitle,
  ) {
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
}