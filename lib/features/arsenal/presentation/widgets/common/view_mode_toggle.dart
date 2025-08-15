import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:core_theme/core_theme.dart';

class ViewModeToggle extends ConsumerWidget {
  const ViewModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final primaryColor = Theme.of(context).brightness == Brightness.dark
        ? BrandColors.accentColorDark
        : BrandColors.accentColorLight;
        
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor.withOpacity(0.6), width: 1.5), // 使用主要色
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewModeButton(
            icon: Iconsax.grid_1,
            isSelected: arsenalState.viewMode == ArsenalViewMode.grid,
            primaryColor: primaryColor, // 傳遞主要色
            onTap: () => ref.read(newArsenalControllerProvider.notifier).setViewMode(ArsenalViewMode.grid),
          ),
          _ViewModeButton(
            icon: Iconsax.element_equal,
            isSelected: arsenalState.viewMode == ArsenalViewMode.list,
            primaryColor: primaryColor, // 傳遞主要色
            onTap: () => ref.read(newArsenalControllerProvider.notifier).setViewMode(ArsenalViewMode.list),
          ),
        ],
      ),
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  const _ViewModeButton({
    required this.icon, 
    required this.isSelected, 
    required this.primaryColor,
    required this.onTap
  });
  
  final IconData icon;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.2) : Colors.transparent, // 選中時使用主要色背景
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon, 
          size: 18, 
          color: isSelected ? primaryColor : Colors.white, // 選中時使用主要色，未選中用白色
        ),
      ),
    );
  }
}

