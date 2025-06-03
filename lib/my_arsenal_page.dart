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

class MyArsenalPage extends StatefulWidget {
  const MyArsenalPage({super.key});

  @override
  State<MyArsenalPage> createState() => _MyArsenalPageState();
}

class _MyArsenalPageState extends State<MyArsenalPage> {
  List<BowlingBall> _bowlingBalls = [];

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

    // 篩選邏輯
    if (_selectedFilters['brand'] != null) {
      items = items.where((ball) => ball.brand == _selectedFilters['brand']).toList();
    }
    if (_selectedFilters['core'] != null) {
      items = items.where((ball) => ball.core == _selectedFilters['core']).toList();
    }
    if (_selectedFilters['coverstock'] != null) {
      items = items.where((ball) => ball.coverstock == _selectedFilters['coverstock']).toList();
    }

    // 排序邏輯
    items.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'Name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'RG':
          comparison = 0; // 佔位
          break;
        default:
          comparison = 0;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return items;
  }

  // 底部導覽列相關狀態和方法
  int _bottomNavIndex = 1;
  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
      if (index == 0) {
        Navigator.of(context).pop();
      } else if (index == 1) { 
        print('Already on Arsenal page');
      }
    });
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
        appBar: GFAppBar(
          backgroundColor: theme.colorScheme.primaryContainer,
          title: Text(
            'My Arsenal',
            style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
        ),
        body: Column(
          children: [
            ArsenalSearchBar(
              searchText: _searchText,
              onSearchChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
            ArsenalFilterSection(
              selectedFilters: _selectedFilters,
              onFilterChanged: (filterType, value) {
                setState(() {
                  _selectedFilters[filterType] = value;
                });
              },
            ),
            ArsenalSortSection(
              sortBy: _sortBy,
              sortAscending: _sortAscending,
              onSortChanged: (sortField, ascending) {
                setState(() {
                  _sortBy = sortField;
                  _sortAscending = ascending;
                });
              },
            ),
            BallListHeader(),
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
                  // TODO: 顯示選項選單
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: Colors.grey,
          currentIndex: _bottomNavIndex,
          onTap: _onBottomNavTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: '社群'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline, size: 36), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.sports_baseball), label: 'Arsenal'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '個人'),
          ],
        ),
      ),
    );
  }
}