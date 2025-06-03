import 'package:flutter/material.dart';

class BallListHeader extends StatelessWidget {
  const BallListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 3, child: Text('Ball Name', style: theme.textTheme.labelSmall)),
          Expanded(flex: 2, child: Text('Brand', style: theme.textTheme.labelSmall, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('Cover', style: theme.textTheme.labelSmall, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
} 