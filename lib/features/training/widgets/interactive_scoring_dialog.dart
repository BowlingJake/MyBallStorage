import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_manager.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_strategy.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/simple_pins_down_selector.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/scoring_dialog_header.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/scoring_dialog_content.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/scoring_dialog_footer.dart';
import 'package:core_theme/core_theme.dart';

/// 互動式計分對話框
/// 
/// 整合計分表格、pin selector和計分模式切換的完整計分體驗
class InteractiveScoringDialog extends StatefulWidget {
  const InteractiveScoringDialog({
    required this.game,
    required this.scoringMethod, // 新增：來自訓練記錄的計分方式
    super.key,
    this.onGameSaved,
  });
  
  final GameRecord game;
  final String scoringMethod; // 新增：計分方式 (如 'Standard', 'Current' 等)
  final Function(GameRecord)? onGameSaved;

  @override
  State<InteractiveScoringDialog> createState() => _InteractiveScoringDialogState();
}

class _InteractiveScoringDialogState extends State<InteractiveScoringDialog> {
  late ScoringManager _scoringManager;
  late List<int> _rolls; // 儲存原始投球數據
  late List<BowlingFrame> _frames; // 計分表格數據
  int _currentFrameIndex = 0;
  int _currentRollInFrame = 0; // 當前格內的第幾球 (0或1，第10格可能是2)
  bool _isGameComplete = false;

  @override
  void initState() {
    super.initState();
    
    // 根據 scoringMethod 字串選擇對應的計分模式
    final scoringMode = _parseScoringMethod(widget.scoringMethod);
    _scoringManager = ScoringManager(mode: scoringMode);
    
    _rolls = [];
    _frames = List.generate(10, (index) => const BowlingFrame());
    _updateScoreDisplay();
  }

  /// 將 scoringMethod 字串轉換為 ScoringMode 枚舉
  ScoringMode _parseScoringMethod(String method) {
    switch (method.toLowerCase()) {
      case 'current':
        return ScoringMode.current;
      case 'standard':
      case 'traditional':
      default:
        return ScoringMode.traditional;
    }
  }

  /// 更新計分表格顯示
  void _updateScoreDisplay() {
    // 移除 setState，因為這個方法現在只在其他 setState 內部被呼叫
    _frames = _scoringManager.calculateScores(_rolls);
  }



  /// 處理點擊計分格
  Future<void> _onFrameTapped(int frameIndex) async {
    if (_isGameComplete) return;
    
    // 檢查是否可以在此格輸入
    if (!_canInputAtFrame(frameIndex)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter scores in order'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // 簡化的倒瓶數計算 - 暫時假設最大為 10
    int maxPins = 10;
    
    // 顯示數字選單
    final selectedPinsDown = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SimplePinsDownSelector(
        maxPins: maxPins,
        initialPinsDown: 0,
      ),
    );

    if (selectedPinsDown != null) {
      _processPinSelection(frameIndex, selectedPinsDown);
    }
  }

  /// 檢查是否可以在指定格輸入
  bool _canInputAtFrame(int frameIndex) {
    // 簡化版本：只允許在當前格輸入
    return frameIndex == _currentFrameIndex;
  }

  /// 檢查當前格是否已完成
  bool _isCurrentFrameComplete() {
    // 簡化版本：如果遊戲已完成或超出格數，則認為完成
    return _isGameComplete || _currentFrameIndex >= 10;
  }

  /// 取得指定格的投球記錄
  List<int> _getRollsInFrame(int frameIndex) {
    // 暫時註釋掉以避免無限遞迴
    return [];
    /*
    var rollIndex = 0;
    
    // 計算到指定格之前的投球數
    for (var i = 0; i < frameIndex; i++) {
      final frameRolls = _getRollsInFrameFromIndex(rollIndex);
      rollIndex += frameRolls.length;
    }
    
    // 取得當前格的投球
    return _getRollsInFrameFromIndex(rollIndex);
    */
  }

  /// 從指定位置開始取得一格的投球數據
  List<int> _getRollsInFrameFromIndex(int startIndex) {
    // 暫時註釋掉以避免無限遞迴
    return [];
    /*
    final frameRolls = <int>[];
    var index = startIndex;
    
    if (index >= _rolls.length) return frameRolls;
    
    // 第一球
    frameRolls.add(_rolls[index]);
    index++;
    
    // 如果第一球不是strike，或者是第10格，需要第二球
    final isStrike = frameRolls[0] == 10;
    final frameNumber = _getFrameNumberFromRollIndex(startIndex);
    
    if (!isStrike || frameNumber == 10) {
      if (index < _rolls.length) {
        frameRolls.add(_rolls[index]);
        index++;
      }
    }
    
    // 第10格可能有第三球
    if (frameNumber == 10 && frameRolls.length >= 2) {
      final needThirdBall = frameRolls[0] == 10 || 
                           (frameRolls[0] + frameRolls[1] == 10);
      if (needThirdBall && index < _rolls.length) {
        frameRolls.add(_rolls[index]);
      }
    }
    
    return frameRolls;
    */
  }

  /// 從投球索引計算格數
  int _getFrameNumberFromRollIndex(int rollIndex) {
    // 暫時註釋掉以避免無限遞迴
    return 1;
    /*
    var currentRollIndex = 0;
    for (var frameNum = 1; frameNum <= 10; frameNum++) {
      final frameRolls = _getRollsInFrameFromIndex(currentRollIndex);
      if (rollIndex >= currentRollIndex && rollIndex < currentRollIndex + frameRolls.length) {
        return frameNum;
      }
      currentRollIndex += frameRolls.length;
    }
    return 10; // 預設第10格
    */
  }

  /// 計算初始已倒球瓶
  Set<int> _getInitialPinsDown(int frameIndex) {
    final frameRolls = _getRollsInFrame(frameIndex);
    
    if (frameRolls.isEmpty) {
      // 第一球，所有瓶子都站立
      return {};
    }
    
    // 第二球或之後
    final firstRoll = frameRolls[0];
    
    // 如果第一球是strike，第二球重新設置
    if (firstRoll == 10 && frameIndex != 9) {
      return {};
    }
    
    // 第10格特殊處理
    if (frameIndex == 9 && frameRolls.length >= 2) {
      final secondRoll = frameRolls[1];
      if (firstRoll == 10) {
        // 第一球strike，第三球看第二球結果
        if (secondRoll == 10) {
          return {}; // 第二球也strike，第三球重置
        } else {
          // 第二球沒strike，第三球顯示第二球剩餘
          return Set<int>.from(List.generate(10, (i) => i + 1)).difference(Set<int>.from(List.generate(secondRoll, (i) => i + 1)));
        }
      } else if (firstRoll + secondRoll == 10) {
        // 前兩球spare，第三球重置
        return {};
      }
    }
    
    // 一般情況：顯示第一球擊倒的瓶子
    return Set<int>.from(List.generate(firstRoll, (i) => i + 1));
  }

  /// 處理球瓶選擇結果
  void _processPinSelection(int frameIndex, int selectedPinsDown) {
    if (!mounted) return; // 確保 widget 仍然存在
    
    setState(() {
      // 添加到投球記錄
      _rolls.add(selectedPinsDown);
      
      // 簡化的狀態推進邏輯
      _advanceToNextInput();
      
      // 重新計算分數
      _frames = _scoringManager.calculateScores(_rolls);
      
      // 檢查遊戲是否完成
      _isGameComplete = _checkGameCompleteStatus();
    });
    
    // 觸覺回饋
    HapticFeedback.lightImpact();
  }

  /// 簡化的推進到下一個輸入位置
  void _advanceToNextInput() {
    // 重新從頭計算當前位置，完全獨立的邏輯
    _currentFrameIndex = 0;
    _currentRollInFrame = 0;
    int rollIndex = 0;
    
    while (rollIndex < _rolls.length && _currentFrameIndex < 10) {
      if (_currentFrameIndex < 9) {
        // 第1-9格
        if (_currentRollInFrame == 0) {
          // 第一球
          if (_rolls[rollIndex] == 10) {
            // Strike，進入下一格
            _currentFrameIndex++;
            _currentRollInFrame = 0;
          } else {
            // 不是Strike，需要第二球
            _currentRollInFrame = 1;
          }
          rollIndex++;
        } else {
          // 第二球
          _currentFrameIndex++;
          _currentRollInFrame = 0;
          rollIndex++;
        }
      } else {
        // 第10格
        if (_currentRollInFrame == 0) {
          _currentRollInFrame = 1;
          rollIndex++;
        } else if (_currentRollInFrame == 1) {
          // 檢查是否需要第三球
          if (rollIndex >= 2) {
            final firstRoll = _rolls[rollIndex - 1];
            final secondRoll = _rolls[rollIndex];
            if (firstRoll == 10 || firstRoll + secondRoll == 10) {
              // Strike 或 Spare，需要第三球
              _currentRollInFrame = 2;
            } else {
              // 結束
              _currentFrameIndex = 10;
            }
          } else {
            _currentFrameIndex = 10;
          }
          rollIndex++;
        } else {
          // 第三球
          _currentFrameIndex = 10;
          rollIndex++;
        }
      }
    }
  }

  /// 檢查遊戲是否完成（完全獨立的邏輯）
  bool _checkGameCompleteStatus() {
    if (_currentFrameIndex >= 10) {
      return true;
    }
    
    // 如果不在第10格，遊戲未完成
    if (_currentFrameIndex < 9) {
      return false;
    }
    
    // 第10格特殊檢查 - 使用直接的 roll 計算而不是 _getRollsInFrame
    int frame10StartIndex = 0;
    int currentFrameIdx = 0;
    int currentRollIdx = 0;
    
    // 計算到第10格的起始位置
    while (currentFrameIdx < 9 && frame10StartIndex < _rolls.length) {
      if (currentRollIdx == 0) {
        if (_rolls[frame10StartIndex] == 10) {
          // Strike
          currentFrameIdx++;
          currentRollIdx = 0;
        } else {
          currentRollIdx = 1;
        }
        frame10StartIndex++;
      } else {
        // 第二球
        currentFrameIdx++;
        currentRollIdx = 0;
        frame10StartIndex++;
      }
    }
    
    // 檢查第10格的完成狀態
    final frame10RollsCount = _rolls.length - frame10StartIndex;
    if (frame10RollsCount < 2) {
      return false; // 至少需要兩球
    }
    
    if (frame10RollsCount >= 3) {
      return true; // 三球已完成
    }
    
    // 只有兩球，檢查是否需要第三球
    final firstRoll = _rolls[frame10StartIndex];
    final secondRoll = _rolls[frame10StartIndex + 1];
    
    // 如果第一球或前兩球合計為Strike/Spare，需要第三球
    if (firstRoll == 10 || firstRoll + secondRoll == 10) {
      return false; // 需要第三球
    }
    
    return true; // 不需要第三球，遊戲完成
  }

  /// 重置遊戲
  void _resetGame() {
    if (!mounted) return;
    
    setState(() {
      _rolls.clear();
      _currentFrameIndex = 0;
      _currentRollInFrame = 0;
      _isGameComplete = false;
      _frames = _scoringManager.calculateScores(_rolls);
    });
    
    HapticFeedback.mediumImpact();
  }

  /// 撤銷上一球
  void _undoLastRoll() {
    if (_rolls.isNotEmpty && mounted) {
      setState(() {
        _rolls.removeLast();
        _advanceToNextInput();
        _frames = _scoringManager.calculateScores(_rolls);
        _isGameComplete = _checkGameCompleteStatus();
      });
      
      HapticFeedback.selectionClick();
    }
  }

  /// 保存遊戲
  void _saveGame() {
    if (!_isGameComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請完成遊戲後再保存'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // 計算最終統計
    final finalScore = _frames.isNotEmpty ? _frames.last.cumulativeScore : 0;
    final strikes = _countStrikes();
    final spares = _countSpares();
    
    // 創建更新的遊戲記錄
    final updatedGame = GameRecord(
      id: widget.game.id,
      gameNumber: widget.game.gameNumber,
      score: finalScore,
      strikes: strikes,
      spares: spares,
      frameScores: _frames.map((f) => f.cumulativeScore).toList(),
      ballUsed: widget.game.ballUsed,
      notes: widget.game.notes,
      timestamp: widget.game.timestamp,
    );
    
    widget.onGameSaved?.call(updatedGame);
    Navigator.of(context).pop();
    
    // 成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Game saved! Final score: $finalScore'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 計算全倒數
  int _countStrikes() {
    // 暫時簡化實作，避免遞迴
    int strikes = 0;
    for (int roll in _rolls) {
      if (roll == 10) strikes++;
    }
    return strikes;
    /*
    var strikes = 0;
    var rollIndex = 0;
    
    for (var frameIndex = 0; frameIndex < 9; frameIndex++) {
      if (rollIndex < _rolls.length && _rolls[rollIndex] == 10) {
        strikes++;
        rollIndex++;
      } else {
        // 跳過這格的所有球
        final frameRolls = _getRollsInFrameFromIndex(rollIndex);
        rollIndex += frameRolls.length;
      }
    }
    
    // 第10格計算strikes
    final frame10Rolls = _getRollsInFrame(9);
    for (final roll in frame10Rolls) {
      if (roll == 10) strikes++;
    }
    
    return strikes;
    */
  }

  /// 計算補中數
  int _countSpares() {
    // 暫時簡化實作，避免遞迴
    return 0;
    /*
    var spares = 0;
    var rollIndex = 0;
    
    // 前9格
    for (var frameIndex = 0; frameIndex < 9; frameIndex++) {
      final frameRolls = _getRollsInFrameFromIndex(rollIndex);
      if (frameRolls.length >= 2) {
        if (frameRolls[0] != 10 && frameRolls[0] + frameRolls[1] == 10) {
          spares++;
        }
      }
      rollIndex += frameRolls.length;
    }
    
    // 第10格
    final frame10Rolls = _getRollsInFrame(9);
    if (frame10Rolls.length >= 2) {
      if (frame10Rolls[0] != 10 && frame10Rolls[0] + frame10Rolls[1] == 10) {
        spares++;
      }
    }
    
    return spares;
    */
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 確保每次建構時分數都是最新的
    _frames = _scoringManager.calculateScores(_rolls);
    final totalScore = _frames.isNotEmpty ? _frames.last.cumulativeScore : 0;
    
    // 根據計分模式選擇顏色
    final scoringColor = _scoringManager.currentMode == ScoringMode.traditional
        ? BrandColors.traditionalScoringColor
        : BrandColors.currentScoringColor;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 700,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: scoringColor.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: scoringColor.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                ScoringDialogHeader(
                  gameNumber: widget.game.gameNumber,
                  onClose: () => Navigator.of(context).pop(),
                  accentColor: scoringColor, // 傳遞顏色給 header
                ),
                Expanded(
                  child: ScoringDialogContent(
                    frames: _frames,
                    onFrameTapped: _onFrameTapped,
                    onUndo: _undoLastRoll,
                    onReset: _resetGame,
                    onSave: _saveGame,
                    canUndo: _rolls.isNotEmpty,
                    canReset: _rolls.isNotEmpty,
                    canSave: _isGameComplete,
                    accentColor: scoringColor, // 傳遞顏色給內容
                  ),
                ),
                ScoringDialogFooter(
                  rollsCount: _rolls.length,
                  totalScore: totalScore,
                  accentColor: scoringColor, // 傳遞顏色給 footer
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }






} 