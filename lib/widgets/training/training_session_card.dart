import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

// 訓練記錄數據模型
class TrainingSession {
  final String id;
  final String title;
  final DateTime date;
  final String center;
  final String? oilPatternName;
  final String? oilPatternLength;
  final bool isHousePattern;
  final DateTime createdAt;

  TrainingSession({
    required this.id,
    required this.title,
    required this.date,
    required this.center,
    this.oilPatternName,
    this.oilPatternLength,
    required this.isHousePattern,
    required this.createdAt,
  });
}

// 訓練記錄卡片組件
class TrainingSessionCard extends StatelessWidget {
  final TrainingSession session;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TrainingSessionCard({
    Key? key,
    required this.session,
    this.onTap,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  String _getOilPatternDisplay() {
    if (session.isHousePattern) {
      return 'House Pattern';
    } else if (session.oilPatternName?.isNotEmpty == true || session.oilPatternLength?.isNotEmpty == true) {
      final name = session.oilPatternName ?? '';
      final length = session.oilPatternLength ?? '';
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
    final dateFormatter = DateFormat('MMM dd, yyyy');
    
    // 限制標題在20字以內
    String displayTitle = session.title.length > 20 
        ? '${session.title.substring(0, 20)}...' 
        : session.title;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 第一排：標題 + 地點 + 操作按鈕
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          displayTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: theme.colorScheme.primary.withOpacity(0.6),
                        ),
                        SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            session.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 操作按鈕區域
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 編輯按鈕
                      if (onEdit != null)
                        GestureDetector(
                          onTap: onEdit,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 14,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      
                      if (onEdit != null && onDelete != null) SizedBox(width: 6),
                      
                      // 刪除按鈕
                      if (onDelete != null)
                        GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 14,
                              color: Colors.red[700],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // 第二排：日期 + 油型信息
              Row(
                children: [
                  // 日期
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 4),
                        Text(
                          dateFormatter.format(session.date),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: 8),
                  
                  // 油型
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.water_drop,
                          size: 12,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _getOilPatternDisplay(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 