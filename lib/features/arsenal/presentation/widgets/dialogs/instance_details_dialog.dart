import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';

Future<void> showInstanceDetailsDialog({
  required BuildContext context,
  required UserArsenalInstance instance,
  required VoidCallback onRemove,
}) async {
  await showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.black.withOpacity(0.9),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    instance.bowlingBall?.name ?? 'Unknown Ball',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 16),
            if (instance.bowlingBall != null) ...[
              Text('Brand: ${instance.bowlingBall!.brand}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 8),
            ],
            Text('Layout: ${instance.layoutDisplayString}', style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Games Used: ${instance.gamesUsed}', style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            if (instance.allCategories.isNotEmpty) ...[
              Text('Categories: ${instance.allCategories.join(", ")}', style: const TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),
            ],
            Text('Added: ${instance.addedDate?.toString().split(' ')[0] ?? 'Unknown'}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
            if (instance.notes != null && instance.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Notes:', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(instance.notes!, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // 未實作編輯
                  },
                  child: const Text('Edit', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRemove();
                  },
                  child: const Text('Remove', style: TextStyle(color: Colors.red)),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

