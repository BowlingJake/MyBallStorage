import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/components/frame_10_calculator.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/components/current_frame_10_calculator.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/components/traditional_frame_10_calculator.dart';
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

  @override
  void initState() {
    super.initState();
    _pinController = PinSelectionController();
    _updateCalculator();
  }

  void _updateCalculator() {
    _calculator = _selectedMode == 'Current' 
        ? CurrentFrame10Calculator()
        : TraditionalFrame10Calculator();
    _calculateResult();
  }

  void _calculateResult() {
    if (_calculator != null && _rolls.isNotEmpty) {
      _result = _calculator!.calculate(_rolls, 0, 270); // 假設前9格270分
    } else {
      _result = null;
    }
  }

  void _addRoll() async {
    // 檢查是否還能繼續投球
    if (!_canAddMoreRolls()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('第10格已完成，無法再投球'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 計算當前應該顯示的球瓶狀態
    final List<bool>? initialPinState = _getInitialPinState();
    final bool isLogicalFirstRoll = _isLogicalFirstRoll(initialPinState);
    
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
      });
    }
  }

  /// 計算到第 index 球後的累積球瓶狀態
  List<bool> _calculateCumulativeState(int index) {
    if (index < 0 || index >= _rollStates.length) {
      return List.generate(10, (_) => false); // 全部站著
    }

    // 對於第10格Traditional模式的邏輯
    if (_selectedMode == 'Traditional') {
      return _calculateTraditionalCumulativeState(index);
    } else {
      return _calculateCurrentCumulativeState(index);
    }
  }

  List<bool> _calculateTraditionalCumulativeState(int index) {
    // 第一球：直接返回狀態
    if (index == 0) {
      return _rollStates[0];
    }
    
    // 第二球
    if (index == 1) {
      final firstRoll = _rolls[0];
      if (firstRoll == 10) {
        // 第一球Strike：第二球是新開始，直接返回第二球狀態
        return _rollStates[1];
      } else {
        // 第一球非Strike：第二球累積到第一球
        return _combineStates(_rollStates[0], _rollStates[1]);
      }
    }
    
    // 第三球
    if (index == 2) {
      final firstRoll = _rolls[0];
      final secondRoll = _rolls[1];
      
      if (firstRoll == 10) {
        // 第一球Strike的情況
        if (secondRoll == 10) {
          // 第二球也Strike：第三球新開始
          return _rollStates[2];
        } else {
          // 第二球非Strike：第三球累積到第二球
          return _combineStates(_rollStates[1], _rollStates[2]);
        }
      } else if (firstRoll + secondRoll == 10) {
        // 第一二球Spare：第三球新開始
        return _rollStates[2];
      } else {
        // Open：不應該有第三球
        return _rollStates[2];
      }
    }
    
    return List.generate(10, (_) => false);
  }

  List<bool> _calculateCurrentCumulativeState(int index) {
    // Current模式邏輯簡單：第二球總是累積到第一球
    if (index == 0) {
      return _rollStates[0];
    } else if (index == 1) {
      return _combineStates(_rollStates[0], _rollStates[1]);
    }
    
    return List.generate(10, (_) => false);
  }

  /// 合併兩個球瓶狀態（OR運算）
  List<bool> _combineStates(List<bool> state1, List<bool> state2) {
    return List.generate(10, (i) => state1[i] || state2[i]);
  }

  /// 判斷這一球在邏輯上是否為「第一球」
  bool _isLogicalFirstRoll(List<bool>? initialPinState) {
    // 如果沒有初始狀態，肯定是第一球
    if (initialPinState == null) return true;
    
    // 如果所有球瓶都站著，在邏輯上就是第一球
    // 這包括：真正的第一球、Strike後的重新開始、Spare後的重新開始
    final allStanding = initialPinState.every((pin) => !pin);
    if (allStanding) return true;
    
    // 其他情況（有部分球瓶倒下）是第二球
    return false;
  }

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

  /// 根據當前投球狀況計算初始球瓶狀態
  List<bool>? _getInitialPinState() {
    if (_rolls.isEmpty) {
      // 第一球：所有球瓶都站著
      return null;
    }

    // 根據第10格的規則來決定
    if (_selectedMode == 'Current') {
      return _getCurrentModeInitialState();
    } else {
      return _getTraditionalModeInitialState();
    }
  }

  List<bool>? _getCurrentModeInitialState() {
    if (_rolls.length == 1) {
      final firstRoll = _rolls[0];
      if (firstRoll == 10) {
        // Strike：遊戲結束，不需要第二球
        return null;
      } else {
        // 非Strike：根據第一球的狀態設置第二球
        return _rollStates[0];
      }
    }
    // Current模式最多2球
    return null;
  }

  List<bool>? _getTraditionalModeInitialState() {
    if (_rolls.length == 1) {
      final firstRoll = _rolls[0];
      if (firstRoll == 10) {
        // Strike：第二球重新開始（所有球瓶重設）
        return List.generate(10, (index) => false);
      } else {
        // 非Strike：根據第一球的狀態設置第二球
        return _rollStates[0];
      }
    } else if (_rolls.length == 2) {
      final firstRoll = _rolls[0];
      final secondRoll = _rolls[1];
      
      if (firstRoll == 10) {
        // 第一球是Strike，第二球的結果決定第三球
        if (secondRoll == 10) {
          // 第二球也是Strike：第三球重新開始
          return List.generate(10, (index) => false);
        } else {
          // 第二球不是Strike：第三球根據第二球狀態
          return _rollStates[1];
        }
      } else if (firstRoll + secondRoll == 10) {
        // Spare：第三球重新開始
        return List.generate(10, (index) => false);
      } else {
        // Open：遊戲結束，不需要第三球
        return null;
      }
    }
    
    return null;
  }

  void _clearRolls() {
    setState(() {
      _rolls.clear();
      _rollStates.clear();
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('第10格計分測試'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),

            // 投球記錄
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '投球記錄',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _rolls.isEmpty ? '無記錄' : _rolls.join(', '),
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (_rollStates.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        '球瓶狀態：',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      ..._rollStates.asMap().entries.map((entry) {
                        final index = entry.key;
                        final cumulativeState = _calculateCumulativeState(index);
                        final standingPins = <int>[];
                        for (int i = 0; i < cumulativeState.length; i++) {
                          if (!cumulativeState[i]) standingPins.add(i + 1);
                        }
                        return Text(
                          '第${index + 1}球後: 剩餘球瓶 ${standingPins.isEmpty ? "無" : standingPins.join(", ")}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        );
                      }),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        AppStandardButton.creative(
                          text: '新增投球',
                          onPressed: _addRoll,
                        ),
                        const SizedBox(width: 8),
                        AppStandardButton.destructive(
                          text: '清除',
                          onPressed: _clearRolls,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 計算結果
            if (_result != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '第10格結果 (${_calculator!.modeName} 模式)',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildFrameDisplay(),
                      const SizedBox(height: 16),
                      Text('分數: ${_result!.score}'),
                      Text('使用球數: ${_result!.rollsUsed}'),
                      Text('是否完成: ${_result!.isComplete ? "是" : "否"}'),
                      if (_calculator != null)
                        Text('需要球數: ${_calculator!.getRequiredRollsCount(_rolls, 0)}'),
                    ],
                  ),
                ),
              ),
          ],
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

