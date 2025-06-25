import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:iconsax/iconsax.dart';
import 'create_ball_bag_dialog.dart';
import 'edit_ball_bag_dialog.dart';
import '../theme/theme.dart';

/// Ball Bag Options Dialog with modern glassmorphism design, refined based on professional feedback.
class BallBagOptionsDialog extends StatefulWidget {
  const BallBagOptionsDialog({super.key});

  @override
  State<BallBagOptionsDialog> createState() => _BallBagOptionsDialogState();
}

class _BallBagOptionsDialogState extends State<BallBagOptionsDialog> {
  bool _isCloseButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final closeButtonScale = _isCloseButtonPressed ? 0.85 : 1.0;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              width: size.width * 0.85,
              constraints: const BoxConstraints(
                maxWidth: 400,
                minWidth: 280,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: theme.colorScheme.surface.withOpacity(0.2).withAlpha(40),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.4),
                  width: 1.5,
                ),
                boxShadow: AppGlows.medium,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.setting_2,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Ball Bag Options',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (_) => setState(() => _isCloseButtonPressed = true),
                          onTapUp: (_) {
                            setState(() => _isCloseButtonPressed = false);
                            Navigator.of(context).pop();
                          },
                          onTapCancel: () => setState(() => _isCloseButtonPressed = false),
                          child: AnimatedScale(
                            scale: closeButtonScale,
                            duration: const Duration(milliseconds: 150),
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.close_circle,
                                color: Colors.white.withOpacity(0.8),
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _ModernOptionButton(
                            title: 'Create New',
                            subtitle: 'Ball Bag',
                            icon: Iconsax.add_square,
                            onTap: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierColor: Colors.black.withOpacity(0.7),
                                builder: (context) => const CreateBallBagDialog(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ModernOptionButton(
                            title: 'Edit Current',
                            subtitle: 'Ball Bag',
                            icon: Iconsax.edit,
                            onTap: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierColor: Colors.black.withOpacity(0.7),
                                builder: (context) => const EditBallBagDialog(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernOptionButton extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ModernOptionButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ModernOptionButton> createState() => _ModernOptionButtonState();
}

class _ModernOptionButtonState extends State<_ModernOptionButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInteracting = _isHovered || _isPressed;

    // 根據互動狀態計算亮度
    final double brightnessFactor = _isPressed ? 0.15 : (_isHovered ? 0.08 : 0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color.lerp(const Color(0xFF003B5C), Colors.white, brightnessFactor)!,
                Color.lerp(const Color(0xFF001824), Colors.white, brightnessFactor)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              width: 1,
            ),
            // Pressed 狀態下的 Inner Shadow
            boxShadow: _isPressed ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
                spreadRadius: -1,
              ),
            ] : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // 增加 Padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: const Color(0xFFE6F3FF), size: 28),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFE6F3FF),
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        blurRadius: 4,
                      )
                    ]
                  ),
                  textAlign: TextAlign.center,
                ),
                 Text(
                  widget.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFE6F3FF).withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 