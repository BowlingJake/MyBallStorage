import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/training_record.dart';
import '../app_standard_button.dart';
import 'components/training_day_equipment.dart';
import 'components/training_day_stats.dart';
import 'components/game_list_item.dart';

// 資訊顯示狀態枚舉
enum InfoVisibility {
  hidden,   // 隱藏
  visible,  // 顯示
}

// 分頁類型枚舉
enum TabType {
  games,       // 遊戲列表頁籤  
  equipment,   // 球具頁籤
  statistics,  // 統計頁籤
}

// 訓練日摘要卡片 - 支援收合展開的分層設計
class TrainingDaySummaryCard extends StatefulWidget {
  final TrainingDaySummary summary;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onAddGame;
  final VoidCallback? onEdit; // 新增編輯回調
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
    this.onEdit, // 新增編輯回調
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
  InfoVisibility _infoVisibility = InfoVisibility.visible; // 資訊顯示狀態
  TabType _selectedTab = TabType.games; // 當前選中的分頁，默認顯示遊戲列表

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

  /// 構建統一樣式的控制按鈕
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
        width: 32, // 恢復按鈕尺寸，讓它們更容易點擊
        height: 32, // 恢復按鈕尺寸，讓它們更容易點擊
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: rotation != null
                ? AnimatedRotation(
                    turns: rotation,
                    duration: Duration(milliseconds: 300),
                    child: Icon(
                      icon,
                      size: 18, // 恢復圖標尺寸
                      color: color.withOpacity(0.8),
                    ),
                  )
                : Icon(
                    icon,
                    size: 18, // 恢復圖標尺寸
                    color: color.withOpacity(0.8),
                  ),
          ),
        ),
      ),
    );
  }

  /// 構建底部資訊區域（等比例分配）
  Widget _buildInfoRow(ThemeData theme) {
    return Row(
      children: [
        // 日期區域 (33.33%)
        Expanded(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today,
                size: 12,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  DateFormat('yyyy.MM.dd', 'en_US').format(widget.summary.date),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        
        // 地點區域 (33.33%)
        Expanded(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  widget.summary.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        
        // 油圖區域 (33.33%)
        Expanded(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.opacity,
                size: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  widget.summary.oilPatternDisplay,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
        onLongPress: () {
          if (!widget.isSelectionMode && widget.onEdit != null) {
            widget.onEdit!();
          }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 頭部區域：標題和控制按鈕
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 複選框（選擇模式時顯示）
                    if (widget.isSelectionMode) ...[
                      Container(
                        width: 24,
                        height: 24,
                        margin: EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: widget.isSelected
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: widget.isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: widget.isSelected
                            ? Icon(
                                Icons.check,
                                size: 16,
                                color: theme.colorScheme.onPrimary,
                              )
                            : null,
                      ),
                      SizedBox(width: 12),
                    ],
                    
                    // 標題區域
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 標題
                          Text(
                            widget.summary.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 16, // 減小標題字體
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // 限制標題為一行
                          ),
                        ],
                      ),
                    ),
                    
                    // 遊戲數量徽章
                    Container(
                      margin: EdgeInsets.only(top: 2, left: 8, right: 4),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${widget.summary.totalGames} games',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    
                    // 控制按鈕組（非選擇模式時顯示）
                    if (!widget.isSelectionMode)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 顯示/隱藏按鈕
                          _buildControlButton(
                            icon: _infoVisibility == InfoVisibility.visible 
                              ? Icons.visibility 
                              : Icons.visibility_off,
                            color: theme.colorScheme.primary,
                            onTap: () {
                              setState(() {
                                _infoVisibility = _infoVisibility == InfoVisibility.visible 
                                  ? InfoVisibility.hidden 
                                  : InfoVisibility.visible;
                              });
                            },
                            tooltip: _infoVisibility == InfoVisibility.visible 
                              ? '隱藏資訊' 
                              : '顯示資訊',
                          ),
                          SizedBox(width: 8), // 恢復間距
                          // 刪除按鈕
                          if (widget.onDelete != null)
                            _buildControlButton(
                              icon: Icons.delete_outline,
                              color: Colors.red,
                              onTap: widget.onDelete!,
                              tooltip: '刪除訓練日',
                            ),
                          SizedBox(width: 8), // 恢復間距
                          // 展開/收起指示器
                          _buildControlButton(
                            icon: Icons.keyboard_arrow_down,
                            color: theme.colorScheme.primary,
                            onTap: _toggleExpanded,
                            tooltip: _isExpanded ? '收起' : '展開',
                            rotation: _isExpanded ? 0.5 : 0,
                          ),
                        ],
                      ),
                  ],
                ),
                
                SizedBox(height: 12),

                // 資訊區域（根據模式顯示不同內容）
                _buildInfoContent(theme),

                // 日期、地點和油型（等比例排列）
                _buildInfoRow(theme),

                // 展開內容：額外的操作按鈕（如果需要的話）
                if (!widget.isSelectionMode && _isExpanded)
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

                            // 額外操作區域
                            Row(
                              children: [
                                Expanded(
                                  child: AppStandardButton(
                                    text: "Edit Training Day",
                                    icon: Icons.edit,
                                    onPressed: widget.onEdit ?? () {},
                                    height: 32,
                                    isPrimary: false,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: AppStandardButton(
                                    text: "Add games",
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

  // 根據顯示狀態構建資訊內容
  Widget _buildInfoContent(ThemeData theme) {
    return AnimatedCrossFade(
      firstChild: Column(
        children: [
          _buildVisibleContent(theme),
          SizedBox(height: 16), // 整個頁籤區域與下方資訊的間距
        ],
      ),
      secondChild: SizedBox.shrink(),
      crossFadeState: _infoVisibility == InfoVisibility.visible
          ? CrossFadeState.showFirst 
          : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 300),
    );
  }

  // 構建可見內容（選中分頁與內容區域一體化邊框）
  Widget _buildVisibleContent(ThemeData theme) {
    return CustomPaint(
      painter: TabContentBorderPainter(
        selectedTab: _selectedTab,
        primaryColor: theme.colorScheme.primary,
      ),
      child: Column(
        children: [
          // 分頁標籤行
          _buildIntegratedTabHeader(theme),
          // 分頁內容（緊湊的 padding）
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: _buildTabContent(theme),
          ),
          SizedBox(height: 4), // 恢復內部小間距
        ],
      ),
    );
  }

  // 構建一體化分頁標籤標題
  Widget _buildIntegratedTabHeader(ThemeData theme) {
    return Container(
      height: 42, // 增加高度以獲得更好的視覺效果
      child: Row(
        children: [
          // Games 分頁
          Expanded(
            child: _buildIntegratedTab(
              theme,
              TabType.games,
              null, // 移除圖標
              'Games',
              _selectedTab == TabType.games,
            ),
          ),
          // Equipment 分頁
          Expanded(
            child: _buildIntegratedTab(
              theme,
              TabType.equipment,
              null, // 移除圖標
              'Equipment', // 改回 Equipment
              _selectedTab == TabType.equipment,
            ),
          ),
          // Statistics 分頁
          Expanded(
            child: _buildIntegratedTab(
              theme,
              TabType.statistics,
              null, // 移除圖標
              'Statistics', // 改回 Statistics
              _selectedTab == TabType.statistics,
            ),
          ),
        ],
      ),
    );
  }

    // 構建一體化分頁標籤（只顯示文字）
  Widget _buildIntegratedTab(ThemeData theme, TabType tabType, IconData? icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tabType;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 42,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected 
                ? theme.colorScheme.primary 
                : theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 12, // 增大字體，因為沒有圖標了
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// 根據選擇的分頁來構建對應的內容
  Widget _buildTabContent(ThemeData theme) {
    switch (_selectedTab) {
      case TabType.games:
        return _buildGamesList(theme);
      case TabType.equipment:
        return TrainingDayEquipment(summary: widget.summary, theme: theme);
      case TabType.statistics:
        return TrainingDayStats(summary: widget.summary, theme: theme);
      default:
        return SizedBox.shrink();
    }
  }

  /// 構建遊戲列表
  Widget _buildGamesList(ThemeData theme) {
    final games = widget.summary.games;

    if (games.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Icon(
              Icons.format_list_numbered,
              size: 40,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            SizedBox(height: 8),
            Text(
              "No games recorded for this day yet.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    // 當有遊戲記錄時，顯示列表
    return Column(children: [
      ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return GameListItem(
            game: game,
            theme: theme,
            onGameTap: (g) => widget.onGameTap?.call(g),
            onGameDelete: (g) => widget.onGameDelete?.call(g),
          );
        },
      ),
    ]);
  }
}

// 自定義繪製器 - 繪製分頁與內容一體化邊框
class TabContentBorderPainter extends CustomPainter {
  final TabType selectedTab;
  final Color primaryColor;
  
  TabContentBorderPainter({
    required this.selectedTab,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final tabHeight = 42.0; // 更新分頁高度
    final thirdWidth = size.width / 3;
    final radius = 8.0;

    // 根據選中的分頁繪製不同的邊框路徑
    switch (selectedTab) {
      case TabType.games:
        // Games 分頁選中 - 左側分頁與內容連接
        path.moveTo(0, tabHeight);
        path.lineTo(0, radius);
        path.quadraticBezierTo(0, 0, radius, 0);
        path.lineTo(thirdWidth - radius, 0);
        path.quadraticBezierTo(thirdWidth, 0, thirdWidth, radius);
        path.lineTo(thirdWidth, tabHeight - radius);
        path.quadraticBezierTo(thirdWidth, tabHeight, thirdWidth + radius, tabHeight);
        path.lineTo(size.width - radius, tabHeight);
        path.quadraticBezierTo(size.width, tabHeight, size.width, tabHeight + radius);
        path.lineTo(size.width, size.height - radius);
        path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
        path.lineTo(radius, size.height);
        path.quadraticBezierTo(0, size.height, 0, size.height - radius);
        path.close();
        break;
        
      case TabType.equipment:
        // Equipment 分頁選中 - 中間分頁與內容連接
        path.moveTo(0, tabHeight + radius);
        path.quadraticBezierTo(0, tabHeight, radius, tabHeight);
        path.lineTo(thirdWidth - radius, tabHeight);
        path.quadraticBezierTo(thirdWidth, tabHeight, thirdWidth, tabHeight - radius);
        path.lineTo(thirdWidth, radius);
        path.quadraticBezierTo(thirdWidth, 0, thirdWidth + radius, 0);
        path.lineTo(thirdWidth * 2 - radius, 0);
        path.quadraticBezierTo(thirdWidth * 2, 0, thirdWidth * 2, radius);
        path.lineTo(thirdWidth * 2, tabHeight - radius);
        path.quadraticBezierTo(thirdWidth * 2, tabHeight, thirdWidth * 2 + radius, tabHeight);
        path.lineTo(size.width - radius, tabHeight);
        path.quadraticBezierTo(size.width, tabHeight, size.width, tabHeight + radius);
        path.lineTo(size.width, size.height - radius);
        path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
        path.lineTo(radius, size.height);
        path.quadraticBezierTo(0, size.height, 0, size.height - radius);
        path.close();
        break;
        
      case TabType.statistics:
        // Statistics 分頁選中 - 右側分頁與內容連接
        path.moveTo(0, tabHeight + radius);
        path.quadraticBezierTo(0, tabHeight, radius, tabHeight);
        path.lineTo(thirdWidth * 2 - radius, tabHeight);
        path.quadraticBezierTo(thirdWidth * 2, tabHeight, thirdWidth * 2, tabHeight - radius);
        path.lineTo(thirdWidth * 2, radius);
        path.quadraticBezierTo(thirdWidth * 2, 0, thirdWidth * 2 + radius, 0);
        path.lineTo(size.width - radius, 0);
        path.quadraticBezierTo(size.width, 0, size.width, radius);
        path.lineTo(size.width, size.height - radius);
        path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
        path.lineTo(radius, size.height);
        path.quadraticBezierTo(0, size.height, 0, size.height - radius);
        path.close();
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TabContentBorderPainter oldDelegate) {
    return selectedTab != oldDelegate.selectedTab || 
           primaryColor != oldDelegate.primaryColor;
  }
} 