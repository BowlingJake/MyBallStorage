import 'package:bowlingarsenal_app/views/my_arsenal_page.dart';
import 'package:bowlingarsenal_app/widgets/app_specific/arsenal/arsenal_card.dart';
import 'package:bowlingarsenal_app/widgets/common/cards/section_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArsenalSection extends ConsumerStatefulWidget {
  const ArsenalSection({super.key, this.onSeeAllPressed, this.onItemPressed});
  final VoidCallback? onSeeAllPressed;
  final void Function(int index)? onItemPressed;

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
    const cardWidth = 130.0 + 16.0; // 卡片寬度 + 間距
    final currentIndex = (_scrollController.offset / cardWidth).round();
    if (currentIndex != _currentIndex) {
      setState(() {
        _currentIndex = currentIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arsenalBalls = ref.watch(userBallsProvider);
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return SectionContainer(
      title: 'My Arsenal',
      onSeeAllPressed: widget.onSeeAllPressed ?? () => print('See All Arsenal'),
      child: Column(
        children: [
          if (arsenalBalls.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Your arsenal is empty.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
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
                        color:
                            _currentIndex == index
                                ? accentColor
                                : Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
