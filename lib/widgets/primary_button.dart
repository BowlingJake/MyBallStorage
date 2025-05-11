import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool hasTextStroke; // 新增一個參數來控制是否有文字描邊

  const MyCustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.hasTextStroke = false, // 預設沒有文字描邊
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 文字樣式
    TextStyle textStyle = TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600, // SemiBold 大約對應 FontWeight.w600
      fontSize: 16,
      color: Color(0xFFFFFFFF), // 文字顏色 FFFFFF
      letterSpacing: 16 * 0.05, // 5% of font size
    );

    // 如果需要文字描邊 (這是一個簡化的實現，可能需要更複雜的方案以達到完美效果)
    if (hasTextStroke) {
      textStyle = textStyle.copyWith(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1 // 你可以根據 Figma 調整描邊寬度，這裡假設為1
          ..color = Color(0xFF000000), // 描邊顏色 000000
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFA3D5DC), // 按鈕背景色 A3D5DC
        padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        minimumSize: Size(0, 40), // 確保按鈕的最小高度是 40，寬度由內容決定
                                  // Figma 上的 W:115 Hug 可能是特定文字下的寬度
                                  // 如果需要固定寬度，可以設為 Size(115, 40)
                                  // 但通常按鈕寬度 'Hug' 內容會更好
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 圓角 20
        ),
        elevation: 0, // 如果 Figma 設計中沒有陰影，設為 0
        // 如果有陰影，可以根據 Figma 的 Effects 調整
        // shadowColor: Colors.grey,
        // elevation: 5,
      ).copyWith(
        // 確保文字在按鈕內是居中的 (ElevatedButton 預設就是居中的)
        alignment: Alignment.center,
      ),
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center, // 文字本身在 Text Widget 內居中
      ),
    );
  }
}