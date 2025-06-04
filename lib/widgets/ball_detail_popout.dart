import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'ball_list_view.dart'; // 導入原有的 BowlingBall 模型

// 從球心名稱提取核心類型的輔助函數
String getCoreCategory(String coreName) {
  if (coreName.trim().isEmpty) {
    return '未知';
  }
  final lowerCoreName = coreName.toLowerCase();
  if (lowerCoreName.contains('asymmetric')) {
    return 'Asymmetric';
  } else if (lowerCoreName.contains('symmetric')) {
    return 'Symmetric';
  }
  final parts = coreName.trim().split(' ');
  return parts.isNotEmpty ? parts.last : '未知';
}

class BowlingBallDetailWidget extends StatelessWidget {
  final BowlingBall ball;

  const BowlingBallDetailWidget({
    Key? key,
    required this.ball,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 定義 neumorphic 基礎顏色
    const Color baseColor = Color(0xFFE8E8E8);
    
    // 安全檢查，確保 ball 對象有效
    if (ball.name.isEmpty && ball.id.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('球的資料不完整或載入失敗。'),
        ),
      );
    }

    return Container(
      color: baseColor, // 設置背景顏色匹配 clay containers
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. 球的照片區域 - 使用 ClayContainer
            ClayContainer(
              color: baseColor,
              height: 180,
              width: 180,
              borderRadius: 16,
              depth: 40,
              spread: 6,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    ball.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: baseColor,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0, 
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: baseColor,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined, 
                            size: 40, 
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16.0),

            // 2. 中間區域 (球名和品牌名) - 使用輕微的 emboss 效果
            ClayContainer(
              color: baseColor,
              borderRadius: 12,
              depth: 12,
              spread: 3,
              emboss: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  children: [
                    Text(
                      ball.name,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      ball.brand,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16.0),

            // 3. SPEC 區域 - 只保留五個主要規格
            ClayContainer(
              color: baseColor,
              borderRadius: 14,
              depth: 32,
              spread: 6,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildSpecContent(context, theme, baseColor),
              ),
            ),
            
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  // SPEC 項目的 Widget
  Widget _buildSpecItem(BuildContext context, String label, String value, Color baseColor) {
    final theme = Theme.of(context);

    return ClayContainer(
      color: baseColor,
      borderRadius: 8,
      depth: 12,
      spread: 2,
      emboss: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold, 
                color: Colors.grey[800],
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // SPEC "視窗" 的內部內容
  Widget _buildSpecContent(BuildContext context, ThemeData theme, Color baseColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 標題
        Center(
          child: Text(
            "規格參數",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontSize: 15,
            ),
          ),
        ),
        
        const SizedBox(height: 10.0),
        
        // 第一排：球心類型 和 球皮類型
        Row(
          children: [
            Expanded(child: _buildSpecItem(context, "球心類型", getCoreCategory(ball.core), baseColor)),
            const SizedBox(width: 8),
            Expanded(child: _buildSpecItem(context, "球皮類型", ball.coverstock, baseColor)),
          ],
        ),
        
        const SizedBox(height: 8.0),
        
        // 第二排：RG, RG差, Mass Bias
        Row(
          children: [
            Expanded(child: _buildSpecItem(context, "RG", ball.rg?.toStringAsFixed(3) ?? 'N/A', baseColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildSpecItem(context, "RG差", ball.differential?.toStringAsFixed(3) ?? 'N/A', baseColor)),
            const SizedBox(width: 6),
            Expanded(child: _buildSpecItem(context, "Mass Bias", ball.massBias?.toStringAsFixed(3) ?? 'N/A', baseColor)),
          ],
        ),
      ],
    );
  }
}

// 顯示球詳細資訊的輔助函數
void showBallDetails(BuildContext context, BowlingBall ball) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.90,
      minHeight: 200,
    ),
    builder: (builderContext) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          color: Color(0xFFE8E8E8), // 匹配 neumorphic 基礎顏色
        ),
        child: BowlingBallDetailWidget(ball: ball),
      );
    },
  );
}
