import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';

/// Arsenal 過濾服務
/// 負責處理所有與球具篩選、搜尋相關的業務邏輯
class ArsenalFilterService {
  ArsenalFilterService._(); // 私有建構子

  /// 根據多種條件過濾球具列表
  /// 
  /// [instances] 原始球具列表
  /// [selectedBagNumber] 選中的袋子編號 (1 = All My Arsenal)
  /// [selectedCategory] 選中的類別 (null = All My Arsenal)
  /// [searchText] 搜尋文字
  /// [filters] 進階過濾條件
  static List<UserArsenalInstance> filterInstances({
    required List<UserArsenalInstance> instances,
    required int selectedBagNumber,
    String? selectedCategory,
    String searchText = '',
    BallFilters filters = const BallFilters(),
  }) {
    var filteredInstances = instances;
    
    // 1. 按袋子過濾
    filteredInstances = _filterByBag(filteredInstances, selectedBagNumber);
    
    // 2. 按類別過濾
    filteredInstances = _filterByCategory(filteredInstances, selectedCategory);
    
    // 3. 按搜尋文字過濾
    filteredInstances = _filterBySearchText(filteredInstances, searchText);
    
    // 4. 按品牌過濾
    filteredInstances = _filterByBrands(filteredInstances, filters.brands);
    
    // 5. 按核心類型過濾
    filteredInstances = _filterByCores(filteredInstances, filters.cores);
    
    // 6. 按表面材質過濾
    filteredInstances = _filterByCoverstocks(filteredInstances, filters.coverstocks);
    
    return filteredInstances;
  }

  /// 按袋子過濾
  static List<UserArsenalInstance> _filterByBag(
    List<UserArsenalInstance> instances,
    int selectedBagNumber,
  ) {
    if (selectedBagNumber == 1) {
      // 袋子1代表"All My Arsenal"，不需要過濾
      return instances;
    }
    
    return instances
        .where((instance) => instance.isInBag(selectedBagNumber))
        .toList();
  }

  /// 按類別過濾
  static List<UserArsenalInstance> _filterByCategory(
    List<UserArsenalInstance> instances,
    String? selectedCategory,
  ) {
    if (selectedCategory == null) {
      // null 代表"All My Arsenal"，不需要過濾
      return instances;
    }
    
    return instances
        .where((instance) => instance.belongsToCategory(selectedCategory))
        .toList();
  }

  /// 按搜尋文字過濾
  static List<UserArsenalInstance> _filterBySearchText(
    List<UserArsenalInstance> instances,
    String searchText,
  ) {
    if (searchText.isEmpty) {
      return instances;
    }
    
    final searchLower = searchText.toLowerCase();
    return instances.where((instance) {
      return _matchesSearchText(instance, searchLower);
    }).toList();
  }

  /// 檢查球具是否符合搜尋文字
  static bool _matchesSearchText(UserArsenalInstance instance, String searchLower) {
    final ball = instance.bowlingBall;
    if (ball == null) return false;
    
    final ballName = ball.name.toLowerCase();
    final ballBrand = ball.brand.toLowerCase();
    
    return ballName.contains(searchLower) || ballBrand.contains(searchLower);
  }

  /// 按品牌過濾
  static List<UserArsenalInstance> _filterByBrands(
    List<UserArsenalInstance> instances,
    Set<String> selectedBrands,
  ) {
    if (selectedBrands.isEmpty) {
      return instances;
    }
    
    return instances.where((instance) {
      final ball = instance.bowlingBall;
      return ball != null && selectedBrands.contains(ball.brand);
    }).toList();
  }

  /// 按核心類型過濾
  static List<UserArsenalInstance> _filterByCores(
    List<UserArsenalInstance> instances,
    Set<String> selectedCores,
  ) {
    if (selectedCores.isEmpty) {
      return instances;
    }
    
    return instances.where((instance) {
      final ball = instance.bowlingBall;
      if (ball?.coreType == null) return false;
      
      final coreType = _determineCoreType(ball!.coreType!);
      return selectedCores.contains(coreType);
    }).toList();
  }

  /// 決定核心類型（Symmetric 或 Asymmetric）
  static String _determineCoreType(String coreTypeRaw) {
    return coreTypeRaw.toLowerCase().contains('asym') ? 'Asymmetric' : 'Symmetric';
  }

  /// 按表面材質過濾
  static List<UserArsenalInstance> _filterByCoverstocks(
    List<UserArsenalInstance> instances,
    Set<String> selectedCoverstocks,
  ) {
    if (selectedCoverstocks.isEmpty) {
      return instances;
    }
    
    return instances.where((instance) {
      final ball = instance.bowlingBall;
      return ball?.coverstockType != null && 
             selectedCoverstocks.contains(ball!.coverstockType!);
    }).toList();
  }

  /// 取得所有可用的品牌選項
  static Set<String> getAvailableBrands(List<UserArsenalInstance> instances) {
    return instances
        .where((instance) => instance.bowlingBall?.brand != null)
        .map((instance) => instance.bowlingBall!.brand)
        .toSet();
  }

  /// 取得所有可用的核心類型選項
  static Set<String> getAvailableCoreTypes(List<UserArsenalInstance> instances) {
    return instances
        .where((instance) => instance.bowlingBall?.coreType != null)
        .map((instance) => _determineCoreType(instance.bowlingBall!.coreType!))
        .toSet();
  }

  /// 取得所有可用的表面材質選項
  static Set<String> getAvailableCoverstocks(List<UserArsenalInstance> instances) {
    return instances
        .where((instance) => instance.bowlingBall?.coverstockType != null)
        .map((instance) => instance.bowlingBall!.coverstockType!)
        .toSet();
  }

  /// 檢查是否有任何過濾條件被啟用
  static bool hasActiveFilters({
    required int selectedBagNumber,
    String? selectedCategory,
    String searchText = '',
    BallFilters filters = const BallFilters(),
  }) {
    return selectedBagNumber != 1 ||
           selectedCategory != null ||
           searchText.isNotEmpty ||
           filters.brands.isNotEmpty ||
           filters.cores.isNotEmpty ||
           filters.coverstocks.isNotEmpty;
  }

  /// 清除所有過濾條件的輔助資料結構
  static FilterClearInfo getClearFilterInfo({
    required int selectedBagNumber,
    String? selectedCategory,
    String searchText = '',
    BallFilters filters = const BallFilters(),
  }) {
    return FilterClearInfo(
      shouldClearBag: selectedBagNumber != 1,
      shouldClearCategory: selectedCategory != null,
      shouldClearSearchText: searchText.isNotEmpty,
      shouldClearBrands: filters.brands.isNotEmpty,
      shouldClearCores: filters.cores.isNotEmpty,
      shouldClearCoverstocks: filters.coverstocks.isNotEmpty,
    );
  }
}

/// 過濾清除資訊類別
class FilterClearInfo {
  final bool shouldClearBag;
  final bool shouldClearCategory;
  final bool shouldClearSearchText;
  final bool shouldClearBrands;
  final bool shouldClearCores;
  final bool shouldClearCoverstocks;

  const FilterClearInfo({
    required this.shouldClearBag,
    required this.shouldClearCategory,
    required this.shouldClearSearchText,
    required this.shouldClearBrands,
    required this.shouldClearCores,
    required this.shouldClearCoverstocks,
  });

  /// 是否有任何需要清除的過濾條件
  bool get hasFiltersToClear {
    return shouldClearBag ||
           shouldClearCategory ||
           shouldClearSearchText ||
           shouldClearBrands ||
           shouldClearCores ||
           shouldClearCoverstocks;
  }
}