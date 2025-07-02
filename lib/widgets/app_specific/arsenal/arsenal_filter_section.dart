import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        children: [
          Text('Filter', style: theme.textTheme.labelMedium),
          SizedBox(width: 6),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: _buildDropdown(
                    context: context,
                    label: 'Brand',
                    value: selectedFilters['brand'],
                    items: ['Storm', 'Hammer', 'Brunswick', 'Roto Grip', 'Motiv', 'Columbia 300', 'Ebonite', '900 Global', 'Track', 'Radical', 'SWAG'],
                    onChanged: (value) => onFilterChanged('brand', value),
                  ),
                ),
                SizedBox(width: 6),
                Flexible(
                  flex: 1,
                  child: _buildDropdown(
                    context: context,
                    label: 'Core',
                    value: selectedFilters['core'],
                    items: ['Symmetric', 'Asymmetric'],
                    onChanged: (value) => onFilterChanged('core', value),
                  ),
                ),
                SizedBox(width: 6),
                Flexible(
                  flex: 1,
                  child: _buildDropdown(
                    context: context,
                    label: 'Coverstock',
                    value: selectedFilters['coverstock'],
                    items: ['Solid Reactive', 'Pearl Reactive', 'Hybrid Reactive', 'Urethane', 'Polyester'],
                    onChanged: (value) => onFilterChanged('coverstock', value),
                  ),
                ),
              ],
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
    
    String getAllText(String label) {
      if (label == 'Coverstock') {
        return 'All Cover';
      }
      return 'All $label';
    }
    
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: value,
        hint: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              getAllText(label),
              style: TextStyle(fontSize: 12),
            ),
          ),
          ...items.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          )).toList(),
        ],
        onChanged: onChanged,
        isExpanded: true,
        buttonStyleData: ButtonStyleData(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
              width: 1,
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
          offset: const Offset(0, 0),
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