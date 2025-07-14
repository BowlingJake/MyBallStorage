import 'dart:ui';

import 'package:bowlingarsenal_app/features/training/models/score_data.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 專業級遊戲詳情對話框
/// 顯示單局遊戲的詳細分數表、統計資訊和備註
class GameDetailDialog extends StatefulWidget {
  const GameDetailDialog({
    required this.game,
    super.key,
    this.onGameUpdated,
    this.onGameDeleted,
  });
  final GameRecord game;
  final Function(GameRecord)? onGameUpdated;
  final Function(GameRecord)? onGameDeleted;

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
      for (var i = 0; i < widget.game.frameScores.length && i < 10; i++) {
        final frameScore = widget.game.frameScores[i];
        final frame = scoreData.frames[i];

        // 簡化的分數重建邏輯
        if (frameScore == 10 && i < 9) {
          // Strike
          frame.rolls.add(
            Roll(
              pinsDown: 10,
              pinsStandingAfterThrow: {},
              displayScore: 'X',
              pinsStandingBeforeThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
            ),
          );
        } else if (frameScore > 0 && frameScore < 10) {
          // 簡化：假設是兩球的組合
          final firstBall = frameScore ~/ 2;
          final secondBall = frameScore - firstBall;

          frame.rolls.add(
            Roll(
              pinsDown: firstBall,
              pinsStandingAfterThrow: {
                1,
                2,
                3,
                4,
                5,
                6,
                7,
                8,
                9,
                10,
              }.difference(List.generate(firstBall, (i) => i + 1).toSet()),
              displayScore: firstBall.toString(),
              pinsStandingBeforeThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
            ),
          );

          if (firstBall + secondBall == 10) {
            frame.rolls.add(
              Roll(
                pinsDown: secondBall,
                pinsStandingAfterThrow: {},
                displayScore: '/',
                pinsStandingBeforeThrow: frame.rolls[0].pinsStandingAfterThrow!,
              ),
            );
          } else {
            frame.rolls.add(
              Roll(
                pinsDown: secondBall,
                pinsStandingAfterThrow: {
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  7,
                  8,
                  9,
                  10,
                }.difference(
                  List.generate(firstBall + secondBall, (i) => i + 1).toSet(),
                ),
                displayScore: secondBall.toString(),
                pinsStandingBeforeThrow: frame.rolls[0].pinsStandingAfterThrow!,
              ),
            );
          }
        }

        frame.isComplete = true;
        frame.totalScore = widget.game.frameScores
            .take(i + 1)
            .reduce((a, b) => a + b);
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
      const SnackBar(content: Text('備註已更新'), backgroundColor: Colors.green),
    );
  }

  void _deleteGame() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Game'),
            content: Text(
              'Are you sure you want to delete Game ${widget.game.gameNumber}? This action cannot be undone.',
            ),
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
    final size = MediaQuery.of(context).size;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: size.width * 0.92,
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: size.height * 0.8,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x33000000), // 20% 不透明度的純黑色
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(theme),
                    Expanded(child: _buildContent(theme)),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          // 遊戲圖標
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Icon(
              Icons.sports_bowling,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // 標題
          Expanded(
            child: Text(
              'Game ${widget.game.gameNumber} Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 關閉按鈕
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surface.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

                // 分數總覽
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Total Score',
                        widget.game.score.toString(),
                        theme,
                      ),
                      _buildStatItem(
                        'Strikes',
                        widget.game.strikes.toString(),
                        theme,
                      ),
                      _buildStatItem(
                        'Spares',
                        widget.game.spares.toString(),
                        theme,
                      ),
                      _buildStatItem(
                        'Time',
                        DateFormat('HH:mm').format(widget.game.timestamp),
                        theme,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 詳細分數表
                Text(
                  'Score Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(12),
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
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
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
                                      style: const TextStyle(
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

                const SizedBox(height: 20),

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

                const SizedBox(height: 8),

                if (_isEditingNotes)
                  Column(
                    children: [
                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Add notes...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.game.notes?.isNotEmpty == true
                          ? widget.game.notes!
                          : 'No notes yet',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            widget.game.notes?.isNotEmpty == true
                                ? Colors.white
                                : Colors.white54,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

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
                    const SizedBox(width: 12),
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
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: _isEditingNotes 
        ? Row(
            children: [
              Expanded(
                child: AppStandardButton(
                  text: 'Cancel',
                  icon: Icons.cancel,
                  onPressed: () {
                    setState(() {
                      _isEditingNotes = false;
                      _notesController.text = widget.game.notes ?? '';
                    });
                  },
                  height: 40,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppStandardButton(
                  text: 'Save Notes',
                  icon: Icons.save,
                  onPressed: _saveNotes,
                  isPrimary: false,
                  height: 40,
                ),
              ),
            ],
          )
        : AppStandardButton(
            text: 'Close',
            icon: Icons.close,
            onPressed: () => Navigator.of(context).pop(),
            width: double.infinity,
            height: 40,
          ),
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
