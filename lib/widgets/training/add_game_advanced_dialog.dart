import 'dart:ui';

import 'package:bowlingarsenal_app/models/score_data.dart';
import 'package:bowlingarsenal_app/models/training_record.dart';
import 'package:bowlingarsenal_app/widgets/app_standard_button.dart';
import 'package:bowlingarsenal_app/widgets/bowling_score_table.dart';
import 'package:flutter/material.dart';

/// 高級新增遊戲對話框
class AddGameAdvancedDialog extends StatefulWidget {

  const AddGameAdvancedDialog({
    required this.dayId, required this.nextGameNumber, super.key,
  });
  final String dayId;
  final int nextGameNumber;

  @override
  State<AddGameAdvancedDialog> createState() => _AddGameAdvancedDialogState();
}

class _AddGameAdvancedDialogState extends State<AddGameAdvancedDialog> {
  final _formKey = GlobalKey<FormState>();
  late GameRecord _gameRecord;
  late BowlingScoreData _scoreData;
  final _notesController = TextEditingController();
  final List<int> _frameScores = [];

  @override
  void initState() {
    super.initState();
    _scoreData = BowlingScoreData.newGame();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onScoreChanged(BowlingScoreData data) {
    setState(() {
      _scoreData = data;
    });
  }

  void _saveGame() {
    var totalScore = 0;
    var strikes = 0;
    var spares = 0;

    _frameScores.clear();

    for (var i = 0; i < _scoreData.frames.length; i++) {
      final frame = _scoreData.frames[i];
      if (frame.totalScore != null) {
        totalScore = frame.totalScore!;
        _frameScores.add(frame.totalScore!);
      } else {
        _frameScores.add(0);
      }

      if (frame.rolls.isNotEmpty) {
        if (frame.rolls[0].pinsDown == 10) {
          strikes++;
        } else if (frame.rolls.length > 1 && 
                   frame.rolls[0].pinsDown + frame.rolls[1].pinsDown == 10) {
          spares++;
        }
      }
    }

    _gameRecord = GameRecord(
      id: '${widget.dayId}_game_${DateTime.now().millisecondsSinceEpoch}',
      gameNumber: widget.nextGameNumber,
      score: totalScore,
      frameScores: _frameScores,
      strikes: strikes,
      spares: spares,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      timestamp: DateTime.now(),
    );

    Navigator.of(context).pop(_gameRecord);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGameComplete = _scoreData.isGameOver;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.98,
            height: MediaQuery.of(context).size.height * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Game ${widget.nextGameNumber}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isGameComplete ? 'Game Complete' : 'In Progress...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isGameComplete ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Click frames to enter scores:',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: BowlingScoreTable(
                    scoreData: _scoreData,
                    onScoreChanged: _onScoreChanged,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_scoreData.frames.any((f) => f.rolls.isNotEmpty))
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickStat('Current Score', '${_scoreData.frames.lastWhere((f) => f.totalScore != null, orElse: () => Frame.empty(1)).totalScore ?? 0}', theme),
                    _buildQuickStat('Strikes', '${_scoreData.frames.where((f) => f.rolls.isNotEmpty && f.rolls[0].pinsDown == 10).length}', theme),
                    _buildQuickStat('Frames', '${_scoreData.frames.where((f) => f.isComplete).length}/10', theme),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Notes:',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Record performance, thoughts...',
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                                  Expanded(
                    child: AppStandardButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      customColor: Colors.white,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStandardButton(
                      text: isGameComplete ? 'Save Game' : 'Please Complete Game',
                      onPressed: isGameComplete ? _saveGame : () {},
                      customColor: isGameComplete 
                        ? theme.colorScheme.primary 
                        : Colors.grey,
                      isPrimary: isGameComplete,
                      enabled: isGameComplete,
                      height: 50,
                    ),
                  ),
              ],
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

Future<GameRecord?> showAddGameAdvancedDialog(
  BuildContext context,
  String dayId,
  int nextGameNumber,
) async {
  return showDialog<GameRecord>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: AddGameAdvancedDialog(
          dayId: dayId,
          nextGameNumber: nextGameNumber,
        ),
      );
    },
  );
} 