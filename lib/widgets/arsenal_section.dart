import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/arsenal_ball.dart';
import '../views/my_arsenal_page.dart';
import 'arsenal_card.dart';

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
    final cardWidth = 130.0 + 16.0; // 卡片寬度 + 間距
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
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Arsenal', style: theme.textTheme.headlineMedium),
            TextButton(
              onPressed: widget.onSeeAllPressed ?? () => print('See All Arsenal'),
              style: TextButton.styleFrom(
                foregroundColor: accentColor,
              ),
              child: const Row(
                children: [
                  Text('See All'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (arsenalBalls.isEmpty)
          const Center(
            child: Text('Your arsenal is empty.'),
          )
        else ...[
          SizedBox(
            height: 180,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: arsenalBalls.length,
              itemBuilder: (context, index) {
                final ball = arsenalBalls[index];
                return ArsenalCard(
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
          
          const SizedBox(height: 12),
          if (arsenalBalls.length > 1)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  arsenalBalls.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: _currentIndex == index 
                        ? accentColor 
                        : Colors.white.withOpacity(0.3),
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