import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/providers/providers.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

class SortButton extends StatelessWidget {
  const SortButton({
    super.key,
    required this.sortCriterion,
    required this.onSortChanged,
  });

  final SortCriterion sortCriterion;
  final ValueChanged<SortCriterion> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortCriterion>(
      onSelected: onSortChanged,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortCriterion>>[
        const PopupMenuItem<SortCriterion>(
          value: SortCriterion(field: SortField.name, ascending: true),
          child: Text('Name (A-Z)'),
        ),
        const PopupMenuItem<SortCriterion>(
          value: SortCriterion(field: SortField.name, ascending: false),
          child: Text('Name (Z-A)'),
        ),
        const PopupMenuItem<SortCriterion>(
          value: SortCriterion(field: SortField.rg, ascending: true),
          child: Text('RG (Low-High)'),
        ),
        const PopupMenuItem<SortCriterion>(
          value: SortCriterion(field: SortField.rg, ascending: false),
          child: Text('RG (High-Low)'),
        ),
      ],
      child: AppStandardButton(
        text: 'Sort: ${sortCriterion.displayName}',
        icon: Icons.sort,
        isPrimary: false,
        onPressed: () {}, // onPressed must be non-null for the button to be enabled for PopupMenuButton
        enabled: true, 
      ),
    );
  }
} 