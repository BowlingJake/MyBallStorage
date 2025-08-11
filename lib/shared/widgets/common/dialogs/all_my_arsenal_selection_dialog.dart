import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:core_theme/core_theme.dart';

class AllMyArsenalSelectionDialog extends ConsumerStatefulWidget {
  const AllMyArsenalSelectionDialog({super.key});

  @override
  ConsumerState<AllMyArsenalSelectionDialog> createState() => _AllMyArsenalSelectionDialogState();
}

class _AllMyArsenalSelectionDialogState extends ConsumerState<AllMyArsenalSelectionDialog> {
  Set<int> _selectedInstanceIds = {};

  void _toggle(int id) {
    setState(() {
      if (_selectedInstanceIds.contains(id)) {
        _selectedInstanceIds.remove(id);
      } else {
        _selectedInstanceIds.add(id);
      }
    });
  }

  void _confirm() {
    Navigator.of(context).pop(_selectedInstanceIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final instances = arsenalState.allInstances; // All My Arsenal 列表

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[600]!, width: 1.5),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[600]!.withOpacity(0.3), width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'All My Arsenal',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: instances.isEmpty
                  ? const Center(
                      child: Text('No balls in All My Arsenal', style: TextStyle(color: Colors.white70)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: instances.length,
                      itemBuilder: (context, index) {
                        final instance = instances[index];
                        final isSelected = _selectedInstanceIds.contains(instance.id);
                        return GestureDetector(
                          onTap: () => _toggle(instance.id),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? BrandColors.accentColorDark.withOpacity(0.15) : Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? BrandColors.accentColorDark : Colors.grey[600]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // 簡化顯示：名稱 + 品牌
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(instance.displayName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      Text(instance.brandName, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle, color: BrandColors.accentColorDark),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Bottom actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[600]!.withOpacity(0.3), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppStandardButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStandardButton(
                      text: 'Add ${_selectedInstanceIds.length} Ball${_selectedInstanceIds.length != 1 ? 's' : ''}',
                      onPressed: _selectedInstanceIds.isEmpty ? () {} : _confirm,
                      customColor: BrandColors.accentColorDark,
                      isPrimary: true,
                      whiteForeground: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<int>?> showAllMyArsenalSelectionDialog(BuildContext context) {
  return showDialog<List<int>>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.8),
    builder: (BuildContext context) {
      return const AllMyArsenalSelectionDialog();
    },
  );
}

