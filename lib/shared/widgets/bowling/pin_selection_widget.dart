library pin_selection;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/icons/my_flutter_app_icons.dart';

part 'pin_selection_controller.dart';

class PinSelectionWidget extends StatefulWidget {
  final PinSelectionController? controller;
  final List<bool>? initialPinState; // Add initial state parameter

  const PinSelectionWidget({
    super.key,
    this.controller,
    this.initialPinState,
  });

  @override
  PinSelectionWidgetState createState() => PinSelectionWidgetState();
}

// State class is now public
class PinSelectionWidgetState extends State<PinSelectionWidget> {
  late List<bool> _pinsKnockedDown;
  final List<GlobalKey> _pinKeys = List.generate(10, (index) => GlobalKey());
  
  // To keep track of pins toggled during a single drag gesture
  final Set<int> _toggledPinsInDrag = {};

  @override
  void initState() {
    super.initState();
    // Initialize with initial state if provided, otherwise default to all standing
    _pinsKnockedDown = widget.initialPinState ?? List.generate(10, (index) => false);
    // Call the public attach method
    widget.controller?.attach(this);
  }

  // --- Public methods for parent widget to call ---
  void strike() {
    setState(() {
      for (int i = 0; i < _pinsKnockedDown.length; i++) {
        _pinsKnockedDown[i] = true;
      }
    });
  }

  void leave(int pinToLeave) {
    setState(() {
      for (int i = 0; i < _pinsKnockedDown.length; i++) {
        _pinsKnockedDown[i] = (i + 1 != pinToLeave);
      }
    });
  }
  
  void spare() {
    setState(() {
       for (int i = 0; i < _pinsKnockedDown.length; i++) {
        if (!_pinsKnockedDown[i]) {
          _pinsKnockedDown[i] = true;
        }
      }
    });
  }

  void clear() {
    setState(() {
      for (int i = 0; i < _pinsKnockedDown.length; i++) {
        _pinsKnockedDown[i] = false;
      }
    });
  }

  List<bool> get pinState => _pinsKnockedDown;

  void _togglePinState(int pinIndex) {
    setState(() {
      _pinsKnockedDown[pinIndex] = !_pinsKnockedDown[pinIndex];
    });
  }

  void _handleDrag(DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    for (int i = 0; i < _pinKeys.length; i++) {
      if (_toggledPinsInDrag.contains(i)) continue;

      final key = _pinKeys[i];
      if (key.currentContext != null) {
        final RenderBox pinBox = key.currentContext!.findRenderObject() as RenderBox;
        final pinRect = pinBox.localToGlobal(Offset.zero) & pinBox.size;
        
        // Convert pinRect to local coordinates to compare with drag position
        final localPinRect = Rect.fromPoints(
          renderBox.globalToLocal(pinRect.topLeft),
          renderBox.globalToLocal(pinRect.bottomRight),
        );

        if (localPinRect.contains(localPosition)) {
          _togglePinState(i);
          _toggledPinsInDrag.add(i); // Mark as toggled for this drag session
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _toggledPinsInDrag.clear(); // Clear at the start of a new drag
        _handleDrag(DragUpdateDetails(globalPosition: details.globalPosition));
      },
      onPanUpdate: _handleDrag,
      onPanEnd: (details) {
        _toggledPinsInDrag.clear(); // Clear when the drag ends
      },
      child: Column(
        // ... (rest of the layout is the same, but _buildPin will now use keys)
        mainAxisSize: MainAxisSize.min,
      children: [
        // Row 4 (4 pins)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPin(6),
            const SizedBox(width: 16),
            _buildPin(7),
            const SizedBox(width: 16),
            _buildPin(8),
            const SizedBox(width: 16),
            _buildPin(9),
          ],
        ),
        const SizedBox(height: 8),
        // Row 3 (3 pins)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPin(3),
            const SizedBox(width: 16),
            _buildPin(4),
            const SizedBox(width: 16),
            _buildPin(5),
          ],
        ),
        const SizedBox(height: 8),
        // Row 2 (2 pins)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPin(1),
            const SizedBox(width: 16),
            _buildPin(2),
          ],
        ),
        const SizedBox(height: 8),
        // Row 1 (1 pin)
        _buildPin(0),
      ],
      ),
    );
  }

  Widget _buildPin(int pinIndex) {
    final isKnockedDown = _pinsKnockedDown[pinIndex];
    // Check if the pin was down from the start (for disabling interaction)
    final wasInitiallyDown = widget.initialPinState?[pinIndex] ?? false;
    final pinColor = isKnockedDown ? Colors.grey[800] : Colors.teal;

    return GestureDetector(
      key: _pinKeys[pinIndex], // Assign key here
      // Disable onTap if the pin was already down from the initial state
      onTap: wasInitiallyDown ? null : () => _togglePinState(pinIndex), // Keep onTap for individual clicks
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Transform.rotate(
          angle: isKnockedDown ? math.pi / 2 : 0,
          child: Icon(
            MyFlutterApp.bowling_pin,
            size: 40,
            // Visually indicate disabled state
            color: wasInitiallyDown ? Colors.grey[600] : pinColor,
          ),
        ),
      ),
    );
  }
} 