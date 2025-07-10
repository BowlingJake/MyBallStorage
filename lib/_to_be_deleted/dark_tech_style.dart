import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// 深色Tech風格展示頁面 - 專業運動數據版本 v2.0
class DarkTechStyle extends StatefulWidget {
  const DarkTechStyle({super.key});

  @override
  State<DarkTechStyle> createState() => _DarkTechStyleState();
}

class _DarkTechStyleState extends State<DarkTechStyle>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _chartController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _chartAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // 脈衝動畫 - 輕微但明顯
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 圖表動畫
    _chartController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _chartAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(_chartController);

    // 發光動畫 - 更溫和
    _glowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(_glowController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _chartController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // 稍深的背景
      body: Stack(
        children: [
          // 添加細微的背景線條效果
          _buildBackgroundGrid(),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 頂部導航
                    _buildTopBar(),

                    const SizedBox(height: 30),

                    // 主標題
                    _buildMainTitle(),

                    const SizedBox(height: 40),

                    // 保齡球數據統計卡片
                    _buildBowlingStats(),

                    const SizedBox(height: 30),

                    // 成績趨勢圖表
                    _buildPerformanceChart(),

                    const SizedBox(height: 30),

                    // 球具分析
                    _buildBallAnalysis(),

                    const SizedBox(height: 30),

                    // 最近比賽記錄
                    _buildRecentMatches(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: GridPainter(_glowAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        // 返回按鈕
        _buildButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.pop(context),
        ),

        const SizedBox(width: 16),

        // 狀態指示器 - 增加動態效果
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      Color.lerp(
                        const Color(0xFF4CAF50),
                        const Color(0xFF81C784),
                        _pulseAnimation.value,
                      )!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF4CAF50,
                    ).withOpacity(_pulseAnimation.value * 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Color(0xFF4CAF50), blurRadius: 4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'LIVE DATA',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const Spacer(),

        // 設定按鈕 - 添加發光效果
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return _buildButton(
              icon: Icons.analytics_outlined,
              backgroundColor: const Color(
                0xFF1E88E5,
              ).withOpacity(0.1 + _glowAnimation.value * 0.1),
              iconColor: Color.lerp(
                const Color(0xFF1E88E5),
                const Color(0xFF42A5F5),
                _glowAnimation.value,
              ),
              shouldGlow: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? iconColor,
    bool shouldGlow = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                shouldGlow
                    ? (iconColor ?? const Color(0xFF1E88E5)).withOpacity(0.4)
                    : const Color(0xFF404040),
          ),
          boxShadow:
              shouldGlow
                  ? [
                    BoxShadow(
                      color: (iconColor ?? const Color(0xFF1E88E5)).withOpacity(
                        0.3,
                      ),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                  : null,
        ),
        child: Icon(
          icon,
          color: iconColor ?? const Color(0xFF9E9E9E),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMainTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 主標題 - 增加動態效果
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF1E88E5,
                    ).withOpacity(_pulseAnimation.value * 0.2),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Text(
                'Professional Analytics',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color.lerp(
                    const Color(0xFFFFFFFF),
                    const Color(0xFF64B5F6),
                    _pulseAnimation.value * 0.3,
                  ),
                  letterSpacing: 1,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        // 副標題
        const Text(
          'Bowling Performance Dashboard',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF90CAF9),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 16),

        // 描述框 - 增加漸變效果
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A1A1A),
                const Color(0xFF2A2A2A).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E88E5).withOpacity(0.3)),
          ),
          child: const Text(
            '專業運動數據分析界面\n清晰的數據可視化 + 深色護眼設計\n適合專業球員和數據分析需求',
            style: TextStyle(
              color: Color(0xFFE3F2FD),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBowlingStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Average Score',
                value: '187',
                subtitle: '+3 this week',
                color: const Color(0xFF1E88E5),
                icon: Iconsax.chart_2,
                index: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Strike Rate',
                value: '23%',
                subtitle: '+1.2% improved',
                color: const Color(0xFF43A047),
                icon: Iconsax.award,
                index: 1,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Games Played',
                value: '42',
                subtitle: 'This month',
                color: const Color(0xFFFF9800),
                icon: Iconsax.game,
                index: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _glowAnimation]),
      builder: (context, child) {
        final delay = index * 0.3;
        final animValue = math.sin(
          (_glowAnimation.value * 2 * math.pi) + delay,
        );

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E1E1E),
                Color.lerp(
                  const Color(0xFF1E1E1E),
                  color,
                  0.05 + animValue * 0.02,
                )!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3 + animValue * 0.2)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1 + animValue * 0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(color: color.withOpacity(0.5), blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF757575), fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceChart() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E1E1E),
                const Color(0xFF2A2A2A).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(
                0xFF1E88E5,
              ).withOpacity(0.2 + _glowAnimation.value * 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E88E5).withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Iconsax.chart_square,
                      color: Color(0xFF1E88E5),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Score Trend',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Last 10 games',
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 增強的圖表
              _buildEnhancedChart(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnhancedChart() {
    return AnimatedBuilder(
      animation: Listenable.merge([_chartAnimation, _glowAnimation]),
      builder: (context, child) {
        return SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(10, (index) {
              final baseHeight = 40 + (index * 3.0) + (math.sin(index) * 15);
              final height = baseHeight * _chartAnimation.value;
              final glowIntensity = math.sin(
                (_glowAnimation.value * 2 * math.pi) + (index * 0.3),
              );

              return Container(
                width: 16,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1E88E5),
                      Color.lerp(
                        const Color(0xFF1E88E5),
                        const Color(0xFF64B5F6),
                        glowIntensity * 0.5,
                      )!,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF1E88E5,
                      ).withOpacity(0.3 + glowIntensity * 0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildBallAnalysis() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E1E1E),
            const Color(0xFF2A2A2A).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF43A047).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF43A047).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.safe_home,
                  color: Color(0xFF43A047),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Ball Performance',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildBallCard(
                  'Jackal EXJ',
                  '192 avg',
                  const Color(0xFF1E88E5),
                  0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBallCard(
                  'Phaze II',
                  '184 avg',
                  const Color(0xFF43A047),
                  1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBallCard(
                  'IQ Tour',
                  '179 avg',
                  const Color(0xFFFF9800),
                  2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBallCard(String name, String avg, Color color, int index) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final delay = index * 0.5;
        final animValue = math.sin(
          (_glowAnimation.value * 2 * math.pi) + delay,
        );

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3 + animValue * 0.2)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1 + animValue * 0.1),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.sports_baseball, color: color, size: 16),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                avg,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentMatches() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E1E1E),
            const Color(0xFF2A2A2A).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.clock,
                  color: Color(0xFFFF9800),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Recent Matches',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildMatchRow(
            'Tournament A',
            '195',
            'Yesterday',
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 8),
          _buildMatchRow(
            'League Match',
            '187',
            '3 days ago',
            const Color(0xFF1E88E5),
          ),
          const SizedBox(height: 8),
          _buildMatchRow(
            'Practice',
            '203',
            '1 week ago',
            const Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchRow(
    String match,
    String score,
    String date,
    Color scoreColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2A2A2A),
            const Color(0xFF333333).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              score,
              style: TextStyle(
                color: scoreColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 背景網格繪製器
class GridPainter extends CustomPainter {
  GridPainter(this.animationValue);
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(
            0xFF1E88E5,
          ).withOpacity(0.05 + animationValue * 0.05)
          ..strokeWidth = 1;

    // 繪製垂直線
    for (var i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    // 繪製水平線
    for (var i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
