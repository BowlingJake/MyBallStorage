import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';
import 'dart:math' as math;

class CyberpunkTechStyle extends StatefulWidget {
  const CyberpunkTechStyle({super.key});

  @override
  State<CyberpunkTechStyle> createState() => _CyberpunkTechStyleState();
}

class _CyberpunkTechStyleState extends State<CyberpunkTechStyle> with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _matrixController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _matrixController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _matrixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          // 背景矩陣雨效果
          _buildMatrixBackground(),
          
          // 主要內容
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 標題區域
                  _buildHeaderSection(context),
                  
                  const SizedBox(height: 30),
                  
                  // 用戶資料顯示器
                  _buildUserTerminal(context),
                  
                  const SizedBox(height: 25),
                  
                  // 系統監控面板
                  _buildSystemMonitor(context),
                  
                  const SizedBox(height: 25),
                  
                  // 武器庫掃描器
                  _buildArsenalScanner(context),
                  
                  const SizedBox(height: 25),
                  
                  // 網路活動圖表
                  _buildNetworkActivity(context),
                  
                  const SizedBox(height: 25),
                  
                  // 威脅分析
                  _buildThreatAnalysis(context),
                  
                  const SizedBox(height: 30),
                  
                  // 風格說明
                  _buildStyleDescription(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixBackground() {
    return AnimatedBuilder(
      animation: _matrixController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: MatrixPainter(_matrixController.value),
          ),
        );
      },
    );
  }

  Widget _buildGlowContainer({
    required Widget child,
    required Color glowColor,
    double? height,
    double? width,
    EdgeInsets padding = const EdgeInsets.all(20),
    double borderRadius = 12,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: glowColor.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: glowColor.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0A0A0F).withOpacity(0.8),
            const Color(0xFF1A1A2E).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  glowColor.withOpacity(0.05),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      children: [
        _buildGlowContainer(
          height: 50,
          width: 50,
          padding: EdgeInsets.zero,
          glowColor: const Color(0xFF00FFFF),
          borderRadius: 25,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF00FFFF),
              size: 20,
            ),
          ),
        ),
        const Spacer(),
        Column(
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'CYBERPUNK TECH',
                  textStyle: const TextStyle(
                    color: Color(0xFF00FFFF),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    shadows: [
                      Shadow(
                        color: Color(0xFF00FFFF),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              isRepeatingAnimation: false,
            ).animate().slideY(begin: -0.3),
            const SizedBox(height: 4),
            Text(
              '> 科技未來風格',
              style: TextStyle(
                color: const Color(0xFF00FF00).withOpacity(0.8),
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ).animate(delay: 1500.ms).fadeIn(),
          ],
        ),
        const Spacer(),
        const SizedBox(width: 50),
      ],
    );
  }

  Widget _buildUserTerminal(BuildContext context) {
    return _buildGlowContainer(
      height: 200,
      width: double.infinity,
      glowColor: const Color(0xFF00FFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF00FF00),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF00FF00),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ).animate(delay: 300.ms).scale(),
              const SizedBox(width: 8),
              Text(
                'USER_TERMINAL_ACTIVE',
                style: TextStyle(
                  color: const Color(0xFF00FF00),
                  fontSize: 12,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 用戶信息
          AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(
                '> USER: 打保齡遊戲玩國\n> LOCATION: NYC_TERMINAL_7\n> ACCESS_LEVEL: PROFESSIONAL\n> NEURAL_LINK: CONNECTED',
                textStyle: const TextStyle(
                  color: Color(0xFF00FFFF),
                  fontSize: 14,
                  fontFamily: 'monospace',
                  height: 1.8,
                ),
                speed: const Duration(milliseconds: 50),
              ),
            ],
            isRepeatingAnimation: false,
          ),
          
          const Spacer(),
          
          // 掃描線
          AnimatedBuilder(
            animation: _scanController,
            builder: (context, child) {
              return Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFF00FFFF).withOpacity(_scanController.value),
                      Colors.transparent,
                    ],
                    stops: [
                      (_scanController.value - 0.1).clamp(0.0, 1.0),
                      _scanController.value,
                      (_scanController.value + 0.1).clamp(0.0, 1.0),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildSystemMonitor(BuildContext context) {
    final metrics = [
      {'label': 'CPU_USAGE', 'value': 73, 'color': const Color(0xFF00FF00)},
      {'label': 'MEMORY', 'value': 91, 'color': const Color(0xFFFF6B6B)},
      {'label': 'NETWORK', 'value': 45, 'color': const Color(0xFF4ECDC4)},
      {'label': 'STRIKES', 'value': 88, 'color': const Color(0xFFFFE66D)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.monitor,
              color: const Color(0xFF00FFFF),
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              'SYSTEM_MONITOR.EXE',
              style: TextStyle(
                color: const Color(0xFF00FFFF),
                fontSize: 16,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ).animate(delay: 600.ms).fadeIn().slideX(begin: -0.3),
        
        const SizedBox(height: 15),
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.3,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return _buildGlowContainer(
              glowColor: metric['color'] as Color,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    metric['label'] as String,
                    style: TextStyle(
                      color: (metric['color'] as Color),
                      fontSize: 10,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Text(
                        '${metric['value']}%',
                        style: TextStyle(
                          color: (metric['color'] as Color),
                          fontSize: 24,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: (metric['color'] as Color).withOpacity(_pulseController.value * 0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (metric['value'] as int) / 100,
                    backgroundColor: Colors.black.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(metric['color'] as Color),
                    minHeight: 4,
                  ),
                ],
              ),
            ).animate(delay: (700 + index * 100).ms).fadeIn().scale();
          },
        ),
      ],
    );
  }

  Widget _buildArsenalScanner(BuildContext context) {
    final weapons = [
      {'name': 'JACKAL_EXJ', 'threat': 'HIGH', 'status': 'ACTIVE'},
      {'name': 'PHAZE_II', 'threat': 'MEDIUM', 'status': 'STANDBY'},
      {'name': 'IQ_TOUR', 'threat': 'LOW', 'status': 'OFFLINE'},
    ];

    return _buildGlowContainer(
      width: double.infinity,
      glowColor: const Color(0xFFFF6B6B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.scan_barcode,
                color: const Color(0xFFFF6B6B),
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'ARSENAL_SCANNER.DLL',
                style: TextStyle(
                  color: const Color(0xFFFF6B6B),
                  fontSize: 16,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _scanController,
                builder: (context, child) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B).withOpacity(_scanController.value),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withOpacity(_scanController.value * 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          ...weapons.asMap().entries.map((entry) {
            final index = entry.key;
            final weapon = entry.value;
            final threatColor = weapon['threat'] == 'HIGH' 
              ? const Color(0xFFFF6B6B)
              : weapon['threat'] == 'MEDIUM'
                ? const Color(0xFFFFE66D)
                : const Color(0xFF4ECDC4);
                
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: threatColor.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: threatColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: threatColor,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      weapon['name'] as String,
                      style: const TextStyle(
                        color: Color(0xFF00FFFF),
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  Text(
                    weapon['threat'] as String,
                    style: TextStyle(
                      color: threatColor,
                      fontSize: 10,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    weapon['status'] as String,
                    style: TextStyle(
                      color: const Color(0xFF00FF00).withOpacity(0.8),
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ).animate(delay: (800 + index * 150).ms).fadeIn().slideX(begin: 0.3);
          }).toList(),
        ],
      ),
    ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildNetworkActivity(BuildContext context) {
    return _buildGlowContainer(
      height: 200,
      width: double.infinity,
      glowColor: const Color(0xFF8B5CF6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.activity,
                color: const Color(0xFF8B5CF6),
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'NETWORK_ACTIVITY.LOG',
                style: TextStyle(
                  color: const Color(0xFF8B5CF6),
                  fontSize: 16,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFF8B5CF6).withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                backgroundColor: Colors.transparent,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 1),
                      const FlSpot(2, 4),
                      const FlSpot(3, 2),
                      const FlSpot(4, 5),
                      const FlSpot(5, 3),
                      const FlSpot(6, 4),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF8B5CF6),
                        const Color(0xFF8B5CF6).withOpacity(0.5),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF8B5CF6).withOpacity(0.3),
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
    ).animate(delay: 1000.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildThreatAnalysis(BuildContext context) {
    return _buildGlowContainer(
      width: double.infinity,
      glowColor: const Color(0xFFFFE66D),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.shield_search,
                color: const Color(0xFFFFE66D),
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'THREAT_ANALYSIS.BAT',
                style: TextStyle(
                  color: const Color(0xFFFFE66D),
                  fontSize: 16,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(
                '> 掃描中... 100% 完成\n> 發現 0 個威脅\n> 系統狀態: 安全\n> 建議動作: 繼續監控',
                textStyle: const TextStyle(
                  color: Color(0xFF00FF00),
                  fontSize: 12,
                  fontFamily: 'monospace',
                  height: 1.6,
                ),
                speed: const Duration(milliseconds: 80),
              ),
            ],
            isRepeatingAnimation: false,
          ),
        ],
      ),
    ).animate(delay: 1200.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildStyleDescription(BuildContext context) {
    return _buildGlowContainer(
      width: double.infinity,
      glowColor: const Color(0xFF00FFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.code,
                color: const Color(0xFF00FFFF),
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'STYLE_INFO.TXT',
                style: TextStyle(
                  color: const Color(0xFF00FFFF),
                  fontSize: 16,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '• 賽博朋克未來科技風格，充滿科幻感\n• 霓虹發光效果和掃描線動畫\n• 終端機風格文字和打字機效果\n• 系統監控面板和數據可視化\n• 適合科技愛好者和未來主義用戶\n• 豐富的動畫和視覺特效',
            style: TextStyle(
              color: const Color(0xFF00FFFF).withOpacity(0.8),
              fontSize: 13,
              fontFamily: 'monospace',
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate(delay: 1400.ms).fadeIn().slideY(begin: 0.3);
  }
}

class MatrixPainter extends CustomPainter {
  final double animationValue;
  
  MatrixPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF00).withOpacity(0.1);
    
    const double spacing = 30;
    final random = math.Random(42);
    
    for (double x = 0; x < size.width; x += spacing) {
      final offset = (animationValue * size.height * 2) % (size.height + 100);
      for (double y = -100 + offset; y < size.height + 100; y += spacing) {
        if (random.nextDouble() < 0.7) {
          canvas.drawCircle(
            Offset(x + random.nextDouble() * 10, y),
            1 + random.nextDouble() * 2,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(MatrixPainter oldDelegate) => oldDelegate.animationValue != animationValue;
} 