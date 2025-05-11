import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:collection'; // For HashSet
import 'primary_button.dart';
import '../theme/text_styles.dart';

class PinSelectorPopupWidget extends StatefulWidget {
  final Set<int> initialPinsDown; // 本球次前已倒的瓶號 (1-10)
  final String pinStandingAssetPath;
  final String pinFallenAssetPath;
  final double pinSize;
  final double pinVisualSpacingFactor;

  const PinSelectorPopupWidget({
    super.key,
    this.initialPinsDown = const {},
    required this.pinStandingAssetPath,
    required this.pinFallenAssetPath,
    this.pinSize = 40.0,
    this.pinVisualSpacingFactor = 2.4, // 使用者提供的數值
  });

  @override
  State<PinSelectorPopupWidget> createState() => _PinSelectorPopupWidgetState();
}

class _PinSelectorPopupWidgetState extends State<PinSelectorPopupWidget> {
  late HashSet<int> _newlySelectedPins; // 本次互動中新選擇的瓶子
  final Map<int, GlobalKey> _pinKeys = {}; // 儲存每個瓶子的 GlobalKey
  final Set<int> _swipedPinsInCurrentGesture = {}; // 追蹤單次滑動中已觸發的瓶子

  @override
  void initState() {
    super.initState();
    _newlySelectedPins = HashSet<int>();
    // 為 1 到 10 號瓶初始化 GlobalKey
    for (int i = 1; i <= 10; i++) {
      _pinKeys[i] = GlobalKey(debugLabel: 'PinKey_$i');
    }
  }

  void _togglePinSelection(int pinNumber, {bool fromSwipe = false}) {
    if (widget.initialPinsDown.contains(pinNumber)) return; // 不可更改初始已倒的瓶

    if (fromSwipe) {
      if (_swipedPinsInCurrentGesture.contains(pinNumber)) {
        return; // 在本次滑動中此瓶已被處理
      }
      _swipedPinsInCurrentGesture.add(pinNumber); // 標記此瓶在本次滑動中已被處理
    }

    setState(() {
      if (_newlySelectedPins.contains(pinNumber)) {
        _newlySelectedPins.remove(pinNumber);
      } else {
        _newlySelectedPins.add(pinNumber);
      }
    });
  }

  Widget _buildPin(int pinNumber) {
    final GlobalKey pinKey = _pinKeys[pinNumber]!; // 獲取此瓶的 GlobalKey
    final bool isInitiallyDown = widget.initialPinsDown.contains(pinNumber);
    final bool isNewlySelected = _newlySelectedPins.contains(pinNumber);
    final bool isEffectivelyDown = isInitiallyDown || isNewlySelected;
    final String assetPath = isEffectivelyDown ? widget.pinFallenAssetPath : widget.pinStandingAssetPath;

    return GestureDetector(
      key: pinKey, // 將 GlobalKey 指派給 GestureDetector
      onTap: isInitiallyDown ? null : () => _togglePinSelection(pinNumber),
      // 使用 Behavior.opaque 確保即使是透明區域也能接收點擊，對於滑動偵測可能也有幫助
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: isInitiallyDown ? 0.6 : 1.0,
        child: SvgPicture.asset(
          assetPath,
          width: widget.pinSize,
          height: widget.pinSize,
          placeholderBuilder: (BuildContext context) => Container(
            width: widget.pinSize,
            height: widget.pinSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.red)),
            child: Text(pinNumber.toString(), style: TextStyle(fontSize: widget.pinSize * 0.4, color: Colors.red))
          ),
        ),
      ),
    );
  }

  Widget _buildPinRow(List<int> pinNumbers, {double leftPaddingPins = 0.0}) {
    double actualLeftPadding = leftPaddingPins * widget.pinSize * widget.pinVisualSpacingFactor;
    return Padding(
      padding: EdgeInsets.only(left: actualLeftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: pinNumbers.map((pin) {
          double horizontalPinPadding = (widget.pinSize * widget.pinVisualSpacingFactor - widget.pinSize) / 2;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPinPadding.clamp(0, widget.pinSize / 2)),
            child: _buildPin(pin), // 直接傳遞瓶號
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<List<int>> pinLayout = [ [7, 8, 9, 10], [4, 5, 6], [2, 3], [1] ];
    // 使用者提供的數值
    final List<double> rowLeftPaddingsInPinUnits = [0.0, 0.1, 0.1, 0.1];

    return AlertDialog(
      title: const Text('選擇擊倒的球瓶', style: AppTextStyles.title),
      content: SingleChildScrollView( // 確保內容過多時可以滾動
        child: GestureDetector( // 包裹 Column 以偵測滑動
          onPanStart: (details) {
            _swipedPinsInCurrentGesture.clear(); // 開始新的滑動時，清除已觸發的瓶子記錄
          },
          onPanUpdate: (details) {
            // 遍歷所有瓶子的 GlobalKey
            for (var entry in _pinKeys.entries) {
              final int pinNumber = entry.key;
              final GlobalKey pinKey = entry.value;

              if (pinKey.currentContext != null) {
                final RenderBox renderBox = pinKey.currentContext!.findRenderObject() as RenderBox;
                // 獲取瓶子在螢幕上的絕對位置和大小
                final Offset globalPinPosition = renderBox.localToGlobal(Offset.zero);
                final Rect pinGlobalRect = globalPinPosition & renderBox.size;

                // 檢查當前手指的全域位置是否在該瓶子的矩形區域內
                if (pinGlobalRect.contains(details.globalPosition)) {
                  _togglePinSelection(pinNumber, fromSwipe: true);
                }
              }
            }
          },
          onPanEnd: (details) {
            _swipedPinsInCurrentGesture.clear(); // 滑動結束時，清除已觸發的瓶子記錄
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < pinLayout.length; i++)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: (widget.pinSize * widget.pinVisualSpacingFactor - widget.pinSize) / 3),
                  child: _buildPinRow(pinLayout[i], leftPaddingPins: rowLeftPaddingsInPinUnits[i]),
                ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        // 新增快速選擇按鈕
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _newlySelectedPins = HashSet<int>.from(List.generate(10, (i) => i + 1));
                });
              },
              child: const Text('全倒', style: AppTextStyles.button),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _newlySelectedPins = HashSet<int>.from(List.generate(9, (i) => i + 1)); // 1~9
                });
              },
              child: const Text('留10號', style: AppTextStyles.button),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _newlySelectedPins = HashSet<int>.from([1,2,3,4,5,6,8,9,10]); // 7號不倒
                });
              },
              child: const Text('留7號', style: AppTextStyles.button),
            ),
          ],
        ),
        // 原有重設按鈕
        TextButton(
          child: const Text('重設本次', style: AppTextStyles.button),
          onPressed: () {
            setState(() {
              _newlySelectedPins.clear();
              _swipedPinsInCurrentGesture.clear(); // 重設時也清除滑動記錄
            });
          },
        ),
        // 原有取消/確定
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              child: const Text('取消', style: AppTextStyles.button),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 8),
            MyCustomButton(
              text: '確定',
              onPressed: () => Navigator.of(context).pop(HashSet<int>.from(_newlySelectedPins)),
            ),
          ],
        ),
      ],
    );
  }
}
