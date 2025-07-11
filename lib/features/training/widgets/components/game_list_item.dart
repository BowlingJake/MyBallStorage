import 'dart:math';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Added for ImageFilter

/// 單局遊戲列表項目組件
class GameListItem extends StatelessWidget {
  const GameListItem({
    required this.game,
    required this.theme,
    super.key,
    this.onGameTap,
    this.onGameDelete,
  });
  final GameRecord game;
  final ThemeData theme;
  final Function(GameRecord)? onGameTap;
  final Function(GameRecord)? onGameDelete;

  @override
  Widget build(BuildContext context) {
    // 計算填寫進度
    final filledFrames = game.frameScores.where((score) => score > 0).length;
    final progressPercent = filledFrames / 10;
    
    return GestureDetector(
      onTap: () => onGameTap?.call(game),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            // 新的進度條 - 參考分享的圖片樣式
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0A1A22),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF00ACC1).withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // 垂直條紋背景
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CustomPaint(
                      painter: VerticalStripePainter(
                        stripeColor: const Color(0xFF00ACC1).withOpacity(0.15),
                        stripeWidth: 1.5,
                        gapWidth: 3,
                      ),
                      child: Container(),
                    ),
                  ),
                  // 進度條填充
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progressPercent,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                const Color(0xFF00ACC1),
                                const Color(0xFF00838F),
                              ],
                            ),
                          ),
                          child: CustomPaint(
                            painter: VerticalStripePainter(
                              stripeColor: Colors.white.withOpacity(0.2),
                              stripeWidth: 1.5,
                              gapWidth: 3,
                            ),
                            child: Container(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 百分比文字
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        '${(progressPercent * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // 局數
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '${game.gameNumber}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 分數和球具記錄
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 只顯示分數
                      Text(
                        '${game.score}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 顯示使用的球具
                      if (game.ballUsed != null)
                        Text(
                          game.ballUsed!.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                
                // 刪除按鈕 - 修改為帶圓形外框的設計
                if (onGameDelete != null)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.error.withOpacity(0.7),
                        width: 1.0,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => _confirmDelete(context),
                        child: Center(
                          child: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.error.withOpacity(0.7),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // 刪除確認對話框
  void _confirmDelete(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.red.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm Delete',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Are you sure you want to delete Game ${game.gameNumber}? This action cannot be undone.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onGameDelete?.call(game);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
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

/// 垂直條紋繪製器
class VerticalStripePainter extends CustomPainter {
  final Color stripeColor;
  final double stripeWidth;
  final double gapWidth;

  VerticalStripePainter({
    required this.stripeColor,
    required this.stripeWidth,
    required this.gapWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = stripeColor
      ..strokeWidth = stripeWidth
      ..style = PaintingStyle.stroke;

    final totalWidth = stripeWidth + gapWidth;
    final stripeCount = (size.width / totalWidth).ceil() + 1;

    for (int i = 0; i < stripeCount; i++) {
      final x = i * totalWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
