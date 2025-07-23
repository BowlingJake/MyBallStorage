// 檔案路徑： professional_dark_background.dart

import 'package:flutter/material.dart';

class ProfessionalDarkBackground extends StatelessWidget {
  const ProfessionalDarkBackground({
    required this.child,
    super.key,
    // *** 請確保這個路徑是您專案中正確的圖片路徑 ***
    this.backgroundImage = 'assets/images/Sport_Tech_Background.webp',
  });
  final Widget child;
  final String backgroundImage;

  @override
  Widget build(BuildContext context) {
    // 使用 Container 的 decoration 來設定可重複的背景圖
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          // 關鍵屬性：讓圖片在垂直和水平方向上重複平鋪
          repeat: ImageRepeat.repeat,
          // 你仍然可以使用 fit，但 repeat 通常效果更好
          // fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        // Scaffold 必須是透明的，才能讓 Container 的背景顯示出來
        backgroundColor: Colors.transparent,
        body: child,
      ),
    );
  }
}