import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:core_theme/core_theme.dart';

class BallComparisonDialog extends StatelessWidget {
  const BallComparisonDialog({
    required this.ball1,
    required this.ball2,
    super.key,
  });

  final BowlingBall ball1;
  final BowlingBall ball2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Ball Comparison',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Ball Images with comparison arrow
                    _buildBallImagesSection(theme),
                    
                    const SizedBox(height: 20),
                    
                    // Brand and Ball Names
                    _buildBallNamesSection(theme),
                    
                    const SizedBox(height: 24),
                    
                    // Comparison Data
                    _buildComparisonData(theme, context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 球圖片區域 - 頂部兩個球圖片中間有比較箭頭
  Widget _buildBallImagesSection(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 左邊球圖片
        _buildBallImage(ball1, theme),
        
        // 中間比較箭頭
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.compare_arrows,
            color: Colors.white,
            size: 28,
          ),
        ),
        
        // 右邊球圖片
        _buildBallImage(ball2, theme),
      ],
    );
  }

  // 單個球圖片
  Widget _buildBallImage(BowlingBall ball, ThemeData theme) {
    final brandPalette = getBrandTonalPalette(ball.brand, theme);
    final brandColor = brandPalette[400]!;
    
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: ClipOval(
        child: ball.imageUrl.isNotEmpty && ball.imageUrl != 'https://via.placeholder.com/150'
            ? Image.network(
                ball.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.sports_baseball,
                    color: brandColor,
                    size: 40,
                  );
                },
              )
            : Icon(
                Icons.sports_baseball,
                color: brandColor,
                size: 40,
              ),
      ),
    );
  }

  // 品牌和球名區域 - 左右兩欄，字體較大較重要
  Widget _buildBallNamesSection(ThemeData theme) {
    return Row(
      children: [
        // 左邊球資訊
        Expanded(
          child: _buildBallNameColumn(ball1, theme),
        ),
        
        // 中間間隔
        const SizedBox(width: 24),
        
        // 右邊球資訊
        Expanded(
          child: _buildBallNameColumn(ball2, theme),
        ),
      ],
    );
  }

  // 單個球的品牌和名稱欄
  Widget _buildBallNameColumn(BowlingBall ball, ThemeData theme) {
    final brandPalette = getBrandTonalPalette(ball.brand, theme);
    final brandColor = brandPalette[400]!;
    
    return Column(
      children: [
        // 品牌名稱 - 第一行，較重要，無外框
        Text(
          ball.brand,
          style: TextStyle(
            color: brandColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // 球名稱 - 第二行，較重要，無外框
        Text(
          ball.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // 比較資料區域 - 中間是標題，左右是資料
  Widget _buildComparisonData(ThemeData theme, BuildContext context) {
    return Column(
      children: [
        // 一般資訊比較
        ..._buildTextComparisons(),
        
        const SizedBox(height: 16),
        
        // RG, Diff, MB 進度條比較
        _buildProgressBarComparisons(context),
      ],
    );
  }

  // 文字比較項目
  List<Widget> _buildTextComparisons() {
    final textSpecs = [
      ('Core Name', ball1.coreName ?? 'N/A', ball2.coreName ?? 'N/A'),
      ('Core Type', ball1.coreType ?? 'N/A', ball2.coreType ?? 'N/A'),
      ('Cover Name', ball1.coverstockName ?? ball1.coverstock ?? 'N/A', ball2.coverstockName ?? ball2.coverstock ?? 'N/A'),
      ('Cover Type', ball1.coverstockType ?? 'N/A', ball2.coverstockType ?? 'N/A'),
    ];

    return textSpecs.map((spec) => _buildComparisonRow(spec.$1, spec.$2, spec.$3)).toList();
  }

  // 單個比較行 - 中間標題，左右資料
  Widget _buildComparisonRow(String label, String leftValue, String rightValue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // 左邊資料
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                leftValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // 中間標題
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // 右邊資料
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                rightValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // RG, Diff, MB 進度條比較
  Widget _buildProgressBarComparisons(BuildContext context) {
    return Column(
      children: [
        _buildProgressBarRow('RG', ball1.rg, ball2.rg, 2.4, 2.8, context),
        const SizedBox(height: 12),
        _buildProgressBarRow('Diff', ball1.diff, ball2.diff, 0.01, 0.08, context),
        const SizedBox(height: 12),
        _buildProgressBarRow('MB Diff', ball1.mbDiff, ball2.mbDiff, 0, 0.03, context),
      ],
    );
  }

  // 單個進度條行
  Widget _buildProgressBarRow(String label, double? leftValue, double? rightValue, double minValue, double maxValue, BuildContext context) {
    return Column(
      children: [
        // 標題
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        
        Row(
          children: [
            // 左邊數值
            Expanded(
              flex: 2,
              child: Text(
                leftValue?.toStringAsFixed(3) ?? 'N/A',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // 進度條區域
            Expanded(
              flex: 4,
              child: _buildProgressBars(leftValue, rightValue, minValue, maxValue, context),
            ),
            
            // 右邊數值
            Expanded(
              flex: 2,
              child: Text(
                rightValue?.toStringAsFixed(3) ?? 'N/A',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 雙進度條 - 左右對比
  Widget _buildProgressBars(double? leftValue, double? rightValue, double minValue, double maxValue, BuildContext context) {
    final leftProgress = leftValue != null ? ((leftValue - minValue) / (maxValue - minValue)).clamp(0.0, 1.0) : 0.0;
    final rightProgress = rightValue != null ? ((rightValue - minValue) / (maxValue - minValue)).clamp(0.0, 1.0) : 0.0;
    
    return Row(
      children: [
        // 左邊進度條 (從右到左填充)
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 8,
                  width: (MediaQuery.of(context).size.width * 0.2) * leftProgress,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 8),
        
        // 右邊進度條 (從左到右填充)
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 8,
                  width: (MediaQuery.of(context).size.width * 0.2) * rightProgress,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}