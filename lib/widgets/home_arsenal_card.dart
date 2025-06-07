import 'package:flutter/material.dart';
import '../models/arsenal_ball.dart';
import '../theme/brand_colors.dart';

/// Creates a matte overlay effect for the given brand colors
LinearGradient createMatteOverlay(List<Color> brandColors) {
  return LinearGradient(
    colors: [
      brandColors[0].withOpacity(0.25),
      brandColors[1].withOpacity(0.15),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Home page Arsenal card with the same design as ArsenalBallCard but optimized for horizontal scrolling
class HomeArsenalCard extends StatelessWidget {
  final ArsenalBall ball;
  final VoidCallback? onTap;

  const HomeArsenalCard({
    super.key,
    required this.ball,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandPalette = getBrandTonalPalette(ball.brand, theme);
    final brandColors = brandPalette.getCardGradient();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: brandColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: createMatteOverlay(brandColors),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.10),
                    Colors.white.withOpacity(0.08),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
              // Ball name at the top (white text with shadow)
              Text(
                ball.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              // Ball image in the center (3D effect from popout detail)
              Expanded(
                flex: 4,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Spotlight 背景光源
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.8,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.08),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.06),
                            blurRadius: 22,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    // 球的陰影
                    Positioned(
                      bottom: 6,
                      child: Container(
                        width: 50,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: const BorderRadius.all(
                            Radius.elliptical(25, 6),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                              color: Colors.black.withOpacity(0.15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 球圖片 (3D 效果)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.12),
                      ),
                      child: ClipOval(
                        child: Stack(
                          children: [
                            // 球圖片
                            Image.asset(
                              ball.imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              filterQuality: FilterQuality.high,
                            ),
                            // 接觸陰影 - 球底部內側的窄暗帶
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  center: const Alignment(0, 0.7),
                                  radius: 0.6,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.25),
                                  ],
                                  stops: const [0.7, 1.0],
                                ),
                              ),
                            ),
                            // 內陰影疊加層
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  center: const Alignment(-0.3, -0.3),
                                  radius: 0.8,
                                  colors: [
                                    Colors.black.withOpacity(0.15),
                                    Colors.black.withOpacity(0.05),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.4, 0.8],
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
              const SizedBox(height: 8),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 