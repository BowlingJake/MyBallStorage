import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/arsenal_ball.dart';
import '../views/my_arsenal_page.dart';
import 'home_arsenal_card.dart';

class ArsenalSection extends ConsumerStatefulWidget {
  final VoidCallback? onSeeAllPressed;
  final void Function(int index)? onItemPressed;

  const ArsenalSection({
    Key? key,
    this.onSeeAllPressed,
    this.onItemPressed,
  }) : super(key: key);

  @override
  ConsumerState<ArsenalSection> createState() => _ArsenalSectionState();
}

class _ArsenalSectionState extends ConsumerState<ArsenalSection> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNext() {
    final double cardWidth = 120 + 12; // 卡片寬度 + margin
    final double scrollDistance = cardWidth * 3; // 一次滑動3張卡片的距離
    
    _scrollController.animateTo(
      _scrollController.offset + scrollDistance,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ArsenalBall> arsenalBalls = ref.watch(userBallsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Arsenal', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ) ?? TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            )),
            Row(
              children: [
                if (arsenalBalls.length > 3) // 只有當球數超過6個時才顯示滑動提示
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: _scrollToNext,
                      child: Icon(
                        Icons.keyboard_double_arrow_right,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        size: 20,
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: widget.onSeeAllPressed ?? () => print('See All Arsenal'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text('See All'),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: arsenalBalls.length, // 顯示所有球，而不只是前6個
            itemBuilder: (context, index) {
              final ball = arsenalBalls[index];
              return HomeArsenalCard(
                ball: ball,
                onTap: () {
                  if (widget.onItemPressed != null) {
                    widget.onItemPressed!(index);
                  } else {
                    print('View Arsenal Item ${index + 1}: ${ball.name}');
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }


} 