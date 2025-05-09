class Roll {
  final int pinsDown;
  final Set<int>? pinsStandingAfterThrow;
  final String displayScore;
  final Set<int> pinsStandingBeforeThrow;

  Roll({
    required this.pinsDown,
    this.pinsStandingAfterThrow,
    required this.displayScore,
    required this.pinsStandingBeforeThrow,
  });
}


/// 表示單一局 (Frame) 的記錄
class Frame {
  final int frameNumber;

  final List<Roll> rolls;


  int? totalScore;

  bool isComplete;

  Frame({
    required this.frameNumber,
    required this.rolls,
    this.totalScore,
    this.isComplete = false,
  });

  /// 方便初始化一個空的 Frame
  factory Frame.empty(int frameNumber) {
    return Frame(frameNumber: frameNumber, rolls: []);
  }

}
class BowlingScoreData {
  /// 包含 10 局的列表
  final List<Frame> frames;
  int currentFrameIndex;
  int currentRollIndex;
  Set<int> pinsStanding;
  bool isGameOver;

  BowlingScoreData({
    required this.frames,
    this.currentFrameIndex = 0,
    this.currentRollIndex = 0,
    this.pinsStanding = const {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, // 遊戲開始時所有瓶都站立
    this.isGameOver = false,
  });

  /// 方便初始化一個新的遊戲數據
  factory BowlingScoreData.newGame() {
    return BowlingScoreData(
      frames: List.generate(10, (index) => Frame.empty(index + 1)),
    );
  }

  /// 計算並更新所有局的累計總分
  /// 這是核心的計分邏輯，需要根據保齡球規則實現
  void calculateScores() {
    // 重置所有局的總分以便重新計算
    for (var frame in frames) {
      frame.totalScore = null;
    }

    int cumulativeScore = 0;

    // 遍歷前 9 局
    for (int i = 0; i < 9; i++) {
      final currentFrame = frames[i];
      int frameScore = 0;
      bool frameScorable = false; // 判斷本局是否已經可以計算分數

      if (currentFrame.rolls.isNotEmpty) {
        final firstRoll = currentFrame.rolls[0];

        if (firstRoll.pinsDown == 10) { // Strike
          frameScore = 10;
          // Strike 的獎勵是後面兩次投球的擊倒瓶數
          final nextTwoRolls = _getNextRolls(i, 2);
          if (nextTwoRolls.length == 2) {
            frameScore += nextTwoRolls[0].pinsDown;
            frameScore += nextTwoRolls[1].pinsDown;
            frameScorable = true; // 獎勵球數夠了，本局分數可以確定
          }
        } else if (currentFrame.rolls.length > 1 && (firstRoll.pinsDown + currentFrame.rolls[1].pinsDown) == 10) { // Spare
          frameScore = 10;
          // Spare 的獎勵是後面一次投球的擊倒瓶數
          final nextRoll = _getNextRolls(i, 1);
          if (nextRoll.length == 1) {
            frameScore += nextRoll[0].pinsDown;
            frameScorable = true; // 獎勵球數夠了，本局分數可以確定
          }
        } else if (currentFrame.rolls.length > 1) { // Open Frame (非 Strike 也非 Spare)
          frameScore = firstRoll.pinsDown + currentFrame.rolls[1].pinsDown;
          frameScorable = true; // Open Frame 兩球投完，分數確定
        }
      }

      if (frameScorable) {
        cumulativeScore += frameScore;
        currentFrame.totalScore = cumulativeScore;
      } else {
         // 如果分數還不能確定 (例如 Strike/Spare 的獎勵球還沒投)，則本局總分暫時為 null
         // cumulativeScore 不會更新
      }
    }

    final tenthFrame = frames[9];
    int tenthFrameScore = 0;
    bool tenthFrameScorable = false;

    if (tenthFrame.rolls.isNotEmpty) {
      final int first = tenthFrame.rolls[0].pinsDown;
      final int second = tenthFrame.rolls.length > 1 ? tenthFrame.rolls[1].pinsDown : 0;
      final int third = tenthFrame.rolls.length > 2 ? tenthFrame.rolls[2].pinsDown : 0;

      if (tenthFrame.rolls.length == 1) {
        // 只打一球，分數暫不確定
      } else if (tenthFrame.rolls.length == 2) {
        if (first == 10) {
          // 第一球strike，還沒打完三球，分數暫不確定
        } else if (first + second == 10) {
          // spare，還沒打完第三球，分數暫不確定
        } else {
          // 只打兩球，直接加總
          tenthFrameScore = first + second;
          tenthFrameScorable = true;
        }
      } else if (tenthFrame.rolls.length == 3) {
        if (first == 10) {
          // 第一球strike，三球都加
          tenthFrameScore = first + second + third;
          tenthFrameScorable = true;
        } else if (first + second == 10) {
          // spare，10+第三球
          tenthFrameScore = 10 + third;
          tenthFrameScorable = true;
        }
      }
    }

    if (tenthFrameScorable) {
      cumulativeScore += tenthFrameScore;
      tenthFrame.totalScore = cumulativeScore;
    }
  }

  List<Roll> _getNextRolls(int currentFrameIndex, int count) {
    final List<Roll> nextRolls = [];
    int rollsFound = 0;

    for (int i = currentFrameIndex + 1; i < 10 && rollsFound < count; i++) {
      final frame = frames[i];
      for (final roll in frame.rolls) {
        nextRolls.add(roll);
        rollsFound++;
        if (rollsFound == count) break;
      }
    }
    return nextRolls;
  }
}