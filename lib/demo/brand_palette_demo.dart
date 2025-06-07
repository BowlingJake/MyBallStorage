import 'package:flutter/material.dart';
import '../theme/brand_colors.dart';
import '../models/arsenal_ball.dart';
import '../models/ball_bag_type.dart';

/// 設計測試頁面
class BrandPaletteDemoPage extends StatelessWidget {
  const BrandPaletteDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brands = ['Storm', 'Motiv', 'Brunswick', 'Hammer', 'Roto Grip'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('設計測試頁面'),
        backgroundColor: Colors.white,
        foregroundColor: theme.colorScheme.primary,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題區域
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '色環設計測試',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '灰底卡片 + 4px 品牌色圓環',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 色環卡片網格 - 類似 Library 頁面佈局
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7, // 調整比例適配新的卡片佈局
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return _ColorRingCard(
                  ball: _createSampleBall(brand),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // 設計說明
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '設計特色',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _FeatureItem('🎨', '4px 品牌色圓環套在整個卡片外面'),
                  _FeatureItem('⚪', '中性灰底卡片保持內容易讀'),
                  _FeatureItem('📋', '仿造 Library 頁面的卡片佈局'),
                  _FeatureItem('🎯', '圓環提供強烈的品牌視覺識別'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _FeatureItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ArsenalBall _createSampleBall(String brand) {
    return ArsenalBall(
      name: brand == 'Storm' ? 'Jackal EXJ' : '$brand Demo',
      core: 'Demo Core',
      cover: 'Demo Cover',
      layout: '4.5" x 4" x 2"',
      imagePath: brand == 'Storm' ? 'assets/images/Jackal EXJ.jpg' : 'assets/images/placeholder_ball.png',
      brand: brand,
      dateAdded: DateTime.now(),
      bagType: BallBagType.practice,
    );
  }
}

/// 色環設計卡片 - 仿造 Library 頁面卡片佈局
class _ColorRingCard extends StatelessWidget {
  final ArsenalBall ball;
  
  const _ColorRingCard({required this.ball});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandPalette = getBrandTonalPalette(ball.brand, theme);
    final brandColor = brandPalette.shade600; // 使用較深的品牌色作為圓環
    
    return Container(
      decoration: BoxDecoration(
        // 4px 品牌色圓環套在整個卡片外面
        border: Border.all(
          color: brandColor,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(20), // 圓角略大以配合邊框
        boxShadow: [
          BoxShadow(
            color: brandColor.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
              child: Container(
          decoration: BoxDecoration(
            // 透明背景卡片
            color: Colors.transparent,
          borderRadius: BorderRadius.circular(16), // 內側圓角稍小
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 球圖片 - 類似 Library 頁面的佈局
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1.2, // 橫向矩形
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ball.name == 'Jackal EXJ' 
                      ? Image.asset(
                          ball.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.sports_volleyball,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Icon(
                            Icons.sports_volleyball,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // 球名稱 - 類似 Library 頁面樣式
              Text(
                ball.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // 品牌名稱
              Text(
                ball.brand,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: brandColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // 詳細資訊 - 類似 Library 頁面
              Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      ball.core,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 4),
              
              Row(
                children: [
                  Icon(
                    Icons.texture_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      ball.cover,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // 底部品牌色指示條
              Container(
                width: double.infinity,
                height: 3,
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: brandColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 