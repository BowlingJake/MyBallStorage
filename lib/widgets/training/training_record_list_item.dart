import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../models/training_record.dart';

class TrainingRecordListItem extends StatelessWidget {
  final TrainingRecord record;
  final ThemeData theme;
  final VoidCallback onTap;
  final bool isLastItem;
  final int index;

  const TrainingRecordListItem({
    Key? key,
    required this.record,
    required this.theme,
    required this.onTap,
    required this.isLastItem,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GFListTile(
          title: Text(
            "${record.date.year}.${record.date.month.toString().padLeft(2, '0')}.${record.date.day.toString().padLeft(2, '0')} @ ${record.centerName}",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          subTitle: Text(
             "球道油型: ${record.oilPattern}",
             style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          avatar: GFAvatar(
            child: Text((index + 1).toString(), style: TextStyle(color: theme.colorScheme.onPrimary)),
            backgroundColor: theme.colorScheme.primary,
            shape: GFAvatarShape.standard,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: theme.cardColor,
          onTap: onTap,
        ),
        if (!isLastItem)
          Divider(height: 1, indent: 16 + 40 + 16, endIndent: 16, color: theme.dividerColor.withOpacity(0.5)),
      ],
    );
  }
} 