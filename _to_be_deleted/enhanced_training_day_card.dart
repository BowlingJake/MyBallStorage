import 'package:bowlingarsenal_app/models/training_record.dart';
import 'package:bowlingarsenal_app/widgets/enhanced_action_button.dart';
import 'package:bowlingarsenal_app/widgets/training/components/enhanced_game_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

/// Enhanced Training Day Card with Professional Dark Tech Style
/// 具有專業深色科技風格的增強訓練日卡片
class EnhancedTrainingDayCard extends StatefulWidget {
  const EnhancedTrainingDayCard({
    required this.summary,
    super.key,
    this.onTap,
    this.onDelete,
    this.onAddGame,
    this.onEdit,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
    this.onGameTap,
    this.onGameDelete,
  });
  final TrainingDaySummary summary;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onAddGame;
  final VoidCallback? onEdit;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final Function(GameRecord)? onGameTap;
  final Function(GameRecord)? onGameDelete;

  @override
  State<EnhancedTrainingDayCard> createState() =>
      _EnhancedTrainingDayCardState();
}

class _EnhancedTrainingDayCardState extends State<EnhancedTrainingDayCard>
    with TickerProviderStateMixin {
  late AnimationController _expansionController;
  late AnimationController _pulseController;
  late AnimationController _scanController;

  late Animation<double> _expansionAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;

  bool _isExpanded = false;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _expansionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _expansionAnimation = CurvedAnimation(
      parent: _expansionController,
      curve: Curves.easeInOutCubic,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _scanController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _expansionController.dispose();
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    if (!widget.isSelectionMode) {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _expansionController.forward();
        } else {
          _expansionController.reverse();
        }
      });
      HapticFeedback.lightImpact();
    }
  }

  void _handleCardTap() {
    if (widget.isSelectionMode) {
      widget.onSelectionChanged?.call(!widget.isSelected);
      HapticFeedback.selectionClick();
    } else {
      _toggleExpanded();
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _scanAnimation]),
        builder: (context, child) {
          return _buildEnhancedCard(theme);
        },
      ),
    );
  }

  Widget _buildEnhancedCard(ThemeData theme) {
    return GestureDetector(
      onTap: _handleCardTap,
      onLongPress: () {
        if (!widget.isSelectionMode && widget.onEdit != null) {
          HapticFeedback.heavyImpact();
          widget.onEdit!();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        decoration: BoxDecoration(
          color:
              widget.isSelected
                  ? theme.colorScheme.primary.withOpacity(0.15)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                widget.isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withOpacity(0.3),
            width: widget.isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            // 主光暈效果
            BoxShadow(
              color:
                  widget.isSelected
                      ? theme.colorScheme.primary.withOpacity(0.3)
                      : theme.colorScheme.primary.withOpacity(0.1),
              blurRadius: widget.isSelected ? 20 : 12,
              spreadRadius: widget.isSelected ? 3 : 1,
            ),
            // 掃描線效果
            if (!widget.isSelectionMode)
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(
                  _scanAnimation.value * 0.1,
                ),
                blurRadius: 8 + (_scanAnimation.value * 4),
                spreadRadius: _scanAnimation.value * 2,
              ),
            // 深度陰影
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            children: [
              // 主要內容區域
              _buildMainContent(theme),

              // 展開內容
              AnimatedBuilder(
                animation: _expansionAnimation,
                builder: (context, child) {
                  return ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _expansionAnimation.value,
                      child: _buildExpandedContent(theme),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 頭部區域
          _buildHeader(theme),

          const SizedBox(height: 16),

          // 統計資訊區域
          _buildQuickStats(theme),

          const SizedBox(height: 16),

          // 底部資訊區域
          _buildInfoRow(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        // 選擇框（選擇模式時顯示）
        if (widget.isSelectionMode) ...[
          _buildSelectionCheckbox(theme),
          const SizedBox(width: 16),
        ],

        // 標題和日期
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.summary.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Iconsax.calendar,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM dd, yyyy').format(widget.summary.date),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 遊戲數量徽章
        _buildGamesBadge(theme),

        // 控制按鈕組
        if (!widget.isSelectionMode) ...[
          const SizedBox(width: 12),
          _buildControlButtons(theme),
        ],
      ],
    );
  }

  Widget _buildSelectionCheckbox(ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color:
            widget.isSelected ? theme.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              widget.isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.5),
          width: 2,
        ),
      ),
      child:
          widget.isSelected
              ? const Icon(Icons.check, size: 18, color: Colors.white)
              : null,
    );
  }

  Widget _buildGamesBadge(ThemeData theme) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              '${widget.summary.totalGames} Games',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButtons(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 編輯按鈕
        if (widget.onEdit != null)
          _buildControlButton(
            icon: Iconsax.edit,
            color: Colors.blue,
            onTap: widget.onEdit!,
            tooltip: 'Edit Training Day',
          ),

        const SizedBox(width: 8),

        // 刪除按鈕
        if (widget.onDelete != null)
          _buildControlButton(
            icon: Iconsax.trash,
            color: Colors.red,
            onTap: widget.onDelete!,
            tooltip: 'Delete Training Day',
          ),

        const SizedBox(width: 8),

        // 展開指示器
        _buildControlButton(
          icon:
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: theme.colorScheme.primary,
          onTap: _toggleExpanded,
          tooltip: _isExpanded ? 'Collapse' : 'Expand',
          rotation: _isExpanded ? 0.5 : 0.0,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
    double? rotation,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            borderRadius: BorderRadius.circular(16),
            child:
                rotation != null
                    ? AnimatedRotation(
                      turns: rotation,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        icon,
                        size: 18,
                        color: color.withOpacity(0.8),
                      ),
                    )
                    : Icon(icon, size: 18, color: color.withOpacity(0.8)),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // 平均分
          Expanded(
            child: _buildStatItem(
              theme,
              Iconsax.chart_21,
              widget.summary.averageScore.toStringAsFixed(0),
              'AVG',
              theme.colorScheme.primary,
            ),
          ),

          // 最高分
          Expanded(
            child: _buildStatItem(
              theme,
              Iconsax.arrow_up,
              '${widget.summary.highestScore}',
              'HIGH',
              Colors.green,
            ),
          ),

          // Strike %
          Expanded(
            child: _buildStatItem(
              theme,
              Iconsax.direct_up,
              '${widget.summary.strikePercentage.toStringAsFixed(0)}%',
              'STR',
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme) {
    return Row(
      children: [
        // 球館
        Expanded(
          child: _buildInfoItem(theme, Iconsax.location, widget.summary.center),
        ),

        // 油圖
        Expanded(
          child: _buildInfoItem(
            theme,
            Iconsax.drop,
            widget.summary.oilPatternDisplay,
          ),
        ),

        // 計分方式
        Expanded(
          child: _buildInfoItem(
            theme,
            Iconsax.calculator,
            widget.summary.scoringMethod,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(ThemeData theme, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: theme.colorScheme.primary.withOpacity(0.7)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent(ThemeData theme) {
    if (!_isExpanded) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          // 分隔線
          Container(
            height: 1,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  theme.colorScheme.primary.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // 標籤頁
          _buildTabBar(theme),

          const SizedBox(height: 16),

          // 標籤內容
          _buildTabContent(theme),

          const SizedBox(height: 16),

          // 新增遊戲按鈕
          if (widget.onAddGame != null)
            SizedBox(
              width: double.infinity,
              child: EnhancedActionButton(
                text: 'Add New Game',
                icon: Iconsax.add_circle,
                color: theme.colorScheme.primary,
                onPressed: widget.onAddGame!,
                isPrimary: true,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          _buildTab(theme, 0, 'Games', Iconsax.game),
          _buildTab(theme, 1, 'Equipment', Iconsax.box),
        ],
      ),
    );
  }

  Widget _buildTab(ThemeData theme, int index, String label, IconData icon) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTabIndex = index);
          HapticFeedback.selectionClick();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? theme.colorScheme.primary.withOpacity(0.2)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border:
                isSelected
                    ? Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    )
                    : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? theme.colorScheme.primary : Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isSelected ? theme.colorScheme.primary : Colors.white70,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(ThemeData theme) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildGamesContent(theme);
      case 1:
        return _buildEquipmentContent(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGamesContent(ThemeData theme) {
    if (widget.summary.games.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            const Icon(Iconsax.game, size: 48, color: Colors.white30),
            const SizedBox(height: 12),
            Text(
              'No games recorded yet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children:
          widget.summary.games.asMap().entries.map((entry) {
            final index = entry.key;
            final game = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < widget.summary.games.length - 1 ? 8 : 0,
              ),
              child: EnhancedGameItem(
                game: game,
                theme: theme,
                onTap: () => widget.onGameTap?.call(game),
                onDelete: () => widget.onGameDelete?.call(game),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildEquipmentContent(ThemeData theme) {
    final equipmentUsage = widget.summary.equipmentUsage;

    if (equipmentUsage.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            const Icon(Iconsax.box, size: 48, color: Colors.white30),
            const SizedBox(height: 12),
            Text(
              'No equipment data recorded',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          equipmentUsage.entries.map((entry) {
            final ball = entry.key;
            final games = entry.value;

            // 解析品牌顏色
            Color brandColor;
            try {
              brandColor = Color(
                int.parse(ball.brandColor.replaceFirst('#', '0xFF')),
              );
            } catch (e) {
              brandColor = theme.colorScheme.primary;
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: brandColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: brandColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ball.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${games.length})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brandColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
