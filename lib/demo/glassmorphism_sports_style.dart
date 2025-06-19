import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';

class GlassmorphismSportsStyle extends StatelessWidget {
  const GlassmorphismSportsStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B73FF),
              Color(0xFF000DFF),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 標題區域
                _buildHeaderSection(context),
                
                const SizedBox(height: 30),
                
                // 用戶統計卡片
                _buildUserStatsCard(context),
                
                const SizedBox(height: 25),
                
                // 球櫃展示
                _buildArsenalShowcase(context),
                
                const SizedBox(height: 25),
                
                // 成就系統
                _buildAchievementSystem(context),
                
                const SizedBox(height: 25),
                
                // 性能圖表
                _buildPerformanceChart(context),
                
                const SizedBox(height: 30),
                
                // 風格說明
                _buildStyleDescription(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassContainer({
    required Widget child,
    required double height,
    double? width,
    double borderRadius = 20,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              'Glassmorphism Sports',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3),
            const SizedBox(height: 4),
            Text(
              '運動玻璃態風格',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
          ],
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildUserStatsCard(BuildContext context) {
    return _buildGlassContainer(
      height: 180,
      width: double.infinity,
      borderRadius: 25,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Row(
          children: [
            // 用戶頭像
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: Icon(
                Iconsax.user,
                size: 40,
                color: Colors.white.withOpacity(0.9),
              ),
            ).animate().scale(delay: 300.ms, duration: 600.ms),
            
            const SizedBox(width: 25),
            
            // 用戶信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '打保齡遊戲玩國',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ).animate(delay: 400.ms).fadeIn().slideX(begin: 0.3),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        size: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'New York',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ).animate(delay: 500.ms).fadeIn().slideX(begin: 0.3),
                  
                  const SizedBox(height: 12),
                  
                  // 閃光效果的等級標籤
                  Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.6),
                    highlightColor: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        '🏆 Professional Level',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ).animate(delay: 600.ms).scale(),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildArsenalShowcase(BuildContext context) {
    final balls = [
      {'name': 'Jackal EXJ', 'brand': 'Motiv', 'color': const Color(0xFFFF6B9D)},
      {'name': 'Phaze II', 'brand': 'Storm', 'color': const Color(0xFF4ECDC4)},
      {'name': 'IQ Tour', 'brand': 'Storm', 'color': const Color(0xFFFFE66D)},
      {'name': 'Hustle Ink', 'brand': 'Roto Grip', 'color': const Color(0xFF8B5CF6)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.box,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              '我的武器庫',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 8.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.3),
        
        const SizedBox(height: 20),
        
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: balls.length,
            itemBuilder: (context, index) {
              final ball = balls[index];
              return Container(
                width: 110,
                margin: EdgeInsets.only(right: index < balls.length - 1 ? 15 : 0),
                child: _buildGlassContainer(
                  height: 140,
                  width: 110,
                  borderRadius: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                (ball['color'] as Color),
                                (ball['color'] as Color).withOpacity(0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (ball['color'] as Color).withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ).animate(delay: (400 + index * 100).ms).scale(),
                        
                        const SizedBox(height: 12),
                        
                        Text(
                          ball['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).animate(delay: (500 + index * 100).ms).fadeIn(),
                        
                        const SizedBox(height: 4),
                        
                        Text(
                          ball['brand'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ).animate(delay: (600 + index * 100).ms).fadeIn(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementSystem(BuildContext context) {
    final achievements = [
      {'icon': Iconsax.cup, 'title': 'Strike Master', 'progress': 0.8},
      {'icon': Iconsax.medal_star, 'title': 'Perfect Game', 'progress': 0.6},
      {'icon': Iconsax.crown, 'title': 'Tournament Winner', 'progress': 0.9},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.award,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              '成就系統',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 8.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ).animate(delay: 600.ms).fadeIn().slideX(begin: -0.3),
        
        const SizedBox(height: 20),
        
        ...achievements.asMap().entries.map((entry) {
          final index = entry.key;
          final achievement = entry.value;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: _buildGlassContainer(
              height: 80,
              width: double.infinity,
              borderRadius: 20,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.withOpacity(0.8),
                            Colors.orange.withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        achievement['icon'] as IconData,
                        color: Colors.white,
                        size: 20,
                      ),
                    ).animate(delay: (700 + index * 100).ms).scale(),
                    
                    const SizedBox(width: 20),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            achievement['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: achievement['progress'] as double,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.amber.withOpacity(0.8),
                            ),
                            minHeight: 6,
                          ),
                        ],
                      ),
                    ),
                    
                    Text(
                      '${((achievement['progress'] as double) * 100).toInt()}%',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate(delay: (650 + index * 100).ms).fadeIn().slideX(begin: 0.3);
        }).toList(),
      ],
    );
  }

  Widget _buildPerformanceChart(BuildContext context) {
    return _buildGlassContainer(
      height: 200,
      width: double.infinity,
      borderRadius: 25,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.chart,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  '分數趨勢',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(1, 4),
                        const FlSpot(2, 3.5),
                        const FlSpot(3, 5),
                        const FlSpot(4, 4.5),
                        const FlSpot(5, 6),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan.withOpacity(0.8),
                          Colors.blue.withOpacity(0.5),
                        ],
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: Colors.cyan,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: 1000.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildStyleDescription(BuildContext context) {
    return _buildGlassContainer(
      height: 200,
      width: double.infinity,
      borderRadius: 25,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.brush,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Glassmorphism Sports 風格特色',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Text(
                '• 玻璃態毛玻璃效果，營造現代科技感\n• 漸變背景和運動感配色\n• 流暢的動畫和過渡效果\n• 發光和閃光元素增強視覺吸引力\n• 適合年輕、時尚的用戶群體\n• 強調視覺衝擊和互動體驗',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: 1200.ms).fadeIn().slideY(begin: 0.3);
  }
} 