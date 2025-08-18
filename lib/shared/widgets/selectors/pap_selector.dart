import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

/// PAP值選擇結果
class PapSelectorResult {
  final int? integer;
  final String? fraction1;
  final PapDirection direction;
  final String? fraction2;

  const PapSelectorResult({
    this.integer,
    this.fraction1,
    required this.direction,
    this.fraction2,
  });

  @override
  String toString() {
    final parts = <String>[];
    
    if (integer != null) {
      parts.add(integer.toString());
    }
    
    if (fraction1 != null) {
      parts.add(fraction1!);
    }
    
    if (direction != PapDirection.none) {
      parts.add(direction.symbol);
      if (fraction2 != null) {
        parts.add(fraction2!);
      }
    }
    
    return parts.isEmpty ? 'Not set' : parts.join(' ');
  }
}

/// PAP方向枚舉
enum PapDirection {
  none, // 空白選項 (0)
  up,   // 向上 (1)
  down; // 向下 (-1)

  String get symbol {
    switch (this) {
      case PapDirection.up:
        return '↑';
      case PapDirection.down:
        return '↓';
      case PapDirection.none:
        return '';
    }
  }

  int get value {
    switch (this) {
      case PapDirection.up:
        return 1;
      case PapDirection.down:
        return -1;
      case PapDirection.none:
        return 0;
    }
  }

  static PapDirection fromValue(int? value) {
    switch (value) {
      case 1:
        return PapDirection.up;
      case -1:
        return PapDirection.down;
      default:
        return PapDirection.none;
    }
  }
}

/// PAP選擇器底部彈窗
class PapSelector extends StatefulWidget {
  final int? initialInteger;
  final String? initialFraction1;
  final PapDirection initialDirection;
  final String? initialFraction2;
  final Function(PapSelectorResult) onChanged;

  const PapSelector({
    super.key,
    this.initialInteger,
    this.initialFraction1,
    this.initialDirection = PapDirection.none,
    this.initialFraction2,
    required this.onChanged,
  });

  @override
  State<PapSelector> createState() => _PapSelectorState();
}

class _PapSelectorState extends State<PapSelector> {
  late FixedExtentScrollController _integerController;
  late FixedExtentScrollController _fraction1Controller;
  late FixedExtentScrollController _directionController;
  late FixedExtentScrollController _fraction2Controller;

  // 選項數據
  final List<int?> integers = [null, ...List.generate(7, (i) => i)]; // null, 0-6
  final List<String?> fractions = [
    null, '1/8', '1/4', '3/8', '1/2', '5/8', '3/4', '7/8'
  ];
  final List<PapDirection> directions = PapDirection.values;

  // 當前選中的值
  late int? selectedInteger;
  late String? selectedFraction1;
  late PapDirection selectedDirection;
  late String? selectedFraction2;

  @override
  void initState() {
    super.initState();
    
    // 初始化當前值
    selectedInteger = widget.initialInteger;
    selectedFraction1 = widget.initialFraction1;
    selectedDirection = widget.initialDirection;
    selectedFraction2 = widget.initialFraction2;
    
    // 初始化控制器到正確位置
    _integerController = FixedExtentScrollController(
      initialItem: integers.indexOf(selectedInteger),
    );
    _fraction1Controller = FixedExtentScrollController(
      initialItem: fractions.indexOf(selectedFraction1),
    );
    _directionController = FixedExtentScrollController(
      initialItem: directions.indexOf(selectedDirection),
    );
    _fraction2Controller = FixedExtentScrollController(
      initialItem: fractions.indexOf(selectedFraction2),
    );
  }

  @override
  void dispose() {
    _integerController.dispose();
    _fraction1Controller.dispose();
    _directionController.dispose();
    _fraction2Controller.dispose();
    super.dispose();
  }

  void _onSelectionChanged() {
    final result = PapSelectorResult(
      integer: selectedInteger,
      fraction1: selectedFraction1,
      direction: selectedDirection,
      fraction2: selectedFraction2,
    );
    widget.onChanged(result);
  }

  Widget _buildPicker({
    required String title,
    required List<dynamic> items,
    required FixedExtentScrollController controller,
    required Function(int)? onSelectedItemChanged, // 改為nullable
    required String Function(dynamic) displayText,
    bool isDisabled = false, // 添加禁用參數
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDisabled ? Colors.grey[600] : Colors.white, // 改回白色
              fontSize: 18, // 從16增大到18
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Expanded( // 使用 Expanded 而非固定高度
            child: AbsorbPointer( // 禁用時阻止觸摸
              absorbing: isDisabled,
              child: Opacity( // 禁用時降低透明度
                opacity: isDisabled ? 0.4 : 1.0,
                child: CupertinoPicker(
                  scrollController: controller,
                  itemExtent: 44, // 增大項目高度
                  onSelectedItemChanged: onSelectedItemChanged,
                  children: items.map((item) => Center(
                    child: Text(
                      displayText(item),
                      style: TextStyle(
                        color: isDisabled ? Colors.grey[600] : Colors.white, // 改回白色
                        fontSize: 24, // 從20增大到24
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6, // 高度到螢幕中間以上
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black, // 不透明黑色背景
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary, // 主要色線框
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // 只保留關閉按鈕，移除標題
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 10), // 減少頂部間距

          // 滾動選擇器 - 擴展以填充可用空間
          Expanded(
            child: Row(
              children: [
                _buildPicker(
                  title: 'Integer',
                  items: integers,
                  controller: _integerController,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedInteger = integers[index];
                    });
                    _onSelectionChanged();
                  },
                  displayText: (item) => item?.toString() ?? '-',
                ),
                const SizedBox(width: 12),
                _buildPicker(
                  title: 'Fraction',
                  items: fractions,
                  controller: _fraction1Controller,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedFraction1 = fractions[index];
                    });
                    _onSelectionChanged();
                  },
                  displayText: (item) => item ?? '-',
                ),
                const SizedBox(width: 12),
                _buildPicker(
                  title: 'Direction',
                  items: directions,
                  controller: _directionController,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedDirection = directions[index];
                      // 當Direction選擇none時，將Drift設為null並滾動到第一項
                      if (selectedDirection == PapDirection.none) {
                        selectedFraction2 = null;
                        _fraction2Controller.jumpToItem(0); // 跳到第一項(null)
                      }
                    });
                    _onSelectionChanged();
                  },
                  displayText: (item) => item.symbol.isEmpty ? '-' : item.symbol,
                ),
                const SizedBox(width: 12),
                _buildPicker(
                  title: 'Drift',
                  items: fractions,
                  controller: _fraction2Controller,
                  onSelectedItemChanged: selectedDirection == PapDirection.none 
                      ? null // 當Direction是none時禁用
                      : (index) {
                          setState(() {
                            selectedFraction2 = fractions[index];
                          });
                          _onSelectionChanged();
                        },
                  displayText: (item) => item ?? '-',
                  isDisabled: selectedDirection == PapDirection.none, // 當Direction是none時禁用
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 按鈕
          Row(
            children: [
              Expanded(
                child: AppStandardButton.secondary(
                  onPressed: () => Navigator.pop(context),
                  text: 'Cancel',
                  height: 48, // 增大按鈕高度
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppStandardButton(
                  onPressed: () {
                    Navigator.pop(context, PapSelectorResult(
                      integer: selectedInteger,
                      fraction1: selectedFraction1,
                      direction: selectedDirection,
                      fraction2: selectedFraction2,
                    ));
                  },
                  text: 'Confirm',
                  height: 48, // 增大按鈕高度
                ),
              ),
            ],
          ),
          
          // 為底部安全區域添加額外空間
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

/// 顯示PAP選擇器的便利方法
Future<PapSelectorResult?> showPapSelector(
  BuildContext context, {
  int? initialInteger,
  String? initialFraction1,
  PapDirection initialDirection = PapDirection.none,
  String? initialFraction2,
}) {
  return showModalBottomSheet<PapSelectorResult>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => PapSelector(
      initialInteger: initialInteger,
      initialFraction1: initialFraction1,
      initialDirection: initialDirection,
      initialFraction2: initialFraction2,
      onChanged: (result) {
        // 即時預覽更新
      },
    ),
  );
}