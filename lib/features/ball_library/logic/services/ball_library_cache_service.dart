import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';

part 'ball_library_cache_service.g.dart';

/// Ball Library Cache Service - Smart caching for improved performance
/// 
/// Features:
/// - LRU (Least Recently Used) cache eviction
/// - Separate caches for different data types
/// - Memory-aware cache management
/// - Cache hit rate optimization
@riverpod
class BallLibraryCacheService extends _$BallLibraryCacheService {
  @override
  BallLibraryCacheState build() {
    return const BallLibraryCacheState();
  }

  // === Ball Data Cache ===

  /// Cache individual ball data
  void cacheBall(BowlingBall ball) {
    final updatedBalls = Map<int, CachedBall>.from(state.ballCache);
    
    updatedBalls[ball.id] = CachedBall(
      ball: ball,
      cachedAt: DateTime.now(),
      accessCount: (updatedBalls[ball.id]?.accessCount ?? 0) + 1,
      lastAccessed: DateTime.now(),
    );
    
    // Enforce cache size limit
    if (updatedBalls.length > _maxBallCacheSize) {
      _evictLeastUsedBalls(updatedBalls);
    }
    
    state = state.copyWith(ballCache: updatedBalls);
  }

  /// Get cached ball data
  BowlingBall? getCachedBall(int ballId) {
    final cachedBall = state.ballCache[ballId];
    if (cachedBall != null) {
      // Update access statistics
      final updatedBalls = Map<int, CachedBall>.from(state.ballCache);
      updatedBalls[ballId] = cachedBall.copyWith(
        accessCount: cachedBall.accessCount + 1,
        lastAccessed: DateTime.now(),
      );
      state = state.copyWith(ballCache: updatedBalls);
      
      return cachedBall.ball;
    }
    return null;
  }

  /// Cache multiple balls efficiently
  void cacheBalls(List<BowlingBall> balls) {
    final updatedBalls = Map<int, CachedBall>.from(state.ballCache);
    final now = DateTime.now();
    
    for (final ball in balls) {
      updatedBalls[ball.id] = CachedBall(
        ball: ball,
        cachedAt: now,
        accessCount: (updatedBalls[ball.id]?.accessCount ?? 0) + 1,
        lastAccessed: now,
      );
    }
    
    // Enforce cache size limit
    if (updatedBalls.length > _maxBallCacheSize) {
      _evictLeastUsedBalls(updatedBalls);
    }
    
    state = state.copyWith(ballCache: updatedBalls);
  }

  // === Search Result Cache ===

  /// Cache search results
  void cacheSearchResults(String searchKey, List<BowlingBall> results) {
    final updatedSearchCache = Map<String, CachedSearchResult>.from(state.searchCache);
    
    updatedSearchCache[searchKey] = CachedSearchResult(
      searchKey: searchKey,
      results: results,
      cachedAt: DateTime.now(),
      lastAccessed: DateTime.now(),
      hitCount: 1,
    );
    
    // Enforce search cache size limit
    if (updatedSearchCache.length > _maxSearchCacheSize) {
      _evictOldestSearchResults(updatedSearchCache);
    }
    
    state = state.copyWith(searchCache: updatedSearchCache);
  }

  /// Get cached search results
  List<BowlingBall>? getCachedSearchResults(String searchKey) {
    final cachedResult = state.searchCache[searchKey];
    if (cachedResult != null && !_isSearchResultExpired(cachedResult)) {
      // Update access statistics
      final updatedSearchCache = Map<String, CachedSearchResult>.from(state.searchCache);
      updatedSearchCache[searchKey] = cachedResult.copyWith(
        lastAccessed: DateTime.now(),
        hitCount: cachedResult.hitCount + 1,
      );
      state = state.copyWith(searchCache: updatedSearchCache);
      
      return cachedResult.results;
    }
    return null;
  }

  // === Filter Result Cache ===

  /// Cache filter results
  void cacheFilterResults(String filterKey, List<BowlingBall> results) {
    final updatedFilterCache = Map<String, CachedFilterResult>.from(state.filterCache);
    
    updatedFilterCache[filterKey] = CachedFilterResult(
      filterKey: filterKey,
      results: results,
      cachedAt: DateTime.now(),
      lastAccessed: DateTime.now(),
      hitCount: 1,
    );
    
    // Enforce filter cache size limit
    if (updatedFilterCache.length > _maxFilterCacheSize) {
      _evictOldestFilterResults(updatedFilterCache);
    }
    
    state = state.copyWith(filterCache: updatedFilterCache);
  }

  /// Get cached filter results
  List<BowlingBall>? getCachedFilterResults(String filterKey) {
    final cachedResult = state.filterCache[filterKey];
    if (cachedResult != null && !_isFilterResultExpired(cachedResult)) {
      // Update access statistics
      final updatedFilterCache = Map<String, CachedFilterResult>.from(state.filterCache);
      updatedFilterCache[filterKey] = cachedResult.copyWith(
        lastAccessed: DateTime.now(),
        hitCount: cachedResult.hitCount + 1,
      );
      state = state.copyWith(filterCache: updatedFilterCache);
      
      return cachedResult.results;
    }
    return null;
  }

  // === Cache Management ===

  /// Clear all caches
  void clearAllCaches() {
    state = const BallLibraryCacheState();
  }

  /// Clear expired caches
  void clearExpiredCaches() {
    final updatedSearchCache = Map<String, CachedSearchResult>.from(state.searchCache);
    updatedSearchCache.removeWhere((key, result) => _isSearchResultExpired(result));
    
    final updatedFilterCache = Map<String, CachedFilterResult>.from(state.filterCache);
    updatedFilterCache.removeWhere((key, result) => _isFilterResultExpired(result));
    
    state = state.copyWith(
      searchCache: updatedSearchCache,
      filterCache: updatedFilterCache,
    );
  }

  /// Get cache statistics
  BallLibraryCacheStats getCacheStats() {
    final totalBalls = state.ballCache.length;
    final totalSearchResults = state.searchCache.length;
    final totalFilterResults = state.filterCache.length;
    
    final searchHitCount = state.searchCache.values
        .fold<int>(0, (sum, result) => sum + result.hitCount);
    final filterHitCount = state.filterCache.values
        .fold<int>(0, (sum, result) => sum + result.hitCount);
    
    return BallLibraryCacheStats(
      ballCacheSize: totalBalls,
      searchCacheSize: totalSearchResults,
      filterCacheSize: totalFilterResults,
      totalSearchHits: searchHitCount,
      totalFilterHits: filterHitCount,
      cacheEfficiency: _calculateCacheEfficiency(),
    );
  }

  // === Private Methods ===

  static const int _maxBallCacheSize = 500;
  static const int _maxSearchCacheSize = 50;
  static const int _maxFilterCacheSize = 50;
  static const Duration _searchCacheExpiry = Duration(minutes: 30);
  static const Duration _filterCacheExpiry = Duration(minutes: 30);

  void _evictLeastUsedBalls(Map<int, CachedBall> ballCache) {
    // Sort by access count and last accessed time
    final sortedEntries = ballCache.entries.toList()
      ..sort((a, b) {
        final accessCompare = a.value.accessCount.compareTo(b.value.accessCount);
        if (accessCompare != 0) return accessCompare;
        return a.value.lastAccessed.compareTo(b.value.lastAccessed);
      });
    
    // Remove 20% of least used items
    final itemsToRemove = (_maxBallCacheSize * 0.2).ceil();
    for (int i = 0; i < itemsToRemove && sortedEntries.isNotEmpty; i++) {
      ballCache.remove(sortedEntries[i].key);
    }
  }

  void _evictOldestSearchResults(Map<String, CachedSearchResult> searchCache) {
    final sortedEntries = searchCache.entries.toList()
      ..sort((a, b) => a.value.lastAccessed.compareTo(b.value.lastAccessed));
    
    // Remove 30% of oldest items
    final itemsToRemove = (_maxSearchCacheSize * 0.3).ceil();
    for (int i = 0; i < itemsToRemove && sortedEntries.isNotEmpty; i++) {
      searchCache.remove(sortedEntries[i].key);
    }
  }

  void _evictOldestFilterResults(Map<String, CachedFilterResult> filterCache) {
    final sortedEntries = filterCache.entries.toList()
      ..sort((a, b) => a.value.lastAccessed.compareTo(b.value.lastAccessed));
    
    // Remove 30% of oldest items
    final itemsToRemove = (_maxFilterCacheSize * 0.3).ceil();
    for (int i = 0; i < itemsToRemove && sortedEntries.isNotEmpty; i++) {
      filterCache.remove(sortedEntries[i].key);
    }
  }

  bool _isSearchResultExpired(CachedSearchResult result) {
    return DateTime.now().difference(result.cachedAt) > _searchCacheExpiry;
  }

  bool _isFilterResultExpired(CachedFilterResult result) {
    return DateTime.now().difference(result.cachedAt) > _filterCacheExpiry;
  }

  double _calculateCacheEfficiency() {
    final totalRequests = state.searchCache.values
        .fold<int>(0, (sum, result) => sum + result.hitCount) +
        state.filterCache.values
        .fold<int>(0, (sum, result) => sum + result.hitCount);
    
    if (totalRequests == 0) return 0.0;
    
    final cacheHits = state.searchCache.length + state.filterCache.length;
    return (cacheHits / totalRequests).clamp(0.0, 1.0);
  }
}

/// Ball Library Cache State
class BallLibraryCacheState {
  final Map<int, CachedBall> ballCache;
  final Map<String, CachedSearchResult> searchCache;
  final Map<String, CachedFilterResult> filterCache;

  const BallLibraryCacheState({
    this.ballCache = const {},
    this.searchCache = const {},
    this.filterCache = const {},
  });

  BallLibraryCacheState copyWith({
    Map<int, CachedBall>? ballCache,
    Map<String, CachedSearchResult>? searchCache,
    Map<String, CachedFilterResult>? filterCache,
  }) {
    return BallLibraryCacheState(
      ballCache: ballCache ?? this.ballCache,
      searchCache: searchCache ?? this.searchCache,
      filterCache: filterCache ?? this.filterCache,
    );
  }
}

/// Cached Ball Data
class CachedBall {
  final BowlingBall ball;
  final DateTime cachedAt;
  final DateTime lastAccessed;
  final int accessCount;

  const CachedBall({
    required this.ball,
    required this.cachedAt,
    required this.lastAccessed,
    required this.accessCount,
  });

  CachedBall copyWith({
    BowlingBall? ball,
    DateTime? cachedAt,
    DateTime? lastAccessed,
    int? accessCount,
  }) {
    return CachedBall(
      ball: ball ?? this.ball,
      cachedAt: cachedAt ?? this.cachedAt,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      accessCount: accessCount ?? this.accessCount,
    );
  }
}

/// Cached Search Result
class CachedSearchResult {
  final String searchKey;
  final List<BowlingBall> results;
  final DateTime cachedAt;
  final DateTime lastAccessed;
  final int hitCount;

  const CachedSearchResult({
    required this.searchKey,
    required this.results,
    required this.cachedAt,
    required this.lastAccessed,
    required this.hitCount,
  });

  CachedSearchResult copyWith({
    String? searchKey,
    List<BowlingBall>? results,
    DateTime? cachedAt,
    DateTime? lastAccessed,
    int? hitCount,
  }) {
    return CachedSearchResult(
      searchKey: searchKey ?? this.searchKey,
      results: results ?? this.results,
      cachedAt: cachedAt ?? this.cachedAt,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      hitCount: hitCount ?? this.hitCount,
    );
  }
}

/// Cached Filter Result
class CachedFilterResult {
  final String filterKey;
  final List<BowlingBall> results;
  final DateTime cachedAt;
  final DateTime lastAccessed;
  final int hitCount;

  const CachedFilterResult({
    required this.filterKey,
    required this.results,
    required this.cachedAt,
    required this.lastAccessed,
    required this.hitCount,
  });

  CachedFilterResult copyWith({
    String? filterKey,
    List<BowlingBall>? results,
    DateTime? cachedAt,
    DateTime? lastAccessed,
    int? hitCount,
  }) {
    return CachedFilterResult(
      filterKey: filterKey ?? this.filterKey,
      results: results ?? this.results,
      cachedAt: cachedAt ?? this.cachedAt,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      hitCount: hitCount ?? this.hitCount,
    );
  }
}

/// Cache Statistics
class BallLibraryCacheStats {
  final int ballCacheSize;
  final int searchCacheSize;
  final int filterCacheSize;
  final int totalSearchHits;
  final int totalFilterHits;
  final double cacheEfficiency;

  const BallLibraryCacheStats({
    required this.ballCacheSize,
    required this.searchCacheSize,
    required this.filterCacheSize,
    required this.totalSearchHits,
    required this.totalFilterHits,
    required this.cacheEfficiency,
  });
}