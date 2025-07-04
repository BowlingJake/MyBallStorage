import 'package:bowlingarsenal_app/logic/scoring_logic.dart';
import 'package:flutter/material.dart';

class FrameEditorDialog extends StatefulWidget {

  const FrameEditorDialog({
    required this.frameNumber, super.key,
    this.frame,
    this.onScoreSubmitted,
  });
  final Frame? frame;
  final int frameNumber;
  final Function(int?, int?, int?)? onScoreSubmitted;

  @override
  _FrameEditorDialogState createState() => _FrameEditorDialogState();
}

class _FrameEditorDialogState extends State<FrameEditorDialog> {
  late TextEditingController _firstRollController;
  late TextEditingController _secondRollController;
  late TextEditingController _thirdRollController;
  bool _showThirdRoll = false;

  @override
  void initState() {
    super.initState();
    _firstRollController = TextEditingController(text: widget.frame?.firstRoll?.toString() ?? '');
    _secondRollController = TextEditingController(text: widget.frame?.secondRoll?.toString() ?? '');
    _thirdRollController = TextEditingController(text: widget.frame?.thirdRoll?.toString() ?? '');
    _showThirdRoll = widget.frameNumber == 10;
  }

  @override
  void dispose() {
    _firstRollController.dispose();
    _secondRollController.dispose();
    _thirdRollController.dispose();
    super.dispose();
  }

  void _submitScores() {
    final firstRoll = int.tryParse(_firstRollController.text);
    final secondRoll = int.tryParse(_secondRollController.text);
    final thirdRoll = _showThirdRoll ? int.tryParse(_thirdRollController.text) : null;

    if (widget.onScoreSubmitted != null) {
      widget.onScoreSubmitted!(firstRoll, secondRoll, thirdRoll);
      Navigator.of(context).pop();
      return;
    }

    if (firstRoll == null) {
      Navigator.of(context).pop();
      return;
    }

    final frame = Frame(
      frameNumber: widget.frameNumber,
    );
    frame.setRolls(firstRoll, secondRoll, thirdRoll);

    Navigator.of(context).pop(frame);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text('Edit Frame ${widget.frameNumber}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _firstRollController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'First Roll',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _secondRollController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Second Roll',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (_showThirdRoll) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _thirdRollController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Third Roll',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitScores,
          child: const Text('Save'),
        ),
      ],
    );
  }
} 