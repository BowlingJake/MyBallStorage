import 'package:bowlingarsenal_app/features/ball_library/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/filter_popout.dart';
import 'package:flutter/material.dart';

class BallLibraryControls extends StatelessWidget {
  final String searchText;
  final BallFilters filters;
  final SortCriterion sortCriterion;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<BallFilters> onFiltersChanged;
  final ValueChanged<SortCriterion> onSortChanged;
  final VoidCallback onClearFilters;

  const BallLibraryControls({
    super.key,
    required this.searchText,
    required this.filters,
    required this.sortCriterion,
    required this.onSearchChanged,
    required this.onFiltersChanged,
    required this.onSortChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 搜尋框
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search balls...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          // 控制按鈕行
          Row(
            children: [
              // 篩選按鈕
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showFilterDialog(context),
                  icon: Icon(
                    Icons.filter_list,
                    color: filters.activeFilterCount > 0 ? Colors.blue : Colors.grey,
                  ),
                  label: Text(
                    filters.activeFilterCount > 0 
                        ? 'Filters (${filters.activeFilterCount})' 
                        : 'Filters',
                    style: TextStyle(
                      color: filters.activeFilterCount > 0 ? Colors.blue : Colors.grey,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 排序按鈕
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showSortDialog(context),
                  icon: const Icon(Icons.sort, color: Colors.grey),
                  label: Text(
                    sortCriterion.displayName,
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 清除按鈕
              ElevatedButton(
                onPressed: searchText.isNotEmpty || filters.activeFilterCount > 0 
                    ? onClearFilters 
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.clear, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FilterPopout(
        currentFilters: filters,
        onFiltersChanged: onFiltersChanged,
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Sort By',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name sorting options
            ListTile(
              title: const Text('Name (A-Z)', style: TextStyle(color: Colors.white)),
              leading: Radio<SortCriterion>(
                value: const SortCriterion(field: SortField.name, ascending: true),
                groupValue: sortCriterion,
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Name (Z-A)', style: TextStyle(color: Colors.white)),
              leading: Radio<SortCriterion>(
                value: const SortCriterion(field: SortField.name, ascending: false),
                groupValue: sortCriterion,
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            // RG sorting options
            ListTile(
              title: const Text('RG (Low-High)', style: TextStyle(color: Colors.white)),
              leading: Radio<SortCriterion>(
                value: const SortCriterion(field: SortField.rg, ascending: true),
                groupValue: sortCriterion,
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('RG (High-Low)', style: TextStyle(color: Colors.white)),
              leading: Radio<SortCriterion>(
                value: const SortCriterion(field: SortField.rg, ascending: false),
                groupValue: sortCriterion,
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}