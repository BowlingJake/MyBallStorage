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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cardWidth = 120.0 + 12.0; // 卡片寬度 + 間距
    final currentIndex = (_scrollController.offset / cardWidth).round();
    if (currentIndex != _currentIndex) {
      setState(() {
        _currentIndex = currentIndex;
      });
    }
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
            TextButton(
              onPressed: widget.onSeeAllPressed ?? () => print('See All Arsenal'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text('See All'),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (arsenalBalls.isEmpty)
          const Center(
            child: Text('Your arsenal is empty.'),
          )
        else ...[
          SizedBox(
            height: 160,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: arsenalBalls.length,
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
          
          // 分頁指示器
          const SizedBox(height: 8),
          if (arsenalBalls.length > 1)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  arsenalBalls.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex == index ? 8 : 6,
                    height: _currentIndex == index ? 8 : 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index 
                        ? const Color(0xFFf39c12)
                        : Colors.grey.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
} 