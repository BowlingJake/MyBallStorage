import 'package:bowlingarsenal_app/features/arsenal/models/arsenal_ball.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/cards/standard_app_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// 用於在主頁顯示單個裝備庫球的卡片
/// 使用 StandardAppCard 作為基礎，以保持風格統一
class ArsenalCard extends StatelessWidget {
  const ArsenalCard({required this.ball, super.key, this.onTap});
  final ArsenalBall ball;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130, // 給定一個固定寬度以在 ListView 中正常顯示
      margin: const EdgeInsets.only(right: 16),
      child: StandardAppCard(
        variant: StandardAppCardVariant.nested, // 使用嵌套變體以獲得更好的視覺對比
        onTap: onTap,
        margin: EdgeInsets.zero, // 父容器已處理 margin
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 球的圖片
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                // 使用 imagePath 並假設是本地 asset
                child:
                    ball.imagePath.isNotEmpty
                        ? Image.asset(
                          'assets/images/${ball.imagePath}', // 假設路徑相對於 assets/images
                          fit: BoxFit.contain,
                          // 圖片載入失敗時的錯誤圖示
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error_outline,
                              color: Colors.white.withOpacity(0.5),
                            );
                          },
                        )
                        : Icon(
                          // 如果沒有圖片路徑，使用替代圖示
                          Iconsax.box, // 使用存在的圖示
                          size: 40,
                          color: Colors.white.withOpacity(0.7),
                        ),
              ),
            ),
            const SizedBox(height: 8),

            // 球的名稱
            Text(
              ball.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
