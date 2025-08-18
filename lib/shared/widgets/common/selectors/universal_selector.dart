import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/shared/interfaces/selectable_item.dart';
import 'package:bowlingarsenal_app/shared/models/selector_config.dart';

/// 終極通用選擇器
/// 支援任何類型的選擇場景，完全可配置
class UniversalSelector<T> extends StatelessWidget {
  final T? selectedValue;
  final List<SelectableItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final SelectorConfig config;
  final bool enabled;

  const UniversalSelector({
    super.key,
    required this.items,
    required this.config,
    this.selectedValue,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && onChanged != null ? () => _showSelector(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled 
                ? Theme.of(context).colorScheme.primary 
                : Colors.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(child: _buildContent()),
            Icon(
              Icons.keyboard_arrow_down,
              color: enabled ? Colors.grey[400] : Colors.grey[600],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final selectedItem = _findSelectedItem();
    
    if (selectedItem == null) {
      return _buildHint();
    }

    return Row(
      children: [
        // 前置圖示
        if (selectedItem.leadingWidget != null) ...[
          selectedItem.leadingWidget!,
          const SizedBox(width: 8),
        ],
        
        // 主要內容
        Expanded(
          child: Text(
            selectedItem.displayText,
            style: selectedItem.customTextStyle ?? const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        
        // 尾隨圖示
        if (selectedItem.trailingWidget != null) ...[
          const SizedBox(width: 8),
          selectedItem.trailingWidget!,
        ],
      ],
    );
  }

  Widget _buildHint() {
    return Text(
      config.buttonHint,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 16,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  SelectableItem<T>? _findSelectedItem() {
    try {
      return items.firstWhere((item) => item.value == selectedValue);
    } catch (e) {
      return null;
    }
  }

  Future<void> _showSelector(BuildContext context) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _UniversalSelectorBottomSheet<T>(
        items: items,
        config: config,
        selectedValue: selectedValue,
      ),
    );

    if (result != null && onChanged != null) {
      onChanged!(result);
    }
  }
}

/// 通用選擇器底部選單
class _UniversalSelectorBottomSheet<T> extends StatefulWidget {
  final List<SelectableItem<T>> items;
  final SelectorConfig config;
  final T? selectedValue;

  const _UniversalSelectorBottomSheet({
    required this.items,
    required this.config,
    this.selectedValue,
  });

  @override
  State<_UniversalSelectorBottomSheet<T>> createState() => 
      _UniversalSelectorBottomSheetState<T>();
}

class _UniversalSelectorBottomSheetState<T> 
    extends State<_UniversalSelectorBottomSheet<T>> {
  
  late List<SelectableItem<T>> filteredItems;
  final TextEditingController _searchController = TextEditingController();
  Map<String, List<SelectableItem<T>>> groupedItems = {};
  
  @override
  void initState() {
    super.initState();
    _initializeItems();
    if (widget.config.showSearch) {
      _searchController.addListener(_onSearchChanged);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeItems() {
    // 排序項目
    var sortedItems = List<SelectableItem<T>>.from(widget.items);
    if (widget.config.customSortComparator != null) {
      sortedItems.sort(widget.config.customSortComparator!);
    } else {
      sortedItems.sort((a, b) {
        // 先按權重排序，再按顯示文字排序
        final weightCompare = a.sortWeight.compareTo(b.sortWeight);
        if (weightCompare != 0) return weightCompare;
        return a.displayText.compareTo(b.displayText);
      });
    }
    
    filteredItems = sortedItems;
    _groupItems();
  }

  void _groupItems() {
    if (!widget.config.showGroups) return;
    
    groupedItems.clear();
    for (final item in filteredItems) {
      final groupKey = item.groupKey ?? 'Others';
      if (!groupedItems.containsKey(groupKey)) {
        groupedItems[groupKey] = [];
      }
      groupedItems[groupKey]!.add(item);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _initializeItems();
      } else {
        if (widget.config.customSearchFilter != null) {
          filteredItems = widget.items.where((item) => 
              widget.config.customSearchFilter!(query, item)).toList();
        } else {
          filteredItems = widget.items.where((item) {
            return item.searchText.toLowerCase().contains(query) ||
                   (item.subtitle?.toLowerCase().contains(query) ?? false);
          }).toList();
        }
        _groupItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * widget.config.maxHeightRatio,
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
            _buildHeader(),
            if (widget.config.showSearch) _buildSearchBar(),
            _buildResultInfo(),
            _buildDivider(),
            _buildItemsList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      child: Column(
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
              widget.config.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: widget.config.searchHint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: Icon(
            Icons.search, 
            color: BrandColors.accentColorDark, 
            size: 20,
          ),
          suffixIcon: widget.config.showClearButton && _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: () => _searchController.clear(),
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
    );
  }

  Widget _buildResultInfo() {
    if (!widget.config.showResultCount) return const SizedBox.shrink();
    
    if (!widget.config.showSearch || 
        filteredItems.length == widget.items.length) {
      return const SizedBox.shrink();
    }

    return Padding(
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
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[700],
      height: 1,
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _buildItemsList() {
    return Flexible(
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
              child: widget.config.showGroups && groupedItems.isNotEmpty
                  ? _buildGroupedList()
                  : _buildSimpleList(),
            ),
    );
  }

  Widget _buildSimpleList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final isSelected = widget.selectedValue == item.value;
        
        return Column(
          children: [
            _buildItemTile(item, isSelected),
            if (widget.config.itemDivider != null && index < filteredItems.length - 1)
              widget.config.itemDivider!,
          ],
        );
      },
    );
  }

  Widget _buildGroupedList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8),
      itemCount: groupedItems.length,
      itemBuilder: (context, groupIndex) {
        final groupKey = groupedItems.keys.elementAt(groupIndex);
        final groupItems = groupedItems[groupKey]!;
        final groupItem = groupItems.first;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分組標題
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                groupItem.groupDisplayName ?? groupKey,
                style: TextStyle(
                  color: BrandColors.accentColorDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // 分組項目
            ...groupItems.map((item) {
              final isSelected = widget.selectedValue == item.value;
              return _buildItemTile(item, isSelected);
            }),
          ],
        );
      },
    );
  }

  Widget _buildItemTile(SelectableItem<T> item, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.isEnabled ? () => Navigator.of(context).pop(item.value) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // 前置圖示
              if (item.leadingWidget != null) ...[
                item.leadingWidget!,
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
                      style: _getItemTextStyle(item, isSelected),
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
              
              // 尾隨圖示
              if (item.trailingWidget != null) ...[
                const SizedBox(width: 8),
                item.trailingWidget!,
              ],
              
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

  TextStyle _getItemTextStyle(SelectableItem<T> item, bool isSelected) {
    if (item.customTextStyle != null) {
      return item.customTextStyle!;
    }
    
    if (isSelected && widget.config.selectedItemStyle != null) {
      return widget.config.selectedItemStyle!;
    }
    
    if (!isSelected && widget.config.unselectedItemStyle != null) {
      return widget.config.unselectedItemStyle!;
    }
    
    return TextStyle(
      color: isSelected ? BrandColors.accentColorDark : 
             (item.isEnabled ? Colors.white : Colors.grey[600]),
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      fontSize: 16,
    );
  }

  Widget _buildEmptyState() {
    if (widget.config.customEmptyWidget != null) {
      return widget.config.customEmptyWidget!;
    }
    
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