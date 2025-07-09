import 'package:flutter/material.dart';

/// 簡單的倒瓶數量選擇器
/// 用來替代複雜的 pin selector，直接選擇倒瓶數量（1-10）
class SimplePinsDownSelector extends StatefulWidget {
  const SimplePinsDownSelector({
    super.key,
    required this.maxPins,
    this.initialPinsDown = 0,
  });

  final int maxPins; // 可選擇的最大倒瓶數
  final int initialPinsDown; // 初始選擇的倒瓶數

  @override
  State<SimplePinsDownSelector> createState() => _SimplePinsDownSelectorState();
}

class _SimplePinsDownSelectorState extends State<SimplePinsDownSelector> {
  int? _selectedPinsDown;

  @override
  void initState() {
    super.initState();
    _selectedPinsDown = widget.initialPinsDown > 0 ? widget.initialPinsDown : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(
        '選擇倒瓶數量',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 400),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: widget.maxPins + 1, // 包括 0 瓶
          itemBuilder: (context, index) {
            final pinsDown = index;
            final isSelected = _selectedPinsDown == pinsDown;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPinsDown = pinsDown;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected 
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    pinsDown.toString(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isSelected 
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _selectedPinsDown != null
            ? () => Navigator.of(context).pop(_selectedPinsDown)
            : null,
          child: const Text('確定'),
        ),
      ],
    );
  }
} 