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
}) async {
  int? selectedTarget;
  final bool onlyOneSubBag = subBags.length <= 1;

  return showOutlinedContentDialog<int>(
    context: context,
    title: 'Move $selectedCount Ball${selectedCount != 1 ? 's' : ''}',
    content: StatefulBuilder(
      builder: (context, setState) {
        List<Widget> buildGrid() {
          final List<Widget> rows = [];
          for (int i = 0; i < subBags.length; i += 2) {
            final first = subBags[i];
            final second = i + 1 < subBags.length ? subBags[i + 1] : null;

            rows.add(Row(
              children: [
                Expanded(child: _BagButton(
                  bag: first,
                  bagColor: bagColors[first.number - 1],
                  disabled: onlyOneSubBag || first.number == currentBagNumber,
                  selected: selectedTarget == first.number,
                  onTap: () {
                    if (onlyOneSubBag || first.number == currentBagNumber) {
                      return;
                    }
                    setState(() => selectedTarget = first.number);
                  },
                )),
                const SizedBox(width: 12),
                if (second != null)
                  Expanded(child: _BagButton(
                    bag: second,
                    bagColor: bagColors[second.number - 1],
                    disabled: onlyOneSubBag || second.number == currentBagNumber,
                    selected: selectedTarget == second.number,
                    onTap: () {
                      if (onlyOneSubBag || second.number == currentBagNumber) {
                        return;
                      }
                      setState(() => selectedTarget = second.number);
                    },
                  ))
                else
                  const Expanded(child: SizedBox()),
              ],
            ));

            rows.add(const SizedBox(height: 12));
          }
          return rows;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose target bag:', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 16),
            ...buildGrid(),
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
    );
  }
}

