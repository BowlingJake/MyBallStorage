import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui';
import '../models/arsenal_ball.dart';
import '../models/ball_bag_type.dart';
import '../widgets/action_button_pair.dart';
import '../widgets/bag_selector_widget.dart';
import '../widgets/ball_grid_widget.dart';
import '../widgets/ball_bag_options_dialog.dart';
import '../widgets/professional_dark_background.dart';
import '../widgets/section_container.dart';
import '../widgets/modern_bottom_navigation.dart';

final bottomIndexProvider = StateProvider<int>((ref) => 0);
final selectedBagTypeProvider = StateProvider<BallBagType>((ref) => BallBagType.all);

/// Mock data for the arsenal grid.
final userBallsProvider = Provider<List<ArsenalBall>>((ref) => [
      ArsenalBall(
        name: 'Jackal EXJ',
        core: 'Predator V2',
        cover: 'Propulsion HVH Hybrid Reactive',
        layout: '4x4x2',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Motiv',
        dateAdded: DateTime(2024, 1, 15),
        bagType: BallBagType.competition,
      ),
      ArsenalBall(
        name: 'Phaze II',
        core: 'R2S Pearl',
        cover: 'R2S Pearl Reactive',
        layout: '5x3x3',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Storm',
        dateAdded: DateTime(2024, 2, 20),
        bagType: BallBagType.competition,
      ),
      ArsenalBall(
        name: 'IQ Tour',
        core: 'C3 Centripetal Control Core',
        cover: 'R2S Solid Reactive',
        layout: '4.5x4x2',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Storm',
        dateAdded: DateTime(2024, 3, 10),
        bagType: BallBagType.practice,
      ),
      ArsenalBall(
        name: 'Hustle Ink',
        core: 'VTC-P18',
        cover: 'VTC-S19 Solid Reactive',
        layout: '5x4x3',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Roto Grip',
        dateAdded: DateTime(2024, 1, 5),
        bagType: BallBagType.practice,
      ),
      ArsenalBall(
        name: 'Code Black',
        core: 'RAD4 Core',
        cover: 'HK22 Solid Reactive',
        layout: '4.5x3.5x3',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Motiv',
        dateAdded: DateTime(2024, 4, 2),
        bagType: BallBagType.competition,
      ),
    ]);

/// Filter balls based on selected bag type
final filteredBallsProvider = Provider<List<ArsenalBall>>((ref) {
  final allBalls = ref.watch(userBallsProvider);
  final selectedBagType = ref.watch(selectedBagTypeProvider);
  
  if (selectedBagType == BallBagType.all) {
    return allBalls;
  }
  
  return allBalls.where((ball) => ball.bagType == selectedBagType).toList();
});

/// A simple page showing the user's arsenal.
class MyArsenalPage extends ConsumerWidget {
  const MyArsenalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomIndexProvider);
    final selectedBagType = ref.watch(selectedBagTypeProvider);
    final balls = ref.watch(filteredBallsProvider);
    final theme = Theme.of(context);

    return ProfessionalDarkBackground(
      backgroundImage: 'images/Sport_Tech_Background.png',
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 控制區域 - 使用簡化的容器
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ball Bag',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Bag selector dropdown 
                        Expanded(
                          flex: 3,
                          child: _buildModernDropdown(theme, selectedBagType, ref),
                        ),
                        const SizedBox(width: 12),
                        // Create ball bag button
                        Expanded(
                          flex: 2,
                          child: _buildCreateBagButton(theme, context, ref),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 球的網格 - 使用簡化的容器
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      width: 1.0,
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
                        child: balls.isEmpty
                            ? _buildEmptyState(theme)
                            : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.65,
                                ),
                                itemCount: balls.length,
                                itemBuilder: (context, index) {
                                  final ball = balls[index];
                                  return _buildBallCard(theme, ball);
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
          currentIndex: 1, // Arsenal 頁面在第1個位置
          onTap: (index) => _handleBottomNavigation(context, index, ref),
        ),
      ),
    );
  }

  Widget _buildModernDropdown(ThemeData theme, BallBagType selectedBagType, WidgetRef ref) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<BallBagType>(
        value: selectedBagType,
        hint: Text(
          '選擇球袋',
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        items: BallBagType.values.map((bagType) {
          return DropdownMenuItem<BallBagType>(
            value: bagType,
            child: Text(
              bagType.displayName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        onChanged: (BallBagType? value) {
          if (value != null) {
            ref.read(selectedBagTypeProvider.notifier).state = value;
          }
        },
        isExpanded: true,
        buttonStyleData: ButtonStyleData(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.5),
              width: 1.5,
            ),
            color: Colors.transparent, // 透明背景
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Iconsax.arrow_down_1,
            color: theme.colorScheme.primary,
            size: 16,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface.withOpacity(0.95),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          offset: const Offset(0, 4),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildCreateBagButton(ThemeData theme, BuildContext context, WidgetRef ref) {
    return Container(
      height: 40,
      child: OutlinedButton.icon(
        onPressed: () {
          _showBallBagOptionsDialog(context, ref);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface.withOpacity(0.2), // 霧化玻璃背景
          side: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.7),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          elevation: 0,
        ),
        icon: Icon(Iconsax.add_circle, size: 16, color: theme.colorScheme.primary),
        label: Text(
          'Create Bag',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
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

  Widget _buildBallCard(ThemeData theme, ArsenalBall ball) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 球的圖片
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Iconsax.box,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 球的名稱
            Text(
              ball.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // 品牌
            Text(
              ball.brand,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                      backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
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

  void _showBallBagOptionsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return const BallBagOptionsDialog();
      },
    );
  }

  void _handleBottomNavigation(BuildContext context, int index, WidgetRef ref) {
    switch (index) {
      case 0: // 首頁
        Navigator.of(context).pop(); // 返回首頁
        break;
      case 1: // Arsenal
        // 已經在 Arsenal 頁面，不需要導航
        break;
      case 2: // 中央按鈕 (新增)
        print('Add button tapped in Arsenal');
        // TODO: 實現新增球的功能
        break;
      case 3: // 訓練
        print('Training button tapped in Arsenal');
        // TODO: 導航到訓練頁面
        break;
      case 4: // 設定
        print('Settings button tapped in Arsenal');
        // TODO: 導航到設定頁面
        break;
    }
    // 更新當前索引
    ref.read(bottomIndexProvider.notifier).state = index;
  }
}
