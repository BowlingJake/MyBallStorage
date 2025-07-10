import 'package:flutter/material.dart';

class BallImageWidget extends StatelessWidget {
  const BallImageWidget({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  static const String _placeholderImage = 'assets/images/sample_strikeTrack.png';

  @override
  Widget build(BuildContext context) {
    Widget placeholderBuilder(BuildContext context) {
      return Image.asset(
        _placeholderImage,
        width: width,
        height: height,
        fit: fit,
      );
    }

    if (imageUrl.isEmpty) {
      return placeholderBuilder(context);
    }

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return placeholderBuilder(context);
        },
      );
    } else {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.high,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return placeholderBuilder(context);
        },
      );
    }
  }
} 