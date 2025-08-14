import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

Future<void> showInstanceDetailsDialog({
  required BuildContext context,
  required UserArsenalInstance instance,
  required VoidCallback onRemove,
}) async {
  await ArsenalDialog.show(
    context: context,
    title: instance.bowlingBall?.name ?? 'Unknown Ball',
    maxHeight: MediaQuery.of(context).size.height * 0.8,
    content: _InstanceDetailsContent(instance: instance),
    actions: [
      AppStandardButton(
        text: 'Edit',
        height: DialogDefaults.buttonHeight,
        fontSize: DialogDefaults.buttonFontSize,
        onPressed: () {
          Navigator.of(context).pop();
          // 未實作編輯
        },
        enabled: false, // 因為未實作編輯功能
      ),
      AppStandardButton(
        text: 'Remove',
        height: DialogDefaults.buttonHeight,
        fontSize: DialogDefaults.buttonFontSize,
        customColor: Colors.red,
        isPrimary: true,
        onPressed: () {
          Navigator.of(context).pop();
          onRemove();
        },
      ),
    ],
  );
}

class _InstanceDetailsContent extends StatelessWidget {
  const _InstanceDetailsContent({required this.instance});

  final UserArsenalInstance instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (instance.bowlingBall != null) ...[
          Text(
            'Brand: ${instance.bowlingBall!.brand}',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),
        ],
        _DetailRow(
          label: 'Layout',
          value: instance.layoutDisplayString,
        ),
        const SizedBox(height: 12),
        _DetailRow(
          label: 'Games Used',
          value: instance.gamesUsed.toString(),
        ),
        const SizedBox(height: 12),
        if (instance.allCategories.isNotEmpty) ...[
          _DetailRow(
            label: 'Categories',
            value: instance.allCategories.join(", "),
          ),
          const SizedBox(height: 12),
        ],
        _DetailRow(
          label: 'Added',
          value: instance.addedDate?.toString().split(' ')[0] ?? 'Unknown',
          isSecondary: true,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isSecondary = false,
  });

  final String label;
  final String value;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(
              color: isSecondary ? Colors.grey : Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isSecondary ? Colors.grey : Colors.white,
              fontSize: isSecondary ? 14 : 16,
            ),
          ),
        ),
      ],
    );
  }
}

