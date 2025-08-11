import 'package:flutter/material.dart';

class SelectionAppBarActions extends StatelessWidget {
  const SelectionAppBarActions({
    super.key,
    required this.count,
    required this.onConfirm,
    required this.onCancel,
    required this.color,
    required this.confirmIcon,
  });

  final int count;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Color color;
  final IconData confirmIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            '$count selected',
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onConfirm,
          icon: Icon(confirmIcon, color: color),
          tooltip: 'Confirm',
        ),
        IconButton(
          onPressed: onCancel,
          icon: const Icon(Icons.close, color: Colors.orange),
          tooltip: 'Cancel',
        ),
      ],
    );
  }
}

