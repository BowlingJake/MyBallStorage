import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_core_state_provider.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_ui_state_provider.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_selection_state_provider.dart';

part 'arsenal_family_providers.g.dart';

/// Family provider for filtered Arsenal instances by bag number
/// This allows each bag to have its own cached filtered list
@riverpod
List<UserArsenalInstance> arsenalInstancesByBag(
  ArsenalInstancesByBagRef ref,
  int bagNumber,
) {
  final coreState = ref.watch(arsenalCoreStateProviderProvider);
  final uiState = ref.watch(arsenalUiStateProviderProvider);
  
  // Get instances for the specific bag
  List<UserArsenalInstance> instances;
  if (bagNumber == 1) {
    // Main arsenal view - return all instances
    instances = coreState.allInstances;
  } else {
    // Specific bag - return instances in that bag
    instances = coreState.allInstances
        .where((instance) => instance.activeBagNumbers.contains(bagNumber))
        .toList();
  }
  
  // Apply category filter if selected
  if (coreState.selectedCategory != null) {
    instances = instances
        .where((instance) => instance.category == coreState.selectedCategory)
        .toList();
  }
  
  // Apply search filter
  if (uiState.searchText.isNotEmpty) {
    final searchLower = uiState.searchText.toLowerCase();
    instances = instances.where((instance) {
      return instance.displayName.toLowerCase().contains(searchLower) ||
             instance.brandName.toLowerCase().contains(searchLower) ||
             (instance.notes?.toLowerCase().contains(searchLower) ?? false);
    }).toList();
  }
  
  // Apply advanced filters
  instances = _applyAdvancedFilters(instances, uiState.filters);
  
  // Apply sorting
  instances = _applySorting(instances, uiState.sortOption, uiState.sortAscending);
  
  return instances;
}

/// Family provider for individual Arsenal instance by ID
/// This allows each instance to be cached separately
@riverpod
UserArsenalInstance? arsenalInstanceById(
  ArsenalInstanceByIdRef ref,
  int instanceId,
) {
  final coreState = ref.watch(arsenalCoreStateProviderProvider);
  
  try {
    return coreState.allInstances
        .firstWhere((instance) => instance.id == instanceId);
  } catch (e) {
    return null; // Instance not found
  }
}

/// Family provider for selection state of individual instances
/// This prevents unnecessary rebuilds when selection changes
@riverpod
bool isInstanceSelected(
  IsInstanceSelectedRef ref,
  int instanceId,
) {
  final selectionState = ref.watch(arsenalSelectionStateProviderProvider);
  
  if (selectionState.isRemoveMode) {
    return selectionState.selectedForRemoval.contains(instanceId);
  } else if (selectionState.isMoveMode) {
    return selectionState.selectedForMove.contains(instanceId);
  }
  
  return false;
}

/// Family provider for bag statistics
/// This allows each bag to have its own cached statistics
@riverpod
BagStatistics bagStatistics(
  BagStatisticsRef ref,
  int bagNumber,
) {
  final instances = ref.watch(arsenalInstancesByBagProvider(bagNumber));
  
  if (instances.isEmpty) {
    return const BagStatistics.empty();
  }
  
  final totalGamesUsed = instances.fold<int>(
    0, 
    (sum, instance) => sum + instance.gamesUsed,
  );
  
  final averageGamesUsed = totalGamesUsed / instances.length;
  
  final brandCounts = <String, int>{};
  final categoryCounts = <String, int>{};
  
  for (final instance in instances) {
    brandCounts[instance.brandName] = (brandCounts[instance.brandName] ?? 0) + 1;
    categoryCounts[instance.category] = (categoryCounts[instance.category] ?? 0) + 1;
  }
  
  // Find most used brands and categories
  final topBrands = brandCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  final topCategories = categoryCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  return BagStatistics(
    totalBalls: instances.length,
    totalGamesUsed: totalGamesUsed,
    averageGamesUsed: averageGamesUsed,
    topBrand: topBrands.isNotEmpty ? topBrands.first.key : null,
    topCategory: topCategories.isNotEmpty ? topCategories.first.key : null,
    brandDistribution: Map.fromEntries(topBrands),
    categoryDistribution: Map.fromEntries(topCategories),
  );
}

/// Family provider for filtered instances count by bag
/// Useful for displaying counts in tabs without rebuilding entire lists
@riverpod
int arsenalInstancesCountByBag(
  ArsenalInstancesCountByBagRef ref,
  int bagNumber,
) {
  final instances = ref.watch(arsenalInstancesByBagProvider(bagNumber));
  return instances.length;
}

/// Family provider for checking if bag has instances
/// Optimized for quick bag state checks
@riverpod
bool bagHasInstances(
  BagHasInstancesRef ref,
  int bagNumber,
) {
  final count = ref.watch(arsenalInstancesCountByBagProvider(bagNumber));
  return count > 0;
}

/// Family provider for search results in specific bag
/// Allows search to be scoped to individual bags
@riverpod
List<UserArsenalInstance> searchResultsInBag(
  SearchResultsInBagRef ref,
  int bagNumber,
  String searchTerm,
) {
  final coreState = ref.watch(arsenalCoreStateProviderProvider);
  
  // Get instances for the specific bag
  List<UserArsenalInstance> instances;
  if (bagNumber == 1) {
    instances = coreState.allInstances;
  } else {
    instances = coreState.allInstances
        .where((instance) => instance.activeBagNumbers.contains(bagNumber))
        .toList();
  }
  
  // Apply search filter
  if (searchTerm.isEmpty) return instances;
  
  final searchLower = searchTerm.toLowerCase();
  return instances.where((instance) {
    return instance.displayName.toLowerCase().contains(searchLower) ||
           instance.brandName.toLowerCase().contains(searchLower) ||
           (instance.notes?.toLowerCase().contains(searchLower) ?? false);
  }).toList();
}

// === Helper Functions ===

/// Apply advanced filters to instance list
List<UserArsenalInstance> _applyAdvancedFilters(
  List<UserArsenalInstance> instances,
  BallFilters filters,
) {
  var filtered = instances;
  
  // Brand filter
  if (filters.selectedBrands.isNotEmpty) {
    filtered = filtered
        .where((instance) => filters.selectedBrands.contains(instance.brandName))
        .toList();
  }
  
  // Category filter
  if (filters.selectedCategories.isNotEmpty) {
    filtered = filtered
        .where((instance) => filters.selectedCategories.contains(instance.category))
        .toList();
  }
  
  // Weight range filter
  if (filters.minWeight != null) {
    filtered = filtered
        .where((instance) => instance.weight >= filters.minWeight!)
        .toList();
  }
  if (filters.maxWeight != null) {
    filtered = filtered
        .where((instance) => instance.weight <= filters.maxWeight!)
        .toList();
  }
  
  // Games used range filter
  if (filters.minGamesUsed != null) {
    filtered = filtered
        .where((instance) => instance.gamesUsed >= filters.minGamesUsed!)
        .toList();
  }
  if (filters.maxGamesUsed != null) {
    filtered = filtered
        .where((instance) => instance.gamesUsed <= filters.maxGamesUsed!)
        .toList();
  }
  
  return filtered;
}

/// Apply sorting to instance list
List<UserArsenalInstance> _applySorting(
  List<UserArsenalInstance> instances,
  SortOption sortOption,
  bool ascending,
) {
  final sorted = List<UserArsenalInstance>.from(instances);
  
  switch (sortOption) {
    case SortOption.nameAZ:
    case SortOption.nameZA:
      sorted.sort((a, b) => a.displayName.compareTo(b.displayName));
      break;
    case SortOption.brandAZ:
    case SortOption.brandZA:
      sorted.sort((a, b) => a.brandName.compareTo(b.brandName));
      break;
    case SortOption.dateNewest:
    case SortOption.dateOldest:
      sorted.sort((a, b) => a.addedDate.compareTo(b.addedDate));
      break;
    case SortOption.gamesUsedMost:
    case SortOption.gamesUsedLeast:
      sorted.sort((a, b) => a.gamesUsed.compareTo(b.gamesUsed));
      break;
  }
  
  if (!ascending) {
    return sorted.reversed.toList();
  }
  
  return sorted;
}

// === Data Classes ===

/// Statistics for a specific bag
class BagStatistics {
  final int totalBalls;
  final int totalGamesUsed;
  final double averageGamesUsed;
  final String? topBrand;
  final String? topCategory;
  final Map<String, int> brandDistribution;
  final Map<String, int> categoryDistribution;
  
  const BagStatistics({
    required this.totalBalls,
    required this.totalGamesUsed,
    required this.averageGamesUsed,
    this.topBrand,
    this.topCategory,
    required this.brandDistribution,
    required this.categoryDistribution,
  });
  
  const BagStatistics.empty()
      : totalBalls = 0,
        totalGamesUsed = 0,
        averageGamesUsed = 0,
        topBrand = null,
        topCategory = null,
        brandDistribution = const {},
        categoryDistribution = const {};
  
  bool get isEmpty => totalBalls == 0;
  bool get isNotEmpty => totalBalls > 0;
  
  String get summary {
    if (isEmpty) return 'Empty bag';
    
    final parts = <String>[];
    parts.add('$totalBalls ball${totalBalls != 1 ? 's' : ''}');
    
    if (topBrand != null) {
      parts.add('mostly $topBrand');
    }
    
    if (totalGamesUsed > 0) {
      parts.add('${averageGamesUsed.toStringAsFixed(1)} avg games');
    }
    
    return parts.join(', ');
  }
}