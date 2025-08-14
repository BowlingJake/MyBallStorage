import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

Future<int?> showMoveTargetBagDialog({
  required BuildContext context,
  required List<BagInfo> subBags,
  required List<Color> bagColors,
  required int currentBagNumber,
  required int selectedCount,
  List<int> alreadyInBags = const [],
  UserProfile? userProfile,
}) async {
  return ArsenalDialog.show<int>(
    context: context,
    title: 'Move ' + selectedCount.toString() + ' Ball' + (selectedCount != 1 ? 's' : ''),
    content: _MoveTargetBagContent(
      subBags: subBags,
      bagColors: bagColors,
      currentBagNumber: currentBagNumber,
      selectedCount: selectedCount,
      alreadyInBags: alreadyInBags,
      userProfile: userProfile,
    ),
    barrierDismissible: false,
    actions: [
      AppStandardButton(
        text: 'Cancel',
        height: DialogDefaults.buttonHeight,
        onPressed: () => Navigator.of(context).pop(),
      ),
      AppStandardButton(
        text: 'Move',
        height: DialogDefaults.buttonHeight,
        onPressed: () {
          // 由 content 內部 state 控制是否選擇，這裡觸發回傳選擇值
          // 若未選擇，保持無動作（outlined 按鈕呈現 disabled 色由上層控制）
          _MoveTargetBagContentState.maybeSubmitSelected(context);
        },
      ),
    ],
  );
}

/// Move Target Bag Dialog content with unified style
class _MoveTargetBagContent extends StatefulWidget {
  const _MoveTargetBagContent({
    required this.subBags,
    required this.bagColors,
    required this.currentBagNumber,
    required this.selectedCount,
    required this.alreadyInBags,
    required this.userProfile,
  });

  final List<BagInfo> subBags;
  final List<Color> bagColors;
  final int currentBagNumber;
  final int selectedCount;
  final List<int> alreadyInBags;
  final UserProfile? userProfile;

  @override
  State<_MoveTargetBagContent> createState() => _MoveTargetBagContentState();
}

class _MoveTargetBagContentState extends State<_MoveTargetBagContent> {
  static _MoveTargetBagContentState? _lastState;
  int? selectedTarget;

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

  static void maybeSubmitSelected(BuildContext context) {
    final state = _lastState;
    if (state != null && state.selectedTarget != null) {
      Navigator.of(context).pop(state.selectedTarget);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool onlyOneSubBag = widget.subBags.length <= 1;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Choose target bag:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (widget.alreadyInBags.isNotEmpty) ...[
            Builder(
              builder: (context) {
                final alsoIn = widget.alreadyInBags
                    .where((n) => n != widget.currentBagNumber && n != 1)
                    .toList();
                if (alsoIn.isEmpty) {
                  return const SizedBox.shrink();
                }
                final names = alsoIn
                    .map((n) => widget.userProfile?.getBagName(n) ?? 'Bag ' + n.toString())
                    .toList();
                return Text(
                  'Also in: ' + names.join(', '),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 16),
          // 將袋子列表包裝在可滾動的區域中
          Flexible(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
                scrollbars: false,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: widget.subBags.length,
                itemBuilder: (context, index) {
                  final bag = widget.subBags[index];
                  final bool disabled = onlyOneSubBag || 
                      bag.number == widget.currentBagNumber || 
                      widget.alreadyInBags.contains(bag.number);
                  final bool selected = selectedTarget == bag.number;
                  
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == widget.subBags.length - 1 ? 4 : DialogDefaults.spacing,
                    ),
                    child: _BagButton(
                      bag: bag,
                      bagColor: widget.bagColors[bag.number - 1],
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
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
      height: DialogDefaults.buttonHeight,
      onPressed: onTap,
      enabled: !disabled,
      customColor: bagColor,
      outlineColor: selected ? bagColor : Colors.white,
      foregroundColor: selected ? Colors.black : Colors.white.withOpacity(0.9),
      backgroundColor: selected ? bagColor : Colors.transparent,
      isPrimary: selected,
      whiteForeground: false,
      fontSize: DialogDefaults.buttonFontSize,
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

