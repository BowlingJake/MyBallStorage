import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

// 保齡球資料模型
class BowlingBall {
  final String id;
  final String name;
  final String brand;
  final String coverstock;
  final String core;
  final String imageUrl;

  BowlingBall({
    required this.id,
    required this.name,
    required this.brand,
    required this.coverstock,
    required this.core,
    this.imageUrl = 'https://via.placeholder.com/80x80/A3D5DC/FFFFFF?Text=Ball',
  });

  factory BowlingBall.fromJson(Map<String, dynamic> json) {
    return BowlingBall(
      id: json['Ball'] ?? '',
      name: json['Ball'] ?? '',
      brand: json['Brand'] ?? '',
      coverstock: json['Coverstock Category'] ?? '',
      core: json['Core'] ?? '',
      imageUrl: '', // 你可以根據需求加上圖片欄位
    );
  }
}

class BallListView extends StatelessWidget {
  final List<BowlingBall> balls;
  final String searchText;
  final Function(BowlingBall)? onBallTap;
  final Function(BowlingBall)? onBallLongPress;

  const BallListView({
    Key? key,
    required this.balls,
    this.searchText = '',
    this.onBallTap,
    this.onBallLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (balls.isEmpty) {
      return Center(
        child: Text(
          searchText.isNotEmpty ? 'No balls match your search.' : 'No balls in your arsenal yet.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      itemCount: balls.length,
      itemBuilder: (context, index) {
        final ball = balls[index];
        return GFListTile(
          title: Text(ball.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          subTitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brand: ${ball.brand}'),
              Text('Cover: ${ball.coverstock}'),
              Text('Core: ${ball.core}'),
            ],
          ),
          icon: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.outline),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: theme.colorScheme.surface,
          shadow: BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
          radius: 8,
          onTap: () {
            onBallTap?.call(ball);
            print('Tapped on ${ball.name}');
          },
          onLongPress: () {
            onBallLongPress?.call(ball);
            print('Long pressed on ${ball.name}');
          },
        );
      },
    );
  }
} 