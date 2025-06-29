import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/training_record.dart';

/// 訓練日摘要卡片的頭部組件
class TrainingDayHeader extends StatelessWidget {
  final TrainingDaySummary summary;
  final bool isSelectionMode;
  final bool isSelected;
  final ThemeData theme;

  const TrainingDayHeader({
    Key? key,
    required this.summary,
    required this.isSelectionMode,
    required this.isSelected,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 複選框（選擇模式時顯示）
        if (isSelectionMode) ...[
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.transparent,
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
          SizedBox(width: 12),
        ],

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題和遊戲數量
              Row(
                children: [
                  Expanded(
                    child: Text(
                      summary.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${summary.totalGames} Games',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
} 