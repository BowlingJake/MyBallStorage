import 'package:flutter/material.dart';
// 假設您的 PinSelectorPopupWidget 在 lib/widgets/dialogs/
import '../widgets/pin_selector_popup_widget.dart';
// 1. 匯入您儲存的 ScoreFrameWidget
//    假設您的 ScoreFrameWidget.dart 在 lib/widgets/
import '../widgets/bowling_score_table.dart';


class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  Set<int>? _pinsSelectedInLastThrow;
  Set<int> _pinsAlreadyDownForNextThrow = {};

  // 計分資料
  final List<Map<String, dynamic>> _frameScores = List.generate(
    10,
    (index) => {
      'ball1': (index % 4 == 0) ? "X" : "7",
      'ball2': (index % 4 == 0) ? "" : ((index % 4 == 1) ? "/" : "2"),
      'ball3': (index == 9) ? ((index % 2 == 0) ? "X" : "9") : null,
      'total': ((index + 1) * ((index == 9) ? 28 : 20) - (index * 5)).toString(),
    },
  );

  Future<void> _showPinSelector(BuildContext context) async {
    final Set<int>? pinsHitThisThrow = await showDialog<Set<int>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PinSelectorPopupWidget(
          initialPinsDown: _pinsAlreadyDownForNextThrow,
          pinStandingAssetPath: 'assets/images/pin_standing.svg', // 請確認路徑
          pinFallenAssetPath: 'assets/images/pin_fallen.svg',     // 請確認路徑
        );
      },
    );

    if (mounted) {
      if (pinsHitThisThrow != null) {
        setState(() {
          _pinsSelectedInLastThrow = pinsHitThisThrow;
        });
        print('本球次擊倒 (彈窗回傳): $pinsHitThisThrow');
      } else {
        print('瓶位選擇已取消');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('訓練模式 (自適應計分格)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BowlingScoreTable(),
          ),
          const Divider(), // 分隔線
          Expanded( // 讓底下的 Column 填滿剩餘空間
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '模擬：下一球前已倒瓶號: ${_pinsAlreadyDownForNextThrow.isEmpty ? "無" : (_pinsAlreadyDownForNextThrow.toList()..sort()).join(", ")}',
                       textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _showPinSelector(context);
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                      child: const Text('選擇本球擊倒瓶位 (測試彈窗)', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                    if (_pinsSelectedInLastThrow != null && _pinsSelectedInLastThrow!.isNotEmpty)
                      Text(
                        '彈窗回傳: ${(_pinsSelectedInLastThrow!.toList()..sort()).join(", ")} (${_pinsSelectedInLastThrow!.length} 瓶)',
                        style: const TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    else if (_pinsSelectedInLastThrow != null && _pinsSelectedInLastThrow!.isEmpty)
                      const Text(
                        '彈窗回傳: 本球次無擊倒',
                        style: TextStyle(fontSize: 16, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                      )
                    else
                      const Text(
                        '彈窗結果將顯示於此',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                       onPressed: () {
                        setState(() {
                          if (_pinsAlreadyDownForNextThrow.isEmpty) {
                            _pinsAlreadyDownForNextThrow = {1, 3, 5, 7};
                          } else if (_pinsAlreadyDownForNextThrow.length < 9) {
                            for (int i = 1; i <= 10; i++) {
                              if (!_pinsAlreadyDownForNextThrow.contains(i)) {
                                _pinsAlreadyDownForNextThrow.add(i);
                                break;
                              }
                            }
                          } else {
                            _pinsAlreadyDownForNextThrow.clear();
                          }
                          _pinsSelectedInLastThrow = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: Text(
                        _pinsAlreadyDownForNextThrow.isEmpty ? '模擬第一球倒瓶 (設定)' : '改變/清除模擬倒瓶',
                        style: const TextStyle(color: Colors.white)
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
