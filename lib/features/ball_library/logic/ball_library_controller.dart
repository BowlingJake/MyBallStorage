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
      
      // 獲取總數量
      final totalCount = await _repository.getTotalCount();
      print('📊 Total count: $totalCount');
      
      // 獲取第一頁資料 (50筆)，使用預設排序
      final balls = await _repository.getBallsPaginated(
        offset: 0,
        limit: 50,
        orderBy: 'create_at',
        ascending: true,
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
    print('🎯 All balls count: ${currentState.allBalls.length}');
    
    if (searchText.isEmpty) {
      // 搜尋文字清空時，重置為第一頁資料
      final newState = currentState.copyWith(
        searchText: searchText,
        filteredBalls: currentState.allBalls,
        hasMoreData: currentState.allBalls.length < currentState.totalCount,
      );
      state = AsyncValue.data(newState);
      return;
    }

    // 如果有搜尋文字，需要搜尋所有資料
    try {
      // 先取得所有資料進行搜尋
      final allBalls = await _repository.getBallsPaginated(
        offset: 0,
        limit: currentState.totalCount, // 取得所有資料
        orderBy: 'create_at',
        ascending: true,
      );
      
      print('🎾 Got ${allBalls.length} balls for search');
      
      final newState = currentState.copyWith(
        searchText: searchText,
        allBalls: allBalls,
      );
      
      final filteredBalls = _applyFiltersAndSort(allBalls, newState);
      print('✅ Filtered results: ${filteredBalls.length}');
      
      state = AsyncValue.data(newState.copyWith(
        filteredBalls: filteredBalls,
        hasMoreData: false, // 搜尋時不需要分頁
      ));
    } catch (e) {
      print('❌ Search error: $e');
      // 發生錯誤時至少更新搜尋文字
      final newState = currentState.copyWith(searchText: searchText);
      final filteredBalls = _applyFiltersAndSort(currentState.allBalls, newState);
      state = AsyncValue.data(newState.copyWith(filteredBalls: filteredBalls));
    }
  }

  /// 更新篩選條件
  void updateFilters(BallFilters filters) {
    final currentState = state.value;
    if (currentState == null) return;

    final newState = currentState.copyWith(filters: filters);
    final filteredBalls = _applyFiltersAndSort(currentState.allBalls, newState);
    
    state = AsyncValue.data(newState.copyWith(filteredBalls: filteredBalls));
  }

  /// 更新品牌篩選
  void updateBrandFilter(String? brand) {
    final currentState = state.value;
    if (currentState == null) return;

    final newFilters = currentState.filters.copyWith(brand: brand);
    updateFilters(newFilters);
  }

  /// 更新核心篩選
  void updateCoreFilter(String? core) {
    final currentState = state.value;
    if (currentState == null) return;

    final newFilters = currentState.filters.copyWith(core: core);
    updateFilters(newFilters);
  }

  /// 更新覆蓋篩選
  void updateCoverstockFilter(String? coverstock) {
    final currentState = state.value;
    if (currentState == null) return;

    final newFilters = currentState.filters.copyWith(coverstock: coverstock);
    updateFilters(newFilters);
  }

  /// 更新排序條件
  void updateSortCriterion(SortCriterion sortCriterion) {
    final currentState = state.value;
    if (currentState == null) return;

    final newState = currentState.copyWith(sortCriterion: sortCriterion);
    final filteredBalls = _applyFiltersAndSort(currentState.allBalls, newState);
    
    state = AsyncValue.data(newState.copyWith(filteredBalls: filteredBalls));
  }

  /// 更新排序條件 (別名方法)
  void updateSort(SortCriterion sortCriterion) {
    updateSortCriterion(sortCriterion);
  }

  /// 清除所有篩選條件
  void clearAllFilters() {
    final currentState = state.value;
    if (currentState == null) return;

    final newState = currentState.copyWith(
      searchText: '',
      filters: const BallFilters(),
    );
    final filteredBalls = _applyFiltersAndSort(currentState.allBalls, newState);
    
    state = AsyncValue.data(newState.copyWith(filteredBalls: filteredBalls));
  }

  /// 載入更多資料
  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || currentState.isLoadingMore || !currentState.hasMoreData) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final offset = nextPage * currentState.pageSize;
      
      final newBalls = await _repository.getBallsPaginated(
        offset: offset,
        limit: currentState.pageSize,
        orderBy: 'create_at',
        ascending: true,
      );

      final updatedAllBalls = [...currentState.allBalls, ...newBalls];
      final allBalls = [...currentState.filteredBalls, ...newBalls];
      
      state = AsyncValue.data(currentState.copyWith(
        allBalls: updatedAllBalls,
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
      
      final balls = await _repository.getBallsPaginated(
        offset: 0,
        limit: 50,
        orderBy: 'create_at',
        ascending: true,
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

  /// 根據搜尋、篩選和排序條件處理球列表
  List<BowlingBall> _applyFiltersAndSort(List<BowlingBall> balls, BallLibraryState state) {
    Iterable<BowlingBall> items = balls;

    // 搜尋篩選
    if (state.searchText.isNotEmpty) {
      items = items.where((ball) =>
          ball.name.toLowerCase().contains(state.searchText.toLowerCase()) ||
          ball.brand.toLowerCase().contains(state.searchText.toLowerCase()));
    }

    // 品牌篩選
    if (state.filters.brand != null) {
      items = items.where((ball) => 
          state.matchesBrandFilter(ball.brand, state.filters.brand));
    }

    // 核心篩選
    if (state.filters.core != null) {
      items = items.where((ball) => 
          state.matchesCoreFilter(ball.core, state.filters.core));
    }

    // 覆蓋篩選
    if (state.filters.coverstock != null) {
      items = items.where((ball) => 
          state.matchesCoverstockFilter(ball.coverstock ?? '', state.filters.coverstock));
    }

    // 轉換為列表以進行排序
    final filteredList = items.toList();

    // 排序
    filteredList.sort((a, b) {
      int comparison;
      switch (state.sortCriterion.field) {
        case SortField.id:
          comparison = a.id.compareTo(b.id);
          break;
        case SortField.name:
          comparison = a.name.compareTo(b.name);
          break;
        case SortField.brand:
          comparison = a.brand.compareTo(b.brand);
          if (comparison == 0) {
            comparison = a.name.compareTo(b.name);
          }
          break;
        case SortField.releaseYear:
          if (a.releaseDate == null && b.releaseDate == null) {
            comparison = a.name.compareTo(b.name);
          } else if (a.releaseDate == null) {
            comparison = 1;
          } else if (b.releaseDate == null) {
            comparison = -1;
          } else {
            comparison = a.releaseDate!.compareTo(b.releaseDate!);
            if (comparison == 0) {
              comparison = a.name.compareTo(b.name);
            }
          }
          break;
        case SortField.rg:
          if (a.rg == null && b.rg == null) {
            comparison = a.name.compareTo(b.name);
          } else if (a.rg == null) {
            comparison = 1;
          } else if (b.rg == null) {
            comparison = -1;
          } else {
            comparison = a.rg!.compareTo(b.rg!);
            if (comparison == 0) {
              comparison = a.name.compareTo(b.name);
            }
          }
          break;
      }
      return state.sortCriterion.ascending ? comparison : -comparison;
    });

    return filteredList;
  }
}