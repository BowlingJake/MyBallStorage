import 'dart:ui';

import 'package:bowlingarsenal_app/features/training/logic/game_detail_provider.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/game_action_buttons.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/game_dialog_header.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/game_stats_overview.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/notes_edit_section.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/score_details_display.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 專業級遊戲詳情對話框
/// 顯示單局遊戲的詳細分數表、統計資訊和備註
class GameDetailDialog extends ConsumerStatefulWidget {
  const GameDetailDialog({
    required this.game,
    super.key,
    this.onGameUpdated,
    this.onGameDeleted,
  });
  final GameRecord game;
  final void Function(GameRecord)? onGameUpdated;
  final void Function(GameRecord)? onGameDeleted;

  @override
  ConsumerState<GameDetailDialog> createState() => _GameDetailDialogState();
}

class _GameDetailDialogState extends ConsumerState<GameDetailDialog> {

  Future<void> _handleSaveNotes(String notes) async {
    final gameNotifier = ref.read(gameDetailNotifierProvider(widget.game).notifier);
    
    try {
      await gameNotifier.updateNotes(notes);
      
      final updatedGame = ref.read(gameDetailNotifierProvider(widget.game));
      widget.onGameUpdated?.call(updatedGame);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('備註已更新'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新失敗: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _deleteGame() {
    showDialog<void>(
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
                onPressed: () async {
                  Navigator.pop(context); // Close confirmation dialog
                  Navigator.pop(context); // Close details dialog
                  
                  final gameNotifier = ref.read(gameDetailNotifierProvider(widget.game).notifier);
                  
                  try {
                    await gameNotifier.deleteGame();
                    widget.onGameDeleted?.call(widget.game);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('刪除失敗: $e'), backgroundColor: Colors.red),
                      );
                    }
                  }
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
    final currentGame = ref.watch(gameDetailNotifierProvider(widget.game));

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
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GameDialogHeader(
                      game: currentGame,
                      onClose: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GameStatsOverview(game: currentGame),
                            const SizedBox(height: 20),
                            ScoreDetailsDisplay(game: currentGame),
                            const SizedBox(height: 20),
                            NotesEditSection(
                              game: currentGame,
                              onSaveNotes: _handleSaveNotes,
                            ),
                            const SizedBox(height: 24),
                            GameActionButtons(
                              onDelete: _deleteGame,
                              onClose: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }




}

/// 顯示遊戲詳情對話框的輔助函數
void showGameDetailDialog(
  BuildContext context,
  GameRecord game, {
  void Function(GameRecord)? onGameUpdated,
  void Function(GameRecord)? onGameDeleted,
}) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.7),
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