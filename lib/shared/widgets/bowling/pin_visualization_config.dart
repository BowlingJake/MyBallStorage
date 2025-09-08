import 'package:flutter/material.dart';

/// Pin 視覺化設定物件與預設組合
class PinVisualizationConfig {
  final double? height;
  final bool showFrame;
  final Color? frameBorderColor;
  final double? frameBorderWidth;
  final double? frameBorderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final double pinSizeFactor;
  final double spacingScaleX;
  final double spacingScaleY;
  final double radiusToSpacingMax;
  final Color? knockedDownColor;
  final Color? standingColor;

  const PinVisualizationConfig({
    this.height,
    this.showFrame = false,
    this.frameBorderColor,
    this.frameBorderWidth,
    this.frameBorderRadius,
    this.contentPadding,
    this.pinSizeFactor = 0.045,
    this.spacingScaleX = 1.0,
    this.spacingScaleY = 1.0,
    this.radiusToSpacingMax = 0.48,
    this.knockedDownColor,
    this.standingColor,
  });

  factory PinVisualizationConfig.defaultPreset() => const PinVisualizationConfig();

  /// 更緊湊的小型顯示
  factory PinVisualizationConfig.compact() => const PinVisualizationConfig(
        height: 40,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        pinSizeFactor: 0.05,
        spacingScaleX: 1.05,
        spacingScaleY: 1.05,
        radiusToSpacingMax: 0.46,
        showFrame: true,
        frameBorderWidth: 1.0,
        frameBorderRadius: 4.0,
      );

  /// 更寬鬆、視覺更清楚的顯示
  factory PinVisualizationConfig.spacious() => const PinVisualizationConfig(
        height: 56,
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        pinSizeFactor: 0.075,
        spacingScaleX: 1.15,
        spacingScaleY: 1.15,
        radiusToSpacingMax: 0.44,
        showFrame: true,
        frameBorderWidth: 1.0,
        frameBorderRadius: 4.0,
      );

  /// 開發者當前最佳視覺（大且分散，無上限）
  factory PinVisualizationConfig.dev() => const PinVisualizationConfig(
        height: 56,
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        pinSizeFactor: 0.12,
        spacingScaleX: 3.9,
        spacingScaleY: 1.35,
        radiusToSpacingMax: 0.0,
        showFrame: true,
        frameBorderWidth: 1.0,
        frameBorderRadius: 4.0,
      );
}


