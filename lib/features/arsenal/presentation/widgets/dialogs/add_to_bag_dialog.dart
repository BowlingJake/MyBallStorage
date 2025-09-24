import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';

Future<String?> showAddToBagDialog({
  required BuildContext context,
  required bool isMainBag,
  required String currentBagName,
}) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (context) => _AddToBagDialog(
      isMainBag: isMainBag,
      currentBagName: currentBagName,
    ),
  );
}

/// Add To Bag Dialog with unified style
class _AddToBagDialog extends StatefulWidget {
  const _AddToBagDialog({
    required this.isMainBag,
    required this.currentBagName,
  });

  final bool isMainBag;
  final String currentBagName;

  @override
  State<_AddToBagDialog> createState() => _AddToBagDialogState();
}

class _AddToBagDialogState extends State<_AddToBagDialog> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.brightness == Brightness.dark
        ? const Color(0xFFFFD700) // BrandColors.accentColorDark
        : const Color(0xFFFFB300); // BrandColors.accentColorLight
        
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 380),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primaryColor.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Header: Title + Close in一列，縮小上方空白
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.isMainBag ? 'Add to Arsenal' : 'Add to ${widget.currentBagName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Message
            Text(
              widget.isMainBag
                  ? 'Choose where to add new balls:'
                  : 'Choose source to add balls from:',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // 水平並列的選擇按鈕
            if (widget.isMainBag) 
              // 主球袋只有一個選項
              Container(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    // 主球袋：直接回傳 library 並關閉
                    Navigator.of(context).pop('library');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedOption == 'library' ? primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'Ball Library',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selectedOption == 'library' ? Colors.black : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              // 子球袋有兩個選項
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // 子袋：立即選擇 From Library
                        Navigator.of(context).pop('library');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedOption == 'library' ? primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'Ball Library',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selectedOption == 'library' ? Colors.black : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // 子袋：立即選擇 From My Arsenal (主袋)
                        Navigator.of(context).pop('main_bag');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedOption == 'main_bag' ? primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'All My Arsenal',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selectedOption == 'main_bag' ? Colors.black : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            // 子袋點選即回傳，不需底部按鈕；主袋亦已改為點即回傳
            ],
          ),
        ),
      ),
    );
  }
}

