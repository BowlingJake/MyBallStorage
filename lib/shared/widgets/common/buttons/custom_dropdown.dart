// 檔案路徑： custom_dropdown.dart

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
// 'dart:ui' 不再需要，因為我們移除了 ImageFilter.blur

class CustomDropdown<T> extends StatelessWidget {
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool isFilled;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Text(
          hintText,
          style: TextStyle(fontSize: 14, color: Colors.grey[400]),
        ),
        items: items,
        value: value,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isFilled ? Colors.grey.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
        ),
        // *** 最終修改 ***
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            // 使用一個半透明的深色背景來取代模糊效果
            // 這樣在舊版本上也能有很好的視覺體驗
            color: const Color(0xFF2C3A4B).withOpacity(0.95), 
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          offset: const Offset(0, 8),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}