import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../../models/training_record.dart';
import '../app_standard_button.dart';
import '../../models/score_data.dart';
import '../bowling_score_table.dart';
import '../common/glass_dialog_base.dart';

/// 專業級遊戲詳情對話框
/// 顯示單局遊戲的詳細分數表、統計資訊和備註
class GameDetailDialog extends StatefulWidget {
  final GameRecord game;
  final Function(GameRecord)? onGameUpdated;
  final Function(GameRecord)? onGameDeleted;

  const GameDetailDialog({
    Key? key,
    required this.game,
    this.onGameUpdated,
    this.onGameDeleted,
  }) : super(key: key);

  @override
  State<GameDetailDialog> createState() => _GameDetailDialogState();
}

class _GameDetailDialogState extends State<GameDetailDialog> {
  late TextEditingController _notesController;
  bool _isEditingNotes = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.game.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// 將 GameRecord 轉換為 BowlingScoreData 用於顯示
  BowlingScoreData _convertToScoreData() {
    final scoreData = BowlingScoreData.newGame();
    
    // 如果有 frameScores，嘗試重建分數表
    if (widget.game.frameScores.isNotEmpty) {
      for (int i = 0; i < widget.game.frameScores.length && i < 10; i++) {
        final frameScore = widget.game.frameScores[i];
        final frame = scoreData.frames[i];
        
        // 簡化的分數重建邏輯
        if (frameScore == 10 && i < 9) {
          // Strike
          frame.rolls.add(Roll(
            pinsDown: 10,
            pinsStandingAfterThrow: {},
            displayScore: "X",
            pinsStandingBeforeThrow: {1,2,3,4,5,6,7,8,9,10},
          ));
        } else if (frameScore > 0 && frameScore < 10) {
          // 簡化：假設是兩球的組合
          final firstBall = frameScore ~/ 2;
          final secondBall = frameScore - firstBall;
          
          frame.rolls.add(Roll(
            pinsDown: firstBall,
            pinsStandingAfterThrow: {1,2,3,4,5,6,7,8,9,10}.difference(
              List.generate(firstBall, (i) => i + 1).toSet()
            ),
            displayScore: firstBall.toString(),
            pinsStandingBeforeThrow: {1,2,3,4,5,6,7,8,9,10},
          ));
          
          if (firstBall + secondBall == 10) {
            frame.rolls.add(Roll(
              pinsDown: secondBall,
              pinsStandingAfterThrow: {},
              displayScore: "/",
              pinsStandingBeforeThrow: frame.rolls[0].pinsStandingAfterThrow!,
            ));
          } else {
            frame.rolls.add(Roll(
              pinsDown: secondBall,
              pinsStandingAfterThrow: {1,2,3,4,5,6,7,8,9,10}.difference(
                List.generate(firstBall + secondBall, (i) => i + 1).toSet()
              ),
              displayScore: secondBall.toString(),
              pinsStandingBeforeThrow: frame.rolls[0].pinsStandingAfterThrow!,
            ));
          }
        }
        
        frame.isComplete = true;
        frame.totalScore = widget.game.frameScores.take(i + 1).reduce((a, b) => a + b);
      }
    }
    
    scoreData.isGameOver = true;
    scoreData.currentFrameIndex = -1;
    scoreData.calculateScores();
    
    return scoreData;
  }

  void _saveNotes() {
    final updatedGame = GameRecord(
      id: widget.game.id,
      gameNumber: widget.game.gameNumber,
      score: widget.game.score,
      frameScores: widget.game.frameScores,
      strikes: widget.game.strikes,
      spares: widget.game.spares,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      timestamp: widget.game.timestamp,
    );

    widget.onGameUpdated?.call(updatedGame);
    setState(() {
      _isEditingNotes = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('備註已更新'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteGame() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Game'),
        content: Text('Are you sure you want to delete Game ${widget.game.gameNumber}? This action cannot be undone.'),
        actions: [
          AppStandardButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          AppStandardButton(
            text: 'Delete',
            onPressed: () {
              Navigator.pop(context); // Close confirmation dialog
              Navigator.pop(context); // Close details dialog
              widget.onGameDeleted?.call(widget.game);
            },
            customColor: Colors.red,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Game ${widget.game.gameNumber} Details',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            
            SizedBox(height: 20),

            // 分數總覽
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total Score', widget.game.score.toString(), theme),
                  _buildStatItem('Strikes', widget.game.strikes.toString(), theme),
                  _buildStatItem('Spares', widget.game.spares.toString(), theme),
                  _buildStatItem('Time', DateFormat('HH:mm').format(widget.game.timestamp), theme),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 詳細分數表
            Text(
              'Score Details',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < widget.game.frameScores.length; i++)
                      Container(
                        width: 60,
                        height: 80,
                        margin: EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 20,
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  widget.game.frameScores[i].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // 備註區域
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notes',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditingNotes = !_isEditingNotes;
                    });
                  },
                  icon: Icon(
                    _isEditingNotes ? Icons.close : Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8),

            if (_isEditingNotes)
              Column(
                children: [
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Add notes...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.colorScheme.primary),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppStandardButton(
                          text: 'Save Notes',
                          onPressed: _saveNotes,
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.game.notes?.isNotEmpty == true 
                    ? widget.game.notes!
                    : 'No notes yet',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: widget.game.notes?.isNotEmpty == true 
                      ? Colors.white
                      : Colors.white54,
                  ),
                ),
              ),

            SizedBox(height: 24),

            // 底部按鈕
            Row(
              children: [
                                  Expanded(
                    child: AppStandardButton(
                      text: 'Delete',
                      onPressed: _deleteGame,
                      customColor: Colors.red,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: AppStandardButton(
                      text: 'Close',
                      onPressed: () => Navigator.pop(context),
                      isPrimary: true,
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

  Widget _buildStatItem(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
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

/// 顯示遊戲詳情對話框的輔助函數
void showGameDetailDialog(
  BuildContext context,
  GameRecord game, {
  Function(GameRecord)? onGameUpdated,
  Function(GameRecord)? onGameDeleted,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: GameDetailDialog(
          game: game,
          onGameUpdated: onGameUpdated,
          onGameDeleted: onGameDeleted,
        ),
      );
    },
  );
} 