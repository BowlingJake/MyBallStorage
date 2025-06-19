import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class DigitalDashboardStyle extends StatefulWidget {
  const DigitalDashboardStyle({super.key});

  @override
  State<DigitalDashboardStyle> createState() => _DigitalDashboardStyleState();
}

class _DigitalDashboardStyleState extends State<DigitalDashboardStyle> with TickerProviderStateMixin {
  late AnimationController _counterController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _counterController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _counterController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
              Color(0xFF020617),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context),
                const SizedBox(height: 25),
                _buildKPICards(context),
                const SizedBox(height: 25),
                _buildPerformanceChart(context),
                const SizedBox(height: 25),
                _buildProgressMetrics(context),
                const SizedBox(height: 25),
                _buildDataTable(context),
                const SizedBox(height: 25),
                _buildGaugeMetrics(context),
                const SizedBox(height: 30),
                _buildStyleDescription(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(20),
    Color? borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? const Color(0xFF334155),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: (borderColor ?? const Color(0xFF334155)).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      children: [
        _buildDashboardCard(
          padding: EdgeInsets.zero,
          borderColor: const Color(0xFF3B82F6),
          child: SizedBox(
            width: 50,
            height: 50,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
            ),
          ),
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              'DIGITAL DASHBOARD',
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.3),
            const SizedBox(height: 4),
            Text(
              '數字儀表板風格',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
          ],
        ),
        const Spacer(),
        const SizedBox(width: 50),
      ],
    );
  }

  Widget _buildKPICards(BuildContext context) {
    final kpis = [
      {
        'title': '平均分數',
        'value': 185,
        'unit': 'PTS',
        'change': '+12%',
        'positive': true,
        'color': const Color(0xFF10B981),
        'icon': Iconsax.chart_2,
      },
      {
        'title': '最高分數',
        'value': 267,
        'unit': 'PTS',
        'change': '+5%',
        'positive': true,
        'color': const Color(0xFF3B82F6),
        'icon': Iconsax.crown,
      },
      {
        'title': 'Strike 率',
        'value': 76,
        'unit': '%',
        'change': '+8%',
        'positive': true,
        'color': const Color(0xFFF59E0B),
        'icon': Iconsax.flash,
      },
      {
        'title': '比賽場次',
        'value': 142,
        'unit': '場',
        'change': '+23',
        'positive': true,
        'color': const Color(0xFF8B5CF6),
        'icon': Iconsax.activity,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.4,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return _buildDashboardCard(
          borderColor: kpi['color'] as Color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    kpi['icon'] as IconData,
                    color: kpi['color'] as Color,
                    size: 18,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (kpi['positive'] as bool)
                          ? const Color(0xFF10B981).withOpacity(0.2)
                          : const Color(0xFFEF4444).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      kpi['change'] as String,
                      style: TextStyle(
                        color: (kpi['positive'] as bool)
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                kpi['title'] as String,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  AnimatedBuilder(
                    animation: _counterController,
                    builder: (context, child) {
                      final animatedValue = ((kpi['value'] as int) * _counterController.value).round();
                      return Text(
                        animatedValue.toString(),
                        style: TextStyle(
                          color: kpi['color'] as Color,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    kpi['unit'] as String,
                    style: TextStyle(
                      color: (kpi['color'] as Color).withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate(delay: (200 + index * 100).ms).fadeIn().slideY(begin: 0.3);
      },
    );
  }

  Widget _buildPerformanceChart(BuildContext context) {
    return _buildDashboardCard(
      borderColor: const Color(0xFF06B6D4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.chart_1,
                color: Color(0xFF06B6D4),
                size: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                '性能趨勢分析',
                style: TextStyle(
                  color: Color(0xFF06B6D4),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF06B6D4).withOpacity(0.3),
                  ),
                ),
                child: const Text(
                  '過去 7 天',
                  style: TextStyle(
                    color: Color(0xFF06B6D4),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFF334155),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: const Color(0xFF334155),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 10,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['週一', '週二', '週三', '週四', '週五', '週六', '週日'];
                        if (value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                backgroundColor: Colors.transparent,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 175),
                      FlSpot(1, 190),
                      FlSpot(2, 165),
                      FlSpot(3, 210),
                      FlSpot(4, 185),
                      FlSpot(5, 195),
                      FlSpot(6, 205),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFF06B6D4),
                          strokeWidth: 2,
                          strokeColor: const Color(0xFF1E293B),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF06B6D4).withOpacity(0.3),
                          const Color(0xFF06B6D4).withOpacity(0.1),
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
    ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildProgressMetrics(BuildContext context) {
    final metrics = [
      {
        'title': 'Strike 完成度',
        'current': 76,
        'target': 85,
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Spare 轉換率',
        'current': 68,
        'target': 75,
        'color': const Color(0xFF10B981),
      },
      {
        'title': '一致性指數',
        'current': 84,
        'target': 90,
        'color': const Color(0xFF8B5CF6),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Iconsax.percentage_circle,
              color: Color(0xFF64748B),
              size: 20,
            ),
            const SizedBox(width: 10),
            const Text(
              '進度指標',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ).animate(delay: 800.ms).fadeIn().slideX(begin: -0.3),
        
        const SizedBox(height: 15),
        
        ...metrics.asMap().entries.map((entry) {
          final index = entry.key;
          final metric = entry.value;
          final progress = (metric['current'] as int) / (metric['target'] as int);
          
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: _buildDashboardCard(
              borderColor: metric['color'] as Color,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metric['title'] as String,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${metric['current']}',
                              style: TextStyle(
                                color: metric['color'] as Color,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                            Text(
                              ' / ${metric['target']}',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearPercentIndicator(
                          lineHeight: 6,
                          percent: progress.clamp(0.0, 1.0),
                          backgroundColor: const Color(0xFF334155),
                          progressColor: metric['color'] as Color,
                          barRadius: const Radius.circular(3),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  CircularPercentIndicator(
                    radius: 30,
                    lineWidth: 6,
                    percent: progress.clamp(0.0, 1.0),
                    center: Text(
                      '${(progress * 100).round()}%',
                      style: TextStyle(
                        color: metric['color'] as Color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    progressColor: metric['color'] as Color,
                    backgroundColor: const Color(0xFF334155),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ],
              ),
            ),
          ).animate(delay: (850 + index * 100).ms).fadeIn().slideX(begin: 0.3);
        }).toList(),
      ],
    );
  }

  Widget _buildDataTable(BuildContext context) {
    final tableData = [
      {'date': '2024/01/15', 'score': 198, 'strikes': 8, 'spares': 6},
      {'date': '2024/01/14', 'score': 175, 'strikes': 6, 'spares': 8},
      {'date': '2024/01/13', 'score': 210, 'strikes': 9, 'spares': 5},
      {'date': '2024/01/12', 'score': 162, 'strikes': 5, 'spares': 7},
      {'date': '2024/01/11', 'score': 189, 'strikes': 7, 'spares': 6},
    ];

    return _buildDashboardCard(
      borderColor: const Color(0xFF64748B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.data_2,
                color: Color(0xFF64748B),
                size: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                '最近比賽記錄',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 表格標題
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF334155).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    '日期',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '分數',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Strike',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Spare',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 表格數據
          ...tableData.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: index == 0 
                  ? const Color(0xFF3B82F6).withOpacity(0.1)
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: index == 0 
                  ? Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3))
                  : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      row['date'] as String,
                      style: TextStyle(
                        color: index == 0 ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                        fontSize: 12,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${row['score']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: index == 0 ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${row['strikes']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: index == 0 ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${row['spares']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: index == 0 ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: (1100 + index * 100).ms).fadeIn().slideX(begin: 0.2);
          }).toList(),
        ],
      ),
    ).animate(delay: 1000.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildGaugeMetrics(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDashboardCard(
            borderColor: const Color(0xFFEF4444),
            child: Column(
              children: [
                const Text(
                  '技能評分',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                CircularPercentIndicator(
                  radius: 50,
                  lineWidth: 8,
                  percent: 0.87,
                  center: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '87',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        '/ 100',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  progressColor: const Color(0xFFEF4444),
                  backgroundColor: const Color(0xFF334155),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildDashboardCard(
            borderColor: const Color(0xFF10B981),
            child: Column(
              children: [
                const Text(
                  '月度目標',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                CircularPercentIndicator(
                  radius: 50,
                  lineWidth: 8,
                  percent: 0.73,
                  center: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '73',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        '/ 100',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  progressColor: const Color(0xFF10B981),
                  backgroundColor: const Color(0xFF334155),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate(delay: 1400.ms).fadeIn().slideY(begin: 0.3);
  }

  Widget _buildStyleDescription(BuildContext context) {
    return _buildDashboardCard(
      borderColor: const Color(0xFF3B82F6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.chart,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                'Digital Dashboard 風格特色',
                style: TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '• 專業數據可視化，適合大量數字展示\n• 清晰的圖表和進度指標\n• 等寬字體確保數字對齊\n• KPI 卡片和數據表格設計\n• 適合數據分析和專業使用\n• 深色背景減少眼部疲勞',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate(delay: 1600.ms).fadeIn().slideY(begin: 0.3);
  }
} 