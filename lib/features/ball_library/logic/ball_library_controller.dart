import 'package:bowlingarsenal_app/features/ball_library/data/ball_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_data_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_data_service.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/supabase_ball_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    _repository = ref.watch(ballRepositoryProvider);
    
    try {
      print('🔄 BallLibraryController: Starting build...');
      
      // 獲取總數量（無篩選條件）
      final totalCount = await _repository.getTotalCount();
      print('📊 Total count: $totalCount');
      
      // 使用新的方法獲取第一頁資料
      final balls = await _repository.getBallsWithFilters(
        sortCriterion: const SortCriterion(field: SortField.id, ascending: true),
        offset: 0,
        limit: 50,
      );
      print('🎯 First page balls: ${balls.length}');
      print('🎾 Sample ball names: ${balls.take(3).map((b) => b.name).toList()}');
      
      final state = BallLibraryState(
        allBalls: balls,
        filteredBalls: balls,
        isLoading: false,
        totalCount: totalCount,
        hasMoreData: balls.length < totalCount,
        currentPage: 0,
      );
      
      print('✅ State created: ${state.filteredBalls.length} balls, hasMore: ${state.hasMoreData}');
      return state;
    } catch (e, stackTrace) {
      print('❌ BallLibraryController build error: $e');
      print('Stack trace: $stackTrace');
      return BallLibraryState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 更新搜尋文字
  Future<void> updateSearchText(String searchText) async {
    final currentState = state.value;
    if (currentState == null) return;

    print('🔍 Searching for: "$searchText"');
    
    try {
      // 使用新的Repository方法直接從資料庫搜尋
      final filteredBalls = await _repository.getBallsWithFilters(
        searchText: searchText.isEmpty ? null : searchText,
        filters: currentState.filters,
        sortCriterion: currentState.sortCriterion,
        offset: 0,
        limit: null, // 搜尋時取得所有符合條件的資料
      );
      
      // 獲取符合搜尋條件的總數量
      final filteredCount = await _repository.getTotalCountWithFilters(
        searchText: searchText.isEmpty ? null : searchText,
        filters: currentState.filters,
      );
      
      print('✅ Search results: ${filteredBalls.length} balls');
      
      final newState = currentState.copyWith(
        searchText: searchText,
        filteredBalls: filteredBalls,
        hasMoreData: false, // 搜尋時一次載入所有結果
        currentPage: 0,
      );
      
      state = AsyncValue.data(newState);
    } catch (e) {
      print('❌ Search error: $e');
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
      print('🔧 Updating filters: ${filters.activeFilterCount} active');
      
      // 使用新的Repository方法直接從資料庫篩選
      final filteredBalls = await _repository.getBallsWithFilters(
        searchText: currentState.searchText.isEmpty ? null : currentState.searchText,
        filters: filters,
        sortCriterion: currentState.sortCriterion,
      );
      
      print('✅ Filter results: ${filteredBalls.length} balls');
      
      final newState = currentState.copyWith(
        filters: filters,
        filteredBalls: filteredBalls,
        hasMoreData: false, // 篩選時一次載入所有結果
        currentPage: 0,
      );
      
      state = AsyncValue.data(newState);
    } catch (e) {
      print('❌ Filter error: $e');
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
      print('📊 Updating sort: ${sortCriterion.field} ${sortCriterion.ascending ? "ASC" : "DESC"}');
      
      // 使用新的Repository方法直接從資料庫排序
      final filteredBalls = await _repository.getBallsWithFilters(
        searchText: currentState.searchText.isEmpty ? null : currentState.searchText,
        filters: currentState.filters,
        sortCriterion: sortCriterion,
      );
      
      print('✅ Sort results: ${filteredBalls.length} balls');
      
      final newState = currentState.copyWith(
        sortCriterion: sortCriterion,
        filteredBalls: filteredBalls,
        hasMoreData: false, // 排序時一次載入所有結果
        currentPage: 0,
      );
      
      state = AsyncValue.data(newState);
    } catch (e) {
      print('❌ Sort error: $e');
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
      print('🧹 Clearing all filters');
      
      // 重新載入第一頁資料，無任何篩選條件
      final balls = await _repository.getBallsWithFilters(
        sortCriterion: currentState.sortCriterion,
        offset: 0,
        limit: 50,
      );
      
      final totalCount = await _repository.getTotalCount();
      
      print('✅ Cleared filters: ${balls.length} balls');
      
      final newState = currentState.copyWith(
        searchText: '',
        filters: const BallFilters(),
        filteredBalls: balls,
        hasMoreData: balls.length < totalCount,
        currentPage: 0,
      );
      
      state = AsyncValue.data(newState);
    } catch (e) {
      print('❌ Clear filters error: $e');
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
      print('⚠️ Load more not supported with active filters/search');
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final offset = nextPage * currentState.pageSize;
      
      print('📄 Loading more: page $nextPage, offset $offset');
      
      final newBalls = await _repository.getBallsWithFilters(
        sortCriterion: currentState.sortCriterion,
        offset: offset,
        limit: currentState.pageSize,
      );

      final allBalls = [...currentState.filteredBalls, ...newBalls];
      
      print('✅ Loaded ${newBalls.length} more balls, total: ${allBalls.length}');
      
      state = AsyncValue.data(currentState.copyWith(
        filteredBalls: allBalls,
        currentPage: nextPage,
        isLoadingMore: false,
        hasMoreData: allBalls.length < currentState.totalCount,
      ));
    } catch (e) {
      print('❌ Load more error: $e');
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
      print('🔄 Refreshing ball library...');
      
      final totalCount = await _repository.getTotalCount();
      
      final balls = await _repository.getBallsWithFilters(
        sortCriterion: const SortCriterion(field: SortField.id, ascending: true),
        offset: 0,
        limit: 50,
      );
      
      print('✅ Refreshed: ${balls.length} balls');
      
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
      print('❌ Refresh error: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}