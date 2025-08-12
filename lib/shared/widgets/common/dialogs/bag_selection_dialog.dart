import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart' as up;
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';

Future<List<int>?> showBagSelectionDialog({
  required BuildContext context,
  required up.UserProfile profile,
  String title = 'Add to Arsenal',
  String? subtitle,
}) async {
  final unlockedBags = profile.unlockedBags;
  final selectedBags = <int>{1};
  final bagColors = <Color>[
    Colors.orange,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.cyan,
    Colors.white,
    Colors.brown,
  ];

  return showDialog<List<int>>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BrandColors.accentColorDark, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                ],
                const SizedBox(height: 16),
                Text('Select which bags to add:', style: TextStyle(color: Colors.grey[300], fontSize: 14)),
                const SizedBox(height: 12),
                ...unlockedBags.map((bagInfo) {
                  final isSelected = selectedBags.contains(bagInfo.number);
                  final bagColor = bagColors[bagInfo.number - 1];
                  final bagText = bagInfo.number == 1 ? '${bagInfo.name} (Required)' : bagInfo.name;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppStandardButton(
                      text: bagText,
                      height: 36,
                      width: double.infinity,
                      isPrimary: isSelected,
                      customColor: isSelected ? bagColor : null,
                      outlineColor: isSelected ? null : Colors.white,
                      foregroundColor: isSelected ? Colors.black : Colors.white,
                      onPressed: () {
                        if (bagInfo.number == 1) {
                          return;
                        }
                        setState(() {
                          if (isSelected) {
                            selectedBags.remove(bagInfo.number);
                          } else {
                            selectedBags.add(bagInfo.number);
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppStandardButton(
                        text: 'Cancel',
                        height: 36,
                        outlineColor: Colors.white,
                        foregroundColor: Colors.white,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        text: 'Add',
                        height: 36,
                        isPrimary: true,
                        customColor: BrandColors.accentColorDark,
                        whiteForeground: true,
                        onPressed: () => Navigator.of(context).pop(selectedBags.toList()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


