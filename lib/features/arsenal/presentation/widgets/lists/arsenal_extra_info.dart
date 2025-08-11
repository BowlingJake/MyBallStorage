import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';

class ArsenalExtraInfo extends StatelessWidget {
  const ArsenalExtraInfo({super.key, required this.instance});

  final UserArsenalInstance instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          instance.layoutDisplayString,
          style: TextStyle(color: Colors.grey[300], fontSize: 11, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'Games Used: ${instance.gamesUsed}',
          style: TextStyle(color: Colors.grey[300], fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

