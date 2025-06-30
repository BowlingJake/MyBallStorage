import 'package:flutter/material.dart';
import '../../logic/scoring_logic.dart';
import 'frame_widget.dart';
import 'frame_editor_dialog.dart'; 

class BowlingScorerWidget extends StatefulWidget {
  final Function(int)? onFrameTap;
  final bool readOnly;

  const BowlingScorerWidget({
    Key? key,
    this.onFrameTap,
    this.readOnly = false,
  }) : super(key: key);

  @override
  BowlingScorerWidgetState createState() => BowlingScorerWidgetState();
}

class BowlingScorerWidgetState extends State<BowlingScorerWidget> {
  final BowlingScorerLogic _logic = BowlingScorerLogic();

  void updateFrameScore(int frameIndex, int? firstRoll, int? secondRoll, int? thirdRoll) {
    setState(() {
      _logic.updateFrame(frameIndex, firstRoll, secondRoll, thirdRoll);
    });
  }

  BowlingScorerLogic getScoreData() {
    return _logic;
  }

  void _editFrame(int frameIndex) async {
    if (widget.onFrameTap != null) {
      widget.onFrameTap!(frameIndex);
      return;
    }

    if (widget.readOnly) return;

    final Frame? updatedFrame = await showDialog<Frame>(
      context: context,
      builder: (context) => FrameEditorDialog(
        frame: _logic.frames[frameIndex],
        frameNumber: frameIndex + 1,
      ),
    );

    if (updatedFrame != null) {
      setState(() {
        _logic.updateFrame(
          frameIndex,
          updatedFrame.firstRoll,
          updatedFrame.secondRoll,
          updatedFrame.thirdRoll,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return FrameWidget(
                frameNumber: index + 1,
                frame: _logic.frames[index],
                onTap: () => _editFrame(index),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Score", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface)),
              Text(
                _logic.totalScore.toString(),
                style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
} 