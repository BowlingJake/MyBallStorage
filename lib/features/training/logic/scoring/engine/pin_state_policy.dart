class PinStatePolicy {
  static bool isLogicalFirst(List<bool>? initialPinState) {
    if (initialPinState == null) {
      return true;
    }
    return initialPinState.every((pin) => !pin);
  }

  /// 前1-9格：下一球的初始球瓶狀態（null 代表所有球瓶站立）
  static List<bool>? initialStateForFrames1to9(List<int> rolls, List<List<bool>> rollStates) {
    if (rolls.isEmpty) {
      return null;
    }
    final pos = _advanceToNextInputForFrames1to9(rolls);
    if (pos.currentRollInFrame == 0) {
      return null;
    }
    final lastIndex = rollStates.length - 1;
    if (lastIndex >= 0) {
      return rollStates[lastIndex];
    }
    return null;
  }

  /// 第10格（Current）：無獎勵球；若第一球非 Strike，第二球沿用第一球狀態
  static List<bool>? initialStateForFrame10Current(List<int> rolls, List<List<bool>> rollStates) {
    if (rolls.isEmpty) {
      return null;
    }
    if (rolls.length == 1) {
      final firstRoll = rolls[0];
      if (firstRoll == 10) {
        return null; // 結束
      } else {
        return rollStates.isNotEmpty ? rollStates[0] : null;
      }
    }
    return null;
  }

  /// 第10格（Traditional）：依照前一球結果決定是否重置
  static List<bool>? initialStateForFrame10Traditional(List<int> rolls, List<List<bool>> rollStates) {
    if (rolls.isEmpty) {
      return null;
    }
    if (rolls.length == 1) {
      final first = rolls[0];
      if (first == 10) {
        return List.generate(10, (index) => false);
      } else {
        return rollStates.isNotEmpty ? rollStates[0] : null;
      }
    }
    if (rolls.length == 2) {
      final first = rolls[0];
      final second = rolls[1];
      if (first == 10) {
        if (second == 10) {
          return List.generate(10, (index) => false);
        } else {
          return rollStates.length > 1 ? rollStates[1] : null;
        }
      } else if (first + second == 10) {
        return List.generate(10, (index) => false);
      } else {
        return null; // 不應有第三球
      }
    }
    return null;
  }

  static ({int currentFrameIndex, int currentRollInFrame}) _advanceToNextInputForFrames1to9(List<int> rolls) {
    int currentFrameIndex = 0;
    int currentRollInFrame = 0;
    int rollIndex = 0;
    while (rollIndex < rolls.length && currentFrameIndex < 9) {
      if (currentRollInFrame == 0) {
        if (rolls[rollIndex] == 10) {
          currentFrameIndex++;
          currentRollInFrame = 0;
        } else {
          currentRollInFrame = 1;
        }
        rollIndex++;
      } else {
        currentFrameIndex++;
        currentRollInFrame = 0;
        rollIndex++;
      }
    }
    return (currentFrameIndex: currentFrameIndex, currentRollInFrame: currentRollInFrame);
  }
}


