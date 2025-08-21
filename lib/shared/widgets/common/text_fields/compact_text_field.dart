import 'package:flutter/material.dart';

class CompactTextField extends StatelessWidget {
  const CompactTextField({
    super.key,
    required this.controller,
    this.label,
    this.icon,
    this.onChanged,
    this.hintText,
  });

  final TextEditingController controller;
  final String? label;
  final IconData? icon;
  final void Function(String)? onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
        color: Colors.black.withOpacity(0.8),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        autocorrect: true,
        enableSuggestions: true,
        style: theme.textTheme.bodyMedium,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: icon != null ? Icon(
            icon,
            color: theme.colorScheme.primary.withOpacity(0.7),
            size: 18,
          ) : null,
          labelStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary.withOpacity(0.8),
          ),
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          isDense: false,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }
}