import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:glass_kit/glass_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ball_list_view.dart'; // 導入原有的 BowlingBall 模型

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

// 品牌色對照表，可依需求擴充
const Map<String, List<Color>> brandGradients = {
  'Storm Bowling': [Color(0xFF00B4D8), Color(0xFF0077B6)],
  'Motiv Bowling': [Color(0xFFFFA500), Color(0xFFFC7300)],
  'Brunswick': [Color(0xFF003049), Color(0xFF669BBC)],
  // 其他品牌可自行加入
};

class BowlingBallDetailWidget extends StatefulWidget {
  final BowlingBall ball;

  const BowlingBallDetailWidget({
    Key? key,
    required this.ball,
  }) : super(key: key);

  @override
  State<BowlingBallDetailWidget> createState() => _BowlingBallDetailWidgetState();
}

class _BowlingBallDetailWidgetState extends State<BowlingBallDetailWidget> {
  bool isFavorited = false; // 收藏狀態

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    // 取得品牌色漸層，若無則用預設
    final List<Color> baseColors = brandGradients[widget.ball.brand] ?? [Color(0xFF5F72BE), Color(0xFF9B23EA)];
    final List<Color> gradientColors = [
      baseColors[0].withOpacity(0.55),
      baseColors[1].withOpacity(0.35),
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
              child: Stack(
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
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.12),
                            ),
                            child: ClipOval(
                              child: widget.ball.imageUrl.isNotEmpty
                                  ? Image.network(
                                      widget.ball.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Colors.grey[200],
                                        child: Icon(Icons.sports_baseball, size: 60, color: Colors.grey[400]),
                                      ),
                                    )
                                  : Icon(Icons.sports_baseball, size: 60, color: Colors.white38),
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
                        const SizedBox(height: 18),
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
                        const SizedBox(height: 32),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (svgAsset != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              height: 32,
              width: 32,
              child: SvgPicture.asset(
                svgAsset!,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        if (icon != null && svgAsset == null) 
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        Text(
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
      ],
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
