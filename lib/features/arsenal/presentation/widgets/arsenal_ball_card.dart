import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_ball_instance.dart';


/// Arsenal 專用的球具卡片組件
class ArsenalBallCard extends StatelessWidget {
  final ArsenalBallInstance ballInstance;
  final VoidCallback onTap;
  final bool isListView;

  const ArsenalBallCard({
    super.key,
    required this.ballInstance,
    required this.onTap,
    this.isListView = false,
  });

  @override
  Widget build(BuildContext context) {
    return isListView 
        ? _buildListCard(context)
        : _buildGridCard(context);
  }

  Widget _buildGridCard(BuildContext context) {
    final theme = Theme.of(context);
    final ball = ballInstance.bowlingBall;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getBrandColor().withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _getBrandColor().withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 球具圖片區域
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _getBrandColor().withOpacity(0.1),
                        _getBrandColor().withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 球具圖片
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildBallImage(context, 80),
                        ),
                      ),
                      // 實例編號標記
                      if (ballInstance.instanceNumber > 1)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getBrandColor(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '#${ballInstance.instanceNumber}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      // 鑽法類型標記
                      if (ballInstance.hasLayout)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Iconsax.setting_4,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // 球具資訊區域
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 球具名稱
                      Text(
                        ballInstance.displayName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // 品牌名稱
                      Text(
                        ballInstance.brandName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getBrandColor(),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      // RG/Diff 資訊
                      if (ball?.rg != null && ball?.diff != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSpecItem('RG', ball!.rg!.toStringAsFixed(2), theme),
                            _buildSpecItem('Diff', ball.diff!.toStringAsFixed(3), theme),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    final theme = Theme.of(context);
    final ball = ballInstance.bowlingBall;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(60), // 更加橢圓形
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 參考Ball Library設計
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // 調整內邊距
          decoration: BoxDecoration(
            // 橢圓形設計：黑色80%透明背景 + 品牌色邊框
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(60), // 更加橢圓形
            border: Border.all(
              color: _getBrandColor(),
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 左側：加大的圓形球具圖片
              Container(
                width: 100, // 進一步加大到100
                height: 100, // 確保 1:1 比例
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getBrandColor().withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    // 圓形裁切的球圖片
                    ClipOval(
                      child: _buildBallImage(context, 100),
                    ),
                    // 實例編號標記
                    if (ballInstance.instanceNumber > 1)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: _getBrandColor(),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              '${ballInstance.instanceNumber}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(width: 24), // 增加間距
              
              // 右側：整合所有資訊的垂直區域
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ball Name：最大字體、白色、粗體
                    Text(
                      ballInstance.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19, // 稍微加大
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Brand：橢圓形標籤
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getBrandColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20), // 橢圓形
                        border: Border.all(
                          color: _getBrandColor().withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        ballInstance.brandName,
                        style: TextStyle(
                          color: _getBrandColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Core Type & Cover Type：直接文字顯示
                    Text(
                      _buildCoreAndCoverText(ball),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Layout：獨佔一行
                    Text(
                      _buildLayoutText(),
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Games Used：獨佔一行
                    Text(
                      'Games Used: ${ballInstance.gamesUsed}',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBallImage(BuildContext context, double size) {
    final imageUrl = ballInstance.effectiveImageUrl;
    
    if (ballInstance.localImagePath != null) {
      // 本地圖片
      return Image.asset(
        ballInstance.localImagePath!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(context, size),
      );
    } else {
      // 網路圖片
      return Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingPlaceholder(context, size);
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(context, size),
      );
    }
  }

  Widget _buildPlaceholder(BuildContext context, double size) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getBrandColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Iconsax.cpu,
        color: _getBrandColor(),
        size: size * 0.5,
      ),
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildSpecItem(String label, String value, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 9,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecChip(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 建構 Core Type & Cover Type 文字
  String _buildCoreAndCoverText(dynamic ball) {
    final parts = <String>[];
    
    if (ball?.coreType != null) {
      parts.add(ball.coreType);
    }
    
    if (ball?.coverstockType != null) {
      parts.add(ball.coverstockType);
    }
    
    if (parts.isEmpty) {
      return 'No core/cover info';
    }
    
    return parts.join(' • ');
  }

  /// 建構 Layout 文字
  String _buildLayoutText() {
    if (!ballInstance.hasLayout) {
      return 'Layout: Not set';
    }
    
    final layout = ballInstance.layout!;
    final pinToPap = layout.pinToPap.toStringAsFixed(1);
    final papToMb = layout.papToMb.toStringAsFixed(1);
    final psaAngle = layout.psaAngle.toStringAsFixed(0);
    
    // 格式：5.0 x 4.0 x 50 (Control)
    return 'Layout: ${pinToPap}" x ${papToMb}" x ${psaAngle}° (${layout.layoutType.displayName})';
  }

  Color _getBrandColor() {
    // 根據品牌返回對應的顏色
    final brand = ballInstance.brandName.toLowerCase();
    
    if (brand.contains('storm')) return const Color(0xFF1E88E5);
    if (brand.contains('roto grip') || brand.contains('rotogrip')) return const Color(0xFFE53935);
    if (brand.contains('hammer')) return const Color(0xFF8E24AA);
    if (brand.contains('columbia 300')) return const Color(0xFF43A047);
    if (brand.contains('ebonite')) return const Color(0xFFFF6F00);
    if (brand.contains('brunswick')) return const Color(0xFF5E35B1);
    if (brand.contains('dv8')) return const Color(0xFF00ACC1);
    if (brand.contains('track')) return const Color(0xFFD32F2F);
    if (brand.contains('motiv')) return const Color(0xFF7CB342);
    
    // 預設顏色
    return const Color(0xFF2E7D32);
  }
}