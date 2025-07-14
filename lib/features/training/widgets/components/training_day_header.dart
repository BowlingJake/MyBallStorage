import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:flutter/material.dart';

/// 訓練日卡片的頭部部分
class TrainingDayHeader extends StatelessWidget {
  /// 創建訓練日頭部
  const TrainingDayHeader({
    required this.summary,
    required this.isSelectionMode,
    required this.isSelected,
    required this.infoVisibility,
    required this.isExpanded,
    this.onSelectionChanged,
    this.onDelete,
    this.onVisibilityTap,
    this.onExpandTap,
    super.key,
  });

  /// 訓練日摘要數據
  final TrainingDaySummary summary;
  /// 是否處於選擇模式
  final bool isSelectionMode;
  /// 是否被選中
  final bool isSelected;
  /// 資訊可見性狀態
  final InfoVisibility infoVisibility;
  /// 是否展開
  final bool isExpanded;
  /// 選擇狀態改變回調
  final ValueChanged<bool>? onSelectionChanged;
  /// 刪除按鈕點擊回調
  final VoidCallback? onDelete;
  /// 可見性按鈕點擊回調
  final VoidCallback? onVisibilityTap;
  /// 展開/收起按鈕點擊回調
  final VoidCallback? onExpandTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 複選框（選擇模式時顯示）
        if (isSelectionMode) ...[
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    size: 16,
                    color: theme.colorScheme.onPrimary,
                  )
                : null,
          ),
          const SizedBox(width: 12),
        ],

        // 標題區域
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題
              Text(
                summary.title,
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
          margin: const EdgeInsets.only(top: 2, left: 8, right: 4),
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${summary.totalGames} games',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ),

        // 控制按鈕組（非選擇模式時顯示）
        if (!isSelectionMode)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顯示/隱藏按鈕
              _buildControlButton(
                context: context,
                icon: infoVisibility == InfoVisibility.visible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: theme.colorScheme.primary,
                onTap: onVisibilityTap ?? () {},
                tooltip: infoVisibility == InfoVisibility.visible
                    ? '隱藏資訊'
                    : '顯示資訊',
              ),
              const SizedBox(width: 8), // 恢復間距
              // 刪除按鈕
              if (onDelete != null)
                _buildControlButton(
                  context: context,
                  icon: Icons.delete_outline,
                  color: Colors.red,
                  onTap: onDelete!,
                  tooltip: '刪除訓練日',
                ),
              const SizedBox(width: 8), // 恢復間距
              // 展開/收起指示器
              _buildControlButton(
                context: context,
                icon: Icons.keyboard_arrow_down,
                color: theme.colorScheme.primary,
                onTap: onExpandTap ?? () {},
                tooltip: isExpanded ? '收起' : '展開',
                rotation: isExpanded ? 0.5 : 0,
              ),
            ],
          ),
      ],
    );
  }

  /// 構建統一樣式的控制按鈕
  Widget _buildControlButton({
    required BuildContext context,
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
          border: Border.all(
            color: color.withAlpha(77), // 0.3 opacity
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
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      icon,
                      size: 18,
                      color: color.withAlpha(204), // 0.8 opacity
                    ),
                  )
                : Icon(
                    icon,
                    size: 18,
                    color: color.withAlpha(204), // 0.8 opacity
                  ),
          ),
        ),
      ),
    );
  }
}

/// Enum for the visibility state of the info section.
enum InfoVisibility {
  /// The info section is hidden.
  hidden,

  /// The info section is visible.
  visible,
} 