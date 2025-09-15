import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_config.dart';

/// 保齡球瓶視覺化組件
/// 顯示10個球瓶的俯視圖，深色表示擊倒，淺色表示站立
class PinVisualizationWidget extends StatelessWidget {
  /// 10個球瓶的狀態，true表示擊倒，false表示站立
  final List<bool> pinStates;
  
  /// 組件寬度，通常與對應的frame寬度相同
  final double width;
  
  /// 組件高度，默認為寬度的0.6倍
  final double? height;
  
  /// 擊倒球瓶的顏色
  final Color? knockedDownColor;
  
  /// 站立球瓶的顏色
  final Color? standingColor;

  /// 是否顯示外框
  final bool showFrame;

  /// 外框顏色
  final Color? frameBorderColor;

  /// 外框寬度
  final double? frameBorderWidth;

  /// 外框圓角
  final double? frameBorderRadius;

  /// 內距（讓球瓶在外框內置中）
  final EdgeInsetsGeometry? contentPadding;

  /// 球瓶大小係數（半徑 = size.width * 係數）
  final double pinSizeFactor;
  
  /// 水平/垂直間距放大倍率（>1 更分開）
  final double spacingScaleX;
  final double spacingScaleY;
  
  /// 半徑相對於行/列間距的上限比例
  final double radiusToSpacingMax;

  /// 絕對球瓶半徑（像素），優先於 pinSizeFactor
  final double? absolutePinRadius;

  const PinVisualizationWidget({
    super.key,
    required this.pinStates,
    required this.width,
    this.height,
    this.knockedDownColor,
    this.standingColor,
    this.showFrame = false,
    this.frameBorderColor,
    this.frameBorderWidth,
    this.frameBorderRadius,
    this.contentPadding,
    this.pinSizeFactor = 0.045,
    this.spacingScaleX = 1.0,
    this.spacingScaleY = 1.0,
    this.radiusToSpacingMax = 0.48,
    this.absolutePinRadius,
  });

  /// 使用設定物件的建立函式（單點入口）
  factory PinVisualizationWidget.withConfig({
    Key? key,
    required List<bool> pinStates,
    required double width,
    double? height,
    PinVisualizationConfig? config,
  }) {
    final PinVisualizationConfig cfg = config ?? PinVisualizationConfig.defaultPreset();
    return PinVisualizationWidget(
      key: key,
      pinStates: pinStates,
      width: width,
      height: height ?? cfg.height,
      knockedDownColor: cfg.knockedDownColor,
      standingColor: cfg.standingColor,
      showFrame: cfg.showFrame,
      frameBorderColor: cfg.frameBorderColor,
      frameBorderWidth: cfg.frameBorderWidth,
      frameBorderRadius: cfg.frameBorderRadius,
      contentPadding: cfg.contentPadding,
      pinSizeFactor: cfg.pinSizeFactor,
      spacingScaleX: cfg.spacingScaleX,
      spacingScaleY: cfg.spacingScaleY,
      radiusToSpacingMax: cfg.radiusToSpacingMax,
      absolutePinRadius: cfg.absolutePinRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(pinStates.length == 10, 'pinStates must contain exactly 10 elements');
    
    final theme = Theme.of(context);
    final actualHeight = height ?? width * 0.6;
    final knockedColor = knockedDownColor ?? theme.colorScheme.primary;
    final standingColorFinal = standingColor ?? theme.colorScheme.outline.withValues(alpha: 0.3);
    
    final borderColor = frameBorderColor ?? theme.colorScheme.primary.withOpacity(0.6);
    final borderWidth = frameBorderWidth ?? 1.0;
    final borderRadius = frameBorderRadius ?? 4.0;
    final padding = contentPadding ?? const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0);

    Widget content = SizedBox.expand(
      child: CustomPaint(
        painter: _PinVisualizationPainter(
          pinStates: pinStates,
          knockedDownColor: knockedColor,
          standingColor: standingColorFinal,
          pinSizeFactor: pinSizeFactor,
          spacingScaleX: spacingScaleX,
          spacingScaleY: spacingScaleY,
          radiusToSpacingMax: radiusToSpacingMax,
          absolutePinRadius: absolutePinRadius,
        ),
      ),
    );

    if (showFrame) {
      content = Container(
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: content,
      );
    }

    return SizedBox(width: width, height: actualHeight, child: content);
  }
}

/// 自定義繪製器，繪製保齡球瓶的三角排列
class _PinVisualizationPainter extends CustomPainter {
  final List<bool> pinStates;
  final Color knockedDownColor;
  final Color standingColor;
  final double pinSizeFactor;
  final double spacingScaleX;
  final double spacingScaleY;
  final double radiusToSpacingMax;
  final double? absolutePinRadius;

  _PinVisualizationPainter({
    required this.pinStates,
    required this.knockedDownColor,
    required this.standingColor,
    required this.pinSizeFactor,
    required this.spacingScaleX,
    required this.spacingScaleY,
    required this.radiusToSpacingMax,
    this.absolutePinRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 計算球瓶位置 - 標準三角排列
    final positions = _calculatePinPositions(size);
    
    // 繪製每個球瓶
    for (int i = 0; i < 10; i++) {
      final position = positions[i];
      final isKnockedDown = pinStates[i];
      
      // 計算球瓶半徑 - 優先使用絕對大小
      final double radius;
      if (absolutePinRadius != null) {
        // 使用絕對像素大小，不受容器大小影響
        radius = absolutePinRadius!;
      } else {
        // 使用原來的相對計算
        final double baseRadius = math.min(size.width, size.height) * pinSizeFactor;
        final double hSpace = (size.width / 12) * spacingScaleX;
        final double vSpace = (size.height / 5) * spacingScaleY;
        radius = radiusToSpacingMax <= 0
            ? baseRadius
            : math.min(baseRadius, radiusToSpacingMax * math.min(hSpace, vSpace));
      }

      if (isKnockedDown) {
        // 擊倒：實心主要色
        final fillPaint = Paint()
          ..color = knockedDownColor
          ..style = PaintingStyle.fill;
        canvas.drawCircle(position, radius, fillPaint);
      } else {
        // 站立：僅外框主要色（移除灰色底）
        final borderPaint = Paint()
          ..color = knockedDownColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
        canvas.drawCircle(position, radius, borderPaint);
      }
    }
  }

  /// 計算10個球瓶的位置
  /// 標準排列：
  ///     7  8  9  10
  ///       4  5  6
  ///         2  3
  ///           1
  List<Offset> _calculatePinPositions(Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // 計算間距
    final horizontalSpacing = (size.width / 12) * spacingScaleX;
    final verticalSpacing = (size.height / 5) * spacingScaleY;
    
    return [
      // 第1排（最前面）- Pin 1
      Offset(centerX, centerY + verticalSpacing * 1.5),
      
      // 第2排 - Pins 2, 3
      Offset(centerX - horizontalSpacing * 0.5, centerY + verticalSpacing * 0.5),
      Offset(centerX + horizontalSpacing * 0.5, centerY + verticalSpacing * 0.5),
      
      // 第3排 - Pins 4, 5, 6
      Offset(centerX - horizontalSpacing, centerY - verticalSpacing * 0.5),
      Offset(centerX, centerY - verticalSpacing * 0.5),
      Offset(centerX + horizontalSpacing, centerY - verticalSpacing * 0.5),
      
      // 第4排（最後面） - Pins 7, 8, 9, 10
      Offset(centerX - horizontalSpacing * 1.5, centerY - verticalSpacing * 1.5),
      Offset(centerX - horizontalSpacing * 0.5, centerY - verticalSpacing * 1.5),
      Offset(centerX + horizontalSpacing * 0.5, centerY - verticalSpacing * 1.5),
      Offset(centerX + horizontalSpacing * 1.5, centerY - verticalSpacing * 1.5),
    ];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _PinVisualizationPainter ||
        oldDelegate.pinStates != pinStates ||
        oldDelegate.knockedDownColor != knockedDownColor ||
        oldDelegate.standingColor != standingColor;
  }
}

/// 工具類，用於處理球瓶狀態數據
class PinVisualizationHelper {
  /// 將投球結果轉換為球瓶狀態（只顯示第一球擊倒的球瓶）
  /// [rolls] 投球記錄
  /// [rollStates] 詳細的球瓶狀態記錄
  /// [frameIndex] frame索引（0-8為1-9格，9為第10格）
  static List<bool> getFramePinStates({
    required List<int> rolls,
    required List<List<bool>> rollStates,
    required int frameIndex,
  }) {
    if (frameIndex < 0 || frameIndex > 9) {
      return List.generate(10, (_) => false);
    }
    
    if (frameIndex < 9) {
      // 1-9格：只顯示第一球
      return _getFrame19FirstRollOnly(rolls, rollStates, frameIndex);
    } else {
      // 第10格：只顯示第一球
      return _getFrame10FirstRollOnly(rolls, rollStates);
    }
  }
  
  /// 獲取1-9格的第一球狀態（確保只顯示第一球擊倒的球瓶）
  static List<bool> _getFrame19FirstRollOnly(List<int> rolls, List<List<bool>> rollStates, int frameIndex) {
    if (rollStates.isEmpty || rolls.isEmpty) {
      return List.generate(10, (_) => false);
    }
    
    // 計算到達該frame時的第一球roll索引
    int rollIndex = 0;
    for (int f = 0; f < frameIndex; f++) {
      if (rollIndex >= rolls.length) break;
      if (rolls[rollIndex] == 10) {
        rollIndex += 1; // 全倒只有1球
      } else {
        rollIndex += 2; // 非全倒有2球
      }
    }
    
    // 如果該frame還沒有投球，返回空狀態
    if (rollIndex >= rollStates.length || rollIndex >= rolls.length) {
      return List.generate(10, (_) => false);
    }
    
    // 確保只取第一球的狀態
    // 如果PinSelectionDialog返回的是累積狀態，我們需要處理這個問題
    List<bool> firstRollState = rollStates[rollIndex];
    
    // 如果該frame有第二球，且不是全倒，我們需要從累積狀態中推算第一球
    if (rollIndex + 1 < rollStates.length && rolls[rollIndex] != 10) {
      // 有第二球的情況，rollStates[rollIndex+1]可能是累積狀態
      // 我們只要第一球的狀態，應該是rollStates[rollIndex]
      // 如果rollStates[rollIndex]已經是累積的，我們無法逆推
      // 所以我們假設rollStates[rollIndex]就是第一球的純狀態
    }
    
    return firstRollState;
  }
  
  /// 獲取第10格的第一球狀態
  static List<bool> _getFrame10FirstRollOnly(List<int> rolls, List<List<bool>> rollStates) {
    if (rollStates.isEmpty || rolls.isEmpty) {
      return List.generate(10, (_) => false);
    }
    
    // 第10格只顯示第一球的狀態
    return rollStates[0];
  }
  
  /// 合併兩個球瓶狀態（OR運算）
  static List<bool> _combineStates(List<bool> state1, List<bool> state2) {
    return List.generate(10, (i) => state1[i] || state2[i]);
  }
}
 