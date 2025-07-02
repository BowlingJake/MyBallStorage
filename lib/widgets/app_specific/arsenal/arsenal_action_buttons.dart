import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/widgets/common/buttons/app_standard_button.dart';
// import '../models/arsenal_ball.dart';

/// Two action buttons shown on the MyArsenalPage.
class ArsenalActionButtons extends ConsumerWidget {
  const ArsenalActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: AppStandardButton(
            text: 'Add Ball',
            onPressed: () {
              // TODO: Implement Add Ball
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppStandardButton(
            text: 'Edit Arsenal',
            onPressed: () {
              // TODO: Implement Edit Arsenal
            },
            isSecondary: true,
          ),
        ),
      ],
    );
  }
}
