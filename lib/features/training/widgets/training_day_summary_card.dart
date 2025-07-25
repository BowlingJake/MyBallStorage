import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/training_day_header.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/training_day_info_row.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/training_day_tab_view.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';

class TrainingDaySummaryCard extends StatefulWidget {
  const TrainingDaySummaryCard({
    required this.summary,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onViewRecap,
    this.onAddGame,
    this.onGameTap,
    this.onGameDelete,
    super.key,
  });

  /// 訓練日摘要數據
  final TrainingDaySummary summary;

  /// 是否處於選擇模式
  final bool isSelectionMode;

  /// 是否被選中
  final bool isSelected;

  /// 選擇狀態改變回調
  final ValueChanged<bool>? onSelectionChanged;

  /// 點擊卡片回調
  final VoidCallback? onTap;

  /// 編輯按鈕點擊回調
  final VoidCallback? onEdit;

  /// 刪除按鈕點擊回調
  final VoidCallback? onDelete;

  /// 查看今日回顧按鈕點擊回調
  final VoidCallback? onViewRecap;

  /// 新增遊戲按鈕點擊回調
  final VoidCallback? onAddGame;

  /// 點擊遊戲卡片回調
  final Function(GameRecord)? onGameTap;

  /// 刪除遊戲卡片回調
  final void Function(GameRecord)? onGameDelete;

  @override
  State<TrainingDaySummaryCard> createState() => _TrainingDaySummaryCardState();
}

class _TrainingDaySummaryCardState extends State<TrainingDaySummaryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _isExpanded = false;
  InfoVisibility _infoVisibility = InfoVisibility.visible;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
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
    if (widget.isSelectionMode) {
      return;
    }
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          if (widget.isSelectionMode) {
            widget.onSelectionChanged?.call(!widget.isSelected);
          } else {
            _toggleExpanded();
          }
          widget.onTap?.call();
        },
        onLongPress: widget.onEdit,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  widget.isSelected
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    widget.isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.5),
                width: widget.isSelected ? 2.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      widget.isSelected
                          ? theme.colorScheme.primary.withOpacity(0.2)
                          : theme.colorScheme.primary.withOpacity(0.1),
                  blurRadius: widget.isSelected ? 16 : 12,
                  offset: const Offset(0, 4),
                ),
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
                // 使用新的頭部組件
                TrainingDayHeader(
                  summary: widget.summary,
                  isSelectionMode: widget.isSelectionMode,
                  isSelected: widget.isSelected,
                  infoVisibility: _infoVisibility,
                  isExpanded: _isExpanded,
                  onSelectionChanged: widget.onSelectionChanged,
                  onDelete: widget.onDelete,
                  onVisibilityTap: () {
                    setState(() {
                      _infoVisibility =
                          _infoVisibility == InfoVisibility.visible
                              ? InfoVisibility.hidden
                              : InfoVisibility.visible;
                    });
                  },
                  onExpandTap: _toggleExpanded,
                ),

                const SizedBox(height: 12),

                // 使用新的標籤頁視圖組件和資訊行組件
                AnimatedCrossFade(
                  firstChild: Column(
                    children: [
                      TrainingDayTabView(
                        summary: widget.summary,
                        onGameTap: widget.onGameTap,
                        onGameDelete: widget.onGameDelete,
                      ),
                      const SizedBox(height: 16), // 整個頁籤區域與下方資訊的間距
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                  crossFadeState:
                      _infoVisibility == InfoVisibility.visible
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),

                // 使用新的資訊行組件
                TrainingDayInfoRow(summary: widget.summary),

                // 展開內容：額外的操作按鈕（如果需要的話）
                if (!widget.isSelectionMode && _isExpanded)
                  ClipRect(
                    child: SizeTransition(
                      sizeFactor: _animation,
                      axisAlignment: -1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            // 分隔線
                            Container(
                              height: 1,
                              margin: const EdgeInsets.only(bottom: 16),
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

                            // 額外操作區域
                            Row(
                              children: [
                                Expanded(
                                  child: AppStandardButton(
                                    text: 'View today\'s recap',
                                    icon: Icons.analytics_outlined,
                                    onPressed: widget.onViewRecap ?? () {},
                                    height: 32,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppStandardButton(
                                    text: 'Add games',
                                    icon: Icons.add_chart,
                                    onPressed: widget.onAddGame ?? () {},
                                    height: 32,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
}
