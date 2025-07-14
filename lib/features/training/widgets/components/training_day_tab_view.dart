import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/game_list_item.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/training_day_equipment.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/training_day_stats.dart';
import 'package:flutter/material.dart';

/// Enum for the type of tab selected.
enum TabType {
  /// The games tab.
  games,

  /// The equipment tab.
  equipment,

  /// The statistics tab.
  statistics,
}

/// 訓練日標籤頁視圖元件
class TrainingDayTabView extends StatefulWidget {
  /// 創建訓練日標籤頁視圖
  const TrainingDayTabView({
    required this.summary,
    this.onGameTap,
    this.onGameDelete,
    super.key,
  });

  /// 訓練日摘要數據
  final TrainingDaySummary summary;
  /// 遊戲點擊回調
  final void Function(GameRecord)? onGameTap;
  /// 遊戲刪除回調
  final void Function(GameRecord)? onGameDelete;

  @override
  State<TrainingDayTabView> createState() => _TrainingDayTabViewState();
}

class _TrainingDayTabViewState extends State<TrainingDayTabView> {
  TabType _selectedTab = TabType.games;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: _buildTabContent(theme),
          ),
          const SizedBox(height: 4), // 恢復內部小間距
        ],
      ),
    );
  }

  /// 構建一體化分頁標籤標題
  Widget _buildIntegratedTabHeader(ThemeData theme) {
    return SizedBox(
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

  /// 構建一體化分頁標籤（只顯示文字）
  Widget _buildIntegratedTab(
    ThemeData theme,
    TabType tabType,
    IconData? icon,
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tabType;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
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
        return const SizedBox.shrink();
    }
  }

  /// 構建遊戲列表
  Widget _buildGamesList(ThemeData theme) {
    final games = widget.summary.games;

    if (games.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(
              Icons.format_list_numbered,
              size: 40,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: 8),
            Text(
              'No games recorded for this day yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    // 當有遊戲記錄時，顯示列表
    return Column(
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
      ],
    );
  }
}

/// 自定義繪製器 - 繪製分頁與內容一體化邊框
class TabContentBorderPainter extends CustomPainter {
  /// 創建標籤內容邊框繪製器
  TabContentBorderPainter({
    required this.selectedTab,
    required this.primaryColor,
  });
  
  /// 當前選中的標籤
  final TabType selectedTab;
  /// 主要顏色
  final Color primaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    const tabHeight = 42.0; // 更新分頁高度
    final thirdWidth = size.width / 3;
    const radius = 8.0;

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
        path.quadraticBezierTo(
          thirdWidth,
          tabHeight,
          thirdWidth + radius,
          tabHeight,
        );
        path.lineTo(size.width - radius, tabHeight);
        path.quadraticBezierTo(
          size.width,
          tabHeight,
          size.width,
          tabHeight + radius,
        );
        path.lineTo(size.width, size.height - radius);
        path.quadraticBezierTo(
          size.width,
          size.height,
          size.width - radius,
          size.height,
        );
        path.lineTo(radius, size.height);
        path.quadraticBezierTo(0, size.height, 0, size.height - radius);
        path.close();
        break;

      case TabType.equipment:
        // Equipment 分頁選中 - 中間分頁與內容連接
        path.moveTo(0, tabHeight + radius);
        path.quadraticBezierTo(0, tabHeight, radius, tabHeight);
        path.lineTo(thirdWidth - radius, tabHeight);
        path.quadraticBezierTo(
          thirdWidth,
          tabHeight,
          thirdWidth,
          tabHeight - radius,
        );
        path.lineTo(thirdWidth, radius);
        path.quadraticBezierTo(thirdWidth, 0, thirdWidth + radius, 0);
        path.lineTo(thirdWidth * 2 - radius, 0);
        path.quadraticBezierTo(thirdWidth * 2, 0, thirdWidth * 2, radius);
        path.lineTo(thirdWidth * 2, tabHeight - radius);
        path.quadraticBezierTo(
          thirdWidth * 2,
          tabHeight,
          thirdWidth * 2 + radius,
          tabHeight,
        );
        path.lineTo(size.width - radius, tabHeight);
        path.quadraticBezierTo(
          size.width,
          tabHeight,
          size.width,
          tabHeight + radius,
        );
        path.lineTo(size.width, size.height - radius);
        path.quadraticBezierTo(
          size.width,
          size.height,
          size.width - radius,
          size.height,
        );
        path.lineTo(radius, size.height);
        path.quadraticBezierTo(0, size.height, 0, size.height - radius);
        path.close();
        break;

      case TabType.statistics:
        // Statistics 分頁選中 - 右側分頁與內容連接
        path.moveTo(0, tabHeight + radius);
        path.quadraticBezierTo(0, tabHeight, radius, tabHeight);
        path.lineTo(thirdWidth * 2 - radius, tabHeight);
        path.quadraticBezierTo(
          thirdWidth * 2,
          tabHeight,
          thirdWidth * 2,
          tabHeight - radius,
        );
        path.lineTo(thirdWidth * 2, radius);
        path.quadraticBezierTo(thirdWidth * 2, 0, thirdWidth * 2 + radius, 0);
        path.lineTo(size.width - radius, 0);
        path.quadraticBezierTo(size.width, 0, size.width, radius);
        path.lineTo(size.width, size.height - radius);
        path.quadraticBezierTo(
          size.width,
          size.height,
          size.width - radius,
          size.height,
        );
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