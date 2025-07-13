import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';

class PinSelectionDialog extends StatelessWidget {
  final PinSelectionController controller;
  final List<bool>? initialPinState; // Add initial state parameter
  final bool isFirstRoll; // Add this parameter

  const PinSelectionDialog({
    super.key,
    required this.controller,
    this.initialPinState,
    this.isFirstRoll = true, // Default to true
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900]?.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Pins',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                PinSelectionWidget(
                  controller: controller,
                  initialPinState: initialPinState, // Pass it down
                ),
                const SizedBox(height: 24),
                // 2x2 Button Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppStandardButton(
                      text: 'Left 10',
                      onPressed: () => controller.leave(10),
                      width: 120,
                      enabled: isFirstRoll, // Control enabled state
                    ),
                    AppStandardButton(
                      text: 'Left 7',
                      onPressed: () => controller.leave(7),
                      width: 120,
                      enabled: isFirstRoll, // Control enabled state
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppStandardButton(
                      text: 'Strike',
                      onPressed: () => controller.strike(),
                      width: 120,
                      enabled: isFirstRoll, // Control enabled state
                    ),
                    AppStandardButton(
                      text: 'Spare',
                      onPressed: () => controller.spare(),
                      width: 120,
                      enabled: !isFirstRoll, // Control enabled state
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppStandardButton(
                        text: 'Reset',
                        onPressed: () => controller.clear(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        text: 'Save',
                        isPrimary: true,
                        onPressed: () {
                          // Return the state when popping
                          Navigator.of(context).pop(controller.pinState);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Close Button
          Positioned(
            top: -10,
            right: -10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 