import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bowlingarsenal_app/providers/providers.dart';
import 'package:bowlingarsenal_app/features/arsenal/widgets/arsenal_search_bar.dart';
import 'filter_popout.dart';

class BallLibraryControls extends ConsumerWidget {
  const BallLibraryControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 監聽 Provider 以獲取當前狀態
    final searchText = ref.watch(ballSearchTextProvider);
    final filters = ref.watch(ballFiltersProvider);
    final sortCriteria = ref.watch(ballSortProvider);

    // 計算篩選按鈕的顯示文字
    final activeFilterCount = filters.activeFilterCount;
    final filterButtonText =
        activeFilterCount > 0 ? 'Filter ($activeFilterCount)' : 'Filter';

    return Column(
      children: [
        // 搜尋框
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ArsenalSearchBar(
            searchText: searchText,
            onSearchChanged: (text) {
              ref.read(ballSearchTextProvider.notifier).state = text;
            },
          ),
        ),
        // 篩選與排序按鈕
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.filter_list),
                  label: Text(filterButtonText),
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (context) => FilterPopout(
                        filters: filters,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PopupMenuButton<SortCriterion>(
                  onSelected: (criterion) {
                    ref.read(ballSortProvider.notifier).state = criterion;
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<SortCriterion>>[
                    const PopupMenuItem<SortCriterion>(
                      value:
                          SortCriterion(field: SortField.name, ascending: true),
                      child: Text('Name (A-Z)'),
                    ),
                    const PopupMenuItem<SortCriterion>(
                      value: SortCriterion(
                          field: SortField.name, ascending: false),
                      child: Text('Name (Z-A)'),
                    ),
                    const PopupMenuItem<SortCriterion>(
                      value: SortCriterion(field: SortField.rg, ascending: true),
                      child: Text('RG (Low-High)'),
                    ),
                    const PopupMenuItem<SortCriterion>(
                      value:
                          SortCriterion(field: SortField.rg, ascending: false),
                      child: Text('RG (High-Low)'),
                    ),
                  ],
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.sort),
                    label: Text('Sort: ${sortCriteria.displayName}'),
                    onPressed: null, // PopupMenuButton handles tap
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 