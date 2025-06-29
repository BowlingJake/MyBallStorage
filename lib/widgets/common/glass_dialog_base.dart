import 'package:flutter/material.dart';
import 'dart:ui';
import '../app_standard_button.dart';

/// 毛玻璃效果對話框基底組件
class GlassDialogBase extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final double? maxWidth;
  final double? minWidth;
  final VoidCallback? onClose;

  const GlassDialogBase({
    Key? key,
    required this.title,
    required this.child,
    this.actions,
    this.maxWidth = 400,
    this.minWidth = 320,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              width: size.width * 0.9,
              constraints: BoxConstraints(
                maxWidth: maxWidth!,
                minWidth: minWidth!,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 毛玻璃背景
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                  ),
                  // 內容
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 標題與關閉按鈕
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 28),
                              onPressed: onClose ?? () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // 主要內容
                        child,
                        
                        // 操作按鈕
                        if (actions != null) ...[
                          const SizedBox(height: 32),
                          Row(
                            children: actions!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 標準的對話框按鈕
class DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isExpanded;

  const DialogButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.isExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = AppStandardButton(
      text: text,
      onPressed: onPressed,
      customColor: isPrimary ? Colors.white : Colors.white.withOpacity(0.8),
      isPrimary: isPrimary,
      height: 50,
    );

    return isExpanded ? Expanded(child: button) : button;
  }
} 