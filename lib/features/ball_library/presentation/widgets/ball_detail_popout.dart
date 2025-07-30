import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:flutter/material.dart';

class BowlingBallDetailWidget extends StatefulWidget {
  const BowlingBallDetailWidget({required this.ball, super.key});
  final BowlingBall ball;

  @override
  State<BowlingBallDetailWidget> createState() =>
      _BowlingBallDetailWidgetState();
}

class _BowlingBallDetailWidgetState extends State<BowlingBallDetailWidget> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandPalette = getBrandTonalPalette(widget.ball.brand, theme);
    final brandColor = brandPalette[400]!;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey[600]!,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 頂部區域：關閉按鈕 + 圓形圖片 + 收藏按鈕
            Container(
              height: 180,
              child: Stack(
                children: [
                  // 左上角關閉按鈕
                  Positioned(
                    top: 12,
                    left: 12,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ),
                  // 右上角收藏按鈕
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? Colors.red : Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorited = !isFavorited;
                        });
                        // TODO: 實際收藏功能
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ),
                  // 中央圓形圖片
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.3),
                        border: Border.all(
                          color: brandColor.withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: widget.ball.imageUrl.isNotEmpty && 
                               widget.ball.imageUrl != 'https://via.placeholder.com/150'
                            ? Image.network(
                                widget.ball.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.sports_baseball,
                                    color: Colors.white54,
                                    size: 70,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.sports_baseball,
                                color: Colors.white54,
                                size: 70,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 中間區域：球資訊
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // Brand
                  Text(
                    widget.ball.brand,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 4),
                  // Ball Name
                  Text(
                    widget.ball.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 12),
                  // Core Name
                  _buildInfoRow('Core Name', widget.ball.coreName ?? 'Unknown'),
                  const SizedBox(height: 6),
                  // Core Type
                  _buildInfoRow('Core Type', widget.ball.coreType ?? 'Unknown'),
                  const SizedBox(height: 6),
                  // Cover Name
                  _buildInfoRow('Cover Name', widget.ball.coverstockName ?? 'Unknown'),
                  const SizedBox(height: 6),
                  // Cover Type
                  _buildInfoRow('Cover Type', widget.ball.coverstockType ?? widget.ball.coverstock ?? 'Unknown'),
                ],
              ),
            ),
            // 底部區域：進度條
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // RG 進度條
                  _buildProgressBar(
                    'RG',
                    widget.ball.rg,
                    2.460,
                    2.700,
                    const Color(0xFF4A90E2), // 科技藍
                  ),
                  const SizedBox(height: 16),
                  // RG DIFF 進度條
                  _buildProgressBar(
                    'RG DIFF',
                    widget.ball.diff,
                    0.0,
                    0.060,
                    const Color(0xFF50C878), // 科技綠
                  ),
                  const SizedBox(height: 16),
                  // MB DIFF 進度條
                  _buildProgressBar(
                    'MB DIFF',
                    widget.ball.mbDiff,
                    0.0,
                    0.040,
                    const Color(0xFF8B949E), // 科技灰
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(String label, double? value, double min, double max, Color color) {
    final double progress = value != null ? ((value - min) / (max - min)).clamp(0.0, 1.0) : 0.0;
    final String displayValue = value?.toStringAsFixed(3) ?? 'N/A';
    
    return Row(
      children: [
        // 標籤
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 進度條容器 - Outlined設計
        Expanded(
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.8),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // 進度條填充
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,  
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.5),
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ),
                // 數值文字
                Center(
                  child: Text(
                    displayValue,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 顯示球詳細資訊的輔助函數
void showBallDetails(BuildContext context, BowlingBall ball) {
  showDialog(
    context: context,
    builder: (context) => BowlingBallDetailWidget(ball: ball),
  );
}