import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui';
import '../widgets/training/training_session_card.dart';

class TrainingCardTestPage extends StatefulWidget {
  const TrainingCardTestPage({Key? key}) : super(key: key);

  @override
  State<TrainingCardTestPage> createState() => _TrainingCardTestPageState();
}

class _TrainingCardTestPageState extends State<TrainingCardTestPage> 
    with TickerProviderStateMixin {
  late AnimationController _glassmorphismController;
  late AnimationController _gradientController;
  late Animation<double> _glassmorphismAnimation;
  late Animation<double> _gradientAnimation;
  
  bool _isGlassmorphismExpanded = false;
  bool _isGradientExpanded = false;

  @override
  void initState() {
    super.initState();
    
    _glassmorphismController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _gradientController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _glassmorphismAnimation = CurvedAnimation(
      parent: _glassmorphismController,
      curve: Curves.easeInOutCubic,
    );
    
    _gradientAnimation = CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _glassmorphismController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  // 示例數據
  TrainingSession get _sampleSession => TrainingSession(
    id: '1',
    title: 'Evening Practice',
    date: DateTime.now(),
    center: 'Strike Zone Bowling',
    oilPatternName: 'House Pattern',
    oilPatternLength: '38 ft',
    isHousePattern: true,
    scoringMethod: 'Current',
    createdAt: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Card Designs'),
        backgroundColor: Colors.white,
        foregroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Choose Your Favorite Design',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 20),
          
          // Design 1: 玻璃擬態風格 (可展開動畫)
          _buildDesignSection(
            context,
            'Design 1: Glassmorphism with Animation',
            '現代玻璃擬態風格，點擊展開動畫效果',
            _buildAnimatedGlassmorphismCard(context),
          ),
          
          // Design 2: 漸變邊框卡片 (可展開動畫)
          _buildDesignSection(
            context,
            'Design 2: Gradient Border with Animation',
            '漸變邊框設計，展開時邊框動畫效果',
            _buildAnimatedGradientBorderCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignSection(BuildContext context, String title, String description, Widget card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 12),
        card,
        SizedBox(height: 32),
      ],
    );
  }





  // 動畫玻璃擬態卡片
  Widget _buildAnimatedGlassmorphismCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isGlassmorphismExpanded = !_isGlassmorphismExpanded;
            if (_isGlassmorphismExpanded) {
              _glassmorphismController.forward();
            } else {
              _glassmorphismController.reverse();
            }
          });
        },
        child: AnimatedBuilder(
          animation: _glassmorphismAnimation,
          builder: (context, child) {
            return Stack(
              children: [
                // 背景漸變
                Container(
                  height: 120 + (_glassmorphismAnimation.value * 80),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.1 + _glassmorphismAnimation.value * 0.1),
                        theme.colorScheme.secondary.withOpacity(0.1 + _glassmorphismAnimation.value * 0.1),
                      ],
                    ),
                  ),
                ),
                // 玻璃效果卡片
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10 + (_glassmorphismAnimation.value * 5),
                      sigmaY: 10 + (_glassmorphismAnimation.value * 5),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2 + _glassmorphismAnimation.value * 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3 + _glassmorphismAnimation.value * 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 標題行
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1 + (_glassmorphismAnimation.value * 0.1),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3 + _glassmorphismAnimation.value * 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Iconsax.flash_circle,
                                    size: 20,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _sampleSession.title,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      _sampleSession.center,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                  color: Colors.red[400],
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 12),
                          
                          // 信息行
                          Row(
                            children: [
                              _buildGlassInfo(Iconsax.calendar, 'Jun 17'),
                              SizedBox(width: 16),
                              _buildGlassInfo(Iconsax.drop, 'House'),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.2 + _glassmorphismAnimation.value * 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.primary.withOpacity(0.3 + _glassmorphismAnimation.value * 0.2),
                                  ),
                                ),
                                child: Text(
                                  'Current',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // 展開內容
                          if (_glassmorphismAnimation.value > 0)
                            Opacity(
                              opacity: _glassmorphismAnimation.value,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 1,
                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(child: _buildExpandedStat('Games', '12', Iconsax.game)),
                                        Expanded(child: _buildExpandedStat('Avg', '185', Iconsax.chart_2)),
                                        Expanded(child: _buildExpandedStat('Strike', '45%', Iconsax.flash)),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }



  // 動畫漸變邊框卡片
  Widget _buildAnimatedGradientBorderCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isGradientExpanded = !_isGradientExpanded;
            if (_isGradientExpanded) {
              _gradientController.forward();
            } else {
              _gradientController.reverse();
            }
          });
        },
        child: AnimatedBuilder(
          animation: _gradientAnimation,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(2 + (_gradientAnimation.value * 2)), // 動畫邊框寬度
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                    theme.colorScheme.tertiary ?? Colors.purple,
                  ],
                ),
                boxShadow: _gradientAnimation.value > 0 ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3 * _gradientAnimation.value),
                    blurRadius: 10 * _gradientAnimation.value,
                    offset: Offset(0, 4 * _gradientAnimation.value),
                  ),
                ] : null,
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 標題行
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 600),
                          width: 8 + (_gradientAnimation.value * 4),
                          height: 50 + (_gradientAnimation.value * 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _sampleSession.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                _sampleSession.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 600),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary.withOpacity(0.1 + _gradientAnimation.value * 0.1),
                                      theme.colorScheme.secondary.withOpacity(0.1 + _gradientAnimation.value * 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _isGradientExpanded ? 'Expanded' : 'Ready for expansion',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 12),
                    
                    // 漸變信息條
                    Row(
                      children: [
                        _buildGradientInfo('Jun 17, 2025', Iconsax.calendar),
                        SizedBox(width: 8),
                        _buildGradientInfo('House Pattern', Iconsax.drop),
                        SizedBox(width: 8),
                        _buildGradientInfo('Current', Iconsax.chart),
                      ],
                    ),
                    
                    // 展開內容
                    AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      height: _gradientAnimation.value * 80,
                      child: _gradientAnimation.value > 0 ? Opacity(
                        opacity: _gradientAnimation.value,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 2,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary.withOpacity(0.3),
                                      theme.colorScheme.secondary.withOpacity(0.3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(child: _buildExpandedStat('Games', '24', Iconsax.game)),
                                    Expanded(child: _buildExpandedStat('Best', '245', Iconsax.crown)),
                                    Expanded(child: _buildExpandedStat('Trend', '+15', Iconsax.trend_up)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Design 3: 玻璃擬態風格
  Widget _buildGlassmorphismCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          // 背景漸變
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.secondary.withOpacity(0.1),
                ],
              ),
            ),
          ),
          // 玻璃效果卡片
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 標題行
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Iconsax.flash_circle,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _sampleSession.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                _sampleSession.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Colors.red[400],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 12),
                    
                    // 信息行
                    Row(
                      children: [
                        _buildGlassInfo(Iconsax.calendar, 'Jun 17'),
                        SizedBox(width: 16),
                        _buildGlassInfo(Iconsax.drop, 'House'),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Current',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Design 4: 卡片式儀表板
  Widget _buildDashboardCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 6,
        shadowColor: theme.colorScheme.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題行
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Iconsax.chart_2,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _sampleSession.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _sampleSession.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDeleteButton(context),
                ],
              ),
              
              SizedBox(height: 16),
              
              // 統計區域
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildStatItem('Date', 'Jun 17', Iconsax.calendar, Colors.blue),
                    SizedBox(width: 16),
                    _buildStatItem('Pattern', 'House', Iconsax.drop, Colors.green),
                    SizedBox(width: 16),
                    _buildStatItem('Scoring', 'Current', Iconsax.chart, Colors.orange),
                  ],
                ),
              ),
              
              SizedBox(height: 8),
              
              // 展開提示
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.arrow_down_2,
                        size: 12,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Tap to expand',
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
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

  // Design 5: 漸變邊框卡片
  Widget _buildGradientBorderCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: EdgeInsets.all(2), // 邊框寬度
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
              theme.colorScheme.tertiary ?? Colors.purple,
            ],
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題行
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _sampleSession.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          _sampleSession.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withOpacity(0.1),
                                theme.colorScheme.secondary.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Ready for expansion',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDeleteButton(context),
                ],
              ),
              
              SizedBox(height: 12),
              
              // 漸變信息條
              Row(
                children: [
                  _buildGradientInfo('Jun 17, 2025', Iconsax.calendar),
                  SizedBox(width: 8),
                  _buildGradientInfo('House Pattern', Iconsax.drop),
                  SizedBox(width: 8),
                  _buildGradientInfo('Current', Iconsax.chart),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 輔助方法
  Widget _buildDeleteButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.delete_outline,
        size: 16,
        color: Colors.red[700],
      ),
    );
  }

  // 玻璃擬態輔助方法
  Widget _buildGlassInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.black54),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // 儀表板統計項目
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // 漸變信息條
  Widget _buildGradientInfo(String text, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.purple.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: Colors.blue[700]),
            SizedBox(width: 3),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 展開統計項目
  Widget _buildExpandedStat(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey[600],
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
} 