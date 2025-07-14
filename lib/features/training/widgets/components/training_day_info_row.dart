import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 顯示訓練日資訊的行元件
class TrainingDayInfoRow extends StatelessWidget {
  /// 創建訓練日資訊行
  const TrainingDayInfoRow({
    required this.summary,
    super.key,
  });

  /// 訓練日摘要數據
  final TrainingDaySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        // 日期區域 (33.33%)
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today,
                size: 12,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  DateFormat('yyyy.MM.dd', 'en_US').format(summary.date),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 12,
                color: theme.colorScheme.onSurface.withAlpha(179), // 0.7 opacity
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  summary.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(179), // 0.7 opacity
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.opacity,
                size: 12,
                color: theme.colorScheme.onSurface.withAlpha(179), // 0.7 opacity
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  summary.oilPatternDisplay,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(179), // 0.7 opacity
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
} 