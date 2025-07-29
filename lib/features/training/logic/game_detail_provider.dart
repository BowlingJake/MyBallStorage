import 'package:bowlingarsenal_app/features/training/logic/training_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/score_data.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_detail_provider.g.dart';

@riverpod
class GameDetailNotifier extends _$GameDetailNotifier {
  @override
  GameRecord build(GameRecord initialGame) {
    return initialGame;
  }

  Future<void> updateNotes(String notes) async {
    final repository = ref.read(trainingRepositoryProvider);
    
    try {
      await repository.updateGameNotes(state.id, notes.isEmpty ? null : notes);
      
      state = GameRecord(
        id: state.id,
        gameNumber: state.gameNumber,
        score: state.score,
        frameScores: state.frameScores,
        strikes: state.strikes,
        spares: state.spares,
        notes: notes.isEmpty ? null : notes,
        timestamp: state.timestamp,
      );
    } catch (e) {
      throw Exception('Failed to update notes: $e');
    }
  }

  Future<void> deleteGame() async {
    final repository = ref.read(trainingRepositoryProvider);
    
    try {
      await repository.deleteGame(state.id);
    } catch (e) {
      throw Exception('Failed to delete game: $e');
    }
  }

  BowlingScoreData convertToScoreData() {
    final scoreData = BowlingScoreData.newGame();

    if (state.frameScores.isNotEmpty) {
      for (var i = 0; i < state.frameScores.length && i < 10; i++) {
        final frameScore = state.frameScores[i];
        final frame = scoreData.frames[i];

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
          final firstBall = frameScore ~/ 2;
          final secondBall = frameScore - firstBall;

          frame.rolls.add(
            Roll(
              pinsDown: firstBall,
              pinsStandingAfterThrow: {
                1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
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
                  1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
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
        frame.totalScore = state.frameScores
            .take(i + 1)
            .reduce((a, b) => a + b);
      }
    }

    scoreData.isGameOver = true;
    scoreData.currentFrameIndex = -1;
    scoreData.calculateScores();

    return scoreData;
  }
}