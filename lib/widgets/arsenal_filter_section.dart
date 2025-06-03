import 'package:flutter/material.dart';

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
                  SizedBox(width: 8),
                  _buildDropdown(
                    context: context,
                    label: 'Core',
                    value: selectedFilters['core'],
                    items: ['Symmetric', 'Asymmetric'],
                    onChanged: (value) => onFilterChanged('core', value),
                  ),
                  SizedBox(width: 8),
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
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        value: value,
        hint: Text(label),
        underline: SizedBox(),
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
      ),
    );
  }
} 