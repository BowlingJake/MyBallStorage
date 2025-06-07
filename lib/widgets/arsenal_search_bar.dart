import 'package:flutter/material.dart';

class ArsenalSearchBar extends StatelessWidget {
  final String searchText;
  final ValueChanged<String> onSearchChanged;

  const ArsenalSearchBar({
    Key? key,
    required this.searchText,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search balls...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search, 
            color: theme.colorScheme.primary,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
} 