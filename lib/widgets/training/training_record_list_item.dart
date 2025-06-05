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
        GFCard(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          color: theme.colorScheme.surface,
          boxFit: BoxFit.cover,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          content: GFListTile(
            avatar: GFAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                (index + 1).toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              size: GFSize.LARGE,
              shape: GFAvatarShape.circle,
            ),
            title: Text(
              "${record.date.year}.${record.date.month.toString().padLeft(2, '0')}.${record.date.day.toString().padLeft(2, '0')} @ ${record.centerName}",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subTitle: Text(
              "球道油型: ${record.oilPattern}",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            icon: Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            color: Colors.transparent,
            onTap: onTap,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            margin: EdgeInsets.zero,
          ),
        ),
        if (!isLastItem)
          Divider(
            height: 1,
            indent: 32,
            endIndent: 32,
            color: theme.dividerColor.withOpacity(0.18),
          ),
      ],
    );
  }
} 