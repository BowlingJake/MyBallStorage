import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ArsenalSortSection extends StatelessWidget {
  final String sortBy;
  final bool sortAscending;
  final Function(String sortField, bool ascending) onSortChanged;

  const ArsenalSortSection({
    Key? key,
    required this.sortBy,
    required this.sortAscending,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text('Sort By:', style: theme.textTheme.titleSmall),
          SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortButton('Name', Icons.sort_by_alpha, theme),
                  _buildSortButton('RG', Icons.data_usage, theme),
                  _buildSortButton('Diff', Icons.insights, theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String field, IconData icon, ThemeData theme) {
    final bool isActive = sortBy == field;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: GFButton(
        onPressed: () {
          if (sortBy == field) {
            onSortChanged(field, !sortAscending);
          } else {
            onSortChanged(field, true);
          }
        },
        text: field,
        icon: Icon(
          isActive ? (sortAscending ? Icons.arrow_upward : Icons.arrow_downward) : icon,
          size: 16,
          color: isActive ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
        ),
        type: isActive ? GFButtonType.solid : GFButtonType.outline,
        color: isActive ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
        textColor: isActive ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
        shape: GFButtonShape.pills,
        size: GFSize.SMALL,
        buttonBoxShadow: isActive,
      ),
    );
  }
} 