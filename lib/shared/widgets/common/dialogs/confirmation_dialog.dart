import 'dart:ui';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.isDangerous = false,
  });

  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDangerous;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDangerous 
                  ? Colors.red.withOpacity(0.5)
                  : theme.colorScheme.primary.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(cancelText),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () {
                          onConfirm();
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDangerous ? Colors.red : theme.colorScheme.primary,
                          side: BorderSide(
                            color: isDangerous ? Colors.red : theme.colorScheme.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(confirmText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 