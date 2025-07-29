import 'package:bowlingarsenal_app/features/ball_library/data/ball_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_data_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_data_service.dart';
import 'package:bowlingarsenal_app/features/ball_library/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ball_library_controller.g.dart';

/// 提供 BallDataService 的 Provider
@riverpod
BallDataService ballDataService(BallDataServiceRef ref) {
  return BallDataService();
}

/// 提供 BallRepository 的 Provider
@riverpod
BallRepository ballRepository(BallRepositoryRef ref) {
  final dataService = ref.watch(ballDataServiceProvider);
  return BallDataRepository(dataService);
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
      final balls = await _repository.getAllBalls();
      final filteredBalls = _applyFiltersAndSort(balls, const BallLibraryState());
      
      return BallLibraryState(
        allBalls: balls,
        filteredBalls: filteredBalls,
        isLoading: false,
      );
    } catch (e) {
      return BallLibraryState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 更新搜尋文字
  void updateSearchText(String searchText) {
    final currentState = state.value;
    if (currentState == null) return;

    final newState = currentState.copyWith(searchText: searchText);
    final filteredBalls = _applyFiltersAndSort(currentState.allBalls, newState);
    
    state = AsyncValue.data(newState.copyWith(filteredBalls: filteredBalls));
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

  /// 重新載入球庫資料
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    
    try {
      final balls = await _repository.getAllBalls();
      final currentState = state.value ?? const BallLibraryState();
      final filteredBalls = _applyFiltersAndSort(balls, currentState);
      
      state = AsyncValue.data(currentState.copyWith(
        allBalls: balls,
        filteredBalls: filteredBalls,
        isLoading: false,
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