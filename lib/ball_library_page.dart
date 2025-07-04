// my_arsenal_page.dart
import 'dart:developer';

import 'package:bowlingarsenal_app/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/my_training_page.dart';
import 'package:bowlingarsenal_app/providers/providers.dart';
import 'package:bowlingarsenal_app/widgets/arsenal_search_bar.dart';
import 'package:bowlingarsenal_app/widgets/ball_detail_popout.dart';
import 'package:bowlingarsenal_app/widgets/ball_list_view.dart';
import 'package:bowlingarsenal_app/widgets/filter_popout.dart';
import 'package:bowlingarsenal_app/widgets/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/widgets/professional_dark_background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 用於 SystemUiOverlayStyle
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 用於 SystemUiOverlayStyle

class BallLibraryPage extends ConsumerStatefulWidget {
  const BallLibraryPage({super.key});

  @override
  ConsumerState<BallLibraryPage> createState() => _BallLibraryPageState();
}

class _BallLibraryPageState extends ConsumerState<BallLibraryPage> {
  String _searchText = '';
  final Map<String, String?> _selectedFilters = {
    'brand': null,
    'core': null,
    'coverstock': null,
  };
  String _sortBy = 'Name';
  bool _sortAscending = true;

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
  bool _matchesCoverstockFilter(
    String ballCoverstock,
    String? selectedCoverstock,
  ) {
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
  List<BowlingBall> _getFilteredAndSortedBalls(List<BowlingBall> allBalls) {
    var items = List<BowlingBall>.from(allBalls);

    // 搜尋邏輯
    if (_searchText.isNotEmpty) {
      items =
          items
              .where(
                (ball) =>
                    ball.name.toLowerCase().contains(
                      _searchText.toLowerCase(),
                    ) ||
                    ball.brand.toLowerCase().contains(
                      _searchText.toLowerCase(),
                    ),
              )
              .toList();
    }

    // 篩選邏輯 - 使用helper方法進行部分匹配
    if (_selectedFilters['brand'] != null) {
      items =
          items
              .where(
                (ball) =>
                    _matchesBrandFilter(ball.brand, _selectedFilters['brand']),
              )
              .toList();
    }
    if (_selectedFilters['core'] != null) {
      items =
          items
              .where(
                (ball) =>
                    _matchesCoreFilter(ball.core, _selectedFilters['core']),
              )
              .toList();
    }
    if (_selectedFilters['coverstock'] != null) {
      items =
          items
              .where(
                (ball) => _matchesCoverstockFilter(
                  ball.coverstock,
                  _selectedFilters['coverstock'],
                ),
              )
              .toList();
    }

    // 排序邏輯
    items.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'Name':
          comparison = a.name.compareTo(b.name);
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

    final activeCount =
        _selectedFilters.values.where((filter) => filter != null).length;
    return 'Filter ($activeCount)';
  }

  // 底部導覽列相關狀態和方法
  int _bottomNavIndex = 1; // Ball Library在第1個位置（社群）

  void _onBottomNavTapped(int index) {
    switch (index) {
      case 0: // 首頁
        Navigator.of(context).pop(); // 返回首頁
      case 1: // 社群 (Ball Library)
        // 已經在Ball Library頁面，不需要導航
        setState(() {
          _bottomNavIndex = 1;
        });
      case 2: // 中央按鈕 (新增)
        setState(() {
          _bottomNavIndex = index;
        });
        print('Add button tapped in Ball Library');
      // TODO: 實現新增球的功能
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
      case 4: // 個人
        setState(() {
          _bottomNavIndex = index;
        });
        if (kDebugMode) {
          log('Profile button tapped in Ball Library');
        }
      // TODO: 導航到個人頁面
    }

    print('Bottom Nav Tapped in Ball Library: $index');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ballListAsync = ref.watch(ballListProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: ProfessionalDarkBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            // Professional Dark 風格的透明AppBar
            backgroundColor: Colors.transparent,
            foregroundColor: theme.colorScheme.onSurface,
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
              preferredSize: const Size.fromHeight(1),
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
          body: ballListAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (allBalls) {
              final filteredBalls = _getFilteredAndSortedBalls(allBalls);
              return Column(
                children: [
                  // 搜尋和篩選控制項
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ArsenalSearchBar(
                      searchText: _searchText,
                      onSearchChanged: (text) {
                        setState(() {
                          _searchText = text;
                        });
                      },
                    ),
                  ),
                  // Filter and Sort buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.filter_list),
                            label: Text(_getFilterButtonText()),
                            onPressed: () async {
                              final result =
                                  await showDialog<Map<String, String?>>(
                                    context: context,
                                    builder:
                                        (context) => FilterPopout(
                                          selectedFilters: _selectedFilters,
                                          onFilterChanged: (type, value) {
                                            setState(() {
                                              _selectedFilters[type] = value;
                                            });
                                          },
                                        ),
                                  );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              setState(() {
                                final parts = value.split(' ');
                                _sortBy = parts[0];
                                _sortAscending =
                                    !value.contains('High-Low') &&
                                    !value.contains('Z-A');
                              });
                            },
                            itemBuilder:
                                (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Name A-Z',
                                        child: Text('Name (A-Z)'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Name Z-A',
                                        child: Text('Name (Z-A)'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'RG Low-High',
                                        child: Text('RG (Low-High)'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'RG High-Low',
                                        child: Text('RG (High-Low)'),
                                      ),
                                    ],
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.sort),
                              label: Text('Sort: $_sortBy'),
                              onPressed: null, // PopupMenuButton handles tap
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 球列表
                  Expanded(
                    child: BallListView(
                      bowlingBalls: filteredBalls,
                      onBallTapped: (ball) {
                        // 彈出球的詳細資訊
                        showDialog(
                          context: context,
                          builder:
                              (context) => BowlingBallDetailWidget(ball: ball),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: ModernBottomNavigation(
            currentIndex: _bottomNavIndex,
            onTap: _onBottomNavTapped,
          ),
        ),
      ),
    );
  }
}
