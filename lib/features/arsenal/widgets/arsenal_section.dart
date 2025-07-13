import 'package:bowlingarsenal_app/features/arsenal/providers/arsenal_providers.dart';
import 'package:bowlingarsenal_app/features/arsenal/widgets/arsenal_card.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/cards/section_container.dart';
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
  // ScrollController is now the only state managed by this widget.
  late final ScrollController _scrollController;

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

  @override
  Widget build(BuildContext context) {
    final arsenalBallsAsync = ref.watch(userBallsProvider);

    return SectionContainer(
      title: 'My Arsenal',
      onSeeAllPressed: widget.onSeeAllPressed ?? () {},
      child: arsenalBallsAsync.when(
        data: (arsenalBalls) {
          if (arsenalBalls.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Your arsenal is empty.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          }
          return Column(
            children: [
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
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              if (arsenalBalls.length > 1)
                // Use the new, isolated _PageIndicator widget
                _PageIndicator(
                  itemCount: arsenalBalls.length,
                  scrollController: _scrollController,
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading arsenal: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

/// A new StatefulWidget that isolates the page indicator's state.
/// This widget listens to the ScrollController and only rebuilds itself,
/// not the entire ArsenalSection.
class _PageIndicator extends StatefulWidget {
  const _PageIndicator({
    required this.itemCount,
    required this.scrollController,
  });

  final int itemCount;
  final ScrollController scrollController;

  @override
  State<_PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<_PageIndicator> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    const cardWidth = 130.0 + 16.0; // Card width + margin
    final newIndex = (widget.scrollController.offset / cardWidth).round();
    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.itemCount,
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
    );
  }
}
