import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/training_day_stats.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/training_day_equipment.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/enhanced_game_item.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/scoring_board.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_config.dart';
import 'package:bowlingarsenal_app/shared/utils/bowling/split_detector.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/tags/oval_tag.dart';
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

// 本地 UI 狀態：每局的資料（僅用於前端互動，不影響資料層）
class _GameUIState {
  _GameUIState()
      : frames = List<BowlingFrame>.generate(10, (_) => const BowlingFrame()),
        rolls = <int>[],
        rollStates = <List<bool>>[];
  final List<BowlingFrame> frames;
  final List<int> rolls; // 每球擊倒球數
  final List<List<bool>> rollStates; // 每球對應的球瓶狀態（第一球/第二球/第十格第三球）
}

class _TrainingDetailPageState extends ConsumerState<TrainingDetailPage>
    with SingleTickerProviderStateMixin {
  TrainingDetailTab _selectedTab = TrainingDetailTab.games;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final List<_GameUIState> _addedGames = [];

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

  void _addEmptyGame() {
    setState(() {
      _addedGames.add(_GameUIState());
    });
  }

  void _deleteLastGame() {
    if (_addedGames.isEmpty) return;
    setState(() {
      _addedGames.removeLast();
    });
  }

  Future<void> _onGameFrameTapped(int gameIndex, int frameIndex) async {
    if (gameIndex < 0 || gameIndex >= _addedGames.length) return;
    final game = _addedGames[gameIndex];
    final controller = PinSelectionController();
    // 第一球
    final first = await showDialog<List<bool>>(
      context: context,
      barrierDismissible: true,
      builder: (context) => PinSelectionDialog(
        controller: controller,
        isFirstRoll: true,
      ),
    );
    if (first == null) return;
    final firstKnocked = first.where((b) => b).length;

    // 若非 strike，第二球
    List<bool>? second;
    if (firstKnocked < 10 || frameIndex == 9) {
      final secondController = PinSelectionController();
      second = await showDialog<List<bool>>(
        context: context,
        barrierDismissible: true,
        builder: (context) => PinSelectionDialog(
          controller: secondController,
          initialPinState: first,
          isFirstRoll: false,
        ),
      );
    }

    // 第三球（第十格 且 前兩球為spare或strike）
    List<bool>? third;
    if (frameIndex == 9) {
      final totalFirstTwo = firstKnocked + (second?.where((b) => b).length ?? 0);
      final needThird = firstKnocked == 10 || totalFirstTwo >= 10;
      if (needThird) {
        final thirdController = PinSelectionController();
        third = await showDialog<List<bool>>(
          context: context,
          barrierDismissible: true,
          builder: (context) => PinSelectionDialog(
            controller: thirdController,
            isFirstRoll: true,
          ),
        );
      }
    }

    setState(() {
      // 僅記錄每球擊倒數量與狀態
      game.rolls.add(firstKnocked);
      game.rollStates.add(first);
      if (second != null) {
        game.rolls.add(second.where((b) => b).length);
        game.rollStates.add(second);
      }
      if (third != null) {
        game.rolls.add(third.where((b) => b).length);
        game.rollStates.add(third);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _calculateCurrentIndex(location);
    final theme = Theme.of(context);
    
    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context, theme),
        body: Column(
          children: [
            _buildHeader(theme),
            Expanded(
              child: _buildDataSection(theme),
            ),
          ],
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: currentIndex,
          onTap: (index) => _navigateToIndex(context, index),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Training Details',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 標題置中
          Center(
            child: Text(
              widget.trainingSession.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 資訊區 - 地點與日期（等寬，純文字）
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Alley',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.trainingSession.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Date',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('yyyy.MM.dd').format(widget.trainingSession.date),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 等寬的 Oil Pattern 與 Scoring Type
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Oil Pattern',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OvalTag(
                      text: widget.trainingSession.isHousePattern
                          ? 'House Pattern'
                          : '${widget.trainingSession.oilPatternName ?? 'Custom'}${widget.trainingSession.oilPatternLength != null ? ' (${widget.trainingSession.oilPatternLength}ft)' : ''}',
                      color: theme.colorScheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      horizontalPadding: 6,
                      verticalPadding: 3,
                      borderWidth: 1.2,
                      backgroundOpacity: 0.08,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Scoring Type',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OvalTag(
                      text: widget.trainingSession.scoringMethod,
                      color: Colors.orange,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      horizontalPadding: 6,
                      verticalPadding: 3,
                      borderWidth: 1.2,
                      backgroundOpacity: 0.08,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatternTypeChip(ThemeData theme) {
    // 假設從 training session 中獲取 pattern type
    // 這裡先用一個假設的值，您可能需要根據實際的資料模型調整
    final patternType = 'Current'; // 或者 'Traditional'
    final isTraditional = patternType.toLowerCase() == 'traditional';
    
    return OvalTag(
      text: patternType,
      color: isTraditional ? Colors.amber : Colors.green,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      horizontalPadding: 12,
      verticalPadding: 6,
      borderWidth: 1.5,
      backgroundOpacity: 0.1,
    );
  }

  Widget _buildTabSelector(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildArsenalStyleTab(
              theme,
              'Games',
              TrainingDetailTab.games,
              theme.colorScheme.primary,
            ),
          ),
          Expanded(
            child: _buildArsenalStyleTab(
              theme,
              'Equipment',
              TrainingDetailTab.equipment,
              Colors.orange,
            ),
          ),
          Expanded(
            child: _buildArsenalStyleTab(
              theme,
              'Statistics',
              TrainingDetailTab.statistics,
              Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  // 數據區：將分頁與內容合併在同一容器
  Widget _buildDataSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildArsenalStyleTab(
                    theme,
                    'Games',
                    TrainingDetailTab.games,
                    theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _buildArsenalStyleTab(
                    theme,
                    'Equipment',
                    TrainingDetailTab.equipment,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildArsenalStyleTab(
                    theme,
                    'Statistics',
                    TrainingDetailTab.statistics,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildTabContent(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArsenalStyleTab(
    ThemeData theme,
    String label,
    TrainingDetailTab tab,
    Color color,
  ) {
    final isSelected = _selectedTab == tab;
    
    return GestureDetector(
      onTap: () => _onTabChanged(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: _deleteLastGame,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.red.withOpacity(0.5), width: 1),
                    ),
                    child: Center(
                      child: Text(
                        '- Delete Games',
                        style: theme.textTheme.labelSmall?.copyWith(color: Colors.red, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: _addEmptyGame,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Center(
                      child: Text(
                        '+ Add Games',
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _addedGames.isEmpty
                ? _buildEmptyState(
                    theme,
                    Icons.sports,
                    'No games recorded',
                    'Games will appear here once recorded',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    reverse: true,
                    itemCount: _addedGames.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final displayIndex = _addedGames.length - 1 - index;
                      final game = _addedGames[displayIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6, bottom: 6),
                            child: Text('Game ${displayIndex + 1}', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.w600)),
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // 讓計分板視覺在容器內等比例縮放，參考 Developer Page 的一行設計
                              final width = constraints.maxWidth;
                              return SizedBox(
                                width: width,
                                child: ScoringBoard(
                                  title: null,
                                  frames: game.frames,
                                  onFrameTapped: (i) => _onGameFrameTapped(displayIndex, i),
                                  showThirdBallInTenthFrame: widget.trainingSession.scoringMethod.toLowerCase() != 'current',
                                  singleRow: true,
                                  frameAspectRatio: 0.78,
                                  removeOuterContainer: true,
                                  padding: EdgeInsets.zero,
                                  useGlowText: false,
                                  frameMargin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.0),
                                  frameBorderWidth: 1.0,
                                  frameBorderRadius: 4.0,
                                  showFrameShadow: false,
                                  showHeaderNumbers: true,
                                  headerBarHeight: 0.0,
                                  headerBarColor: null,
                                  tenthFrameFlex: 1,
                                  accentColor: theme.colorScheme.primary,
                                  isSplitPerFrame: List<bool>.generate(10, (i) {
                                    // 取得第一球的純狀態
                                    final List<bool> firstRoll = PinVisualizationHelper.getFramePinStates(
                                      rolls: game.rolls,
                                      rollStates: game.rollStates,
                                      frameIndex: i,
                                    );
                                    return SplitDetector.isSplit(firstRoll);
                                  }),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          // 倒瓶視覺列：顯示每格第一球的倒瓶
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                children: List.generate(10, (f) {
                                  final pins = PinVisualizationHelper.getFramePinStates(
                                    rolls: game.rolls,
                                    rollStates: game.rollStates,
                                    frameIndex: f,
                                  );
                                  final bool isFirst = f == 0;
                                  final bool isLast = f == 9;
                                  final EdgeInsets cellMargin = EdgeInsets.only(
                                    left: isFirst ? 0 : 0.5,
                                    right: isLast ? 0 : 0.5,
                                  );
                                  return Expanded(
                                    child: Padding(
                                      padding: cellMargin,
                                      child: LayoutBuilder(
                                        builder: (context, box) {
                                          return PinVisualizationWidget.withConfig(
                                            pinStates: pins,
                                            width: box.maxWidth,
                                            height: 40,
                                            config: PinVisualizationConfig.compact(),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          if (displayIndex == _addedGames.length - 1)
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(999),
                                    onTap: _deleteLastGame,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(color: Colors.red.withOpacity(0.5), width: 1),
                                      ),
                                      child: Center(
                                        child: Text('- Delete Games', style: theme.textTheme.labelSmall?.copyWith(color: Colors.red, fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(999),
                                    onTap: _addEmptyGame,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Center(
                                        child: Text('+ Add Games', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
          ),
        ],
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