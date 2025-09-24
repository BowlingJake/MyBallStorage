import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';


/// Arsenal 專用的球具卡片組件
class ArsenalBallCard extends StatelessWidget {
  final UserArsenalInstance ballInstance;
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // 比主背景稍亮的背景色
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08), // 更低透明度
                blurRadius: 12, // 更大模糊半徑
                offset: const Offset(0, 4), // 稍微向下偏移
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04), // 第二層更柔和陰影
                blurRadius: 6,
                offset: const Offset(0, 2),
                spreadRadius: 0,
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
                          child: _buildBallImage(context, 60), // 縮小圖片
                        ),
                      ),
                      // 實例編號標記 (UserArsenalInstance 沒有 instanceNumber，暫時移除)
                      // if (ballInstance.instanceNumber > 1)
                      //   Positioned(
                      //     top: 8,
                      //     right: 8,
                      //     child: Container(
                      //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      //       decoration: BoxDecoration(
                      //         color: _getBrandColor(),
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Text(
                      //         '#${ballInstance.instanceNumber}',
                      //         style: theme.textTheme.labelSmall?.copyWith(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 10,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
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
                      // 球具名稱 - 最重要的信息
                      Text(
                        ballInstance.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600, // Semibold
                          color: Color(0xFFFFFFFF), // 最亮的白色
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // 品牌名稱
                      Text(
                        ballInstance.brandName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _getBrandColor(),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // 球屬性信息 - 次要描述
                      Text(
                        _buildCoreAndCoverText(ballInstance.bowlingBall),
                        style: const TextStyle(
                          fontSize: 11, // 比球名小5pt
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9CA3AF), // 淺灰色
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      // 移除 RG/Diff 資訊顯示
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
    final ball = ballInstance.bowlingBall;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xFF1E1E1E), // 比主背景稍亮的背景色
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08), // 更低透明度
                blurRadius: 12, // 更大模糊半徑
                offset: const Offset(0, 4), // 稍微向下偏移
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04), // 第二層更柔和陰影
                blurRadius: 6,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              // 左側：縮小的圓形球具圖片
              SizedBox(
                width: 80, // 縮小球的照片
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: ClipOval(
                    child: _buildBallImage(context, 80),
                  ),
                ),
              ),
              const SizedBox(width: 20), // 增加間距
              // 右側：重新設計的文字層級
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 球名 - 最重要，最亮白色，Medium/Semibold
                    Text(
                      ballInstance.displayName,
                      style: const TextStyle(
                        fontSize: 18, // 保持主要標題大小
                        fontWeight: FontWeight.w600, // Semibold
                        color: Color(0xFFFFFFFF), // 最亮的白色
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // 品牌名稱 - 放在球名下方
                    Text(
                      ballInstance.brandName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _getBrandColor(),
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // 球屬性 - 次要描述，淺灰色，小一點
                    Text(
                      _buildCoreAndCoverText(ballInstance.bowlingBall),
                      style: const TextStyle(
                        fontSize: 12, // 比球名小6pt
                        fontWeight: FontWeight.w400, // Normal weight
                        color: Color(0xFF9CA3AF), // 淺灰色，降低視覺優先級
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // 底部信息行 - Games Used 和 Layout
                    Row(
                      children: [
                        Text(
                          'Games: ${ballInstance.gamesUsed}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF6B7280), // 更暗的灰色
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _buildLayoutText(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBallImage(BuildContext context, double size) {
    final imageUrl = ballInstance.effectiveImageUrl;
    
    // 直接使用網路圖片，UserArsenalInstance 沒有 localImagePath 屬性
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

  Widget _buildPlaceholder(BuildContext context, double size) {
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


  /// 建構 Core Type & Cover Type 文字
  String _buildCoreAndCoverText(dynamic ball) {
    final parts = <String>[];
    
    // 使用 BowlingBall 的 core 和 cover 擴展屬性
    if (ball != null) {
      final coreInfo = ball.core as String? ?? 'Unknown Core';
      final coverInfo = ball.cover as String? ?? '未知';
      
      if (coreInfo != 'Unknown Core') {
        parts.add(coreInfo);
      }
      
      if (coverInfo != '未知') {
        parts.add(coverInfo);
      }
    }
    
    if (parts.isEmpty) {
      return 'No core/cover info';
    }
    
    return parts.join(' • ');
  }

  /// 建構 Layout 文字
  String _buildLayoutText() {
    return ballInstance.layoutDisplayString;
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