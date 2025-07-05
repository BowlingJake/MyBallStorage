import 'dart:ui';

import 'package:bowlingarsenal_app/models/ball_bag_type.dart';
import 'package:bowlingarsenal_app/providers/arsenal_providers.dart';
import 'package:bowlingarsenal_app/widgets/features/arsenal/arsenal_ball_card.dart';
import 'package:bowlingarsenal_app/widgets/features/arsenal/arsenal_controls.dart';
import 'package:bowlingarsenal_app/widgets/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/widgets/professional_dark_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

/// A simple page showing the user's arsenal.
class MyArsenalPage extends ConsumerWidget {
  const MyArsenalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomIndexProvider);
    final selectedBagType = ref.watch(selectedBagTypeProvider);
    final balls = ref.watch(filteredBallsProvider);
    final theme = Theme.of(context);

    // 確保進入 Arsenal 頁面時，bottomIndexProvider 設置為正確的索引（1）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentIndex != 1) {
        ref.read(bottomIndexProvider.notifier).state = 1;
      }
    });

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'My Arsenal',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 控制區域 - 使用新的 ArsenalControls 組件
              const ArsenalControls(),

              const SizedBox(height: 16),

              // 球的網格 - 使用簡化的容器
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedBagType == BallBagType.all
                            ? 'All Balls (${balls.length})'
                            : '${selectedBagType.displayName} (${balls.length})',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child:
                            balls.isEmpty
                                ? _buildEmptyState(theme)
                                : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: 0.65,
                                      ),
                                  itemCount: balls.length,
                                  itemBuilder: (context, index) {
                                    final ball = balls[index];
                                    return ArsenalBallCard(
                                      ball: ball,
                                      onTap: () {
                                        // TODO: 導航到球詳細頁面
                                        print('Tapped on ${ball.name}');
                                      },
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // 現代化浮動按鈕
        floatingActionButton: _buildModernFAB(theme, context),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: currentIndex, // 使用 bottomIndexProvider 的狀態
          onTap: (index) => _handleBottomNavigation(context, index, ref),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Text(
        'No balls found',
        style: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildModernFAB(ThemeData theme, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surface.withOpacity(0.3), // 霧化玻璃背景
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () {
                  // TODO: 實現分析圖表功能
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Analyze Chart功能待實現',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.surface.withOpacity(
                        0.9,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Icon(
                    Iconsax.chart_2,
                    size: 24,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleBottomNavigation(BuildContext context, int index, WidgetRef ref) {
    switch (index) {
      case 0: // 首頁
        Navigator.of(context).pop(); // 返回首頁
      case 1: // Arsenal
        // 已經在 Arsenal 頁面，不需要導航
        break;
      case 2: // 中央按鈕 (新增)
        print('Add button tapped in Arsenal');
      // TODO: 實現新增球的功能
      case 3: // 訓練
        print('Training button tapped in Arsenal');
      // TODO: 導航到訓練頁面
      case 4: // 設定
        print('Settings button tapped in Arsenal');
      // TODO: 導航到設定頁面
    }
    // 更新當前索引
    ref.read(bottomIndexProvider.notifier).state = index;
  }
}
