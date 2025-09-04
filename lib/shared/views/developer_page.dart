import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/components/frame_10_calculator.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/components/current_frame_10_calculator.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/components/traditional_frame_10_calculator.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/scoring_board.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/components/frames_1_9_calculator.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_strategy.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/current_scoring_strategy.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/traditional_scoring_strategy.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/engine/scoring_engine.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/engine/pin_state_policy.dart';
import 'package:flutter/material.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  late final PinSelectionController _pinController;
  final List<int> _rolls = [];
  final List<List<bool>> _rollStates = []; // 記錄每一球的球瓶狀態
  String _selectedMode = 'Current';
  Frame10Calculator? _calculator;
  Frame10Result? _result;
  // 前1-9格測試
  final List<int> _rolls19 = [];
  final List<List<bool>> _rollStates19 = [];
  ScoringStrategy? _strategy; // legacy, will be delegated to engine
  ScoringEngine? _engine;
  List<BowlingFrame> _frames19 = const [
    BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
    BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
  ];
  // 合併顯示（1-9 + 第10格）
  List<BowlingFrame> _framesMerged = const [
    BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
    BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
  ];

  @override
  void initState() {
    super.initState();
    _pinController = PinSelectionController();
    _updateCalculator();
    _updateStrategy();
  }

  void _updateCalculator() {
    _calculator = _selectedMode == 'Current' 
        ? CurrentFrame10Calculator()
        : TraditionalFrame10Calculator();
    _calculateResult();
  }

  void _updateStrategy() {
    final mode = _selectedMode == 'Current' ? ScoringMode.current : ScoringMode.traditional;
    _engine ??= ScoringEngine(mode: mode);
    _engine!.updateMode(mode);
    _strategy = _engine!.strategy;
    _recalculateFrames19();
    _recalculateMergedFrames();
  }

  void _calculateResult() {
    if (_calculator != null && _rolls.isNotEmpty) {
      _result = _calculator!.calculate(_rolls, 0, 270); // 假設前9格270分
    } else {
      _result = null;
    }
  }

  void _addRoll() async {
    if (!_canAddMoreRolls()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('第10格已完成，無法再投球'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final List<bool>? initialPinState = _selectedMode == 'Current'
        ? PinStatePolicy.initialStateForFrame10Current(_rolls, _rollStates)
        : PinStatePolicy.initialStateForFrame10Traditional(_rolls, _rollStates);
    final bool isLogicalFirstRoll = PinStatePolicy.isLogicalFirst(initialPinState);
    
    final List<bool>? result = await showDialog<List<bool>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PinSelectionDialog(
          controller: _pinController,
          initialPinState: initialPinState,
          isFirstRoll: isLogicalFirstRoll,
        );
      },
    );

    if (result != null) {
      final pinsDown = result.where((pin) => pin).length;
      setState(() {
        _rolls.add(pinsDown);
        _rollStates.add(result);
        _calculateResult();
        _recalculateMergedFrames();
      });
    }
  }

  /// 1-9格：新增投球
  void _addRoll19() async {
    if (!_canAddMoreRolls19()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('前1-9格已完成，無法再投球'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final List<bool>? initialPinState = PinStatePolicy.initialStateForFrames1to9(_rolls19, _rollStates19);
    final bool isLogicalFirstRoll = PinStatePolicy.isLogicalFirst(initialPinState);

    final List<bool>? result = await showDialog<List<bool>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PinSelectionDialog(
          controller: _pinController,
          initialPinState: initialPinState,
          isFirstRoll: isLogicalFirstRoll,
        );
      },
    );

    if (result != null) {
      final pinsDown = result.where((pin) => pin).length;
      setState(() {
        _rolls19.add(pinsDown);
        _rollStates19.add(result);
        _recalculateFrames19();
        _recalculateMergedFrames();
      });
    }
  }

  // 第10格的累積狀態顯示不再於此處使用（已移除 UI 區塊），保留通用合併運算在 1-9。

  /// 合併兩個球瓶狀態（OR運算）
  List<bool> _combineStates(List<bool> state1, List<bool> state2) {
    return List.generate(10, (i) => state1[i] || state2[i]);
  }

  // 判斷邏輯第一球改由 PinStatePolicy.isLogicalFirst

  /// 檢查是否還能繼續投球
  bool _canAddMoreRolls() {
    if (_calculator == null) return true;
    
    // 使用計算器檢查是否已完成
    if (_rolls.isNotEmpty && _calculator!.isComplete(_rolls, 0)) {
      return false;
    }
    
    // 檢查是否超過該模式的最大球數
    final maxRolls = _selectedMode == 'Current' ? 2 : 3;
    return _rolls.length < maxRolls;
  }

  /// 1-9格：檢查是否還能繼續投球
  bool _canAddMoreRolls19() {
    final pos = _advanceToNextInputForFrames1to9(_rolls19);
    return pos.currentFrameIndex < 9;
  }

  // 初始狀態計算邏輯已移至 PinStatePolicy

  void _clearRolls() {
    setState(() {
      _rolls.clear();
      _rollStates.clear();
      _result = null;
      _recalculateMergedFrames();
    });
  }

  /// 1-9格：清除
  void _clearRolls19() {
    setState(() {
      _rolls19.clear();
      _rollStates19.clear();
      _recalculateFrames19();
      _recalculateMergedFrames();
    });
  }

  void _recalculateFrames19() {
    if (_strategy == null) {
      _frames19 = const [
        BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
        BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
      ];
      return;
    }

    try {
      _frames19 = Frames1To9Calculator.calculate(_rolls19, _strategy!);
    } catch (_) {
      _frames19 = const [
        BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
        BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
      ];
    }
  }

  void _recalculateMergedFrames() {
    if (_engine == null) {
      _framesMerged = const [
        BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
        BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
      ];
      return;
    }
    try {
      _framesMerged = _engine!.calculateMergedFrames(_rolls19, _rolls);
    } catch (_) {
      _framesMerged = const [
        BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
        BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(), BowlingFrame(),
      ];
    }
  }

  /// 1-9格：計算到第 index 球後的累積球瓶狀態
  List<bool> _calculateCumulativeState19(int index) {
    if (index < 0 || index >= _rollStates19.length) {
      return List.generate(10, (_) => false);
    }
    final firstRollIndex = _firstRollIndexOfCurrentFrameAt(index);
    if (firstRollIndex == index) {
      return _rollStates19[index];
    }
    return _combineStates(_rollStates19[firstRollIndex], _rollStates19[index]);
  }

  int _firstRollIndexOfCurrentFrameAt(int rollIndex) {
    int i = 0;
    while (i < rollIndex) {
      if (_rolls19[i] == 10) {
        i += 1;
      } else {
        i += 2;
      }
    }
    return i == rollIndex ? rollIndex : rollIndex - 1;
  }

  ({int currentFrameIndex, int currentRollInFrame}) _advanceToNextInputForFrames1to9(List<int> rolls) {
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

  /// 取得目前可輸入的欄位（0-based）。回傳 -1 代表已完成不可再輸入。
  int _getCurrentFrameIndex() {
    if (_engine == null) return 0;
    return _engine!.getCurrentFrameIndex(_rolls19, _rolls);
  }

  void _onMergedFrameTapped(int frameIndex) async {
    final currentIdx = _getCurrentFrameIndex();
    if (currentIdx == -1 || frameIndex != currentIdx) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('只能在目前欄位輸入')),
      );
      return;
    }

    if (frameIndex < 9) {
      final List<bool>? initialPinState = PinStatePolicy.initialStateForFrames1to9(_rolls19, _rollStates19);
      final bool isFirst = PinStatePolicy.isLogicalFirst(initialPinState);
      final List<bool>? result = await showDialog<List<bool>>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PinSelectionDialog(
            controller: _pinController,
            initialPinState: initialPinState,
            isFirstRoll: isFirst,
          );
        },
      );
      if (result != null) {
        final pinsDown = result.where((pin) => pin).length;
        setState(() {
          _rolls19.add(pinsDown);
          _rollStates19.add(result);
          _recalculateFrames19();
          _recalculateMergedFrames();
        });
      }
    } else {
      final List<bool>? initialPinState = _selectedMode == 'Current'
          ? PinStatePolicy.initialStateForFrame10Current(_rolls, _rollStates)
          : PinStatePolicy.initialStateForFrame10Traditional(_rolls, _rollStates);
      final bool isFirst = PinStatePolicy.isLogicalFirst(initialPinState);
      final List<bool>? result = await showDialog<List<bool>>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PinSelectionDialog(
            controller: _pinController,
            initialPinState: initialPinState,
            isFirstRoll: isFirst,
          );
        },
      );
      if (result != null) {
        final pinsDown = result.where((pin) => pin).length;
    setState(() {
          _rolls.add(pinsDown);
          _rollStates.add(result);
          _calculateResult();
          _recalculateMergedFrames();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('計分開發測試'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 模式選擇
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '計分模式',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Current'),
                            value: 'Current',
                            groupValue: _selectedMode,
                            onChanged: (value) {
                              setState(() {
                                _selectedMode = value!;
                                _updateCalculator();
                                _updateStrategy();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Traditional'),
                            value: 'Traditional',
                            groupValue: _selectedMode,
                            onChanged: (value) {
                              setState(() {
                                _selectedMode = value!;
                                _updateCalculator();
                                _updateStrategy();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // 已精簡：只保留模式切換 + 合併顯示
                    const SizedBox(height: 8),
            ScoringBoard(
              title: null,
              frames: _framesMerged,
              onFrameTapped: _onMergedFrameTapped,
              showThirdBallInTenthFrame: _selectedMode != 'Current',
              singleRow: true,
              frameAspectRatio: 0.78,
              removeOuterContainer: true,
              useGlowText: false,
              frameMargin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.0),
              frameBorderWidth: 1.0,
              frameBorderRadius: 4.0,
              showFrameShadow: false,
              showHeaderNumbers: true,
              headerBarHeight: 0.0,
              headerBarColor: null,
              tenthFrameFlex: 1,
              accentColor: Theme.of(context).colorScheme.primary,
              // 壓到邊界
              // 下層 widget 已支援 suppressEdgeMargins，讓首尾貼齊
              ),
            const SizedBox(height: 16),
            ScoringBoard(
              title: null,
              frames: _framesMerged,
              onFrameTapped: _onMergedFrameTapped,
              showThirdBallInTenthFrame: _selectedMode != 'Current',
              singleRow: true,
              frameAspectRatio: 0.76,
              removeOuterContainer: true,
              useGlowText: false,
              frameMargin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.0),
              frameBorderWidth: 1.1,
              frameBorderRadius: 5.0,
              showFrameShadow: false,
              showHeaderNumbers: true,
              headerBarHeight: 0.0,
              headerBarColor: null,
              tenthFrameFlex: 1,
              accentColor: Theme.of(context).colorScheme.primary,
              innerBorderWidth: 1.0,
              innerBorderColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              frameFillGradient: LinearGradient(colors: [Color(0xFF0B0B0C), Color(0xFF111112)]),
              useCumulativePill: true,
              cumulativeBackgroundColor: Color(0xFF2A2A2C),
              cumulativeTextStyle: TextStyle(color: Color(0xFFFFFFFF), fontSize: 12),
              showSeparatorLine: true,
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildFrameDisplay() {
    if (_result == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 第一球
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                _result!.firstBall,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // 第二球
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                _result!.secondBall,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_result!.thirdBall != null) ...[
            const SizedBox(width: 4),
            // 第三球 (獎勵球)
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(4),
                color: Colors.yellow.withOpacity(0.2),
              ),
              child: Center(
                child: Text(
                  _result!.thirdBall!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

