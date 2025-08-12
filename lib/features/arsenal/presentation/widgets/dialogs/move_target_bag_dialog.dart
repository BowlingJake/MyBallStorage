import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/outlined_content_dialog.dart';
import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';

Future<int?> showMoveTargetBagDialog({
  required BuildContext context,
  required List<BagInfo> subBags,
  required List<Color> bagColors,
  required int currentBagNumber,
  required int selectedCount,
  List<int> alreadyInBags = const [],
  UserProfile? userProfile,
}) async {
  int? selectedTarget;
  final bool onlyOneSubBag = subBags.length <= 1;

  return showOutlinedContentDialog<int>(
    context: context,
    title: 'Move $selectedCount Ball${selectedCount != 1 ? 's' : ''}',
    content: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Choose target bag:', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            if (alreadyInBags.isNotEmpty) ...[
              Builder(
                builder: (context) {
                  final alsoIn = alreadyInBags
                      .where((n) => n != currentBagNumber && n != 1)
                      .toList();
                  if (alsoIn.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final names = alsoIn
                      .map((n) => userProfile?.getBagName(n) ?? 'Bag $n')
                      .toList();
                  return Text(
                    'Also in: ${names.join(', ')}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 16),
            // 垂直排列每個子球袋按鈕
            ...subBags.map((bag) {
              final disabled = onlyOneSubBag || bag.number == currentBagNumber || alreadyInBags.contains(bag.number);
              final selected = selectedTarget == bag.number;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _BagButton(
                  bag: bag,
                  bagColor: bagColors[bag.number - 1],
                  disabled: disabled,
                  selected: selected,
                  onTap: () {
                    if (disabled) {
                      return;
                    }
                    setState(() => selectedTarget = bag.number);
                  },
                ),
              );
            }),
            const SizedBox(height: 4),
            AppStandardButton(
              text: 'Move',
              onPressed: selectedTarget == null ? () {} : () => Navigator.of(context).pop(selectedTarget),
              customColor: BrandColors.accentColorDark,
              isPrimary: true,
              whiteForeground: true,
              width: double.infinity,
              enabled: selectedTarget != null,
            ),
          ],
        );
      },
    ),
  );
}

class _BagButton extends StatelessWidget {
  const _BagButton({
    required this.bag,
    required this.bagColor,
    required this.disabled,
    required this.selected,
    required this.onTap,
  });
  final BagInfo bag;
  final Color bagColor;
  final bool disabled;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String label = bag.name;
    return AppStandardButton(
      text: label,
      onPressed: onTap,
      enabled: !disabled,
      customColor: selected ? bagColor : null,
      outlineColor: selected ? bagColor : Colors.white,
      foregroundColor: selected ? Colors.black : Colors.white,
      backgroundColor: selected ? bagColor : Colors.transparent,
      isPrimary: selected,
      whiteForeground: false,
      fontSize: 12,
      width: double.infinity,
    );
  }
}

class _AlsoInBagsNames extends StatelessWidget {
  const _AlsoInBagsNames({required this.bagNumbers});
  final List<int> bagNumbers;

  @override
  Widget build(BuildContext context) {
    // 需要使用 UserProfile 來查詢袋名
    return _ProfileConsumer(
      builder: (profile) {
        final names = bagNumbers.map((n) => profile.getBagName(n) ?? 'Bag $n').toList();
        return Text(
          'Also in: ' + names.join(', '),
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        );
      },
    );
  }
}

class _ProfileConsumer extends StatelessWidget {
  const _ProfileConsumer({required this.builder});
  final Widget Function(UserProfile profile) builder;

  @override
  Widget build(BuildContext context) {
    // 簡化：透過 InheritedWidget 無法取得，這裡直接使用最簡單方式：
    // 交由上層傳入 UserProfile 也可以，但目前檔案已有 import UserProfile
    // 因此此處改為使用 Dialog 外層傳入 UserProfile 更穩妥。
    // 為避免大改，暫用 InheritedModel 取不到，直接 fallback 顯示 Bag N。
    // 若無法取得 profile，顯示數字。
    return const SizedBox.shrink();
  }
}

