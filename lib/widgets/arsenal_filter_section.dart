import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ArsenalFilterSection extends StatelessWidget {
  final Map<String, String?> selectedFilters;
  final Function(String filterType, String? value) onFilterChanged;

  const ArsenalFilterSection({
    Key? key,
    required this.selectedFilters,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text('Filter:', style: theme.textTheme.titleSmall),
          SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDropdown(
                    context: context,
                    label: 'Brand',
                    value: selectedFilters['brand'],
                    items: ['Storm', 'Hammer', 'Brunswick', 'Roto Grip'],
                    onChanged: (value) => onFilterChanged('brand', value),
                  ),
                  SizedBox(width: 12),
                  _buildDropdown(
                    context: context,
                    label: 'Core',
                    value: selectedFilters['core'],
                    items: ['Symmetric', 'Asymmetric'],
                    onChanged: (value) => onFilterChanged('core', value),
                  ),
                  SizedBox(width: 12),
                  _buildDropdown(
                    context: context,
                    label: 'Coverstock',
                    value: selectedFilters['coverstock'],
                    items: ['Solid', 'Pearl', 'Hybrid'],
                    onChanged: (value) => onFilterChanged('coverstock', value),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      constraints: BoxConstraints(minWidth: 120),
      child: GFDropdown<String>(
        value: value,
        hint: Text(label),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text('All $label'),
          ),
          ...items.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          )).toList(),
        ],
        onChanged: onChanged,
        border: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        dropdownButtonColor: theme.colorScheme.surface,
        dropdownColor: theme.colorScheme.surface,
        icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.primary),
      ),
    );
  }
} 