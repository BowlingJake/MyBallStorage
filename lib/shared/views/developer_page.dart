import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_widget.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/scoring_board.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/utils/bowling/split_detector.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_config.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
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
import 'package:go_router/go_router.dart';

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
  bool _isEditMode = false;
  bool _showPinVisualization = true;

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
      TopNotification.showError(context, '第10格已完成，無法再投球');
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
          frameNumber: 1, // Testing frame
        );
      },
    );

    if (result != null) {
      final pinsDown = result.where((pin) => pin).length;
      setState(() {
        _rolls.add(pinsDown);
        _rollStates.add(result.toList());
        _calculateResult();
        _recalculateMergedFrames();
      });
    }
  }

  /// 1-9格：新增投球
  void _addRoll19() async {
    if (!_canAddMoreRolls19()) {
      TopNotification.showError(context, '前1-9格已完成，無法再投球');
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
          frameNumber: 1, // Testing frame
        );
      },
    );

    if (result != null) {
      final pinsDown = result.where((pin) => pin).length;
      setState(() {
        _rolls19.add(pinsDown);
        _rollStates19.add(result.toList());
        
        // Debug: 列印當前的狀態
        print('Added roll #${_rolls19.length}: $pinsDown pins');
        print('Roll states length: ${_rollStates19.length}');
        print('Last added state: $result');
        
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

  /// 重置所有輸入記錄
  void _resetAllData() {
    setState(() {
      _rolls.clear();
      _rollStates.clear();
      _rolls19.clear();
      _rollStates19.clear();
      _result = null;
      _recalculateFrames19();
      _recalculateMergedFrames();
    });
    TopNotification.showSuccess(context, '已重置所有輸入記錄');
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

  /// 取得 1-9 格某一格的第一球在 _rolls19 中的起始索引
  int _rollStartIndexForFrame19(int frameIndex) {
    int rollIndex = 0;
    for (int f = 0; f < frameIndex; f++) {
      if (rollIndex >= _rolls19.length) return _rolls19.length; // 超出
      if (_rolls19[rollIndex] == 10) {
        rollIndex += 1;
      } else {
        rollIndex += 2;
      }
    }
    return rollIndex;
  }

  /// 確認 1-9 格該格是否為「已完整」
  bool _isFrameComplete19(int frameIndex) {
    final int start = _rollStartIndexForFrame19(frameIndex);
    if (start >= _rolls19.length) return false;
    if (_rolls19[start] == 10) return true; // strike 完整
    return (start + 1) < _rolls19.length; // 需要第二球
  }

  /// 生成球瓶視覺化組件列表
  List<Widget> _buildPinVisualizationRow() {
    final List<Widget> pinVisualizations = [];
    
    for (int frameIndex = 0; frameIndex < 10; frameIndex++) {
      List<bool> pinStates;
      
      if (frameIndex < 9) {
        // 1-9格：使用合併的數據
        pinStates = PinVisualizationHelper.getFramePinStates(
          rolls: _rolls19,
          rollStates: _rollStates19,
          frameIndex: frameIndex,
        );
      } else {
        // 第10格：使用第10格的數據
        pinStates = PinVisualizationHelper.getFramePinStates(
          rolls: _rolls,
          rollStates: _rollStates,
          frameIndex: frameIndex,
        );
      }
      
      pinVisualizations.add(
        Expanded(
          flex: frameIndex == 9 ? 1 : 1, // 第10格與其他格相同flex
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0.5),
            // 開發者頁預覽：暫時保留，若需要一致以 SVG 呈現，可改為 PinSvgWidget
            child: PinVisualizationWidget.withConfig(
              pinStates: pinStates,
              width: double.infinity,
              config: PinVisualizationConfig.dev(),
            ),
          ),
        ),
      );
    }
    
    return pinVisualizations;
  }

  void _onMergedFrameTapped(int frameIndex) async {
    if (!_isEditMode) {
      final currentIdx = _getCurrentFrameIndex();
      if (currentIdx == -1 || frameIndex != currentIdx) {
        TopNotification.showError(context, '只能在目前欄位輸入');
        return;
      }
    } else {
      // 編輯模式：僅允許對「已完成」的格進行編輯
      final bool canEdit = frameIndex < 9 ? _isFrameComplete19(frameIndex) : _rolls.isNotEmpty;
      if (!canEdit) {
        TopNotification.showError(context, '僅可編輯已完成的格');
        return;
      }
    }

    if (frameIndex < 9) {
      final List<bool>? initialPinState = PinStatePolicy.initialStateForFrames1to9(_rolls19, _rollStates19);
      final bool isFirst = _isEditMode ? (initialPinState == null) : PinStatePolicy.isLogicalFirst(initialPinState);
      final List<bool>? result = await showDialog<List<bool>>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PinSelectionDialog(
            controller: _pinController,
            initialPinState: initialPinState,
            isFirstRoll: isFirst,
            frameNumber: frameIndex + 1, // Convert 0-based to 1-based
          );
        },
      );
      if (result != null) {
        final pinsDown = result.where((pin) => pin).length;
        if (_isEditMode) {
          // 計算欲寫入的第一球索引
          int writeIndex = 0;
          for (int f = 0; f < frameIndex; f++) {
            if (writeIndex < _rolls19.length && _rolls19[writeIndex] == 10) {
              writeIndex += 1;
            } else {
              writeIndex += 2;
            }
          }

          // 若非 strike，先取得第二球輸入
          List<bool>? res2;
          int? pinsDown2;
          if (pinsDown != 10) {
            res2 = await showDialog<List<bool>>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return PinSelectionDialog(
                  controller: _pinController,
                  initialPinState: result,
                  isFirstRoll: false,
                  frameNumber: frameIndex + 1, // Convert 0-based to 1-based
                );
              },
            );
            if (res2 != null) {
              pinsDown2 = res2.where((p) => p).length;
            }
          }

          setState(() {
            final bool hadFirst = writeIndex < _rolls19.length;
            final bool originalWasStrike = hadFirst && _rolls19[writeIndex] == 10;

            // 覆寫/新增第一球
            if (hadFirst) {
              _rolls19[writeIndex] = pinsDown;
              _rollStates19[writeIndex] = result.toList();
            } else {
              _rolls19.insert(writeIndex, pinsDown);
              _rollStates19.insert(writeIndex, result.toList());
            }

            if (pinsDown == 10) {
              // 新狀態為 strike：確保移除原第二球（若原本有）
              if (!originalWasStrike && writeIndex + 1 < _rolls19.length) {
                _rolls19.removeAt(writeIndex + 1);
                _rollStates19.removeAt(writeIndex + 1);
              }
            } else {
              // 新狀態為非 strike，須有第二球
              if (res2 != null && pinsDown2 != null) {
                if (originalWasStrike) {
                  // 原本是 strike，現在改為兩球：插入第二球，將後續右移
                  if (writeIndex + 1 <= _rolls19.length) {
                    _rolls19.insert(writeIndex + 1, pinsDown2);
                    _rollStates19.insert(writeIndex + 1, res2.toList());
                  } else {
                    _rolls19.add(pinsDown2);
                    _rollStates19.add(res2.toList());
                  }
                } else {
                  // 原本也是兩球：覆寫第二球
                  if (writeIndex + 1 < _rolls19.length) {
                    _rolls19[writeIndex + 1] = pinsDown2;
                    _rollStates19[writeIndex + 1] = res2.toList();
                  } else {
                    _rolls19.add(pinsDown2);
                    _rollStates19.add(res2.toList());
                  }
                }
              }
            }

            _recalculateFrames19();
            _recalculateMergedFrames();
          });
        } else {
          setState(() {
            _rolls19.add(pinsDown);
            _rollStates19.add(result);
            _recalculateFrames19();
            _recalculateMergedFrames();
          });
        }
      }
    } else {
      final List<bool>? initialPinState = _selectedMode == 'Current'
          ? PinStatePolicy.initialStateForFrame10Current(_rolls, _rollStates)
          : PinStatePolicy.initialStateForFrame10Traditional(_rolls, _rollStates);
      final bool isFirst = _isEditMode ? (initialPinState == null) : PinStatePolicy.isLogicalFirst(initialPinState);
      final List<bool>? result = await showDialog<List<bool>>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PinSelectionDialog(
            controller: _pinController,
            initialPinState: initialPinState,
            isFirstRoll: isFirst,
            frameNumber: frameIndex + 1, // Convert 0-based to 1-based
          );
        },
      );
      if (result != null) {
        final pinsDown = result.where((pin) => pin).length;
        if (_isEditMode) {
          List<bool>? res2;
          int? pinsDown2;
          if (pinsDown != 10) {
            res2 = await showDialog<List<bool>>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return PinSelectionDialog(
                  controller: _pinController,
                  initialPinState: result,
                  isFirstRoll: false,
                  frameNumber: frameIndex + 1, // Convert 0-based to 1-based
                );
              },
            );
            if (res2 != null) {
              pinsDown2 = res2.where((p) => p).length;
            }
          }
          setState(() {
            if (_rolls.isEmpty) {
              _rolls.add(pinsDown);
              _rollStates.add(result.toList());
            } else {
              _rolls[0] = pinsDown;
              _rollStates[0] = result.toList();
            }
            if (pinsDown != 10 && res2 != null && pinsDown2 != null) {
              if (_rolls.length >= 2) {
                _rolls[1] = pinsDown2;
                _rollStates[1] = res2.toList();
              } else {
                _rolls.add(pinsDown2);
                _rollStates.add(res2.toList());
              }
            }
            _calculateResult();
            _recalculateMergedFrames();
          });
        } else {
          setState(() {
            _rolls.add(pinsDown);
            _rollStates.add(result);
            _calculateResult();
            _recalculateMergedFrames();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/'); // 返回主頁面
            }
          },
        ),
        title: const Text('計分開發測試'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppStandardButton.secondary(
              onPressed: () {
                setState(() {
                  _showPinVisualization = !_showPinVisualization;
                });
              },
              text: _showPinVisualization ? 'Hide Pins' : 'Show Pins',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppStandardButton.destructive(
              onPressed: _resetAllData,
              text: 'Reset',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppStandardButton(
              onPressed: () {
                setState(() {
                  _isEditMode = !_isEditMode;
                });
              },
              text: _isEditMode ? 'Done' : 'Edit',
            ),
          ),
        ],
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
            // 回到原本的分離式設計
            const SizedBox(height: 8),
            ScoringBoard(
              title: null,
              frames: _framesMerged,
              onFrameTapped: _onMergedFrameTapped,
              showThirdBallInTenthFrame: _selectedMode != 'Current',
              singleRow: true,
              frameAspectRatio: 0.78,
              removeOuterContainer: true,
              padding: EdgeInsets.zero,
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
              isSplitPerFrame: List<bool>.generate(10, (i) {
                final List<bool> firstRoll = PinVisualizationHelper.getFramePinStates(
                  rolls: i < 9 ? _rolls19 : _rolls,
                  rollStates: i < 9 ? _rollStates19 : _rollStates,
                  frameIndex: i,
                );
                return SplitDetector.isSplit(firstRoll);
              }),
            ),
            // 原本的球瓶視覺化組件
            if (_showPinVisualization)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  children: _buildPinVisualizationRow(),
                ),
              ),
            
          ],
        ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: AppStandardButton.secondary(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/'); // 返回主頁面
                      }
                    },
                    text: '返回',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppStandardButton.destructive(
                    onPressed: _resetAllData,
                    text: '重置所有記錄',
                  ),
                ),
              ],
            ),
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

