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
    // 無內建 hasActiveFilters，簡單依 activeFilterCount 判斷
    // BallLibraryState 有 hasActiveFilters，但這裡只有 BallFilters
    final hasFilters = filters.brands.isNotEmpty ||
        filters.cores.isNotEmpty ||
        filters.coverstocks.isNotEmpty ||
        filters.brand != null ||
        filters.core != null ||
        filters.coverstock != null;
    if (!hasFilters) return balls;

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
    
    // Brand filter (支援多選與單選)
    if (filters.brands.isNotEmpty) {
      if (!filters.brands.contains(ball.brand)) {
        return false;
      }
    } else if (filters.brand != null) {
      if (!ball.brand.toLowerCase().contains(filters.brand!.toLowerCase())) {
        return false;
      }
    }
    
    // Coverstock filter (支援多選與單選)
    final ballCover = ball.cover.toLowerCase();
    if (filters.coverstocks.isNotEmpty) {
      final ok = filters.coverstocks.any((c) => ballCover.contains(c.toLowerCase()));
      if (!ok) return false;
    } else if (filters.coverstock != null) {
      if (!ballCover.contains(filters.coverstock!.toLowerCase())) return false;
    }
    
    // Core filter (支援多選與單選)
    final ballCore = ball.core.toLowerCase();
    if (filters.cores.isNotEmpty) {
      final ok = filters.cores.any((c) => ballCore.contains(c.toLowerCase()));
      if (!ok) return false;
    } else if (filters.core != null) {
      if (!ballCore.contains(filters.core!.toLowerCase())) return false;
    }
    
    // RG range filter
    // 暫無範圍屬性於 BallFilters，這段忽略
    
    // Differential range filter
    // 暫無 differential 欄位，忽略
    
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
      case SortField.releaseYear:
        // createdAt / releaseDate 皆為字串，盡力比較年份
        int parseYear(String? s) {
          if (s == null) return 0;
          final match = RegExp(r'\\d{4}').firstMatch(s);
          return match != null ? int.tryParse(match.group(0)!) ?? 0 : 0;
        }
        final ay = parseYear(a.releaseDate ?? a.createdAt);
        final by = parseYear(b.releaseDate ?? b.createdAt);
        comparison = ay.compareTo(by);
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
  final filters = params.filters;
  final hasFilters = filters.brands.isNotEmpty ||
      filters.cores.isNotEmpty ||
      filters.coverstocks.isNotEmpty ||
      filters.brand != null ||
      filters.core != null ||
      filters.coverstock != null;
  if (hasFilters) {
    result = result.where((ball) {
      final filters = params.filters;
      
      // Brand filter (多選/單選)
      if (filters.brands.isNotEmpty) {
        if (!filters.brands.contains(ball.brand)) return false;
      } else if (filters.brand != null) {
        if (!ball.brand.toLowerCase().contains(filters.brand!.toLowerCase())) return false;
      }
      
      // Coverstock filter (多選/單選)
      final cover = ball.cover.toLowerCase();
      if (filters.coverstocks.isNotEmpty) {
        final ok = filters.coverstocks.any((c) => cover.contains(c.toLowerCase()));
        if (!ok) return false;
      } else if (filters.coverstock != null) {
        if (!cover.contains(filters.coverstock!.toLowerCase())) return false;
      }
      
      // Core filter (多選/單選)
      final core = ball.core.toLowerCase();
      if (filters.cores.isNotEmpty) {
        final ok = filters.cores.any((c) => core.contains(c.toLowerCase()));
        if (!ok) return false;
      } else if (filters.core != null) {
        if (!core.contains(filters.core!.toLowerCase())) return false;
      }
      
      // 範圍條件暫無，忽略
      
      // Differential 欄位暫無，忽略
      
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
      case SortField.releaseYear:
        int parseYear(String? s) {
          if (s == null) return 0;
          final match = RegExp(r'\\d{4}').firstMatch(s);
          return match != null ? int.tryParse(match.group(0)!) ?? 0 : 0;
        }
        final ay = parseYear(a.releaseDate ?? a.createdAt);
        final by = parseYear(b.releaseDate ?? b.createdAt);
        comparison = ay.compareTo(by);
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