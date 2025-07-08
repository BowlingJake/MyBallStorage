import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bowlingarsenal_app/models/training_record.dart';
import 'package:bowlingarsenal_app/logic/scoring/scoring_manager.dart';
import 'package:bowlingarsenal_app/logic/scoring/scoring_strategy.dart';
import 'package:bowlingarsenal_app/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/widgets/pin_selector_popup_widget.dart';
import 'package:bowlingarsenal_app/widgets/training/components/scoring_dialog_header.dart';
import 'package:bowlingarsenal_app/widgets/training/components/scoring_dialog_content.dart';
import 'package:bowlingarsenal_app/widgets/training/components/scoring_dialog_footer.dart';

/// 互動式計分對話框
/// 
/// 整合計分表格、pin selector和計分模式切換的完整計分體驗
class InteractiveScoringDialog extends StatefulWidget {
  const InteractiveScoringDialog({
    required this.game,
    super.key,
    this.onGameSaved,
  });
  
  final GameRecord game;
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
    _scoringManager = ScoringManager(mode: ScoringMode.traditional);
    _rolls = [];
    _frames = List.generate(10, (index) => const BowlingFrame());
    _updateScoreDisplay();
  }

  /// 更新計分表格顯示
  void _updateScoreDisplay() {
    setState(() {
      _frames = _scoringManager.calculateScores(_rolls);
    });
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

    // 計算初始已倒球瓶
    final initialPinsDown = _getInitialPinsDown(frameIndex);
    
    // 顯示球瓶選擇器
    final selectedPins = await showDialog<Set<int>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PinSelectorPopupWidget(
        initialPinsDown: initialPinsDown,
        pinStandingAssetPath: 'assets/images/pin_standing.svg',
        pinFallenAssetPath: 'assets/images/pin_fallen.svg',
      ),
    );

    if (selectedPins != null) {
      _processPinSelection(frameIndex, selectedPins);
    }
  }

  /// 檢查是否可以在指定格輸入
  bool _canInputAtFrame(int frameIndex) {
    // 只能在當前格或當前格的下一球輸入
    if (frameIndex == _currentFrameIndex) return true;
    
    // 如果當前格已完成，且點擊下一格
    if (frameIndex == _currentFrameIndex + 1 && _isCurrentFrameComplete()) {
      return true;
    }
    
    return false;
  }

  /// 檢查當前格是否已完成
  bool _isCurrentFrameComplete() {
    if (_currentFrameIndex >= 10) return true;
    
    final rollsInCurrentFrame = _getRollsInFrame(_currentFrameIndex);
    
    // 第10格特殊邏輯
    if (_currentFrameIndex == 9) {
      if (rollsInCurrentFrame.isEmpty) return false;
      if (rollsInCurrentFrame.length == 1) {
        // 第一球後，如果是strike，需要第二球
        return false;
      }
      if (rollsInCurrentFrame.length == 2) {
        final firstRoll = rollsInCurrentFrame[0];
        final secondRoll = rollsInCurrentFrame[1];
        // 如果前兩球strike或spare，需要第三球
        return !(firstRoll == 10 || firstRoll + secondRoll == 10);
      }
      return true; // 三球完成
    }
    
    // 前9格
    if (rollsInCurrentFrame.isEmpty) return false;
    if (rollsInCurrentFrame.length == 1) {
      return rollsInCurrentFrame[0] == 10; // strike完成
    }
    return true; // 兩球完成
  }

  /// 取得指定格的投球記錄
  List<int> _getRollsInFrame(int frameIndex) {
    var rollIndex = 0;
    
    // 計算到指定格之前的投球數
    for (var i = 0; i < frameIndex; i++) {
      final frameRolls = _getRollsInFrameFromIndex(rollIndex);
      rollIndex += frameRolls.length;
    }
    
    // 取得當前格的投球
    return _getRollsInFrameFromIndex(rollIndex);
  }

  /// 從指定位置開始取得一格的投球數據
  List<int> _getRollsInFrameFromIndex(int startIndex) {
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
  }

  /// 從投球索引計算格數
  int _getFrameNumberFromRollIndex(int rollIndex) {
    var currentRollIndex = 0;
    for (var frameNum = 1; frameNum <= 10; frameNum++) {
      final frameRolls = _getRollsInFrameFromIndex(currentRollIndex);
      if (rollIndex >= currentRollIndex && rollIndex < currentRollIndex + frameRolls.length) {
        return frameNum;
      }
      currentRollIndex += frameRolls.length;
    }
    return 10; // 預設第10格
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
  void _processPinSelection(int frameIndex, Set<int> selectedPins) {
    final pinsDown = selectedPins.length;
    
    // 添加到投球記錄
    _rolls.add(pinsDown);
    
    // 更新當前位置
    _updateCurrentPosition();
    
    // 檢查遊戲是否完成
    _checkGameComplete();
    
    // 更新顯示
    _updateScoreDisplay();
    
    // 觸覺回饋
    HapticFeedback.lightImpact();
  }

  /// 更新當前投球位置
  void _updateCurrentPosition() {
    // 重新計算當前格和球數
    var rollIndex = 0;
    var frameIndex = 0;
    
    while (frameIndex < 10 && rollIndex < _rolls.length) {
      final frameRolls = _getRollsInFrameFromIndex(rollIndex);
      
      if (rollIndex + frameRolls.length <= _rolls.length) {
        // 這格已完成
        rollIndex += frameRolls.length;
        frameIndex++;
      } else {
        // 這格未完成
        break;
      }
    }
    
    _currentFrameIndex = frameIndex;
    _currentRollInFrame = _rolls.length - rollIndex;
  }

  /// 檢查遊戲是否完成
  void _checkGameComplete() {
    if (_currentFrameIndex >= 10) {
      _isGameComplete = true;
      return;
    }
    
    // 檢查第10格特殊情況
    if (_currentFrameIndex == 9) {
      final frameRolls = _getRollsInFrame(9);
      if (frameRolls.length >= 2) {
        final needThirdBall = frameRolls[0] == 10 || 
                             frameRolls[0] + frameRolls[1] == 10;
        if (!needThirdBall || frameRolls.length >= 3) {
          _isGameComplete = true;
        }
      }
    }
  }

  /// 重置遊戲
  void _resetGame() {
    setState(() {
      _rolls.clear();
      _currentFrameIndex = 0;
      _currentRollInFrame = 0;
      _isGameComplete = false;
      _updateScoreDisplay();
    });
    
    HapticFeedback.mediumImpact();
  }

  /// 撤銷上一球
  void _undoLastRoll() {
    if (_rolls.isNotEmpty) {
      setState(() {
        _rolls.removeLast();
        _updateCurrentPosition();
        _checkGameComplete();
        _updateScoreDisplay();
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
  }

  /// 計算補中數
  int _countSpares() {
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalScore = _frames.isNotEmpty ? _frames.last.cumulativeScore : 0;
    
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
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.2),
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
                  ),
                ),
                ScoringDialogFooter(
                  rollsCount: _rolls.length,
                  totalScore: totalScore,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }






} 