import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';

part 'arsenal_ui_state_provider.freezed.dart';
part 'arsenal_ui_state_provider.g.dart';

/// Arsenal UI state containing only display-related state
@freezed
class ArsenalUiState with _$ArsenalUiState {
  const factory ArsenalUiState({
    @Default(ArsenalViewMode.grid) ArsenalViewMode viewMode,
    @Default('') String searchText,
    @Default(BallFilters()) BallFilters filters,
    @Default(SortOption.nameAZ) SortOption sortOption,
    @Default(false) bool sortAscending,
    @Default(false) bool isFilterPanelVisible,
    @Default(false) bool isSearchActive,
  }) = _ArsenalUiState;
}

/// Arsenal view mode enum
enum ArsenalViewMode { grid, list }

/// Sorting options for Arsenal
enum SortOption {
  nameAZ('Name (A-Z)'),
  nameZA('Name (Z-A)'),
  brandAZ('Brand (A-Z)'),
  brandZA('Brand (Z-A)'),
  dateNewest('Date Added (Newest)'),
  dateOldest('Date Added (Oldest)'),
  gamesUsedMost('Games Used (Most)'),
  gamesUsedLeast('Games Used (Least)');

  const SortOption(this.displayName);
  final String displayName;
}

/// Arsenal UI state provider - handles only display and filter state
@riverpod
class ArsenalUiStateProvider extends _$ArsenalUiStateProvider {
  @override
  ArsenalUiState build() {
    return const ArsenalUiState();
  }

  // === View Mode Operations ===

  /// Toggle between grid and list view
  void toggleViewMode() {
    final newMode = state.viewMode == ArsenalViewMode.grid 
        ? ArsenalViewMode.list 
        : ArsenalViewMode.grid;
    state = state.copyWith(viewMode: newMode);
  }

  /// Set specific view mode
  void setViewMode(ArsenalViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  // === Search Operations ===

  /// Update search text
  void updateSearchText(String searchText) {
    state = state.copyWith(
      searchText: searchText,
      isSearchActive: searchText.isNotEmpty,
    );
  }

  /// Clear search
  void clearSearch() {
    state = state.copyWith(
      searchText: '',
      isSearchActive: false,
    );
  }

  /// Toggle search activation
  void toggleSearchActive() {
    state = state.copyWith(isSearchActive: !state.isSearchActive);
    
    // Clear search text when deactivating
    if (!state.isSearchActive) {
      state = state.copyWith(searchText: '');
    }
  }

  // === Filter Operations ===

  /// Update filters
  void updateFilters(BallFilters filters) {
    state = state.copyWith(filters: filters);
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(filters: const BallFilters());
  }

  /// Toggle filter panel visibility
  void toggleFilterPanel() {
    state = state.copyWith(isFilterPanelVisible: !state.isFilterPanelVisible);
  }

  /// Update specific brand filter
  void updateBrandFilter(List<String> brands) {
    final updatedFilters = state.filters.copyWith(selectedBrands: brands);
    state = state.copyWith(filters: updatedFilters);
  }

  /// Update specific category filter
  void updateCategoryFilter(List<String> categories) {
    final updatedFilters = state.filters.copyWith(selectedCategories: categories);
    state = state.copyWith(filters: updatedFilters);
  }

  /// Update weight range filter
  void updateWeightRangeFilter(double? minWeight, double? maxWeight) {
    final updatedFilters = state.filters.copyWith(
      minWeight: minWeight,
      maxWeight: maxWeight,
    );
    state = state.copyWith(filters: updatedFilters);
  }

  /// Update games used range filter
  void updateGamesUsedRangeFilter(int? minGames, int? maxGames) {
    final updatedFilters = state.filters.copyWith(
      minGamesUsed: minGames,
      maxGamesUsed: maxGames,
    );
    state = state.copyWith(filters: updatedFilters);
  }

  // === Sort Operations ===

  /// Update sort option
  void updateSortOption(SortOption sortOption) {
    state = state.copyWith(sortOption: sortOption);
  }

  /// Toggle sort direction
  void toggleSortDirection() {
    state = state.copyWith(sortAscending: !state.sortAscending);
  }

  /// Set sort direction
  void setSortDirection(bool ascending) {
    state = state.copyWith(sortAscending: ascending);
  }

  /// Update sort option and direction
  void updateSort(SortOption sortOption, bool ascending) {
    state = state.copyWith(
      sortOption: sortOption,
      sortAscending: ascending,
    );
  }

  // === Computed Properties ===

  /// Check if any filters are active
  bool get hasActiveFilters {
    final filters = state.filters;
    return filters.selectedBrands.isNotEmpty ||
           filters.selectedCategories.isNotEmpty ||
           filters.minWeight != null ||
           filters.maxWeight != null ||
           filters.minGamesUsed != null ||
           filters.maxGamesUsed != null;
  }

  /// Check if search is active
  bool get isSearching {
    return state.isSearchActive && state.searchText.isNotEmpty;
  }

  /// Get filter summary text
  String get filterSummary {
    if (!hasActiveFilters) return 'No filters';
    
    final activeFilters = <String>[];
    final filters = state.filters;
    
    if (filters.selectedBrands.isNotEmpty) {
      activeFilters.add('${filters.selectedBrands.length} brands');
    }
    if (filters.selectedCategories.isNotEmpty) {
      activeFilters.add('${filters.selectedCategories.length} categories');
    }
    if (filters.minWeight != null || filters.maxWeight != null) {
      activeFilters.add('weight range');
    }
    if (filters.minGamesUsed != null || filters.maxGamesUsed != null) {
      activeFilters.add('games used range');
    }
    
    return activeFilters.join(', ');
  }

  /// Reset all UI state to defaults
  void resetToDefaults() {
    state = const ArsenalUiState();
  }
}