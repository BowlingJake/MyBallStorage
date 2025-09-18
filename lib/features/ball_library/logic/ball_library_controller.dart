import 'dart:developer';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_data_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_data_service.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/supabase_ball_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';
import 'package:bowlingarsenal_app/shared/providers/cache_providers.dart';
import 'package:bowlingarsenal_app/shared/services/local_cache_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/services/ball_library_background_service.dart';

part 'ball_library_controller.g.dart';

/// 提供 BallDataService 的 Provider (本地JSON檔案)
@riverpod
BallDataService ballDataService(BallDataServiceRef ref) {
  return BallDataService();
}

/// 提供本地JSON檔案的 BallRepository
@riverpod
BallRepository localBallRepository(LocalBallRepositoryRef ref) {
  final dataService = ref.watch(ballDataServiceProvider);
  return BallDataRepository(dataService);
}

/// 提供 Supabase 的 BallRepository
@riverpod
BallRepository ballRepository(BallRepositoryRef ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return SupabaseBallRepository(supabaseClient);
}

/// Ball Library 控制器
/// 專注於球庫相關的業務邏輯和狀態管理
@riverpod
class BallLibraryController extends _$BallLibraryController {
  late final BallRepository _repository;

  @override
  Future<BallLibraryState> build() async {
    ref.keepAlive(); // 保持provider活躍，避免頁面切換時重建
    _repository = ref.watch(ballRepositoryProvider);
    final cacheService = ref.read(localCacheServiceProvider);
    
    try {
      // 確保快取服務已初始化
      try {
        await cacheService.initialize();
      } catch (e) {
        log('Ball Library: Cache service initialization failed: $e');
        // 如果快取初始化失敗，直接進行完整初始化
        return await _fullInitialize();
      }
      
      // 第一層：嘗試載入基本快取數據 (前50個球)
      final cachedBasicBalls = await cacheService.getCachedBallLibraryBasicData();
      if (cachedBasicBalls != null && cachedBasicBalls.isNotEmpty) {
        log('Ball Library: Loading basic data from cache for instant display');
        
        // 立即返回基本數據，讓用戶看到內容
        final initialState = BallLibraryState(
          allBalls: cachedBasicBalls,
          filteredBalls: cachedBasicBalls,
          isLoading: false, // 基本數據已可用
          totalCount: cachedBasicBalls.length,
          hasMoreData: true, // 假設有更多數據
          currentPage: 0,
        );
        
        // 背景載入完整數據
        _backgroundLoadFullData();
        
        return initialState;
      }
      
      // 第二層：無快取時的完整載入
      return await _fullInitialize();
    } catch (e) {
      log('Ball Library initialization failed: $e');
      return BallLibraryState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// 完整初始化 (無快取時使用)
  Future<BallLibraryState> _fullInitialize() async {
    try {
      log('Ball Library: Full initialization from database');
      
      // 獲取總數量（無篩選條件）
      final totalCount = await _repository.getTotalCount();
      
      // 使用新的方法獲取第一頁資料
      final balls = await _repository.getBallsWithFilters(
        sortCriterion: const SortCriterion(field: SortField.id, ascending: true),
        offset: 0,
        limit: 50,
      );
      
      // 快取基本數據
      final cacheService = ref.read(localCacheServiceProvider);
      await cacheService.cacheBallLibraryBasicData(balls);
      
      final state = BallLibraryState(
        allBalls: balls,
        filteredBalls: balls,
        isLoading: false,
        totalCount: totalCount,
        hasMoreData: balls.length < totalCount,
        currentPage: 0,
      );
      
      return state;
    } catch (e) {
      return BallLibraryState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// 背景載入完整數據 (不影響 UI 載入狀態)
  Future<void> _backgroundLoadFullData() async {
    try {
      log('Ball Library: Background loading full data');
      
      final cacheService = ref.read(localCacheServiceProvider);
      
      // 檢查是否已有完整快取
      final cachedFullBalls = await cacheService.getCachedBallLibraryFullData();
      if (cachedFullBalls != null && cachedFullBalls.length > 50) {
        log('Ball Library: Full data already cached, updating state');
        
        // 取得總數量
        final totalCount = await _repository.getTotalCount();
        
        // 靜默更新狀態
        final currentState = state.value;
        if (currentState != null) {
          final newState = currentState.copyWith(
            allBalls: cachedFullBalls,
            filteredBalls: cachedFullBalls,
            totalCount: totalCount,
            hasMoreData: false, // 完整數據已載入
          );
          state = AsyncValue.data(newState);
        }
        return;
      }
      
      // 載入更多數據
      final totalCount = await _repository.getTotalCount();
      final allBalls = await _repository.getBallsWithFilters(
        sortCriterion: const SortCriterion(field: SortField.id, ascending: true),
        offset: 0,
        limit: null, // 載入所有數據
      );
      
      // 快取完整數據
      await cacheService.cacheBallLibraryFullData(allBalls);
      
      // 靜默更新狀態
      final currentState = state.value;
      if (currentState != null) {
        final newState = currentState.copyWith(
          allBalls: allBalls,
          filteredBalls: allBalls,
          totalCount: totalCount,
          hasMoreData: false,
        );
        state = AsyncValue.data(newState);
      }
      
      log('Ball Library: Background loading completed (${allBalls.length} balls)');
    } catch (e) {
      log('Ball Library: Background loading failed: $e');
      // 背景載入失敗不影響用戶體驗
    }
  }

  /// 更新搜尋文字
  Future<void> updateSearchText(String searchText) async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      // 優先使用完整本地快取 + 背景運算，避免頻繁網路請求
      final cacheService = ref.read(localCacheServiceProvider);
      final cachedFullBalls = await cacheService.getCachedBallLibraryFullData();

      List<BowlingBall> filteredBalls;
      if (cachedFullBalls != null && cachedFullBalls.isNotEmpty) {
        filteredBalls = await ref
            .read(ballLibraryBackgroundServiceProvider.notifier)
            .processAllInBackground(
              balls: cachedFullBalls,
              searchText: searchText,
              filters: currentState.filters,
              sortCriterion: currentState.sortCriterion,
            );
      } else {
        // 後備：走遠端，但限制回傳筆數，避免過大負載
        filteredBalls = await _repository.getBallsWithFilters(
          searchText: searchText.isEmpty ? null : searchText,
          filters: currentState.filters,
          sortCriterion: currentState.sortCriterion,
          offset: 0,
          limit: 100,
        );
      }
      
      final newState = currentState.copyWith(
        searchText: searchText,
        filteredBalls: filteredBalls,
        hasMoreData: false, // 搜尋時一次載入所有結果
        currentPage: 0,
      );
      
      state = AsyncValue.data(newState);
    } catch (e) {
      final newState = currentState.copyWith(
        searchText: searchText,
        error: e.toString(),
      );
      state = AsyncValue.data(newState);
    }
  }

  /// 更新篩選條件
  Future<void> updateFilters(BallFilters filters) async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      // 優先本地背景處理，無完整快取時再打遠端
      final cacheService = ref.read(localCacheServiceProvider);
      final cachedFullBalls = await cacheService.getCachedBallLibraryFullData();

      List<BowlingBall> filteredBalls;
      if (cachedFullBalls != null && cachedFullBalls.isNotEmpty) {
        filteredBalls = await ref
            .read(ballLibraryBackgroundServiceProvider.notifier)
            .processAllInBackground(
              balls: cachedFullBalls,
              searchText: currentState.searchText,
              filters: filters,
              sortCriterion: currentState.sortCriterion,
            );
      } else {
        filteredBalls = await _repository.getBallsWithFilters(
          searchText: currentState.searchText.isEmpty ? null : currentState.searchText,
          filters: filters,
          sortCriterion: currentState.sortCriterion,
          offset: 0,
          limit: 100,
        );
      }
      
      final newState = currentState.copyWith(
        filters: filters,
        filteredBalls: filteredBalls,
        hasMoreData: false, // 篩選時一次載入所有結果
        currentPage: 0,
      );
      
      state = AsyncValue.data(newState);
    } catch (e) {
      final newState = currentState.copyWith(
        filters: filters,
        error: e.toString(),
      );
      state = AsyncValue.data(newState);
    }
  }

  /// 更新品牌篩選
  Future<void> updateBrandFilter(String? brand) async {
    final currentState = state.value;
    if (currentState == null) return;

    final newFilters = currentState.filters.copyWith(brand: brand);
    await updateFilters(newFilters);
  }

  /// 更新核心篩選
  Future<void> updateCoreFilter(String? core) async {
    final currentState = state.value;
    if (currentState == null) return;

    final newFilters = currentState.filters.copyWith(core: core);
    await updateFilters(newFilters);
  }

  /// 更新覆蓋篩選
  Future<void> updateCoverstockFilter(String? coverstock) async {
    final currentState = state.value;
    if (currentState == null) return;

    final newFilters = currentState.filters.copyWith(coverstock: coverstock);
    await updateFilters(newFilters);
  }

  /// 更新排序條件
  Future<void> updateSortCriterion(SortCriterion sortCriterion) async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      // 優先本地背景處理，無完整快取時再打遠端
      final cacheService = ref.read(localCacheServiceProvider);
      final cachedFullBalls = await cacheService.getCachedBallLibraryFullData();

      List<BowlingBall> filteredBalls;
      if (cachedFullBalls != null && cachedFullBalls.isNotEmpty) {
        filteredBalls = await ref
            .read(ballLibraryBackgroundServiceProvider.notifier)
            .processAllInBackground(
              balls: cachedFullBalls,
              searchText: currentState.searchText,
              filters: currentState.filters,
              sortCriterion: sortCriterion,
            );
      } else {
        filteredBalls = await _repository.getBallsWithFilters(
          searchText: currentState.searchText.isNotEmpty ? currentState.searchText : null,
          filters: currentState.filters,
          sortCriterion: sortCriterion,
          offset: 0,
          limit: 100,
        );
      }
      
      final newState = currentState.copyWith(
        sortCriterion: sortCriterion,
        filteredBalls: filteredBalls,
        hasMoreData: false, // 排序時一次載入所有結果
        currentPage: 0,
      );
      
      state = AsyncValue.data(newState);
    } catch (e) {
      final newState = currentState.copyWith(
        sortCriterion: sortCriterion,
        error: e.toString(),
      );
      state = AsyncValue.data(newState);
    }
  }

  /// 更新排序條件 (別名方法)
  Future<void> updateSort(SortCriterion sortCriterion) async {
    await updateSortCriterion(sortCriterion);
  }

  /// 清除所有篩選條件
  Future<void> clearAllFilters() async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      // 重新載入第一頁資料，無任何篩選條件
      final balls = await _repository.getBallsWithFilters(
        sortCriterion: currentState.sortCriterion,
        offset: 0,
        limit: 50,
      );
      
      final totalCount = await _repository.getTotalCount();
      
      final newState = currentState.copyWith(
        searchText: '',
        filters: const BallFilters(),
        filteredBalls: balls,
        hasMoreData: balls.length < totalCount,
        currentPage: 0,
      );
      
      state = AsyncValue.data(newState);
    } catch (e) {
      final newState = currentState.copyWith(
        searchText: '',
        filters: const BallFilters(),
        error: e.toString(),
      );
      state = AsyncValue.data(newState);
    }
  }

  /// 載入更多資料
  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || currentState.isLoadingMore || !currentState.hasMoreData) {
      return;
    }

    // 如果有搜尋或篩選條件，不支援分頁載入更多
    if (currentState.searchText.isNotEmpty || currentState.filters.activeFilterCount > 0) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final offset = nextPage * currentState.pageSize;
      
      final newBalls = await _repository.getBallsWithFilters(
        sortCriterion: currentState.sortCriterion,
        offset: offset,
        limit: currentState.pageSize,
      );

      final allBalls = [...currentState.filteredBalls, ...newBalls];
      
      state = AsyncValue.data(currentState.copyWith(
        filteredBalls: allBalls,
        currentPage: nextPage,
        isLoadingMore: false,
        hasMoreData: allBalls.length < currentState.totalCount,
      ));
    } catch (e) {
      state = AsyncValue.data(currentState.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      ));
    }
  }

  /// 重新載入球庫資料
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    
    try {
      final totalCount = await _repository.getTotalCount();
      
      final balls = await _repository.getBallsWithFilters(
        sortCriterion: const SortCriterion(field: SortField.id, ascending: true),
        offset: 0,
        limit: 50,
      );
      
      state = AsyncValue.data(BallLibraryState(
        allBalls: balls,
        filteredBalls: balls,
        isLoading: false,
        totalCount: totalCount,
        hasMoreData: balls.length < totalCount,
        currentPage: 0,
        error: null,
      ));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 取得用於比較的球資料
  /// 
  /// 根據提供的球ID列表獲取球資料，用於球比較功能
  /// 符合架構規範：業務邏輯封裝在邏輯層，表現層不直接存取資料層
  Future<(BowlingBall?, BowlingBall?)> getBallsForComparison(List<int> ballIds) async {
    if (ballIds.length != 2) {
      throw ArgumentError('Must provide exactly 2 ball IDs for comparison');
    }
    
    try {
      final ball1Future = _repository.getBallById(ballIds[0].toString());
      final ball2Future = _repository.getBallById(ballIds[1].toString());
      
      final results = await Future.wait([ball1Future, ball2Future]);
      final ball1 = results[0];
      final ball2 = results[1];
      
      return (ball1, ball2);
    } catch (e) {
      throw Exception('Failed to load balls for comparison: $e');
    }
  }
}