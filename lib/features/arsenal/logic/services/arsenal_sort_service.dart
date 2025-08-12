import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';

/// Arsenal 排序服務
/// 負責處理所有與球具排序相關的業務邏輯
class ArsenalSortService {
  ArsenalSortService._(); // 私有建構子

  /// 對球具列表進行排序
  /// 
  /// [instances] 要排序的球具列表
  /// [sortOption] 排序選項
  /// [ascending] 是否升序排列
  static List<UserArsenalInstance> sortInstances({
    required List<UserArsenalInstance> instances,
    required SortOption sortOption,
    bool ascending = true,
  }) {
    final sortedInstances = List<UserArsenalInstance>.from(instances);
    
    switch (sortOption) {
      case SortOption.nameAZ:
        _sortByName(sortedInstances, ascending: true);
      case SortOption.nameZA:
        _sortByName(sortedInstances, ascending: false);
      case SortOption.brandAZ:
        _sortByBrand(sortedInstances, ascending: true);
      case SortOption.brandZA:
        _sortByBrand(sortedInstances, ascending: false);
      case SortOption.dateNewest:
        _sortByAddedDate(sortedInstances, ascending: false);
      case SortOption.dateOldest:
        _sortByAddedDate(sortedInstances, ascending: true);
      case SortOption.gamesUsedMost:
        _sortByGamesUsed(sortedInstances, ascending: false);
      case SortOption.gamesUsedLeast:
        _sortByGamesUsed(sortedInstances, ascending: true);
    }
    
    return sortedInstances;
  }

  /// 按名稱排序
  static void _sortByName(
    List<UserArsenalInstance> instances, 
    {required bool ascending}
  ) {
    instances.sort((a, b) {
      final nameA = a.bowlingBall?.name ?? '';
      final nameB = b.bowlingBall?.name ?? '';
      return ascending ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
    });
  }

  /// 按品牌排序
  static void _sortByBrand(
    List<UserArsenalInstance> instances, 
    {required bool ascending}
  ) {
    instances.sort((a, b) {
      final brandA = a.bowlingBall?.brand ?? '';
      final brandB = b.bowlingBall?.brand ?? '';
      return ascending ? brandA.compareTo(brandB) : brandB.compareTo(brandA);
    });
  }

  /// 按添加日期排序
  static void _sortByAddedDate(
    List<UserArsenalInstance> instances, 
    {required bool ascending}
  ) {
    instances.sort((a, b) {
      // 處理 null 值：null 視為最早日期
      final dateA = a.addedDate;
      final dateB = b.addedDate;
      
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return ascending ? -1 : 1;
      if (dateB == null) return ascending ? 1 : -1;
      
      return ascending 
          ? dateA.compareTo(dateB)
          : dateB.compareTo(dateA);
    });
  }

  /// 按使用次數排序
  static void _sortByGamesUsed(
    List<UserArsenalInstance> instances, 
    {required bool ascending}
  ) {
    instances.sort((a, b) {
      return ascending 
          ? a.gamesUsed.compareTo(b.gamesUsed)
          : b.gamesUsed.compareTo(a.gamesUsed);
    });
  }

  /// 取得排序選項的顯示名稱
  static String getSortDisplayName(SortOption sortOption) {
    return sortOption.displayName;
  }

  /// 檢查排序選項是否為升序
  static bool isSortAscending(SortOption sortOption) {
    switch (sortOption) {
      case SortOption.nameAZ:
      case SortOption.brandAZ:
      case SortOption.dateOldest:
      case SortOption.gamesUsedLeast:
        return true;
      case SortOption.nameZA:
      case SortOption.brandZA:
      case SortOption.dateNewest:
      case SortOption.gamesUsedMost:
        return false;
    }
  }

  /// 取得相反的排序選項
  static SortOption getReverseSortOption(SortOption sortOption) {
    switch (sortOption) {
      case SortOption.nameAZ:
        return SortOption.nameZA;
      case SortOption.nameZA:
        return SortOption.nameAZ;
      case SortOption.brandAZ:
        return SortOption.brandZA;
      case SortOption.brandZA:
        return SortOption.brandAZ;
      case SortOption.dateNewest:
        return SortOption.dateOldest;
      case SortOption.dateOldest:
        return SortOption.dateNewest;
      case SortOption.gamesUsedMost:
        return SortOption.gamesUsedLeast;
      case SortOption.gamesUsedLeast:
        return SortOption.gamesUsedMost;
    }
  }

  /// 取得所有可用的排序選項
  static List<SortOption> getAllSortOptions() {
    return SortOption.values;
  }

  /// 按類型分組的排序選項
  static Map<String, List<SortOption>> getGroupedSortOptions() {
    return {
      'Name': [SortOption.nameAZ, SortOption.nameZA],
      'Brand': [SortOption.brandAZ, SortOption.brandZA],
      'Date Added': [SortOption.dateNewest, SortOption.dateOldest],
      'Usage': [SortOption.gamesUsedMost, SortOption.gamesUsedLeast],
    };
  }
}

/// 排序選項枚舉 (從原控制器移過來)
enum SortOption {
  nameAZ('Name (A-Z)'),
  nameZA('Name (Z-A)'),
  brandAZ('Brand (A-Z)'),
  brandZA('Brand (Z-A)'),
  dateNewest('Date Added (Newest)'),
  dateOldest('Date Added (Oldest)'),
  gamesUsedMost('Games Used (Most)'),
  gamesUsedLeast('Games Used (Least)');

  const SortOption(this.displayName);
  final String displayName;
}