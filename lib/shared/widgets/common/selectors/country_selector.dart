import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/models/country_model.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/searchable_selection_bottom_sheet.dart';

/// 國家選擇器
/// 點擊後彈出帶搜尋功能的國家選擇對話框
class CountrySelector extends StatelessWidget {
  final String hint;
  final Country? selectedCountry;
  final ValueChanged<Country?>? onChanged;
  final bool enabled;

  const CountrySelector({
    super.key,
    this.hint = 'Select Country',
    this.selectedCountry,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && onChanged != null ? () => _showCountryPicker(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            // 國旗和國家名稱
            Expanded(
              child: selectedCountry != null
                  ? _buildSelectedCountry()
                  : _buildHint(),
            ),
            
            // 下拉箭頭
            Icon(
              Icons.keyboard_arrow_down,
              color: enabled ? Colors.grey[400] : Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedCountry() {
    return Row(
      children: [
        // 國旗
        Text(
          selectedCountry!.flag,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 12),
        
        // 國家名稱
        Expanded(
          child: Text(
            selectedCountry!.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // 國家代碼（可選）
        Text(
          selectedCountry!.code,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildHint() {
    return Text(
      hint,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
      ),
    );
  }

  Future<void> _showCountryPicker(BuildContext context) async {
    // 將國家列表轉換為 SearchableSelectionItem
    final items = Countries.all.map((country) {
      return SearchableSelectionItem<Country>(
        value: country,
        displayText: country.name,
        searchText: '${country.name} ${country.code} ${country.dialCode}',
        leading: Text(
          country.flag,
          style: const TextStyle(fontSize: 24),
        ),
        subtitle: '${country.code} ${country.dialCode}',
      );
    }).toList();

    // 按國家名稱排序
    items.sort((a, b) => a.displayText.compareTo(b.displayText));

    final result = await showSearchableSelectionBottomSheet<Country>(
      context: context,
      title: 'Select Country',
      items: items,
      selectedValue: selectedCountry,
      searchHint: 'Search countries...',
    );

    if (result != null && onChanged != null) {
      onChanged!(result);
    }
  }
}

/// 簡化版國家選擇器（只顯示國家代碼）
class CountryCodeSelector extends StatelessWidget {
  final String hint;
  final Country? selectedCountry;
  final ValueChanged<Country?>? onChanged;
  final bool enabled;

  const CountryCodeSelector({
    super.key,
    this.hint = 'Select',
    this.selectedCountry,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && onChanged != null ? () => _showCountryPicker(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedCountry != null) ...[
              // 國旗
              Text(
                selectedCountry!.flag,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 6),
              
              // 國家代碼
              Text(
                selectedCountry!.code,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              Text(
                hint,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
            
            const SizedBox(width: 6),
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

  Future<void> _showCountryPicker(BuildContext context) async {
    final items = Countries.all.map((country) {
      return SearchableSelectionItem<Country>(
        value: country,
        displayText: country.name,
        searchText: '${country.name} ${country.code} ${country.dialCode}',
        leading: Text(
          country.flag,
          style: const TextStyle(fontSize: 24),
        ),
        subtitle: '${country.code} ${country.dialCode}',
      );
    }).toList();

    items.sort((a, b) => a.displayText.compareTo(b.displayText));

    final result = await showSearchableSelectionBottomSheet<Country>(
      context: context,
      title: 'Select Country',
      items: items,
      selectedValue: selectedCountry,
      searchHint: 'Search countries...',
    );

    if (result != null && onChanged != null) {
      onChanged!(result);
    }
  }
}