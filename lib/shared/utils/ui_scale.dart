import 'package:flutter/material.dart';

/// UI 尺寸比例與文字縮放工具（以 iPhone 寬度 390 為基準）
class UiScale {
  static const double _baseWidth = 390.0;
  // 全域字體縮放只縮小不放大，避免大機型文字暴衝
  static const double _minScale = 0.85;
  static const double _maxScale = 1.0;

  /// 依螢幕寬度計算比例（類 rem）並夾制
  static double scale(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double s = width / _baseWidth;
    // 只縮小不放大
    final double shrinkOnly = s.clamp(_minScale, _maxScale);
    return shrinkOnly;
  }

  /// 提供全域文字縮放器，覆寫 MediaQuery.textScaler
  static TextScaler textScalerFor(BuildContext context) {
    return TextScaler.linear(scale(context));
  }
}


