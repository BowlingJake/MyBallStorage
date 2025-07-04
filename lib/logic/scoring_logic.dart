// lib/logic/scoring_logic.dart
class Frame {

  Frame({required this.frameNumber});
  final int frameNumber;
  int? firstRoll;
  int? secondRoll;
  int? thirdRoll;
  int? score;
  bool get isTenthFrame => frameNumber == 10;

  bool get isStrike => firstRoll == 10;
  bool get isSpare => firstRoll != null && (firstRoll! + (secondRoll ?? 0)) == 10;

  void setRolls(int? r1, int? r2, [int? r3]) {
    firstRoll = r1;
    secondRoll = r2;
    if (isTenthFrame) {
      thirdRoll = r3;
    }
  }
}

class BowlingScorerLogic {
  List<Frame> frames = List.generate(10, (index) => Frame(frameNumber: index + 1));
  int totalScore = 0;

  void calculateScores() {
    totalScore = 0;
    for (var i = 0; i < 10; i++) {
      if (frames[i].firstRoll == null) {
        frames[i].score = null;
        continue;
      }

      var frameScore = 0;
      if (frames[i].isStrike && i < 9) {
        frameScore = 10 + _strikeBonus(i);
      } else if (frames[i].isSpare && i < 9) {
        frameScore = 10 + _spareBonus(i);
      } else {
        frameScore = (frames[i].firstRoll ?? 0) + (frames[i].secondRoll ?? 0) + (frames[i].thirdRoll ?? 0);
      }
      
      totalScore += frameScore;
      frames[i].score = totalScore;
    }
  }

  int _strikeBonus(int frameIndex) {
    if (frameIndex >= 9) return 0;

    // Look ahead to next frame
    final nextFrame = frames[frameIndex + 1];
    if (nextFrame.firstRoll == null) return 0;
    
    // Strike in next frame
    if (nextFrame.isStrike) {
      if (frameIndex + 1 < 9) {
        final nextNextFrame = frames[frameIndex + 2];
        return 10 + (nextNextFrame.firstRoll ?? 0);
      } else { // 10th frame
        return 10 + (nextFrame.secondRoll ?? 0);
      }
    } else {
      return (nextFrame.firstRoll ?? 0) + (nextFrame.secondRoll ?? 0);
    }
  }

  int _spareBonus(int frameIndex) {
    if (frameIndex >= 9) return 0;
    final nextFrame = frames[frameIndex + 1];
    return nextFrame.firstRoll ?? 0;
  }

  void updateFrame(int frameIndex, int? r1, int? r2, [int? r3]) {
    frames[frameIndex].setRolls(r1, r2, r3);
    calculateScores();
  }
} 