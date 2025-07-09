import 'package:bowlingarsenal_app/widgets/app_standard_button.dart';
import 'package:bowlingarsenal_app/widgets/training/add_games_dialog.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

// 訓練記錄數據模型
class TrainingSession {
  TrainingSession({
    required this.id,
    required this.title,
    required this.date,
    required this.center,
    required this.isHousePattern,
    required this.scoringMethod, // 新增計分方式, required this.createdAt, this.oilPatternName,
    this.oilPatternLength,
  });
  final String id;
  final String title;
  final DateTime date;
  final String center;
  final String? oilPatternName;
  final String? oilPatternLength;
  final bool isHousePattern;
  final String scoringMethod; // 新增計分方式
  final DateTime createdAt;
}

// 訓練記錄卡片組件 - Professional Dark Glass 風格
class TrainingSessionCard extends StatefulWidget {
  const TrainingSessionCard({
    required this.session,
    super.key,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.onAddGames,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
  });
  final TrainingSession session;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onAddGames;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;

  @override
  State<TrainingSessionCard> createState() => _TrainingSessionCardState();
}

class _TrainingSessionCardState extends State<TrainingSessionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

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

  String _getOilPatternDisplay() {
    if (widget.session.isHousePattern) {
      return 'House Pattern';
    } else if (widget.session.oilPatternName?.isNotEmpty == true ||
        widget.session.oilPatternLength?.isNotEmpty == true) {
      final name = widget.session.oilPatternName ?? '';
      final length = widget.session.oilPatternLength ?? '';
      if (name.isNotEmpty && length.isNotEmpty) {
        return '$name (${length}ft)';
      } else if (name.isNotEmpty) {
        return name;
      } else if (length.isNotEmpty) {
        return '${length}ft';
      }
    }
    return 'Custom Pattern';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 限制標題在20字以內
    final displayTitle =
        widget.session.title.length > 20
            ? '${widget.session.title.substring(0, 20)}...'
            : widget.session.title;

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // Professional Dark Glass 風格 - 透明背景
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
              // 微光效果
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
                // 頂部區域：複選框、標題和控制按鈕
                Row(
                  children: [
                    // 複選框（選擇模式時顯示）
                    if (widget.isSelectionMode) ...[
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color:
                              widget.isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color:
                                widget.isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withOpacity(
                                      0.5,
                                    ),
                            width: 2,
                          ),
                        ),
                        child:
                            widget.isSelected
                                ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: theme.colorScheme.onPrimary,
                                )
                                : null,
                      ),
                      const SizedBox(width: 12),
                    ],

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 標題
                          Text(
                            displayTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // 日期和地點
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat(
                                  'yyyy.MM.dd',
                                ).format(widget.session.date),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  widget.session.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // 油型信息
                          Row(
                            children: [
                              Icon(
                                Iconsax.drop,
                                size: 14,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _getOilPatternDisplay(),
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // 右側控制按鈕（非選擇模式時顯示）
                    if (!widget.isSelectionMode)
                      Column(
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
                          const SizedBox(height: 8),
                          // 展開/收起指示器
                          AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: 24,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // 展開內容（僅在非選擇模式且展開時顯示）
                if (!widget.isSelectionMode)
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
                            // 按鈕區域 - 使用 AppStandardButton
                            Row(
                              children: [
                                // Add Games 按鈕
                                Expanded(
                                  child: AppStandardButton(
                                    text: 'Add Games',
                                    icon: Icons.add_circle_outline,
                                    onPressed: () async {
                                      final result = await showDialog(
                                        context: context,
                                        builder:
                                            (context) => AddGamesDialog(
                                              trainingId: widget.session.id,
                                              scoringMethod:
                                                  widget.session.scoringMethod,
                                            ),
                                      );
                                      if (result != null &&
                                          widget.onAddGames != null) {
                                        widget.onAddGames!();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Delete Games 按鈕 (disabled)
                                Expanded(
                                  child: AppStandardButton(
                                    text: 'Delete Games',
                                    icon: Icons.remove_circle_outline,
                                    onPressed: () {
                                      // TODO: 實現刪除遊戲功能
                                    },
                                    enabled: false,
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
