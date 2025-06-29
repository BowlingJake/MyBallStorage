import 'package:flutter/material.dart';
import '../../models/training_record.dart';
import '../../models/score_data.dart';
import '../bowling_score_table.dart';
import '../app_standard_button.dart';

/// 高級新增遊戲對話框
class AddGameAdvancedDialog extends StatefulWidget {
  final String dayId;
  final int nextGameNumber;

  const AddGameAdvancedDialog({
    Key? key,
    required this.dayId,
    required this.nextGameNumber,
  }) : super(key: key);

  @override
  State<AddGameAdvancedDialog> createState() => _AddGameAdvancedDialogState();
}

class _AddGameAdvancedDialogState extends State<AddGameAdvancedDialog> {
  late BowlingScoreData _scoreData;
  final _notesController = TextEditingController();

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
    int totalScore = 0;
    int strikes = 0;
    int spares = 0;
    List<int> frameScores = [];

    for (int i = 0; i < _scoreData.frames.length; i++) {
      final frame = _scoreData.frames[i];
      if (frame.totalScore != null) {
        totalScore = frame.totalScore!;
        frameScores.add(frame.totalScore!);
      } else {
        frameScores.add(0);
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

    final game = GameRecord(
      id: '${widget.dayId}_game_${DateTime.now().millisecondsSinceEpoch}',
      gameNumber: widget.nextGameNumber,
      score: totalScore,
      frameScores: frameScores,
      strikes: strikes,
      spares: spares,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      timestamp: DateTime.now(),
    );

    Navigator.of(context).pop(game);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGameComplete = _scoreData.isGameOver;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.98,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.all(20),
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
                      '新增第 ${widget.nextGameNumber} 局',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      isGameComplete ? '遊戲完成' : '進行中...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isGameComplete ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              '點擊格子輸入分數：',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
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
            SizedBox(height: 20),
            if (_scoreData.frames.any((f) => f.rolls.isNotEmpty))
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickStat('當前分數', '${_scoreData.frames.lastWhere((f) => f.totalScore != null, orElse: () => Frame.empty(1)).totalScore ?? 0}', theme),
                    _buildQuickStat('Strikes', '${_scoreData.frames.where((f) => f.rolls.isNotEmpty && f.rolls[0].pinsDown == 10).length}', theme),
                    _buildQuickStat('格數', '${_scoreData.frames.where((f) => f.isComplete).length}/10', theme),
                  ],
                ),
              ),
            SizedBox(height: 20),
            Text(
              '備註：',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '記錄本局的表現、心得...',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: AppStandardButton(
                    text: '取消',
                    onPressed: () => Navigator.pop(context),
                    customColor: Colors.white,
                    height: 50,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: AppStandardButton(
                    text: isGameComplete ? '保存遊戲' : '請完成遊戲',
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
        SizedBox(height: 4),
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
  return await showDialog<GameRecord>(
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