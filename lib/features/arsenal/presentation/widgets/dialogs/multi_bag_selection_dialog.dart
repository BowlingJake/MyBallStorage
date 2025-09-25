import 'package:flutter/material.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';

/// 多選子袋對話框：用於主袋 Add to Other Bags
Future<List<int>?> showMultiBagSelectionDialog({
  required BuildContext context,
  required List<BagInfo> subBags,
  required List<Color> bagColors,
  required int currentBagNumber,
  required int selectedCount,
  UserProfile? userProfile,
  String titleText = 'Add to Bags',
}) async {
  final result = await ArsenalDialog.show<List<int>>(
    context: context,
    title: '$titleText ($selectedCount selected)',
    barrierDismissible: false,
    content: _MultiBagSelectionContent(
      subBags: subBags,
      bagColors: bagColors,
      currentBagNumber: currentBagNumber,
      userProfile: userProfile,
    ),
    actions: [
      AppStandardButton.primaryOutlined(
        text: 'Cancel',
        height: 40,
        onPressed: () => Navigator.of(context).pop(),
      ),
      AppStandardButton(
        text: 'Add',
        height: 40,
        onPressed: () => _MultiBagSelectionContentState.submit(context),
      ),
    ],
  );
  return result;
}

class _MultiBagSelectionContent extends StatefulWidget {
  const _MultiBagSelectionContent({
    required this.subBags,
    required this.bagColors,
    required this.currentBagNumber,
    required this.userProfile,
  });

  final List<BagInfo> subBags;
  final List<Color> bagColors;
  final int currentBagNumber;
  final UserProfile? userProfile;

  @override
  State<_MultiBagSelectionContent> createState() => _MultiBagSelectionContentState();
}

class _MultiBagSelectionContentState extends State<_MultiBagSelectionContent> {
  static _MultiBagSelectionContentState? _lastState;
  final Set<int> _selectedTargets = <int>{};

  @override
  void initState() {
    super.initState();
    _lastState = this;
  }

  @override
  void dispose() {
    if (_lastState == this) {
      _lastState = null;
    }
    super.dispose();
  }

  static void submit(BuildContext context) {
    final state = _lastState;
    if (state != null && state._selectedTargets.isNotEmpty) {
      Navigator.of(context).pop(state._selectedTargets.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.subBags.length,
        itemBuilder: (context, index) {
          final bag = widget.subBags[index];
          final disabled = bag.number == 1 || bag.number == widget.currentBagNumber;
          final selected = _selectedTargets.contains(bag.number);
          final color = widget.bagColors[bag.number - 1];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == widget.subBags.length - 1 ? 4 : DialogDefaults.spacing,
            ),
            child: AppStandardButton(
              text: widget.userProfile?.getBagName(bag.number) ?? bag.name,
              height: DialogDefaults.buttonHeight,
              enabled: !disabled,
              onPressed: () {
                if (!disabled) {
                  setState(() {
                    if (selected) {
                      _selectedTargets.remove(bag.number);
                    } else {
                      _selectedTargets.add(bag.number);
                    }
                  });
                }
              },
              customColor: color,
              outlineColor: selected ? color : Colors.white,
              foregroundColor: selected ? Colors.black : Colors.white.withOpacity(0.9),
              backgroundColor: selected ? color : Colors.transparent,
              isPrimary: selected,
              whiteForeground: false,
              fontSize: DialogDefaults.buttonFontSize,
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }
}


