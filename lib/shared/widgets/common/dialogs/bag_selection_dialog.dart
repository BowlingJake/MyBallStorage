import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart' as up;
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:bowlingarsenal_app/shared/services/bag_color_service.dart';
import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

Future<List<int>?> showBagSelectionDialog({
  required BuildContext context,
  required up.UserProfile profile,
  String title = 'Add to Arsenal',
  String? subtitle,
}) async {
  final unlockedBags = profile.unlockedBags;
  final selectedBags = <int>{1};
  // 使用統一的袋子顏色服務
  final bagColors = BagColorService.getAllBagColors();

  final List<int>? result = await showDialog<List<int>>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BrandColors.accentColorDark, width: 1.5),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      // 可滾動的袋子列表
                      Flexible(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                            scrollbars: false, // 隱藏滾動條，符合手機設計規範
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: unlockedBags.length,
                            itemBuilder: (context, index) {
                              final bagInfo = unlockedBags[index];
                              final isSelected = selectedBags.contains(bagInfo.number);
                              final bagColor = bagColors[bagInfo.number - 1];
                              final bagText = bagInfo.number == 1 ? '${bagInfo.name} (Required)' : bagInfo.name;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: AppStandardButton(
                                  text: bagText,
                                  height: DialogDefaults.buttonHeight,
                                  fontSize: DialogDefaults.buttonFontSize,
                                  width: double.infinity,
                                  backgroundColor: isSelected ? bagColor : null,
                                  outlineColor: isSelected ? bagColor : Colors.white.withOpacity(0.6),
                                  foregroundColor: isSelected ? Colors.black : Colors.white.withOpacity(0.9),
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
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppStandardButton(
                              text: 'Cancel',
                              height: DialogDefaults.buttonHeight,
                              fontSize: DialogDefaults.buttonFontSize,
                              outlineColor: Colors.white.withOpacity(0.6),
                              foregroundColor: Colors.white.withOpacity(0.9),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppStandardButton(
                              text: 'Add',
                              height: DialogDefaults.buttonHeight,
                              fontSize: DialogDefaults.buttonFontSize,
                              outlineColor: Colors.white.withOpacity(0.6),
                              foregroundColor: Colors.white.withOpacity(0.9),
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
          );
        },
      );
    },
  );

  return result;
}


