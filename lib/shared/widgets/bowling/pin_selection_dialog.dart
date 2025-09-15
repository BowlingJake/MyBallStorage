import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';

class PinSelectionDialog extends StatefulWidget {
  final PinSelectionController controller;
  final List<bool>? initialPinState; // Add initial state parameter
  final bool isFirstRoll; // Add this parameter
  final int frameNumber; // Add frame number parameter

  const PinSelectionDialog({
    super.key,
    required this.controller,
    required this.frameNumber, // Required frame number
    this.initialPinState,
    this.isFirstRoll = true, // Default to true
  });

  @override
  State<PinSelectionDialog> createState() => _PinSelectionDialogState();
}

class _PinSelectionDialogState extends State<PinSelectionDialog> {
  late final List<bool>? _originalInitialState;

  @override
  void initState() {
    super.initState();
    // 儲存原始的初始狀態
    _originalInitialState = widget.initialPinState?.toList();
  }

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
                Text(
                  'Frame ${widget.frameNumber}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 24),
                PinSelectionWidget(
                  controller: widget.controller,
                  initialPinState: widget.initialPinState, // Pass it down
                ),
                const SizedBox(height: 24),
                // 2x2 Button Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppStandardButton.primaryOutlined(
                      text: 'Left 10',
                      onPressed: () => widget.controller.leave(10),
                      width: 120,
                      enabled: widget.isFirstRoll, // Control enabled state
                    ),
                    AppStandardButton.primaryOutlined(
                      text: 'Left 7',
                      onPressed: () => widget.controller.leave(7),
                      width: 120,
                      enabled: widget.isFirstRoll, // Control enabled state
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppStandardButton(
                      text: 'Strike',
                      onPressed: () => widget.controller.strike(),
                      width: 120,
                      enabled: widget.isFirstRoll, // Control enabled state
                    ),
                    AppStandardButton(
                      text: 'Spare',
                      onPressed: () => widget.controller.spare(),
                      width: 120,
                      enabled: !widget.isFirstRoll, // Control enabled state
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                                  Row(
                    children: [
                      Expanded(
                        child: AppStandardButton.destructiveOutlined(
                          text: 'Reset',
                          onPressed: () => widget.controller.clear(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStandardButton(
                          text: 'Save',
                          isPrimary: true,
                          onPressed: () {
                            // 對於第二球，只返回本球新擊倒的瓶
                            List<bool> resultPinState;
                            if (widget.isFirstRoll || _originalInitialState == null) {
                              // 第一球：返回完整狀態（回傳副本避免後續被覆寫）
                              resultPinState = widget.controller.pinState.toList();
                            } else {
                              // 第二球：只返回本球新擊倒的瓶
                              final currentState = widget.controller.pinState;
                              final originalInitialState = _originalInitialState!;
                              resultPinState = List.generate(10, (i) {
                                // 如果這個瓶現在倒了，但初始狀態時沒倒，表示是本球擊倒的
                                return currentState[i] && !originalInitialState[i];
                              });
                            }
                            Navigator.of(context).pop(resultPinState);
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
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 