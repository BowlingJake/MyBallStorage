import 'package:flutter/material.dart';
import '../models/bowling_ball.dart';
import '../services/ball_data_service.dart';

/// ViewModel 負責管理武器庫頁面的邏輯、狀態
class WeaponLibraryViewModel extends ChangeNotifier {
  /// 所有球的資料（從 service 載入）
  List<BowlingBall> allBalls = [];
  /// 過濾後（搜尋用）- 這個主要用於新增頁面
  List<BowlingBall> filteredBallsForSearch = [];

  /// 我的武器清單
  final List<BowlingBall> myArsenal = [];

  // --- Filtering State for My Arsenal --- 
  String? selectedBrandFilter;
  String? selectedCoreCategoryFilter;
  String? selectedCoverstockCategoryFilter;
  String currentArsenalSearchKeyword = ''; // Keyword for the main arsenal page

  // Make this public
  static const String allFilterOption = '全部';

  // --- Filtering State for Search Page ---
  String? selectedBrandFilterForSearch;
  String? selectedCoreCategoryFilterForSearch;
  String? selectedCoverstockCategoryFilterForSearch;
  String currentSearchKeyword = ''; // Keep track of the keyword

  // --- Helper function for safer core category extraction ---
  String _getCoreCategory(String coreName) {
    if (coreName.trim().isEmpty) {
      return '未知'; // Handle empty core names
    }
    final parts = coreName.trim().split(' ');
    return parts.last; // Return last part (works even if no space)
  }

  // --- Dynamic Filter Options --- 
  List<String> get arsenalBrands {
    final brands = myArsenal.map((ball) => ball.brand).toSet().toList();
    brands.sort();
    return [allFilterOption, ...brands];
  }

  List<String> get arsenalCoreCategories {
    // Use the helper function
    final categories = myArsenal.map((ball) => _getCoreCategory(ball.core)).toSet().toList();
    categories.sort();
    return [allFilterOption, ...categories];
  }

  List<String> get arsenalCoverstockCategories {
    final categories = myArsenal.map((ball) => ball.coverstockcategory).toSet().toList();
    categories.sort();
    return [allFilterOption, ...categories];
  }

  // --- Filtered Arsenal List --- 
  List<BowlingBall> get filteredArsenal {
    return myArsenal.where((ball) {
      // Keyword filter for arsenal page (apply to ball name)
      final keywordMatch = currentArsenalSearchKeyword.isEmpty ||
                           ball.ball.toLowerCase().contains(currentArsenalSearchKeyword);

      // Dropdown filters
      final brandMatch = selectedBrandFilter == null || 
                         selectedBrandFilter == allFilterOption || 
                         ball.brand == selectedBrandFilter;
      final coreCategoryMatch = selectedCoreCategoryFilter == null || 
                                selectedCoreCategoryFilter == allFilterOption ||
                                _getCoreCategory(ball.core) == selectedCoreCategoryFilter; 
      final coverstockCategoryMatch = selectedCoverstockCategoryFilter == null || 
                                      selectedCoverstockCategoryFilter == allFilterOption ||
                                      ball.coverstockcategory == selectedCoverstockCategoryFilter;
      
      return keywordMatch && brandMatch && coreCategoryMatch && coverstockCategoryMatch;
    }).toList();
  }

  // --- Dynamic Filter Options for All Balls ---
  List<String> get allAvailableBrands {
    final brands = allBalls.map((ball) => ball.brand).toSet().toList();
    brands.sort();
    return [allFilterOption, ...brands];
  }

  List<String> get allAvailableCoreCategories {
    final categories = allBalls.map((ball) => _getCoreCategory(ball.core)).toSet().toList();
    categories.sort();
    return [allFilterOption, ...categories];
  }

  List<String> get allAvailableCoverstockCategories {
    final categories = allBalls.map((ball) => ball.coverstockcategory).toSet().toList();
    categories.sort();
    return [allFilterOption, ...categories];
  }

  // --- Update Filter Methods --- 
  void updateSelectedBrandFilter(String? brand) {
    selectedBrandFilter = brand;
    notifyListeners();
  }

  void updateSelectedCoreCategoryFilter(String? category) {
    selectedCoreCategoryFilter = category;
    notifyListeners();
  }

  void updateSelectedCoverstockCategoryFilter(String? category) {
    selectedCoverstockCategoryFilter = category;
    notifyListeners();
  }

  // --- Update Filter Methods for Search Page ---
  void updateSelectedBrandFilterForSearch(String? brand) {
    selectedBrandFilterForSearch = brand;
    _applySearchFilters(); // Re-apply filters
  }

  void updateSelectedCoreCategoryFilterForSearch(String? category) {
    selectedCoreCategoryFilterForSearch = category;
    _applySearchFilters(); // Re-apply filters
  }

  void updateSelectedCoverstockCategoryFilterForSearch(String? category) {
    selectedCoverstockCategoryFilterForSearch = category;
    _applySearchFilters(); // Re-apply filters
  }

  /// 載入 JSON
  Future<void> loadBallData() async {
    allBalls = await BallDataService.loadBallData();
    filteredBallsForSearch = allBalls; // Initialize search list
    notifyListeners();
  }

  /// 新增到我的武器（HomePage 會使用）
  void addBallToArsenal(BowlingBall ball) {
    if (!myArsenal.contains(ball)) {
      myArsenal.add(ball);
      // Validate filters *before* notifying listeners
      _validateAndResetFilters(); 
      notifyListeners(); 
    }
  }

  /// 從我的武器中移除
  void removeBallFromArsenal(BowlingBall ball) {
    myArsenal.remove(ball);
    // Validate filters *before* notifying listeners
    _validateAndResetFilters(); 
    notifyListeners();
  }

  // --- Combined Filtering Logic for Search Page ---
  void filterBalls(String keyword) {
    currentSearchKeyword = keyword.toLowerCase();
    _applySearchFilters();
  }

  void _applySearchFilters() {
    filteredBallsForSearch = allBalls.where((ball) {
      // Keyword filter (applies to ball name currently)
      final keywordMatch = currentSearchKeyword.isEmpty ||
                           ball.ball.toLowerCase().contains(currentSearchKeyword);

      // Dropdown filters
      final brandMatch = selectedBrandFilterForSearch == null ||
                         selectedBrandFilterForSearch == allFilterOption ||
                         ball.brand == selectedBrandFilterForSearch;
      final coreCategoryMatch = selectedCoreCategoryFilterForSearch == null ||
                                selectedCoreCategoryFilterForSearch == allFilterOption ||
                                _getCoreCategory(ball.core) == selectedCoreCategoryFilterForSearch;
      final coverstockCategoryMatch = selectedCoverstockCategoryFilterForSearch == null ||
                                      selectedCoverstockCategoryFilterForSearch == allFilterOption ||
                                      ball.coverstockcategory == selectedCoverstockCategoryFilterForSearch;

      return keywordMatch && brandMatch && coreCategoryMatch && coverstockCategoryMatch;
    }).toList();
    notifyListeners();
  }

  // --- Helper function to check and reset filters if selected value is no longer valid ---
  void _validateAndResetFilters() {
    // Regenerate options based on current arsenal to check against
    final currentBrands = myArsenal.map((ball) => ball.brand).toSet();
    final currentCoreCategories = myArsenal.map((ball) => _getCoreCategory(ball.core)).toSet();
    final currentCoverstockCategories = myArsenal.map((ball) => ball.coverstockcategory).toSet();

    bool filterChanged = false;

    // Check Brand Filter
    if (selectedBrandFilter != null &&
        selectedBrandFilter != allFilterOption &&
        !currentBrands.contains(selectedBrandFilter)) {
      selectedBrandFilter = null; // Reset to null to show hint
      filterChanged = true;
    }

    // Check Core Category Filter
    if (selectedCoreCategoryFilter != null &&
        selectedCoreCategoryFilter != allFilterOption &&
        !currentCoreCategories.contains(selectedCoreCategoryFilter)) {
      selectedCoreCategoryFilter = null; // Reset to null
      filterChanged = true;
    }

    // Check Coverstock Category Filter
    if (selectedCoverstockCategoryFilter != null &&
        selectedCoverstockCategoryFilter != allFilterOption &&
        !currentCoverstockCategories.contains(selectedCoverstockCategoryFilter)) {
      selectedCoverstockCategoryFilter = null; // Reset to null
      filterChanged = true;
    }

    // If any filter was reset, we need to notify listeners, 
    // but notifyListeners is already called in add/remove methods, so this check is mainly for logic clarity.
    // if (filterChanged) { 
    //   // Not strictly needed here as parent methods call notifyListeners
    // }
  }

  // --- Method to update arsenal search keyword ---
  void filterArsenal(String keyword) {
    currentArsenalSearchKeyword = keyword.toLowerCase();
    notifyListeners();
  }
}
