// my_arsenal_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 用於 SystemUiOverlayStyle
import 'package:getwidget/getwidget.dart';
import 'dart:convert';
import 'widgets/arsenal_search_bar.dart';
import 'widgets/arsenal_filter_section.dart';
import 'widgets/arsenal_sort_section.dart';
import 'widgets/ball_list_header.dart';
import 'widgets/ball_list_view.dart';
import 'widgets/ball_detail_popout.dart'; // 導入球詳細資訊彈出框
import 'widgets/filter_popout.dart'; // 導入篩選彈窗
import 'widgets/modern_bottom_navigation.dart'; // 導入現代化底部導覽列
import 'my_training_page.dart';

class BallLibraryPage extends StatefulWidget {
  const BallLibraryPage({super.key});

  @override
  State<BallLibraryPage> createState() => _BallLibraryPageState();
}

class _BallLibraryPageState extends State<BallLibraryPage> {
  List<BowlingBall> _bowlingBalls = <BowlingBall>[];

  String _searchText = '';
  Map<String, String?> _selectedFilters = {
    'brand': null,
    'core': null,
    'coverstock': null,
  };
  String _sortBy = 'Name';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    final String jsonString = await rootBundle.loadString('assets/bowling_ball_data.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      _bowlingBalls = jsonList.map((e) => BowlingBall.fromJson(e)).toList();
    });
  }

  // --- Helper function for brand matching ---
  bool _matchesBrandFilter(String ballBrand, String? selectedBrand) {
    if (selectedBrand == null) {
      return true;
    }
    // Support partial matching: "Storm" should match "Storm Bowling"
    return ballBrand.toLowerCase().contains(selectedBrand.toLowerCase());
  }

  // --- Helper function for core matching ---
  bool _matchesCoreFilter(String ballCore, String? selectedCore) {
    if (selectedCore == null) {
      return true;
    }
    // Extract core category (last word) for matching
    final coreCategory = ballCore.trim().split(' ').last;
    return coreCategory.toLowerCase() == selectedCore.toLowerCase();
  }

  // --- Helper function for coverstock matching ---
  bool _matchesCoverstockFilter(String ballCoverstock, String? selectedCoverstock) {
    if (selectedCoverstock == null) {
      return true;
    }
    
    final coverLower = ballCoverstock.toLowerCase();
    final selectedLower = selectedCoverstock.toLowerCase();
    
    // Priority matching: Urethane and Polyester take precedence
    if (selectedLower == 'urethane') {
      return coverLower.contains('urethane');
    } else if (selectedLower == 'polyester') {
      return coverLower.contains('polyester') || coverLower.contains('poly');
    }
    
    // For reactive types, match the category
    if (selectedLower == 'solid reactive') {
      return coverLower.contains('solid') && coverLower.contains('reactive');
    } else if (selectedLower == 'pearl reactive') {
      return coverLower.contains('pearl') && coverLower.contains('reactive');
    } else if (selectedLower == 'hybrid reactive') {
      return coverLower.contains('hybrid') && coverLower.contains('reactive');
    }
    
    return false;
  }

  // 篩選和排序後的列表
  List<BowlingBall> get _filteredAndSortedBalls {
    List<BowlingBall> items = List.from(_bowlingBalls);

    // 搜尋邏輯
    if (_searchText.isNotEmpty) {
      items = items.where((ball) =>
        ball.name.toLowerCase().contains(_searchText.toLowerCase()) ||
        ball.brand.toLowerCase().contains(_searchText.toLowerCase())
      ).toList();
    }

    // 篩選邏輯 - 使用helper方法進行部分匹配
    if (_selectedFilters['brand'] != null) {
      items = items.where((ball) => _matchesBrandFilter(ball.brand, _selectedFilters['brand'])).toList();
    }
    if (_selectedFilters['core'] != null) {
      items = items.where((ball) => _matchesCoreFilter(ball.core, _selectedFilters['core'])).toList();
    }
    if (_selectedFilters['coverstock'] != null) {
      items = items.where((ball) => _matchesCoverstockFilter(ball.coverstock, _selectedFilters['coverstock'])).toList();
    }

    // 排序邏輯
    items.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'Name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'RG':
          // RG 排序，如果其中一個沒有 RG 值，將其排在後面
          if (a.rg == null && b.rg == null) {
            // 如果都沒有 RG 值，按名稱排序
            comparison = a.name.compareTo(b.name);
          } else if (a.rg == null) {
            comparison = 1; // a 排在後面
          } else if (b.rg == null) {
            comparison = -1; // b 排在後面
          } else {
            // 都有 RG 值，比較 RG
            comparison = a.rg!.compareTo(b.rg!);
            // 如果 RG 相同，按名稱排序
            if (comparison == 0) {
              comparison = a.name.compareTo(b.name);
            }
          }
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }
      return _sortAscending ? comparison : -comparison;
    });

    return items;
  }

  // 篩選按鈕輔助方法
  bool _hasActiveFilters() {
    return _selectedFilters.values.any((filter) => filter != null);
  }
  
  String _getFilterButtonText() {
    if (!_hasActiveFilters()) {
      return 'Filter';
    }
    
    int activeCount = _selectedFilters.values.where((filter) => filter != null).length;
    return 'Filter ($activeCount)';
  }

  // 底部導覽列相關狀態和方法
  int _bottomNavIndex = 1; // Ball Library在第1個位置（社群）
  
  void _onBottomNavTapped(int index) {
    switch (index) {
      case 0: // 首頁
        Navigator.of(context).pop(); // 返回首頁
        break;
      case 1: // 社群 (Ball Library)
        // 已經在Ball Library頁面，不需要導航
        setState(() {
          _bottomNavIndex = 1;
        });
        break;
      case 2: // 中央按鈕 (新增)
        setState(() {
          _bottomNavIndex = index;
        });
        print('Add button tapped in Ball Library');
        // TODO: 實現新增球的功能
        break;
      case 3: // 訓練
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyTrainingPage()),
        ).then((_) {
          // 返回時重置選中狀態為Ball Library
          setState(() {
            _bottomNavIndex = 1;
          });
        });
        break;
      case 4: // 個人
        setState(() {
          _bottomNavIndex = index;
        });
        print('Profile button tapped in Ball Library');
        // TODO: 導航到個人頁面
        break;
    }
    
    print('Bottom Nav Tapped in Ball Library: $index');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          // 改為白底配品牌色圖標的設計
          backgroundColor: Colors.white,
          foregroundColor: theme.colorScheme.primary,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Ball Library',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          // 添加細微的底部邊框
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    theme.colorScheme.outlineVariant.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // 搜尋列
            ArsenalSearchBar(
              searchText: _searchText,
              onSearchChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
            
            // 16dp 間距
            const SizedBox(height: 16),
            
            // 篩選和排序區域
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // 篩選按鈕
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 44, // 統一固定高度
                      child: OutlinedButton(
                        onPressed: () {
                          showFilterPopout(
                            context,
                            _selectedFilters,
                            (filterType, value) {
                              setState(() {
                                _selectedFilters[filterType] = value;
                              });
                            },
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0), // 移除vertical padding
                          minimumSize: Size.zero, // 移除最小尺寸限制
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 縮小點擊區域
                          side: BorderSide(
                            color: theme.colorScheme.primary.withOpacity(0.5),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: _hasActiveFilters() 
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : Colors.transparent,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center, // 置中對齊
                          children: [
                            Icon(
                              Icons.tune,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              _getFilterButtonText(),
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.2, // 統一行高
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // 排序下拉選單按鈕
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 44, // 統一固定高度
                      child: PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            if (value.contains('_desc')) {
                              _sortBy = value.replaceAll('_desc', '');
                              _sortAscending = false;
                            } else {
                              _sortBy = value;
                              _sortAscending = true;
                            }
                          });
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'Name',
                            child: Row(
                              children: [
                                Icon(Icons.sort_by_alpha, size: 20, color: theme.colorScheme.primary),
                                SizedBox(width: 8),
                                Text('Name (A-Z)'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Name_desc',
                            child: Row(
                              children: [
                                Icon(Icons.sort_by_alpha, size: 20, color: theme.colorScheme.primary),
                                SizedBox(width: 8),
                                Text('Name (Z-A)'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'RG',
                            child: Row(
                              children: [
                                Icon(Icons.numbers, size: 20, color: theme.colorScheme.primary),
                                SizedBox(width: 8),
                                Text('RG (Low-High)'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'RG_desc',
                            child: Row(
                              children: [
                                Icon(Icons.numbers, size: 20, color: theme.colorScheme.primary),
                                SizedBox(width: 8),
                                Text('RG (High-Low)'),
                              ],
                            ),
                          ),
                        ],
                        child: Container(
                          width: double.infinity,
                          height: double.infinity, // 填滿SizedBox的高度
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.5),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center, // 置中對齊
                            children: [
                              Icon(
                                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Sort: $_sortBy',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  height: 1.2, // 統一行高
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // 清除篩選按鈕
                  if (_hasActiveFilters()) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilters['brand'] = null;
                          _selectedFilters['core'] = null;
                          _selectedFilters['coverstock'] = null;
                        });
                      },
                      icon: Icon(
                        Icons.clear,
                        color: theme.colorScheme.error,
                        size: 18,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.error.withOpacity(0.1),
                        padding: EdgeInsets.all(6),
                      ),
                      tooltip: 'Clear all filters',
                    ),
                  ],
                ],
              ),
            ),
            
            // 列表標題
            BallListHeader(),
            
            // 16dp 間距
            const SizedBox(height: 16),
            
            // 球列表
            Expanded(
              child: BallListView(
                balls: _filteredAndSortedBalls,
                searchText: _searchText,
                onBallTap: (ball) {
                  print('Navigate to ball detail: ${ball.name}');
                  // TODO: 導航到球詳細頁面
                },
                onBallLongPress: (ball) {
                  print('Show ball options: ${ball.name}');
                  // 顯示球詳細資訊彈出框
                  showBallDetails(context, ball);
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: _bottomNavIndex,
          onTap: _onBottomNavTapped,
        ),
      ),
    );
  }



  /// 漸層效果設計
  Widget _buildGradientNavigationBar(ThemeData theme) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildGradientNavItem(Icons.home, '首頁', 0, theme),
            _buildGradientNavItem(Icons.people, '社群', 1, theme),
            _buildGradientNavItem(Icons.add_circle_outline, '', 2, theme, isCenter: true),
            _buildGradientNavItem(Icons.sports_baseball, 'Training', 3, theme),
            _buildGradientNavItem(Icons.account_circle, '個人', 4, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientNavItem(IconData icon, String label, int index, ThemeData theme, {bool isCenter = false}) {
    final bool isSelected = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () => _onBottomNavTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(isCenter ? 12 : 8),
              decoration: isSelected
                ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  )
                : null,
              child: Icon(
                icon,
                color: isSelected 
                  ? Colors.white
                  : theme.colorScheme.onSurface.withOpacity(0.6),
                size: isCenter ? 28 : 24,
              ),
            ),
            if (label.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}