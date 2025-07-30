import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ball_library_state.freezed.dart';

/// 排序欄位枚舉
enum SortField { id, name, brand, releaseYear, rg }

/// 篩選欄位枚舉
enum FilterField { brand, core, coverstock }

/// 排序條件 - 使用 Freezed 不可變模式
@freezed
class SortCriterion with _$SortCriterion {
  const factory SortCriterion({
    @Default(SortField.name) SortField field,
    @Default(true) bool ascending,
  }) = _SortCriterion;

  const SortCriterion._();

  /// 取得顯示名稱
  String get displayName {
    final fieldName = field.toString().split('.').last.toUpperCase();
    final direction = ascending ? '(Low-High)' : '(High-Low)';
    return '$fieldName $direction';
  }
}

/// 篩選條件 - 使用 Freezed 不可變模式  
@freezed
class BallFilters with _$BallFilters {
  const factory BallFilters({
    @Default(<String>{}) Set<String> brands,
    @Default(<String>{}) Set<String> cores, 
    @Default(<String>{}) Set<String> coverstocks,
    // 保留舊版本相容性
    String? brand,
    String? core,
    String? coverstock,
  }) = _BallFilters;

  const BallFilters._();

  /// 計算目前有多少個有效的篩選條件
  int get activeFilterCount {
    int count = 0;
    if (brands.isNotEmpty || brand != null) count++;
    if (cores.isNotEmpty || core != null) count++;
    if (coverstocks.isNotEmpty || coverstock != null) count++;
    return count;
  }
}

/// Ball Library 主狀態 - 使用 Freezed 不可變模式
@freezed
class BallLibraryState with _$BallLibraryState {
  const factory BallLibraryState({
    @Default([]) List<BowlingBall> allBalls,
    @Default([]) List<BowlingBall> filteredBalls,
    @Default('') String searchText,
    @Default(BallFilters()) BallFilters filters,
    @Default(SortCriterion(field: SortField.id)) SortCriterion sortCriterion,  // 預設ID排序
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(0) int currentPage,
    @Default(50) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasMoreData,
    String? error,
  }) = _BallLibraryState;

  const BallLibraryState._();

  /// 是否有任何篩選條件
  bool get hasActiveFilters => 
      searchText.isNotEmpty || filters.activeFilterCount > 0;

  /// 取得符合品牌篩選的球
  bool matchesBrandFilter(String ballBrand, String? selectedBrand) {
    if (selectedBrand == null) return true;
    return ballBrand.toLowerCase().contains(selectedBrand.toLowerCase());
  }

  /// 取得符合核心篩選的球
  bool matchesCoreFilter(String ballCore, String? selectedCore) {
    if (selectedCore == null) return true;
    final coreCategory = ballCore.trim().split(' ').last;
    return coreCategory.toLowerCase() == selectedCore.toLowerCase();
  }

  /// 取得符合覆蓋篩選的球
  bool matchesCoverstockFilter(String ballCoverstock, String? selectedCoverstock) {
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
}