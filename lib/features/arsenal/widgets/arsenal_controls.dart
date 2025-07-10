import 'package:bowlingarsenal_app/features/arsenal/models/ball_bag_type.dart';
import 'package:bowlingarsenal_app/features/arsenal/providers/arsenal_providers.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/ball_bag_options_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class ArsenalControls extends ConsumerWidget {
  const ArsenalControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedBagType = ref.watch(selectedBagTypeProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ball Bag',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Bag selector dropdown
              Expanded(
                flex: 3,
                child: _buildModernDropdown(
                  theme,
                  selectedBagType,
                  ref,
                ),
              ),
              const SizedBox(width: 12),
              // Create ball bag button
              Expanded(
                flex: 2,
                child: _buildCreateBagButton(theme, context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernDropdown(
    ThemeData theme,
    BallBagType selectedBagType,
    WidgetRef ref,
  ) {
    return DropdownButtonHideUnderline(
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
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        onChanged: (BallBagType? value) {
          if (value != null) {
            ref.read(selectedBagTypeProvider.notifier).state = value;
          }
        },
        isExpanded: true,
        buttonStyleData: ButtonStyleData(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.5),
              width: 1.5,
            ),
            color: Colors.transparent, // 透明背景
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Iconsax.arrow_down_1,
            color: theme.colorScheme.primary,
            size: 16,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface.withOpacity(0.95),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          offset: const Offset(0, 4),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildCreateBagButton(
    ThemeData theme,
    BuildContext context,
    WidgetRef ref,
  ) {
    return SizedBox(
      height: 40,
      child: OutlinedButton.icon(
        onPressed: () {
          _showBallBagOptionsDialog(context, ref);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface.withOpacity(0.2), // 霧化玻璃背景
          side: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.7),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          elevation: 0,
        ),
        icon: Icon(
          Iconsax.add_circle,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        label: Text(
          'Create Bag',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void _showBallBagOptionsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return const BallBagOptionsDialog();
      },
    );
  }
} 