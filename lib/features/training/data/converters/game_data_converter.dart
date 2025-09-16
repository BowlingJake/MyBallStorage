import '../models/game_roll.dart';

/// 遊戲資料轉換工具類
/// 負責將 UI 狀態轉換為新的 JSON 資料結構，以及反向轉換
class GameDataConverter {
  /// 將 UI 狀態轉換為新的 frames JSON 格式
  static List<Map<String, dynamic>> convertToFramesJson({
    required List<int> rolls,
    required List<List<bool>> rollStates,
    String? scoringMethod,
  }) {
    final List<Map<String, dynamic>> frames = [];
    int rollIndex = 0;

    for (int frameNumber = 1; frameNumber <= 10; frameNumber++) {
      if (rollIndex >= rolls.length) break;

      final frameData = <String, dynamic>{
        'frame_number': frameNumber,
        'rolls': <Map<String, dynamic>>[],
        'frame_score': null,
        'is_spare': false,
        'is_strike': false,
      };

      if (frameNumber < 10) {
        // 1-9格
        if (rollIndex < rolls.length) {
          // 第一球
          final firstRoll = <String, dynamic>{
            'roll_number': 1,
            'pins_knocked': rolls[rollIndex],
            'pin_states': rollStates[rollIndex],
          };
          frameData['rolls'].add(firstRoll);

          final isStrike = rolls[rollIndex] == 10;
          frameData['is_strike'] = isStrike;
          rollIndex++;

          if (!isStrike && rollIndex < rolls.length) {
            // 第二球
            final secondRoll = <String, dynamic>{
              'roll_number': 2,
              'pins_knocked': rolls[rollIndex],
              'pin_states': rollStates[rollIndex],
            };
            frameData['rolls'].add(secondRoll);

            final isSpare = (rolls[rollIndex - 1] + rolls[rollIndex]) == 10;
            frameData['is_spare'] = isSpare;
            rollIndex++;
          }
        }
      } else {
        // 第10格：最多三球
        int tenthRoll = 1;
        while (rollIndex < rolls.length && tenthRoll <= 3) {
          final rollData = <String, dynamic>{
            'roll_number': tenthRoll,
            'pins_knocked': rolls[rollIndex],
            'pin_states': rollStates[rollIndex],
          };
          frameData['rolls'].add(rollData);
          rollIndex++;
          tenthRoll++;
        }

        // 檢查第10格的 strike/spare
        final rollsList = frameData['rolls'] as List;
        if (rollsList.isNotEmpty) {
          final firstPins = rollsList[0]['pins_knocked'] as int;
          if (firstPins == 10) {
            frameData['is_strike'] = true;
          } else if (rollsList.length >= 2) {
            final secondPins = rollsList[1]['pins_knocked'] as int;
            if (firstPins + secondPins == 10) {
              frameData['is_spare'] = true;
            }
          }
        }
      }

      if ((frameData['rolls'] as List).isNotEmpty) {
        frames.add(frameData);
      }
    }

    return frames;
  }

  /// 從 frames JSON 格式轉換回 UI 狀態
  static GameUIState convertFromFramesJson(List<dynamic> framesJson) {
    final List<int> rolls = [];
    final List<List<bool>> rollStates = [];

    for (final frameData in framesJson) {
      final frame = frameData as Map<String, dynamic>;
      final rollsList = frame['rolls'] as List<dynamic>;

      for (final rollData in rollsList) {
        final roll = rollData as Map<String, dynamic>;
        final pinsKnocked = roll['pins_knocked'] as int;
        final pinStates = (roll['pin_states'] as List<dynamic>)
            .map((e) => e as bool)
            .toList();

        rolls.add(pinsKnocked);
        rollStates.add(pinStates);
      }
    }

    return GameUIState(rolls: rolls, rollStates: rollStates);
  }

  /// 計算統計資料
  static Map<String, int> calculateStats(List<Map<String, dynamic>> frames) {
    int strikes = 0;
    int spares = 0;

    for (final frame in frames) {
      if (frame['is_strike'] == true) {
        strikes++;
      } else if (frame['is_spare'] == true) {
        spares++;
      }
    }

    return {
      'strikes': strikes,
      'spares': spares,
    };
  }
}

/// UI 狀態轉換結果
class GameUIState {
  final List<int> rolls;
  final List<List<bool>> rollStates;

  GameUIState({required this.rolls, required this.rollStates});
}