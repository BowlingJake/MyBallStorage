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

import 'package:bowlingarsenal_app/widgets/ball_library_controls.dart'; // 引入新的 Widget

class BallLibraryPage extends ConsumerStatefulWidget {
  const BallLibraryPage({super.key});

  @override
  ConsumerState<BallLibraryPage> createState() => _BallLibraryPageState();
}

class _BallLibraryPageState extends ConsumerState<BallLibraryPage> {
  // 底部導覽列相關狀態和方法
  int _bottomNavIndex = 1; // Ball Library在第1個位置（社群）

  void _onBottomNavTapped(int index) {
    if (_bottomNavIndex == index) return; // 如果點擊的是當前分頁，則不執行任何操作

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
        );
        break;
      case 4: // 個人
        setState(() {
          _bottomNavIndex = index;
        });
        if (kDebugMode) {
          log('Profile button tapped in Ball Library');
        }
        // TODO: 導航到個人頁面
        break;
    }

    print('Bottom Nav Tapped in Ball Library: $index');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 監聽最原始的 Provider，只用於檢查載入和錯誤狀態
    final ballListAsync = ref.watch(ballListProvider);
    // 監聽新的計算後的 Provider 來獲取要顯示的資料
    final filteredBalls = ref.watch(filteredBallListProvider);

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
            data: (_) { // 原始資料載入成功後，我們就使用 filteredBalls
              return Column(
                children: [
                  // 搜尋和篩選控制項，現在由一個獨立的 widget 負責
                  const BallLibraryControls(),
                  // 球列表
                  Expanded(
                    child: BallListView(
                      bowlingBalls: filteredBalls, // 直接使用 Provider 計算後的列表
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
