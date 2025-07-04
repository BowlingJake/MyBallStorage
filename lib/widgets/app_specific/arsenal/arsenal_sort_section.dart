import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ArsenalSortSection extends StatelessWidget {
  const ArsenalSortSection({
    required this.sortBy,
    required this.sortAscending,
    required this.onSortChanged,
    super.key,
  });
  final String sortBy;
  final bool sortAscending;
  final Function(String sortField, bool ascending) onSortChanged;

  // Helper function to get current sort option string
  String get _currentSortOption {
    if (sortBy == 'Name') {
      return sortAscending ? 'Name A to Z' : 'Name Z to A';
    } else if (sortBy == 'RG') {
      return sortAscending ? 'RG Low to High' : 'RG High to Low';
    }
    return 'Name A to Z'; // default
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text('Sort', style: theme.textTheme.labelMedium),
          const SizedBox(width: 6),
          Expanded(child: _buildSortDropdown(context, theme)),
        ],
      ),
    );
  }

  Widget _buildSortDropdown(BuildContext context, ThemeData theme) {
    final sortOptions = <String>[
      'Name A to Z',
      'Name Z to A',
      'RG High to Low',
      'RG Low to High',
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: _currentSortOption,
        items:
            sortOptions
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
        onChanged: (String? value) {
          if (value != null) {
            switch (value) {
              case 'Name A to Z':
                onSortChanged('Name', true);
              case 'Name Z to A':
                onSortChanged('Name', false);
              case 'RG High to Low':
                onSortChanged('RG', false);
              case 'RG Low to High':
                onSortChanged('RG', true);
            }
          }
        },
        isExpanded: true,
        buttonStyleData: ButtonStyleData(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
            color: theme.colorScheme.surface,
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: theme.colorScheme.primary,
            size: 16,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 36,
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}
