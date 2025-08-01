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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getBrandColor().withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // 球具圖片
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      _getBrandColor().withOpacity(0.1),
                      _getBrandColor().withOpacity(0.05),
                    ],
                  ),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildBallImage(context, 50),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 球具資訊
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ballInstance.displayName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (ballInstance.instanceNumber > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getBrandColor().withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#${ballInstance.instanceNumber}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _getBrandColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          ballInstance.brandName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _getBrandColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (ballInstance.hasLayout) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Iconsax.setting_4,
                            size: 14,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            ballInstance.layout!.layoutType.displayName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (ball?.rg != null && ball?.diff != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildSpecChip('RG: ${ball!.rg!.toStringAsFixed(2)}', theme),
                          const SizedBox(width: 8),
                          _buildSpecChip('Diff: ${ball.diff!.toStringAsFixed(3)}', theme),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // 操作按鈕
              Icon(
                Iconsax.arrow_right_3,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                size: 20,
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