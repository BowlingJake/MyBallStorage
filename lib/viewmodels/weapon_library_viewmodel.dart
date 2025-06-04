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
  String getCoreCategory(String coreName) {
    if (coreName.trim().isEmpty) {
      return '未知'; // Handle empty core names
    }
    final parts = coreName.trim().split(' ');
    return parts.last; // Return last part (works even if no space)
  }

  // --- Helper function for brand matching ---
  bool _matchesBrandFilter(String ballBrand, String? selectedBrand) {
    if (selectedBrand == null || selectedBrand == allFilterOption) {
      return true;
    }
    // Support partial matching: "Storm" should match "Storm Bowling"
    return ballBrand.toLowerCase().contains(selectedBrand.toLowerCase());
  }

  // --- Helper function to extract simplified brand name for filter options ---
  String _getSimplifiedBrandName(String fullBrandName) {
    // Extract the main brand name from full brand name
    // e.g., "Storm Bowling" -> "Storm", "Hammer Bowling" -> "Hammer"
    final Map<String, String> brandMapping = {
      'Storm Bowling': 'Storm',
      'Hammer Bowling': 'Hammer', 
      'Brunswick Bowling': 'Brunswick',
      'Roto Grip': 'Roto Grip',
      'Motiv Bowling': 'Motiv',
      'Columbia 300': 'Columbia 300',
      'Ebonite': 'Ebonite',
      '900 Global': '900 Global',
      'Track Bowling': 'Track',
      'Radical Bowling': 'Radical',
      'SWAG Bowling': 'SWAG',
    };
    
    return brandMapping[fullBrandName] ?? fullBrandName;
  }

  // --- Dynamic Filter Options --- 
  List<String> get arsenalBrands {
    final brands = myArsenal.map((ball) => _getSimplifiedBrandName(ball.brand)).toSet().toList();
    brands.sort();
    return [allFilterOption, ...brands];
  }

  List<String> get arsenalCoreCategories {
    // Use the public helper function
    final categories = myArsenal.map((ball) => getCoreCategory(ball.core)).toSet().toList();
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

      // Dropdown filters - use helper method for brand matching
      final brandMatch = _matchesBrandFilter(ball.brand, selectedBrandFilter);
      final coreCategoryMatch = selectedCoreCategoryFilter == null || 
                                selectedCoreCategoryFilter == allFilterOption ||
                                getCoreCategory(ball.core) == selectedCoreCategoryFilter;
      final coverstockCategoryMatch = selectedCoverstockCategoryFilter == null || 
                                      selectedCoverstockCategoryFilter == allFilterOption ||
                                      ball.coverstockcategory == selectedCoverstockCategoryFilter;
      
      return keywordMatch && brandMatch && coreCategoryMatch && coverstockCategoryMatch;
    }).toList();
  }

  // --- Dynamic Filter Options for All Balls ---
  List<String> get allAvailableBrands {
    final brands = allBalls.map((ball) => _getSimplifiedBrandName(ball.brand)).toSet().toList();
    brands.sort();
    return [allFilterOption, ...brands];
  }

  List<String> get allAvailableCoreCategories {
    final categories = allBalls.map((ball) => getCoreCategory(ball.core)).toSet().toList();
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

      // Dropdown filters - use helper method for brand matching
      final brandMatch = _matchesBrandFilter(ball.brand, selectedBrandFilterForSearch);
      final coreCategoryMatch = selectedCoreCategoryFilterForSearch == null ||
                                selectedCoreCategoryFilterForSearch == allFilterOption ||
                                getCoreCategory(ball.core) == selectedCoreCategoryFilterForSearch;
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
    final currentBrands = myArsenal.map((ball) => _getSimplifiedBrandName(ball.brand)).toSet();
    final currentCoreCategories = myArsenal.map((ball) => getCoreCategory(ball.core)).toSet();
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

  // --- Getter to check if any arsenal filters are active ---
  bool get hasActiveFilters {
    return (selectedBrandFilter != null && selectedBrandFilter != allFilterOption) ||
           (selectedCoreCategoryFilter != null && selectedCoreCategoryFilter != allFilterOption) ||
           (selectedCoverstockCategoryFilter != null && selectedCoverstockCategoryFilter != allFilterOption);
  }

  // --- Method to update arsenal search keyword ---
  void filterArsenal(String keyword) {
    currentArsenalSearchKeyword = keyword.toLowerCase();
    notifyListeners();
  }

  // Method to get a specific ball from the arsenal by its name
  BowlingBall? getBallByName(String name) {
    try {
      // Find the first ball in myArsenal where the ball name matches.
      // Use firstWhereOrNull from collection package (imported implicitly via flutter/material?)
      // Or implement manually:
      for (final ball in myArsenal) {
        if (ball.ball == name) {
          return ball;
        }
      }
      // If no ball is found, return null.
      return null;
    } catch (e) {
      // Handle potential errors, e.g., if myArsenal is not yet initialized (though unlikely with final).
      print("Error finding ball by name '$name': $e");
      return null;
    }
  }
}
