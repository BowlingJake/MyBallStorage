import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/training_record.dart';
import '../app_standard_button.dart';
import 'components/training_day_header.dart';
import 'components/training_day_stats.dart';
import 'components/game_list_item.dart';

// 訓練日摘要卡片 - 支援收合展開的分層設計
class TrainingDaySummaryCard extends StatefulWidget {
  final TrainingDaySummary summary;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onAddGame;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final Function(GameRecord)? onGameTap;
  final Function(GameRecord)? onGameDelete;

  const TrainingDaySummaryCard({
    Key? key,
    required this.summary,
    this.onTap,
    this.onDelete,
    this.onAddGame,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
    this.onGameTap,
    this.onGameDelete,
  }) : super(key: key);

  @override
  State<TrainingDaySummaryCard> createState() => _TrainingDaySummaryCardState();
}

class _TrainingDaySummaryCardState extends State<TrainingDaySummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    if (!widget.isSelectionMode) {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          if (widget.isSelectionMode) {
            widget.onSelectionChanged?.call(!widget.isSelected);
          } else {
            _toggleExpanded();
          }
          widget.onTap?.call();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withOpacity(0.5),
                width: widget.isSelected ? 2.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isSelected
                      ? theme.colorScheme.primary.withOpacity(0.2)
                      : theme.colorScheme.primary.withOpacity(0.1),
                  blurRadius: widget.isSelected ? 16 : 12,
                  offset: Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 頭部：複選框、日期、遊戲數量
                    TrainingDayHeader(
                      summary: widget.summary,
                      isSelectionMode: widget.isSelectionMode,
                      isSelected: widget.isSelected,
                      theme: theme,
                    ),
                    
                    SizedBox(height: 12),

                    // 統計摘要
                    TrainingDayStats(
                      summary: widget.summary,
                      theme: theme,
                    ),

                    SizedBox(height: 8),

                    // 地點和油型
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            widget.summary.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.opacity,
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            widget.summary.oilPatternDisplay,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // 展開內容：遊戲列表
                    if (!widget.isSelectionMode)
                      ClipRect(
                        child: SizeTransition(
                          sizeFactor: _animation,
                          axisAlignment: -1,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Column(
                              children: [
                                // 分隔線
                                Container(
                                  height: 1,
                                  margin: EdgeInsets.only(bottom: 16),
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

                                // 遊戲列表
                                if (widget.summary.games.isNotEmpty) ...[
                                  ...widget.summary.games.map((game) => 
                                    GameListItem(
                                      game: game,
                                      theme: theme,
                                      onGameTap: widget.onGameTap,
                                      onGameDelete: widget.onGameDelete,
                                    )),
                                  SizedBox(height: 12),
                                ],

                                // 新增遊戲按鈕
                                AppStandardButton(
                                  text: "Add Game",
                                  icon: Icons.add_circle_outline,
                                  onPressed: widget.onAddGame ?? () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                // 右側控制按鈕（非選擇模式時顯示）
                if (!widget.isSelectionMode)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // 刪除按鈕
                        if (widget.onDelete != null)
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: widget.onDelete,
                                borderRadius: BorderRadius.circular(18),
                                child: Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: Colors.red.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 8),
                        // 展開/收起指示器
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: Duration(milliseconds: 300),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 