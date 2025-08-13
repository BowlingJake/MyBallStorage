import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';

part 'ball_library_background_service.g.dart';

/// Ball Library Background Service - Compute-intensive operations in isolates
/// 
/// Features:
/// - Search operations in background isolate
/// - Filter operations without blocking UI
/// - Sort operations with optimal performance
/// - Memory-efficient computation
@riverpod
class BallLibraryBackgroundService extends _$BallLibraryBackgroundService {
  @override
  void build() {
    // No initial state needed for this service
  }

  /// Perform background search operation
  Future<List<BowlingBall>> searchBallsInBackground({
    required List<BowlingBall> balls,
    required String searchText,
  }) async {
    if (searchText.isEmpty) return balls;

    // Use compute for CPU-intensive search operation
    return await compute(_searchBallsIsolate, SearchParams(
      balls: balls,
      searchText: searchText.toLowerCase(),
    ));
  }

  /// Perform background filter operation
  Future<List<BowlingBall>> filterBallsInBackground({
    required List<BowlingBall> balls,
    required BallFilters filters,
  }) async {
    if (!filters.hasActiveFilters) return balls;

    // Use compute for CPU-intensive filter operation
    return await compute(_filterBallsIsolate, FilterParams(
      balls: balls,
      filters: filters,
    ));
  }

  /// Perform background sort operation
  Future<List<BowlingBall>> sortBallsInBackground({
    required List<BowlingBall> balls,
    required SortCriterion sortCriterion,
  }) async {
    // Use compute for CPU-intensive sort operation
    return await compute(_sortBallsIsolate, SortParams(
      balls: balls,
      sortCriterion: sortCriterion,
    ));
  }

  /// Perform combined search, filter, and sort operations
  Future<List<BowlingBall>> processAllInBackground({
    required List<BowlingBall> balls,
    required String searchText,
    required BallFilters filters,
    required SortCriterion sortCriterion,
  }) async {
    // Use compute for all operations in single isolate to avoid overhead
    return await compute(_processAllBallsIsolate, ProcessAllParams(
      balls: balls,
      searchText: searchText.toLowerCase(),
      filters: filters,
      sortCriterion: sortCriterion,
    ));
  }

  /// Generate search suggestions in background
  Future<List<String>> generateSearchSuggestionsInBackground({
    required List<BowlingBall> balls,
    required String partialText,
    int maxSuggestions = 10,
  }) async {
    if (partialText.isEmpty) return [];

    return await compute(_generateSuggestionsIsolate, SuggestionParams(
      balls: balls,
      partialText: partialText.toLowerCase(),
      maxSuggestions: maxSuggestions,
    ));
  }
}

// === Isolate Functions ===

/// Search isolate function
List<BowlingBall> _searchBallsIsolate(SearchParams params) {
  return params.balls.where((ball) {
    final searchText = params.searchText;
    return ball.name.toLowerCase().contains(searchText) ||
           ball.brand.toLowerCase().contains(searchText) ||
           (ball.coverstock?.toLowerCase().contains(searchText) ?? false) ||
           (ball.core?.toLowerCase().contains(searchText) ?? false);
  }).toList();
}

/// Filter isolate function
List<BowlingBall> _filterBallsIsolate(FilterParams params) {
  return params.balls.where((ball) {
    final filters = params.filters;
    
    // Brand filter
    if (filters.selectedBrands.isNotEmpty && 
        !filters.selectedBrands.contains(ball.brand)) {
      return false;
    }
    
    // Coverstock filter
    if (filters.selectedCoverstocks.isNotEmpty && 
        !filters.selectedCoverstocks.contains(ball.coverstock)) {
      return false;
    }
    
    // Core filter
    if (filters.selectedCores.isNotEmpty && 
        !filters.selectedCores.contains(ball.core)) {
      return false;
    }
    
    // RG range filter
    if (filters.rgRange != null && ball.rg != null) {
      final rg = ball.rg!;
      if (rg < filters.rgRange!.start || rg > filters.rgRange!.end) {
        return false;
      }
    }
    
    // Differential range filter
    if (filters.differentialRange != null && ball.differential != null) {
      final diff = ball.differential!;
      if (diff < filters.differentialRange!.start || 
          diff > filters.differentialRange!.end) {
        return false;
      }
    }
    
    return true;
  }).toList();
}

/// Sort isolate function
List<BowlingBall> _sortBallsIsolate(SortParams params) {
  final List<BowlingBall> sortedBalls = List.from(params.balls);
  
  sortedBalls.sort((a, b) {
    int comparison = 0;
    
    switch (params.sortCriterion.field) {
      case SortField.name:
        comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        break;
      case SortField.brand:
        comparison = a.brand.toLowerCase().compareTo(b.brand.toLowerCase());
        break;
      case SortField.id:
        comparison = a.id.compareTo(b.id);
        break;
      case SortField.rg:
        final aRg = a.rg ?? 0.0;
        final bRg = b.rg ?? 0.0;
        comparison = aRg.compareTo(bRg);
        break;
      case SortField.differential:
        final aDiff = a.differential ?? 0.0;
        final bDiff = b.differential ?? 0.0;
        comparison = aDiff.compareTo(bDiff);
        break;
    }
    
    return params.sortCriterion.ascending ? comparison : -comparison;
  });
  
  return sortedBalls;
}

/// Combined processing isolate function
List<BowlingBall> _processAllBallsIsolate(ProcessAllParams params) {
  List<BowlingBall> result = params.balls;
  
  // Step 1: Search
  if (params.searchText.isNotEmpty) {
    result = result.where((ball) {
      final searchText = params.searchText;
      return ball.name.toLowerCase().contains(searchText) ||
             ball.brand.toLowerCase().contains(searchText) ||
             (ball.coverstock?.toLowerCase().contains(searchText) ?? false) ||
             (ball.core?.toLowerCase().contains(searchText) ?? false);
    }).toList();
  }
  
  // Step 2: Filter
  if (params.filters.hasActiveFilters) {
    result = result.where((ball) {
      final filters = params.filters;
      
      // Brand filter
      if (filters.selectedBrands.isNotEmpty && 
          !filters.selectedBrands.contains(ball.brand)) {
        return false;
      }
      
      // Coverstock filter
      if (filters.selectedCoverstocks.isNotEmpty && 
          !filters.selectedCoverstocks.contains(ball.coverstock)) {
        return false;
      }
      
      // Core filter
      if (filters.selectedCores.isNotEmpty && 
          !filters.selectedCores.contains(ball.core)) {
        return false;
      }
      
      // RG range filter
      if (filters.rgRange != null && ball.rg != null) {
        final rg = ball.rg!;
        if (rg < filters.rgRange!.start || rg > filters.rgRange!.end) {
          return false;
        }
      }
      
      // Differential range filter
      if (filters.differentialRange != null && ball.differential != null) {
        final diff = ball.differential!;
        if (diff < filters.differentialRange!.start || 
            diff > filters.differentialRange!.end) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }
  
  // Step 3: Sort
  result.sort((a, b) {
    int comparison = 0;
    
    switch (params.sortCriterion.field) {
      case SortField.name:
        comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        break;
      case SortField.brand:
        comparison = a.brand.toLowerCase().compareTo(b.brand.toLowerCase());
        break;
      case SortField.id:
        comparison = a.id.compareTo(b.id);
        break;
      case SortField.rg:
        final aRg = a.rg ?? 0.0;
        final bRg = b.rg ?? 0.0;
        comparison = aRg.compareTo(bRg);
        break;
      case SortField.differential:
        final aDiff = a.differential ?? 0.0;
        final bDiff = b.differential ?? 0.0;
        comparison = aDiff.compareTo(bDiff);
        break;
    }
    
    return params.sortCriterion.ascending ? comparison : -comparison;
  });
  
  return result;
}

/// Search suggestions isolate function
List<String> _generateSuggestionsIsolate(SuggestionParams params) {
  final Set<String> suggestions = <String>{};
  final partialText = params.partialText;
  
  for (final ball in params.balls) {
    // Ball name suggestions
    if (ball.name.toLowerCase().contains(partialText)) {
      suggestions.add(ball.name);
    }
    
    // Brand suggestions
    if (ball.brand.toLowerCase().contains(partialText)) {
      suggestions.add(ball.brand);
    }
    
    // Coverstock suggestions
    if (ball.coverstock != null && 
        ball.coverstock!.toLowerCase().contains(partialText)) {
      suggestions.add(ball.coverstock!);
    }
    
    // Core suggestions
    if (ball.core != null && 
        ball.core!.toLowerCase().contains(partialText)) {
      suggestions.add(ball.core!);
    }
    
    // Stop when we have enough suggestions
    if (suggestions.length >= params.maxSuggestions) {
      break;
    }
  }
  
  final result = suggestions.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  
  return result.take(params.maxSuggestions).toList();
}

// === Parameter Classes ===

class SearchParams {
  final List<BowlingBall> balls;
  final String searchText;
  
  const SearchParams({
    required this.balls,
    required this.searchText,
  });
}

class FilterParams {
  final List<BowlingBall> balls;
  final BallFilters filters;
  
  const FilterParams({
    required this.balls,
    required this.filters,
  });
}

class SortParams {
  final List<BowlingBall> balls;
  final SortCriterion sortCriterion;
  
  const SortParams({
    required this.balls,
    required this.sortCriterion,
  });
}

class ProcessAllParams {
  final List<BowlingBall> balls;
  final String searchText;
  final BallFilters filters;
  final SortCriterion sortCriterion;
  
  const ProcessAllParams({
    required this.balls,
    required this.searchText,
    required this.filters,
    required this.sortCriterion,
  });
}

class SuggestionParams {
  final List<BowlingBall> balls;
  final String partialText;
  final int maxSuggestions;
  
  const SuggestionParams({
    required this.balls,
    required this.partialText,
    required this.maxSuggestions,
  });
}