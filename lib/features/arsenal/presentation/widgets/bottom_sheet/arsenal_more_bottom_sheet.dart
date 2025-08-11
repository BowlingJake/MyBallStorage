import 'package:flutter/material.dart';

typedef Void = void Function();

class ArsenalMoreBottomSheet extends StatelessWidget {
  const ArsenalMoreBottomSheet({
    super.key,
    required this.canMove,
    required this.onFilter,
    required this.onSort,
    this.onOpenBagManagement,
    this.onClearAll,
    this.activeFilterCount = 0,
    this.sortLabel,
  });

  final bool canMove;
  final Void onFilter;
  final Void onSort;
  final Void? onOpenBagManagement;
  final Void? onClearAll;
  final int activeFilterCount;
  final String? sortLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'More Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onOpenBagManagement != null)
            ListTile(
              title: const Text(
                'Bag Management',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              onTap: onOpenBagManagement,
            ),
          const SizedBox(height: 8),
          ListTile(
            title: Text(
              'Filter',
              style: TextStyle(
                color: activeFilterCount > 0 ? Colors.blue : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: activeFilterCount > 0
                ? Text(
                    '$activeFilterCount filter${activeFilterCount != 1 ? 's' : ''} active',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  )
                : null,
            onTap: onFilter,
          ),
          ListTile(
            title: Text(
              'Sort',
              style: TextStyle(
                color: (sortLabel != null && sortLabel!.isNotEmpty) ? Colors.blue : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: (sortLabel != null && sortLabel!.isNotEmpty)
                ? Text(sortLabel!, style: TextStyle(color: Colors.grey[400], fontSize: 12))
                : null,
            onTap: onSort,
          ),
          if (onClearAll != null)
            ListTile(
              title: Text(
                'Clear All Filters & Sort',
                style: TextStyle(color: Colors.red[400], fontWeight: FontWeight.w500),
              ),
              onTap: onClearAll,
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, Color color, Void onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.6), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

