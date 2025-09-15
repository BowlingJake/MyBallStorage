import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/scoring_board.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_config.dart';
import 'package:bowlingarsenal_app/shared/utils/bowling/split_detector.dart';

/// 計分板與球瓶視覺化的複合組件配置
class ScoreboardPinConfig {
  // 計分板配置
  final bool singleRow;
  final double frameAspectRatio;
  final EdgeInsetsGeometry padding;
  final bool removeOuterContainer;
  final bool useGlowText;
  final EdgeInsets frameMargin;
  final double frameBorderWidth;
  final double frameBorderRadius;
  final bool showFrameShadow;
  final bool showHeaderNumbers;
  final double headerBarHeight;
  final Color? headerBarColor;
  final int tenthFrameFlex;
  final Color? accentColor;
  final double? innerBorderWidth;
  final Color? innerBorderColor;
  final LinearGradient? frameFillGradient;
  final bool? useCumulativePill;
  final Color? cumulativeBackgroundColor;
  final EdgeInsets? cumulativePadding;
  final double? cumulativeBorderRadius;
  final TextStyle? cumulativeTextStyle;
  final bool? showSeparatorLine;

  // 球瓶視覺化配置
  final PinVisualizationConfig pinVisualizationConfig;
  final EdgeInsetsGeometry pinContainerMargin;

  // 動畫配置
  final Duration animationDuration;
  final Curve animationCurve;

  // 響應式配置
  final bool enableResponsiveScaling;
  final double responsiveScaleFactor;

  const ScoreboardPinConfig({
    this.singleRow = true,
    this.frameAspectRatio = 0.9,
    this.padding = EdgeInsets.zero,
    this.removeOuterContainer = false,
    this.useGlowText = false,
    this.frameMargin = const EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
    this.frameBorderWidth = 1.2,
    this.frameBorderRadius = 6.0,
    this.showFrameShadow = false,
    this.showHeaderNumbers = false,
    this.headerBarHeight = 6.0,
    this.headerBarColor,
    this.tenthFrameFlex = 1,
    this.accentColor,
    this.innerBorderWidth,
    this.innerBorderColor,
    this.frameFillGradient,
    this.useCumulativePill,
    this.cumulativeBackgroundColor,
    this.cumulativePadding,
    this.cumulativeBorderRadius,
    this.cumulativeTextStyle,
    this.showSeparatorLine,
    this.pinVisualizationConfig = const PinVisualizationConfig(),
    this.pinContainerMargin = const EdgeInsets.symmetric(horizontal: 0.0),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.enableResponsiveScaling = true,
    this.responsiveScaleFactor = 0.95,
  });

  /// 開發者頁面的預設配置
  factory ScoreboardPinConfig.developer({Color? accentColor}) => ScoreboardPinConfig(
        singleRow: true,
        frameAspectRatio: 0.78,
        removeOuterContainer: true,
        padding: EdgeInsets.zero,
        useGlowText: false,
        frameMargin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.0),
        frameBorderWidth: 1.0,
        frameBorderRadius: 4.0,
        showFrameShadow: false,
        showHeaderNumbers: true,
        headerBarHeight: 0.0,
        headerBarColor: null,
        tenthFrameFlex: 1,
        accentColor: accentColor,
        pinVisualizationConfig: PinVisualizationConfig.dev(),
        pinContainerMargin: const EdgeInsets.symmetric(horizontal: 0.0),
      );

  /// 創建此配置的副本，可選擇性覆蓋某些屬性
  ScoreboardPinConfig copyWith({
    bool? singleRow,
    double? frameAspectRatio,
    EdgeInsetsGeometry? padding,
    bool? removeOuterContainer,
    bool? useGlowText,
    EdgeInsets? frameMargin,
    double? frameBorderWidth,
    double? frameBorderRadius,
    bool? showFrameShadow,
    bool? showHeaderNumbers,
    double? headerBarHeight,
    Color? headerBarColor,
    int? tenthFrameFlex,
    Color? accentColor,
    double? innerBorderWidth,
    Color? innerBorderColor,
    LinearGradient? frameFillGradient,
    bool? useCumulativePill,
    Color? cumulativeBackgroundColor,
    EdgeInsets? cumulativePadding,
    double? cumulativeBorderRadius,
    TextStyle? cumulativeTextStyle,
    bool? showSeparatorLine,
    PinVisualizationConfig? pinVisualizationConfig,
    EdgeInsetsGeometry? pinContainerMargin,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableResponsiveScaling,
    double? responsiveScaleFactor,
  }) {
    return ScoreboardPinConfig(
      singleRow: singleRow ?? this.singleRow,
      frameAspectRatio: frameAspectRatio ?? this.frameAspectRatio,
      padding: padding ?? this.padding,
      removeOuterContainer: removeOuterContainer ?? this.removeOuterContainer,
      useGlowText: useGlowText ?? this.useGlowText,
      frameMargin: frameMargin ?? this.frameMargin,
      frameBorderWidth: frameBorderWidth ?? this.frameBorderWidth,
      frameBorderRadius: frameBorderRadius ?? this.frameBorderRadius,
      showFrameShadow: showFrameShadow ?? this.showFrameShadow,
      showHeaderNumbers: showHeaderNumbers ?? this.showHeaderNumbers,
      headerBarHeight: headerBarHeight ?? this.headerBarHeight,
      headerBarColor: headerBarColor ?? this.headerBarColor,
      tenthFrameFlex: tenthFrameFlex ?? this.tenthFrameFlex,
      accentColor: accentColor ?? this.accentColor,
      innerBorderWidth: innerBorderWidth ?? this.innerBorderWidth,
      innerBorderColor: innerBorderColor ?? this.innerBorderColor,
      frameFillGradient: frameFillGradient ?? this.frameFillGradient,
      useCumulativePill: useCumulativePill ?? this.useCumulativePill,
      cumulativeBackgroundColor: cumulativeBackgroundColor ?? this.cumulativeBackgroundColor,
      cumulativePadding: cumulativePadding ?? this.cumulativePadding,
      cumulativeBorderRadius: cumulativeBorderRadius ?? this.cumulativeBorderRadius,
      cumulativeTextStyle: cumulativeTextStyle ?? this.cumulativeTextStyle,
      showSeparatorLine: showSeparatorLine ?? this.showSeparatorLine,
      pinVisualizationConfig: pinVisualizationConfig ?? this.pinVisualizationConfig,
      pinContainerMargin: pinContainerMargin ?? this.pinContainerMargin,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      enableResponsiveScaling: enableResponsiveScaling ?? this.enableResponsiveScaling,
      responsiveScaleFactor: responsiveScaleFactor ?? this.responsiveScaleFactor,
    );
  }

  /// 訓練頁面的預設配置
  factory ScoreboardPinConfig.training({Color? accentColor}) => ScoreboardPinConfig(
        singleRow: true,
        frameAspectRatio: 0.85,
        removeOuterContainer: true,
        padding: const EdgeInsets.all(8.0),
        useGlowText: true,
        frameMargin: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.5),
        frameBorderWidth: 1.2,
        frameBorderRadius: 6.0,
        showFrameShadow: true,
        showHeaderNumbers: true,
        headerBarHeight: 6.0,
        tenthFrameFlex: 1,
        accentColor: accentColor,
        pinVisualizationConfig: PinVisualizationConfig.spacious(),
        pinContainerMargin: const EdgeInsets.symmetric(horizontal: 4.0),
      );

  /// 緊湊版配置
  factory ScoreboardPinConfig.compact({Color? accentColor}) => ScoreboardPinConfig(
        singleRow: true,
        frameAspectRatio: 0.8,
        removeOuterContainer: true,
        padding: const EdgeInsets.all(4.0),
        useGlowText: false,
        frameMargin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.0),
        frameBorderWidth: 1.0,
        frameBorderRadius: 4.0,
        showFrameShadow: false,
        showHeaderNumbers: true,
        headerBarHeight: 0.0,
        tenthFrameFlex: 1,
        accentColor: accentColor,
        pinVisualizationConfig: PinVisualizationConfig.compact(),
        pinContainerMargin: const EdgeInsets.symmetric(horizontal: 2.0),
      );
}

/// 球瓶數據封裝
class PinData {
  final List<int> rolls19;
  final List<List<bool>> rollStates19;
  final List<int> rolls10;
  final List<List<bool>> rollStates10;

  const PinData({
    required this.rolls19,
    required this.rollStates19,
    required this.rolls10,
    required this.rollStates10,
  });
}

/// 計分板與球瓶視覺化複合組件
class ScoreboardWithPinVisualization extends StatefulWidget {
  final List<BowlingFrame> frames;
  final void Function(int frameIndex) onFrameTapped;
  final bool showThirdBallInTenthFrame;
  final PinData pinData;
  final ScoreboardPinConfig config;
  final bool showPinVisualization;
  final ValueChanged<bool>? onVisualizationToggled;
  final String? title;

  const ScoreboardWithPinVisualization({
    super.key,
    required this.frames,
    required this.onFrameTapped,
    required this.showThirdBallInTenthFrame,
    required this.pinData,
    this.config = const ScoreboardPinConfig(),
    this.showPinVisualization = true,
    this.onVisualizationToggled,
    this.title,
  });

  @override
  State<ScoreboardWithPinVisualization> createState() => _ScoreboardWithPinVisualizationState();
}

class _ScoreboardWithPinVisualizationState extends State<ScoreboardWithPinVisualization>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late bool _isVisualizationVisible;

  @override
  void initState() {
    super.initState();
    _isVisualizationVisible = widget.showPinVisualization;
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );
    _heightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.config.animationCurve,
    ));

    if (_isVisualizationVisible) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ScoreboardWithPinVisualization oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showPinVisualization != oldWidget.showPinVisualization) {
      _toggleVisualization(widget.showPinVisualization);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleVisualization(bool show) {
    if (show == _isVisualizationVisible) return;

    setState(() {
      _isVisualizationVisible = show;
    });

    if (show) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    // 延遲執行回調避免在 build 期間觸發父組件的 setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onVisualizationToggled?.call(show);
    });
  }

  /// 生成球瓶視覺化組件列表
  List<Widget> _buildPinVisualizationRow({double? availableWidth}) {
    final List<Widget> pinVisualizations = [];
    
    // 根據可用寬度智能選擇配置
    PinVisualizationConfig adaptiveConfig = widget.config.pinVisualizationConfig;
    if (availableWidth != null && availableWidth < double.infinity) {
      final frameWidth = availableWidth / 10; // 每個frame的近似寬度
      
      if (frameWidth < 40) {
        // 極小空間：最小配置但確保不重疊
        adaptiveConfig = PinVisualizationConfig.compact().copyWith(
          absolutePinRadius: 2.5, // 更小半徑
          spacingScaleX: 2.8, // 調整間距配合小球瓶
          spacingScaleY: 1.5,
          height: 40,
        );
      } else if (frameWidth < 60) {
        // 中等空間：使用改進的compact配置
        adaptiveConfig = PinVisualizationConfig.compact();
      } else if (frameWidth < 80) {
        // 較大空間：使用spacious配置
        adaptiveConfig = PinVisualizationConfig.spacious();
      } else {
        // 大空間：最優配置，球瓶大但控制垂直間距避免溢出
        adaptiveConfig = widget.config.pinVisualizationConfig.copyWith(
          absolutePinRadius: 7.0, // 稍微減小到7像素
          spacingScaleX: 4.5, // 適度的水平間距
          spacingScaleY: 1.6, // 控制垂直間距避免溢出
          radiusToSpacingMax: 0.0, // 禁用相對限制
          height: 56.0, // 限制高度
        );
      }
    }
    
    for (int frameIndex = 0; frameIndex < 10; frameIndex++) {
      List<bool> pinStates;
      
      if (frameIndex < 9) {
        // 1-9格：使用合併的數據
        pinStates = PinVisualizationHelper.getFramePinStates(
          rolls: widget.pinData.rolls19,
          rollStates: widget.pinData.rollStates19,
          frameIndex: frameIndex,
        );
      } else {
        // 第10格：使用第10格的數據
        pinStates = PinVisualizationHelper.getFramePinStates(
          rolls: widget.pinData.rolls10,
          rollStates: widget.pinData.rollStates10,
          frameIndex: frameIndex,
        );
      }
      
      pinVisualizations.add(
        Expanded(
          flex: frameIndex == 9 ? 1 : 1, // 第10格與其他格相同flex
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0.5),
            child: PinVisualizationWidget.withConfig(
              pinStates: pinStates,
              width: double.infinity,
              config: adaptiveConfig,
            ),
          ),
        ),
      );
    }
    
    return pinVisualizations;
  }

  /// 計算split狀態
  List<bool> _calculateSplitPerFrame() {
    return List<bool>.generate(10, (i) {
      // 取得第一球的純狀態
      final List<bool> firstRoll = PinVisualizationHelper.getFramePinStates(
        rolls: i < 9 ? widget.pinData.rolls19 : widget.pinData.rolls10,
        rollStates: i < 9 ? widget.pinData.rollStates19 : widget.pinData.rollStates10,
        frameIndex: i,
      );
      return SplitDetector.isSplit(firstRoll);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 根據可用寬度決定是否需要縮放
        final availableWidth = constraints.maxWidth;
        final needsScaling = widget.config.enableResponsiveScaling && 
                           availableWidth < double.infinity && 
                           availableWidth < 800; // 假設最佳寬度為800

        Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 計分板
            ScoringBoard(
              title: widget.title,
              frames: widget.frames,
              onFrameTapped: widget.onFrameTapped,
              showThirdBallInTenthFrame: widget.showThirdBallInTenthFrame,
              singleRow: widget.config.singleRow,
              frameAspectRatio: widget.config.frameAspectRatio,
              removeOuterContainer: widget.config.removeOuterContainer,
              padding: widget.config.padding,
              useGlowText: widget.config.useGlowText,
              frameMargin: widget.config.frameMargin,
              frameBorderWidth: widget.config.frameBorderWidth,
              frameBorderRadius: widget.config.frameBorderRadius,
              showFrameShadow: widget.config.showFrameShadow,
              showHeaderNumbers: widget.config.showHeaderNumbers,
              headerBarHeight: widget.config.headerBarHeight,
              headerBarColor: widget.config.headerBarColor,
              tenthFrameFlex: widget.config.tenthFrameFlex,
              accentColor: widget.config.accentColor ?? Theme.of(context).colorScheme.primary,
              innerBorderWidth: widget.config.innerBorderWidth,
              innerBorderColor: widget.config.innerBorderColor,
              frameFillGradient: widget.config.frameFillGradient,
              useCumulativePill: widget.config.useCumulativePill,
              cumulativeBackgroundColor: widget.config.cumulativeBackgroundColor,
              cumulativePadding: widget.config.cumulativePadding,
              cumulativeBorderRadius: widget.config.cumulativeBorderRadius,
              cumulativeTextStyle: widget.config.cumulativeTextStyle,
              showSeparatorLine: widget.config.showSeparatorLine,
              isSplitPerFrame: _calculateSplitPerFrame(),
            ),
            
            // 球瓶視覺化（動畫）
            AnimatedBuilder(
              animation: _heightAnimation,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: _heightAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: widget.config.pinContainerMargin,
                child: Row(
                  children: _buildPinVisualizationRow(availableWidth: availableWidth),
                ),
              ),
            ),
          ],
        );

        // 智能縮放：只有在真正需要時才縮放
        if (needsScaling) {
          final scaleFactor = (availableWidth / 800).clamp(0.8, 1.0); // 動態縮放因子
          content = Transform.scale(
            scale: scaleFactor,
            alignment: Alignment.topCenter, // 確保從頂部縮放
            child: content,
          );
        }

        return content;
      },
    );
  }
}