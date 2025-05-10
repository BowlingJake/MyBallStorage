import 'package:flutter/material.dart';

class BallCardWidget extends StatelessWidget {
  final String title;
  final String stat1, stat2, stat3;
  final VoidCallback? onTap;

  const BallCardWidget({
    Key? key,
    required this.title,
    required this.stat1,
    required this.stat2,
    required this.stat3,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: _TopCurveClipper(),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // 可以在此使用 Positioned 加入 Logo 或 Icon
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(context, stat1, 'RG'),
                  VerticalDivider(color: Colors.white54, thickness: 1),
                  _buildStat(context, stat2, 'Diff'),
                  VerticalDivider(color: Colors.white54, thickness: 1),
                  _buildStat(context, stat3, 'MB Diff'),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext ctx, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(ctx)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(ctx)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(
          size.width * 0.2, size.height, size.width * 0.5, size.height)
      ..quadraticBezierTo(
          size.width * 0.8, size.height, size.width, size.height * 0.8)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}
