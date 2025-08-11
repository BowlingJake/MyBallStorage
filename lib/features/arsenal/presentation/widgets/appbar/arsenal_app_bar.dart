import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArsenalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ArsenalAppBar({
    super.key,
    required this.title,
    required this.searchField,
    required this.isSearching,
    required this.onBack,
    required this.onToggleSearch,
    this.onAdd,
    this.moreAction,
    this.actionsOverride,
  });

  final Widget title;
  final Widget searchField;
  final bool isSearching;
  final VoidCallback onBack;
  final VoidCallback onToggleSearch;
  final VoidCallback? onAdd;
  final Widget? moreAction;
  final List<Widget>? actionsOverride;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack,
      ),
      title: isSearching ? searchField : title,
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      actions: actionsOverride ?? [
        IconButton(
          onPressed: onToggleSearch,
          icon: Icon(
            isSearching ? Icons.search_off : Icons.search,
            color: isSearching ? Colors.blue : Colors.white,
            size: 24,
          ),
          tooltip: isSearching ? 'Close Search' : 'Search',
        ),
        if (onAdd != null)
          IconButton(
            onPressed: onAdd,
            icon: const Icon(Icons.library_add_outlined, color: Colors.white),
            tooltip: 'Add',
          ),
        if (moreAction != null) moreAction!,
        const SizedBox(width: 8),
      ],
    );
  }
}

