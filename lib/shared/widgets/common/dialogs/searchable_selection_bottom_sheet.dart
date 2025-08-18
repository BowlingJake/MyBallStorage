import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:core_theme/core_theme.dart';

/// 帶搜尋功能的底部選擇對話框
/// 適用於大量選項的選擇場景，如國家選擇器
Future<T?> showSearchableSelectionBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<SearchableSelectionItem<T>> items,
  T? selectedValue,
  String searchHint = 'Search...',
  bool showSearch = true,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _SearchableSelectionBottomSheet<T>(
      title: title,
      items: items,
      selectedValue: selectedValue,
      searchHint: searchHint,
      showSearch: showSearch,
    ),
  );
}

/// 可搜尋的選擇項目模型
class SearchableSelectionItem<T> {
  final T value;
  final String displayText;
  final String searchText; // 用於搜尋的文字（可包含多個關鍵詞）
  final Widget? leading; // 前置圖示（如國旗）
  final String? subtitle; // 副標題（如國家代碼）

  const SearchableSelectionItem({
    required this.value,
    required this.displayText,
    String? searchText,
    this.leading,
    this.subtitle,
  }) : searchText = searchText ?? displayText;
}

class _SearchableSelectionBottomSheet<T> extends StatefulWidget {
  final String title;
  final List<SearchableSelectionItem<T>> items;
  final T? selectedValue;
  final String searchHint;
  final bool showSearch;

  const _SearchableSelectionBottomSheet({
    required this.title,
    required this.items,
    this.selectedValue,
    required this.searchHint,
    required this.showSearch,
  });

  @override
  State<_SearchableSelectionBottomSheet<T>> createState() => 
      _SearchableSelectionBottomSheetState<T>();
}

class _SearchableSelectionBottomSheetState<T> 
    extends State<_SearchableSelectionBottomSheet<T>> {
  
  late List<SearchableSelectionItem<T>> filteredItems;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredItems = widget.items;
      } else {
        filteredItems = widget.items.where((item) {
          return item.searchText.toLowerCase().contains(query) ||
                 (item.subtitle?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: BrandColors.accentColorDark, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 拖拽指示器
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // 標題
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // 搜尋欄
            if (widget.showSearch) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    prefixIcon: Icon(
                      Icons.search, 
                      color: BrandColors.accentColorDark, 
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: BrandColors.accentColorDark, 
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: BrandColors.accentColorDark, 
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: BrandColors.accentColorDark, 
                        width: 2.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
            
            // 結果計數
            if (widget.showSearch && filteredItems.length != widget.items.length)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  children: [
                    Text(
                      '${filteredItems.length} results',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            
            // 分隔線
            Divider(
              color: Colors.grey[700],
              height: 1,
              indent: 20,
              endIndent: 20,
            ),
            
            // 可滾動的選項列表
            Flexible(
              child: filteredItems.isEmpty
                  ? _buildEmptyState()
                  : ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                        scrollbars: false,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(top: 8),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final isSelected = widget.selectedValue == item.value;
                          return _SearchableSelectionTile<T>(
                            item: item,
                            isSelected: isSelected,
                            onTap: () {
                              Navigator.of(context).pop(item.value);
                            },
                          );
                        },
                      ),
                    ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            color: Colors.grey[600],
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchableSelectionTile<T> extends StatelessWidget {
  const _SearchableSelectionTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final SearchableSelectionItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // 前置圖示（如國旗）
              if (item.leading != null) ...[
                SizedBox(
                  width: 32,
                  height: 24,
                  child: item.leading!,
                ),
                const SizedBox(width: 12),
              ],
              
              // 主要內容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.displayText,
                      style: TextStyle(
                        color: isSelected 
                            ? BrandColors.accentColorDark 
                            : Colors.white,
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // 選中指示器
              if (isSelected)
                Icon(
                  Icons.check,
                  color: BrandColors.accentColorDark,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}