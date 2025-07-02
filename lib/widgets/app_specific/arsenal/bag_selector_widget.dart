import 'package:flutter/material.dart';
import '../../../models/ball_bag_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:bowlingarsenal_app/viewmodels/my_arsenal_viewmodel.dart';
import 'package:bowlingarsenal_app/providers/providers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

/// 球袋選擇器 Widget，參考 Ball Library filter 樣式
class BagSelectorWidget extends ConsumerWidget {
  final BallBagType selectedBagType;
  final ValueChanged<BallBagType?> onChanged;

  const BagSelectorWidget({
    super.key,
    required this.selectedBagType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Text(
            'Ball Bag',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<BallBagType>(
                value: selectedBagType,
                hint: Text(
                  '選擇球袋',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                items: BallBagType.values.map((bagType) {
                  return DropdownMenuItem<BallBagType>(
                    value: bagType,
                    child: Text(
                      bagType.displayName,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                isExpanded: true,
                buttonStyleData: ButtonStyleData(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.5),
                      width: 1,
                    ),
                    color: theme.colorScheme.surface,
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  offset: const Offset(0, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStateProperty.all(6),
                    thumbVisibility: WidgetStateProperty.all(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 36,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 