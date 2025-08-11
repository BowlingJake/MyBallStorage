import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';

Future<void> showSortOptionsSheet({
  required BuildContext context,
  required SortOption selected,
  required void Function(SortOption) onSelect,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[600]!, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2)),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Sort Options',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          ...SortOption.values.map((option) {
            final isSelected = selected == option;
            return ListTile(
              title: Text(
                option.displayName,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.white,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                onSelect(option);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

