import 'dart:ui';

import 'package:flutter/material.dart';

/// 計分方式選擇器組件
class ScoringMethodSelector extends StatefulWidget {
  const ScoringMethodSelector({
    required this.selectedMethod,
    required this.onMethodSelected,
    super.key,
  });
  final String selectedMethod;
  final Function(String) onMethodSelected;

  @override
  State<ScoringMethodSelector> createState() => _ScoringMethodSelectorState();
}

class _ScoringMethodSelectorState extends State<ScoringMethodSelector> {
  OverlayEntry? _tooltipOverlay;

  void _showTooltip(BuildContext context) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _tooltipOverlay = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              GestureDetector(
                onTap: _hideTooltip,
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                left: position.dx - 50,
                top: position.dy + 40,
                child: Material(
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                            child: Container(
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                        ),
                        Container(
                          width: 260,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                height: 1.3,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Traditional: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: 'Standard 10-pin scoring\n\n'),
                                TextSpan(
                                  text: 'Current: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      'Alternative scoring methods (9-pin, etc.)',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_tooltipOverlay!);
  }

  void _hideTooltip() {
    _tooltipOverlay?.remove();
    _tooltipOverlay = null;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 標題與問號按鈕
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Scoring Method',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onLongPressStart: (_) => _showTooltip(context),
                onLongPressEnd: (_) => _hideTooltip(),
                onTapDown: (_) => _showTooltip(context),
                onTapUp: (_) => _hideTooltip(),
                onTapCancel: _hideTooltip,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                  ),
                  child: Icon(
                    Icons.question_mark,
                    size: 8,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 兩個並排按鈕
          Row(
            children: [
              // Traditional Scoring 按鈕
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onMethodSelected('traditional'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          widget.selectedMethod == 'traditional'
                              ? Colors.white.withOpacity(0.3)
                              : Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color:
                            widget.selectedMethod == 'traditional'
                                ? Colors.white.withOpacity(0.8)
                                : Colors.white.withOpacity(0.3),
                        width: widget.selectedMethod == 'traditional' ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Traditional',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                            widget.selectedMethod == 'traditional'
                                ? FontWeight.w600
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Current Scoring 按鈕
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onMethodSelected('current'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          widget.selectedMethod == 'current'
                              ? Colors.white.withOpacity(0.3)
                              : Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color:
                            widget.selectedMethod == 'current'
                                ? Colors.white.withOpacity(0.8)
                                : Colors.white.withOpacity(0.3),
                        width: widget.selectedMethod == 'current' ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Current',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                            widget.selectedMethod == 'current'
                                ? FontWeight.w600
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
