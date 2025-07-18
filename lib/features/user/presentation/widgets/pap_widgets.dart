import 'package:flutter/material.dart';

// --- Enums for Dropdowns ---

enum DominateHand {
  leftHand,
  rightHand;

  String get displayName {
    switch (this) {
      case DominateHand.leftHand:
        return 'Left-Hand';
      case DominateHand.rightHand:
        return 'Right-Hand';
    }
  }
}

enum BowlingStyle {
  twoHanded,
  oneHanded,
  spinner,
  others;

  String get displayName {
    switch (this) {
      case BowlingStyle.twoHanded:
        return 'Two-Handed';
      case BowlingStyle.oneHanded:
        return 'One-Handed';
      case BowlingStyle.spinner:
        return 'Spinner';
      case BowlingStyle.others:
        return 'Others';
    }
  }
}

enum PapDirection {
  up,
  down;

  String get displayName {
    switch (this) {
      case PapDirection.up:
        return '上';
      case PapDirection.down:
        return '下';
    }
  }
}

// --- Widgets ---

/// A generic dropdown for Hand and Style.
class HandAndStyleDropdowns<T> extends StatelessWidget {
  final String label;
  final T? selectedValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const HandAndStyleDropdowns({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: selectedValue,
          items: items,
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

/// A widget for PAP input, handling conditional display logic.
class PapInputWidget extends StatelessWidget {
  final PapDirection? selectedDirection;
  final int? selectedInteger;
  final String? selectedFraction;
  final ValueChanged<PapDirection?> onDirectionChanged;
  final ValueChanged<int?> onIntegerChanged;
  final ValueChanged<String?> onFractionChanged;

  const PapInputWidget({
    super.key,
    required this.selectedDirection,
    required this.selectedInteger,
    required this.selectedFraction,
    required this.onDirectionChanged,
    required this.onIntegerChanged,
    required this.onFractionChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Lists for dropdown options
    final integerOptions = List.generate(7, (i) => i); // 0 to 6
    final fractionOptions = [
      '1/16', '1/8', '3/16', '1/4', '5/16', '3/8', '7/16',
      '1/2', '9/16', '5/8', '11/16', '3/4', '13/16', '7/8', '15/16'
    ];

    // Build dropdown items from PapDirection enum
    final directionItems = PapDirection.values
        .map((e) => DropdownMenuItem(value: e, child: Text(e.displayName)))
        .toList();
    // Add a null option for 'blank'
    directionItems.insert(0, const DropdownMenuItem(value: null, child: Text('')));

    return Column(
      children: [
        // PAP Direction Dropdown
        DropdownButtonFormField<PapDirection>(
          value: selectedDirection,
          onChanged: onDirectionChanged,
          items: directionItems,
          decoration: const InputDecoration(
            hintText: 'Select Direction',
            border: OutlineInputBorder(),
          ),
        ),
        
        // Conditionally display Integer and Fraction dropdowns
        if (selectedDirection != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                // Integer part dropdown
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedInteger,
                    onChanged: onIntegerChanged,
                    items: integerOptions.map((val) {
                      return DropdownMenuItem(value: val, child: Text('$val'));
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Integer',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Fraction part dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedFraction,
                    onChanged: onFractionChanged,
                    items: fractionOptions.map((val) {
                      return DropdownMenuItem(value: val, child: Text(val));
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Fraction',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}