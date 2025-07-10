import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/models/bowling_ball.dart';
import '../services/ball_data_service.dart';

// Service Provider
final ballDataServiceProvider = Provider<BallDataService>((ref) {
  return BallDataService();
});

/// 提供保齡球列表的 FutureProvider
///
/// 會自動處理讀取、快取（由 BallDataService 處理）、錯誤和成功狀態
final ballListProvider = FutureProvider<List<BowlingBall>>((ref) {
  final ballService = ref.watch(ballDataServiceProvider);
  return ballService.loadBallData();
});

// --- Ball Library Filter and Sort Providers ---

// +++ 型別安全的排序邏輯 +++
enum SortField { name, rg }

class SortCriterion {
  final SortField field;
  final bool ascending;

  const SortCriterion({required this.field, required this.ascending});

  // 覆寫 toString 以便在 UI 上顯示
  String get displayName {
    final fieldName = field.toString().split('.').last.toUpperCase();
    final direction = ascending ? '(Low-High)' : '(High-Low)';
    return '$fieldName $direction';
  }
}
// +++ End +++

// +++ 型別安全的篩選邏輯 +++
enum FilterField { brand, core, coverstock }

@immutable
class BallFilters {
  final String? brand;
  final String? core;
  final String? coverstock;

  const BallFilters({this.brand, this.core, this.coverstock});

  // copyWith 方法方便更新狀態
  BallFilters copyWith({String? brand, String? core, String? coverstock}) {
    return BallFilters(
      brand: brand ?? this.brand,
      core: core ?? this.core,
      coverstock: coverstock ?? this.coverstock,
    );
  }

  // 計算目前有多少個有效的篩選條件
  int get activeFilterCount {
    int count = 0;
    if (brand != null) count++;
    if (core != null) count++;
    if (coverstock != null) count++;
    return count;
  }
}
// +++ End +++

// 1. 搜尋文字的狀態
final ballSearchTextProvider = StateProvider<String>((ref) => '');

// 2. 篩選條件的狀態 (使用新的 BallFilters class)
final ballFiltersProvider = StateProvider<BallFilters>((ref) => const BallFilters());

// 3. 排序條件的狀態 (使用新的 SortCriterion class)
final ballSortProvider =
    StateProvider<SortCriterion>((ref) => const SortCriterion(field: SortField.name, ascending: true));

// --- Top-level helper functions for filtering (moved from the widget) ---

bool _matchesBrandFilter(String ballBrand, String? selectedBrand) {
  if (selectedBrand == null) return true;
  return ballBrand.toLowerCase().contains(selectedBrand.toLowerCase());
}

bool _matchesCoreFilter(String ballCore, String? selectedCore) {
  if (selectedCore == null) return true;
  final coreCategory = ballCore.trim().split(' ').last;
  return coreCategory.toLowerCase() == selectedCore.toLowerCase();
}

bool _matchesCoverstockFilter(String ballCoverstock, String? selectedCoverstock) {
  if (selectedCoverstock == null) return true;
  final coverLower = ballCoverstock.toLowerCase();
  final selectedLower = selectedCoverstock.toLowerCase();

  switch (selectedLower) {
    case 'urethane':
      return coverLower.contains('urethane');
    case 'polyester':
      return coverLower.contains('polyester') || coverLower.contains('poly');
    case 'solid reactive':
      return coverLower.contains('solid') && coverLower.contains('reactive');
    case 'pearl reactive':
      return coverLower.contains('pearl') && coverLower.contains('reactive');
    case 'hybrid reactive':
      return coverLower.contains('hybrid') && coverLower.contains('reactive');
    default:
      return false;
  }
}

// 4. 主要的計算 Provider，結合所有篩選和排序邏輯
final filteredBallListProvider = Provider<List<BowlingBall>>((ref) {
  // 依賴原始列表、搜尋、篩選和排序 providers
  final allBalls = ref.watch(ballListProvider).value ?? [];
  final searchText = ref.watch(ballSearchTextProvider);
  final selectedFilters = ref.watch(ballFiltersProvider);
  final sortCriteria = ref.watch(ballSortProvider);

  // 從 Iterable 開始，以實現惰性求值
  Iterable<BowlingBall> items = allBalls;

  // 鏈式呼叫 .where() 進行搜尋和篩選
  if (searchText.isNotEmpty) {
    items = items.where((ball) =>
        ball.name.toLowerCase().contains(searchText.toLowerCase()) ||
        ball.brand.toLowerCase().contains(searchText.toLowerCase()));
  }

  // 篩選邏輯 (使用 BallFilters 物件)
  if (selectedFilters.brand != null) {
    items = items.where((ball) => _matchesBrandFilter(ball.brand, selectedFilters.brand));
  }
  if (selectedFilters.core != null) {
    items = items.where((ball) => _matchesCoreFilter(ball.core, selectedFilters.core));
  }
  if (selectedFilters.coverstock != null) {
    items = items.where((ball) => _matchesCoverstockFilter(ball.coverstock, selectedFilters.coverstock));
  }

  // 在所有篩選完成後，只呼叫一次 .toList()
  final filteredList = items.toList();

  // 排序邏輯 (對最終列表進行原地排序)
  filteredList.sort((a, b) {
    int comparison;
    switch (sortCriteria.field) {
      case SortField.name:
        comparison = a.name.compareTo(b.name);
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
    return sortCriteria.ascending ? comparison : -comparison;
  });

  return filteredList;
}); 