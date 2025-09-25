import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/appbar/management_section.dart';

class ArsenalManagementSection extends ConsumerWidget {
  final List<Color> bagColors;
  final VoidCallback onShowMoreOptions;

  const ArsenalManagementSection({
    super.key,
    required this.bagColors,
    required this.onShowMoreOptions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Always show the management section, selection mode is handled in bottom nav
    return ManagementSection(
      getSelectedBagText: (state) => '', // Remove redundant viewing text
      onMore: onShowMoreOptions,
    );
  }
}