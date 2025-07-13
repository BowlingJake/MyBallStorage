import 'package:bowlingarsenal_app/features/arsenal/models/arsenal_ball.dart';
import 'package:bowlingarsenal_app/features/arsenal/providers/arsenal_providers.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget for selecting one or more bowling balls from the user's arsenal.
class BallSelectionWidget extends ConsumerStatefulWidget {
  const BallSelectionWidget({
    super.key,
    this.initialBalls,
    required this.onBallsSelected,
    this.accentColor,
  });

  final List<BallInfo>? initialBalls;
  final Function(List<BallInfo>) onBallsSelected;
  final Color? accentColor;

  @override
  ConsumerState<BallSelectionWidget> createState() => _BallSelectionWidgetState();
}

class _BallSelectionWidgetState extends ConsumerState<BallSelectionWidget> {
  late List<ArsenalBall?> _selectedBalls;

  @override
  void initState() {
    super.initState();
    // This mapping is tricky. For now, we assume initialBalls are not passed
    // or we can find them in the arsenal. A better approach would be to pass ArsenalBall objects directly.
    if (widget.initialBalls != null && widget.initialBalls!.isNotEmpty) {
      // This part needs the full arsenal to map names back to ArsenalBall objects.
      // We will handle this inside the build method where arsenal is available.
      _selectedBalls = List.filled(widget.initialBalls!.length, null);
    } else {
      _selectedBalls = [null]; // Start with one empty selection
    }
  }

  void _addBallSelector() {
    setState(() {
      _selectedBalls.add(null);
    });
    _notifyParent();
  }

  void _removeBallSelector(int index) {
    if (_selectedBalls.length > 1) {
      setState(() {
        _selectedBalls.removeAt(index);
      });
      _notifyParent();
    }
  }

  void _onBallChanged(int index, ArsenalBall? ball) {
    setState(() {
      _selectedBalls[index] = ball;
    });
    _notifyParent();
  }

  void _notifyParent() {
    final balls = _selectedBalls
        .where((b) => b != null)
        .map((b) => _createBallInfo(b!))
        .toList();
    widget.onBallsSelected(balls);
  }

  BallInfo _createBallInfo(ArsenalBall arsenalBall) {
    // TODO: Map brand to a real color if available
    return BallInfo(
      id: arsenalBall.name, // Using name as a unique ID for now
      name: arsenalBall.name,
      brand: arsenalBall.brand,
      brandColor: '#FFFFFF',
    );
  }

  @override
  Widget build(BuildContext context) {
    final arsenalAsyncValue = ref.watch(userBallsProvider);
    final theme = Theme.of(context);
    final effectiveAccentColor = widget.accentColor ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Balls Used',
            style: TextStyle(
              color: effectiveAccentColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          arsenalAsyncValue.when(
            data: (arsenal) {
              // One-time mapping of initialBalls from BallInfo to ArsenalBall
              if (widget.initialBalls != null && _selectedBalls.contains(null)) {
                final initialArsenalBalls = widget.initialBalls!.map((ballInfo) {
                  return arsenal.firstWhere(
                    (arsenalBall) => arsenalBall.name == ballInfo.name, // This is still a weak link
                    orElse: () => arsenal.first, // Fallback, not ideal
                  );
                }).toList();
                // This might cause a setState during build, which is not ideal, let's defer it
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _selectedBalls = initialArsenalBalls;
                    });
                  }
                });
              }

              if (arsenal.isEmpty) {
                return const Text(
                  'No balls in your arsenal. Add some from the Ball Library!',
                  style: TextStyle(color: Colors.white70),
                );
              }
              return Column(
                children: List.generate(_selectedBalls.length, (index) {
                  return _buildBallSelector(index, arsenal, effectiveAccentColor);
                }),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text(
              'Error loading arsenal: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBallSelector(int index, List<ArsenalBall> arsenal, Color accentColor) {
    final selectedValue = _selectedBalls[index];

    // A ball is available for the current dropdown if:
    // 1. It hasn't been selected in any dropdown.
    // 2. Or, if it has been selected, it's the one selected for THIS dropdown.
    final availableBalls = arsenal.where((ball) {
      final isSelected = _selectedBalls.contains(ball);
      if (!isSelected) {
        return true; // Not selected anywhere, so it's available.
      }
      // It is selected, so it's only available if it's the item for the current dropdown.
      return selectedValue == ball;
    }).toList();


    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<ArsenalBall>(
                isExpanded: true,
                hint: Text(
                  'Select a ball',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: availableBalls
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  _onBallChanged(index, value);
                },
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.grey[850],
                  ),
                  offset: const Offset(0, -5), // Adjust dropdown position
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all(6),
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
              ),
            ),
          ),
          if (_selectedBalls.length > 1)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.redAccent,
              onPressed: () => _removeBallSelector(index),
              tooltip: 'Remove Ball',
            ),
          if (index == _selectedBalls.length - 1)
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: accentColor,
              onPressed: _addBallSelector,
              tooltip: 'Add Ball',
            ),
        ],
      ),
    );
  }
} 