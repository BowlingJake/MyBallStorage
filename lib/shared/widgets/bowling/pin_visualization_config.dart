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
  final double? absolutePinRadius;

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
    this.absolutePinRadius,
  });

  factory PinVisualizationConfig.defaultPreset() => const PinVisualizationConfig();

  /// 緊湊的小型顯示 - 使用絕對大小確保清晰度
  factory PinVisualizationConfig.compact() => const PinVisualizationConfig(
        height: 48,
        contentPadding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        pinSizeFactor: 0.08,
        spacingScaleX: 3.2,
        spacingScaleY: 1.25,
        radiusToSpacingMax: 0.0,
        absolutePinRadius: 3.4,
        showFrame: true,
        frameBorderWidth: 1.0,
        frameBorderRadius: 4.0,
      );

  /// 寬鬆顯示 - 使用絕對大小確保優質視覺，控制邊界
  factory PinVisualizationConfig.spacious() => const PinVisualizationConfig(
        height: 54, // 稍微降低高度
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 減少垂直padding
        pinSizeFactor: 0.095,  
        spacingScaleX: 4.0, // 保持水平間距
        spacingScaleY: 1.6, // 減少垂直間距避免溢出
        radiusToSpacingMax: 0.0, // 禁用相對限制，使用絕對大小
        absolutePinRadius: 6.0, // 固定6像素半徑，更好的視覺效果
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

  /// 創建此配置的副本，可選擇性覆蓋某些屬性
  PinVisualizationConfig copyWith({
    double? height,
    bool? showFrame,
    Color? frameBorderColor,
    double? frameBorderWidth,
    double? frameBorderRadius,
    EdgeInsetsGeometry? contentPadding,
    double? pinSizeFactor,
    double? spacingScaleX,
    double? spacingScaleY,
    double? radiusToSpacingMax,
    Color? knockedDownColor,
    Color? standingColor,
    double? absolutePinRadius,
  }) {
    return PinVisualizationConfig(
      height: height ?? this.height,
      showFrame: showFrame ?? this.showFrame,
      frameBorderColor: frameBorderColor ?? this.frameBorderColor,
      frameBorderWidth: frameBorderWidth ?? this.frameBorderWidth,
      frameBorderRadius: frameBorderRadius ?? this.frameBorderRadius,
      contentPadding: contentPadding ?? this.contentPadding,
      pinSizeFactor: pinSizeFactor ?? this.pinSizeFactor,
      spacingScaleX: spacingScaleX ?? this.spacingScaleX,
      spacingScaleY: spacingScaleY ?? this.spacingScaleY,
      radiusToSpacingMax: radiusToSpacingMax ?? this.radiusToSpacingMax,
      knockedDownColor: knockedDownColor ?? this.knockedDownColor,
      standingColor: standingColor ?? this.standingColor,
      absolutePinRadius: absolutePinRadius ?? this.absolutePinRadius,
    );
  }
}


