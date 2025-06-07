import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'ball_list_view.dart'; // 導入原有的 BowlingBall 模型
import '../theme/brand_colors.dart'; // 導入品牌色定義

// 從球心名稱提取核心類型的輔助函數
String getCoreCategory(String coreName) {
  if (coreName.trim().isEmpty) {
    return '未知';
  }
  final lowerCoreName = coreName.toLowerCase();
  if (lowerCoreName.contains('asymmetric')) {
    return 'Asymmetric';
  } else if (lowerCoreName.contains('symmetric')) {
    return 'Symmetric';
  }
  final parts = coreName.trim().split(' ');
  return parts.isNotEmpty ? parts.last : '未知';
}

class BowlingBallDetailWidget extends StatefulWidget {
  final BowlingBall ball;

  const BowlingBallDetailWidget({
    super.key,
    required this.ball,
  });

  @override
  State<BowlingBallDetailWidget> createState() => _BowlingBallDetailWidgetState();
}

class _BowlingBallDetailWidgetState extends State<BowlingBallDetailWidget> {
  bool isFavorited = false; // 收藏狀態

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    // 取得品牌色調色板，使用降飽和度的柔和色彩
    final brandPalette = getBrandTonalPalette(widget.ball.brand, theme);
    final List<Color> gradientColors = [
      brandPalette.shade400.withOpacity(0.55),
      brandPalette.shade500.withOpacity(0.35),
    ];

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // 只在彈窗內容區域顯示品牌色漸層背景
            Container(
              width: size.width * 2 / 3,
              constraints: BoxConstraints(
                maxWidth: 420,
                minWidth: 280,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.none, // 關鍵：允許內容超出邊界
              child: Stack(
                clipBehavior: Clip.none, // Stack 也不裁切
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                  ),
                  // 內容
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 上方 X 與愛心
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                                onPressed: () => Navigator.of(context).pop(),
                                tooltip: '關閉',
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorited ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorited ? Colors.red : Colors.white,
                                  size: 26,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isFavorited = !isFavorited;
                                  });
                                  // TODO: 在這裡添加實際的收藏功能邏輯
                                },
                                tooltip: isFavorited ? '取消收藏' : '收藏',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 球主圖
                        Center(
                          child: Transform.translate(
                            offset: const Offset(0, -10), // 整體往上移動 10px
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none, // 球圖片Stack也不裁切
                              children: [
                                // Spotlight 背景光源 - 球正後方的柔光效果
                                Positioned(
                                  child: Container(
                                    width: 130, // 球直徑 × 1.3 (100 × 1.3)
                                    height: 130,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        center: Alignment.center,
                                        radius: 0.8,
                                        colors: [
                                          Colors.grey.withOpacity(0.15), // 中心淺灰白
                                          Colors.white.withOpacity(0.08), // 中間層白光
                                          Colors.transparent, // 邊緣透明
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.06),
                                          blurRadius: 22, // 20-24px 模糊讓光暈更柔和
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // 陰影：使用 Positioned 放在球下方
                                Positioned(
                                  bottom: -18, // 放在球底部下方
                                  child: Container(
                                    width: 100 * 0.9,
                                    height: 100 * 0.28,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.05),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 25,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 2),
                                          color: Colors.black.withOpacity(0.15),
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.elliptical(45, 14)), // 橢圓形
                                    ),
                                  ),
                                ),
                                // 頂層球圖片 - 更明顯的內陰影效果
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.12),
                                  ),
                                  child: Stack(
                                    children: [
                                      // 球圖片
                                      ClipOval(
                                        child: widget.ball.imageUrl.isNotEmpty
                                            ? widget.ball.imageUrl.startsWith('assets/')
                                                ? Image.asset(
                                                    widget.ball.imageUrl,
                                                    fit: BoxFit.cover,
                                                    filterQuality: FilterQuality.high,
                                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                                      'assets/images/sample_strikeTrack.png',
                                                      fit: BoxFit.cover,
                                                      filterQuality: FilterQuality.high,
                                                    ),
                                                  )
                                                : Image.network(
                                                    widget.ball.imageUrl,
                                                    fit: BoxFit.cover,
                                                    filterQuality: FilterQuality.high,
                                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                                      'assets/images/sample_strikeTrack.png',
                                                      fit: BoxFit.cover,
                                                      filterQuality: FilterQuality.high,
                                                    ),
                                                  )
                                            : Image.asset(
                                                'assets/images/sample_strikeTrack.png',
                                                fit: BoxFit.cover,
                                                filterQuality: FilterQuality.high,
                                              ),
                                      ),
                                      // 接觸陰影 - 球底部內側的窄暗帶（環境遮蔽）
                                      ClipOval(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              center: Alignment(0, 0.7), // 靠近底部中心
                                              radius: 0.6,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.25), // 接觸陰影較深
                                              ],
                                              stops: [0.7, 1.0], // 只在邊緣很窄的範圍
                                            ),
                                          ),
                                        ),
                                      ),
                                      // 內陰影疊加層
                                      ClipOval(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              center: Alignment(-0.3, -0.3), // 左上角偏移
                                              radius: 0.8,
                                              colors: [
                                                Colors.black.withOpacity(0.15), // 更明顯的陰影
                                                Colors.black.withOpacity(0.05),
                                                Colors.transparent,
                                              ],
                                              stops: [0.0, 0.4, 0.8],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        // 標題
                        Text(
                          widget.ball.name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.ball.brand,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        // 上排兩格（球心、球皮）
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(child: _StatItem(
                                svgAsset: 'assets/images/core_logo.svg',
                                label: '球心',
                                value: widget.ball.core.isNotEmpty ? widget.ball.core : '未知',
                              )),
                              Expanded(child: _StatItem(
                                svgAsset: 'assets/images/cover_logo.svg',
                                label: '球皮',
                                value: widget.ball.coverstockName.isNotEmpty ? widget.ball.coverstockName : '未知',
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 下排三格（RG、RG差、MB diff）
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(child: _StatItem(
                                svgAsset: 'assets/images/rg_logo.svg',
                                label: 'RG',
                                value: widget.ball.rg?.toStringAsFixed(3) ?? 'N/A',
                              )),
                              Expanded(child: _StatItem(
                                icon: Icons.trending_up,
                                label: 'RG差',
                                value: widget.ball.differential?.toStringAsFixed(3) ?? 'N/A',
                              )),
                              Expanded(child: _StatItem(
                                icon: Icons.balance,
                                label: 'MB',
                                value: widget.ball.massBias?.toStringAsFixed(3) ?? 'N/A',
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData? icon;
  final String? svgAsset;
  final String label;
  final String value;

  const _StatItem({
    this.icon,
    this.svgAsset,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 110, // 增加高度給文字更多空間
      child: Column(
        children: [
          // 圖示區域固定高度
          SizedBox(
            height: 56, // 圖示區域固定高度
            child: Center(
              child: svgAsset != null
                  ? SizedBox(
                      height: 48,
                      width: 48,
                      child: SvgPicture.asset(
                        svgAsset!,
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    )
                  : (icon != null
                      ? Icon(icon, color: Colors.white, size: 48)
                      : SizedBox.shrink()),
            ),
          ),
          const SizedBox(height: 4),
          // 文字區域
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

// 顯示球詳細資訊的輔助函數
void showBallDetails(BuildContext context, BowlingBall ball) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.90,
      minHeight: 200,
    ),
    builder: (builderContext) {
      return BowlingBallDetailWidget(ball: ball);
    },
  );
}

