import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ArsenalErrorState extends StatelessWidget {
  const ArsenalErrorState({super.key, required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.warning_2, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text('載入失敗', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.red, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(error, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Iconsax.refresh), label: const Text('重新載入')),
        ],
      ),
    );
  }
}

