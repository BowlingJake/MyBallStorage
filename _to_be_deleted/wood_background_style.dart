import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

class WoodBackgroundStyle extends StatefulWidget {
  const WoodBackgroundStyle({super.key});

  @override
  State<WoodBackgroundStyle> createState() => _WoodBackgroundStyleState();
}

class _WoodBackgroundStyleState extends State<WoodBackgroundStyle> {
  int _currentBackgroundIndex = 0;

  final List<String> _backgrounds = [
    'assets/images/wood_background_1.jpg',
    'assets/images/wood_background_2.jpg',
    'assets/images/wood_background_3.jpg',
  ];

  final List<String> _backgroundNames = ['經典木紋', '深色木質', '溫暖木調'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          '木質背景風格測試',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // 背景圖片 - Ambient Texture 效果
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Stack(
              key: ValueKey<int>(_currentBackgroundIndex),
              children: [
                // 原始背景圖片
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_backgrounds[_currentBackgroundIndex]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // 高斯模糊 + 降低不透明度的遮罩
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                  child: Container(
                    color: Colors.white.withOpacity(0.25), // 25% 白色遮罩降低對比
                  ),
                ),
              ],
            ),
          ),

          // 主要內容
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // 標題區域 - 薄木片質感
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xFFF4EEE8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                        // 上方高光效果
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // 淡木紋遮罩層
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            image: DecorationImage(
                              image: AssetImage(_backgrounds[0]), // 使用第一個木紋作為遮罩
                              fit: BoxFit.cover,
                              opacity: 0.08, // 極淡的木紋
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              // 圖示容器 - 壓印效果
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0xFFF4EEE8),
                                  // 壓印圓形效果 (使用普通陰影模擬)
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 2,
                                      offset: const Offset(1, 1),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.8),
                                      blurRadius: 2,
                                      offset: const Offset(-1, -1),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Iconsax.tree,
                                  size: 32,
                                  color: Color(0xFF4E342E), // 深胡桃色，無發光
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '大地木質風格',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4E342E), // 深胡桃色
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '當前使用：${_backgroundNames[_currentBackgroundIndex]}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF4E342E), // 深胡桃色
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0),

                  const SizedBox(height: 30),

                  // 背景切換按鈕 - 薄木片質感
                  Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFF4EEE8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // 淡木紋遮罩層
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: AssetImage(
                                    _backgrounds[1],
                                  ), // 使用第二個木紋作為遮罩
                                  fit: BoxFit.cover,
                                  opacity: 0.06, // 極淡的木紋
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '選擇背景紋理',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4E342E), // 深胡桃色
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // 木工分隔線
                                  Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          const Color(
                                            0xFF4E342E,
                                          ).withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(3, (index) {
                                      final isSelected =
                                          _currentBackgroundIndex == index;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _currentBackgroundIndex = index;
                                          });
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: const Color(0xFFF4EEE8),
                                            border:
                                                isSelected
                                                    ? Border.all(
                                                      color: const Color(
                                                        0xFF4E342E,
                                                      ).withOpacity(0.3),
                                                      width: 2,
                                                    )
                                                    : null,
                                            boxShadow: [
                                              if (isSelected) ...[
                                                // 選中時的深陰影
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.15),
                                                  blurRadius: 4,
                                                  offset: const Offset(2, 2),
                                                ),
                                              ] else ...[
                                                // 未選中時的輕微投影
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.06),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.asset(
                                              _backgrounds[index],
                                              fit: BoxFit.cover,
                                              color:
                                                  isSelected
                                                      ? Colors.transparent
                                                      : Colors.black
                                                          .withOpacity(0.1),
                                              colorBlendMode: BlendMode.dstATop,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(3, (index) {
                                      return SizedBox(
                                        width: 80,
                                        child: Text(
                                          _backgroundNames[index],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                _currentBackgroundIndex == index
                                                    ? const Color(
                                                      0xFF4E342E,
                                                    ) // 深胡桃色
                                                    : const Color(
                                                      0xFF4E342E,
                                                    ).withOpacity(0.6),
                                            fontWeight:
                                                _currentBackgroundIndex == index
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .slideX(begin: -0.3, end: 0),

                  const Spacer(),

                  // 示例內容卡片 - 薄木片質感
                  Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFFF4EEE8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                            // 上方高光
                            BoxShadow(
                              color: Colors.white.withOpacity(0.4),
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // 淡木紋遮罩層
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                image: DecorationImage(
                                  image: AssetImage(
                                    _backgrounds[2],
                                  ), // 使用第三個木紋作為遮罩
                                  fit: BoxFit.cover,
                                  opacity: 0.08, // 極淡的木紋
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // 圖示容器 - 壓印效果
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: const Color(
                                            0xFF4E342E,
                                          ), // 深胡桃色
                                          boxShadow: [
                                            // 壓印圓形效果 (使用深陰影模擬)
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Iconsax.activity,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '保齡球訓練記錄',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(
                                                  0xFF4E342E,
                                                ), // 深胡桃色
                                              ),
                                            ),
                                            Text(
                                              '今日表現優異',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(
                                                  0xFF4E342E,
                                                ), // 深胡桃色，稍微透明
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // 木工分隔線
                                  Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          const Color(
                                            0xFF4E342E,
                                          ).withOpacity(0.2),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _StatItem(
                                        label: '平均分數',
                                        value: '156',
                                        icon: Iconsax.chart_success,
                                        baseColor: Color(0xFFF4EEE8),
                                      ),
                                      _StatItem(
                                        label: '全中次數',
                                        value: '8',
                                        icon: Iconsax.star,
                                        baseColor: Color(0xFFF4EEE8),
                                      ),
                                      _StatItem(
                                        label: '補中次數',
                                        value: '12',
                                        icon: Iconsax.flash,
                                        baseColor: Color(0xFFF4EEE8),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 20),

                  // 底部提示 - 深木質感
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF4E342E).withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                        // 上方高光
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // 圖示不發光，使用壓印效果
                          Icon(
                            Iconsax.info_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '手工木質背景提供溫暖、自然的視覺體驗，如薄木片般精緻',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 900.ms, duration: 600.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.baseColor,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 統計圖示 - 壓印效果
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: baseColor,
            boxShadow: [
              // 壓印圓形效果 (使用普通陰影模擬)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(1, 1),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.6),
                blurRadius: 3,
                offset: const Offset(-1, -1),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4E342E), // 深胡桃色，無發光
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4E342E), // 深胡桃色
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF4E342E), // 深胡桃色
          ),
        ),
      ],
    );
  }
}
