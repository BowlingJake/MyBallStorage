import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 以 SVG 呈現的球瓶視覺化（取代 CustomPaint 版本）
/// 預設高度沿用原先邏輯：height ?? width * 0.6
class PinSvgWidget extends StatelessWidget {
  const PinSvgWidget({
    super.key,
    required this.width,
    this.height,
    this.assetPath = 'assets/images/pinvirtrualization.svg',
    this.color,
    this.flipVertical = false,
    this.pinStates,
  });

  final double width;
  final double? height;
  final String assetPath;
  final Color? color;
  final bool flipVertical;
  final List<bool>? pinStates; // true: 被擊倒(填滿), false: 站立(空心)

  @override
  Widget build(BuildContext context) {
    final double actualHeight = height ?? width * 0.6;
    // 若提供 pinStates，改用動態字串以反映每顆球瓶的狀態
    final bool useDynamic = pinStates != null && pinStates!.length == 10;
    final Widget svg = useDynamic
        ? SvgPicture.string(
            _buildDynamicSvg(pinStates!, color),
            width: width,
            height: actualHeight,
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomCenter,
          )
        : SvgPicture.asset(
            assetPath,
            width: width,
            height: actualHeight,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomCenter,
          );

    return SizedBox(
      width: width,
      height: actualHeight,
      child: flipVertical
          ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(1.0, -1.0),
              child: svg,
            )
          : svg,
    );
  }

  /// 生成可貼底顯示的倒三角 SVG 字串，根據 pinStates 動態上色
  /// 採用 viewBox 100x60，最上4、其下3、其下2、最底1（符合倒三角）
  String _buildDynamicSvg(List<bool> states, Color? color) {
    String colorStr = color != null ? _toHex(color) : 'currentColor';

    // pinStates 的索引對應：
    // 0: 底部 1 顆（Pin 1）
    // 1,2: 往上第二列（Pins 2,3）
    // 3,4,5: 再上第三列（Pins 4,5,6）
    // 6,7,8,9: 最上列 4 顆（Pins 7,8,9,10）

    // 倒三角座標配置 (x, y, r)
    final Map<int, Map<String, num>> pos = {
      // 最上列 4 顆（索引6-9）
      6: {'cx': 12.5, 'cy': 8, 'r': 6},
      7: {'cx': 37.5, 'cy': 8, 'r': 6},
      8: {'cx': 62.5, 'cy': 8, 'r': 6},
      9: {'cx': 87.5, 'cy': 8, 'r': 6},
      // 其下 3 顆（索引3-5）
      3: {'cx': 25, 'cy': 24, 'r': 6},
      4: {'cx': 50, 'cy': 24, 'r': 6},
      5: {'cx': 75, 'cy': 24, 'r': 6},
      // 其下 2 顆（索引1-2）
      1: {'cx': 37.5, 'cy': 40, 'r': 6},
      2: {'cx': 62.5, 'cy': 40, 'r': 6},
      // 最底 1 顆（索引0）
      0: {'cx': 50, 'cy': 56, 'r': 6},
    };

    final StringBuffer buf = StringBuffer();
    buf.writeln('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 60" preserveAspectRatio="xMidYMax meet">');
    buf.writeln('<g fill="$colorStr" stroke="$colorStr" stroke-width="1.4">');

    for (int i = 0; i < 10; i++) {
      final p = pos[i]!;
      final bool down = states[i]; // true: 被擊倒
      if (down) {
        buf.writeln('<circle cx="${p['cx']}" cy="${p['cy']}" r="${p['r']}"/>');
      } else {
        buf.writeln('<circle cx="${p['cx']}" cy="${p['cy']}" r="${p['r']}" fill="none"/>');
      }
    }

    buf.writeln('</g></svg>');
    return buf.toString();
  }

  String _toHex(Color c) {
    return '#${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}';
  }
}


