import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bowlingarsenal_app/shared/providers/providers.dart';
import 'package:bowlingarsenal_app/shared/widgets/search/search_bar.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/sort_button.dart';
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
          child: AppSearchBar(
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
                    showFilterPopout(
                      context,
                      initialFilters: filters,
                      onApplyFilters: (newFilters) {
                        ref.read(ballFiltersProvider.notifier).state = newFilters;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SortButton(
                  sortCriterion: sortCriteria,
                  onSortChanged: (criterion) {
                    ref.read(ballSortProvider.notifier).state = criterion;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 