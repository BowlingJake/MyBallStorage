import 'package:bowlingarsenal_app/features/ball_library/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterPopout extends ConsumerStatefulWidget {
  const FilterPopout({
    required this.currentFilters,
    required this.onFiltersChanged,
    super.key,
  });
  final BallFilters currentFilters;
  final ValueChanged<BallFilters> onFiltersChanged;

  @override
  ConsumerState<FilterPopout> createState() => _FilterPopoutState();
}

class _FilterPopoutState extends ConsumerState<FilterPopout> {
  // 本地狀態，用於 UI 互動
  late BallFilters _localFilters;

  // 品牌列表
  final List<String> _brands = [
    'Storm', 'Roto Grip', '900 Global', 'Brunswick', 'Ebonite', 'Track', 
    'Columbia 300', 'DV8', 'Radical', 'Motiv', 'Hammer', 'SWAG'
  ];

  // 球心選項
  final List<String> _cores = ['Symmetric', 'Asymmetric'];

  // 球皮選項
  final List<String> _coverstocks = [
    'Solid Reactive', 'Pearl Reactive', 'Hybrid Reactive', 'Urethane', 'Polyester'
  ];

  @override
  void initState() {
    super.initState();
    _localFilters = widget.currentFilters;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.8,
          constraints: const BoxConstraints(
            maxWidth: 450,
            maxHeight: 700,
            minWidth: 320,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade600,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 標題列
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade600,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Options',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white70,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // 篩選內容
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand 篩選
                      _buildBrandSection(),
                      const SizedBox(height: 24),

                      // Core 篩選
                      _buildCoreSection(),
                      const SizedBox(height: 24),

                      // Coverstock 篩選
                      _buildCoverstockSection(),
                    ],
                  ),
                ),
              ),

              // 底部按鈕
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade600,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppStandardButton(
                        onPressed: () {
                          setState(() {
                            _localFilters = const BallFilters();
                          });
                        },
                        text: 'Reset All',
                        isPrimary: false,
                        height: 48,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        onPressed: () {
                          widget.onFiltersChanged(_localFilters);
                          Navigator.of(context).pop();
                        },
                        text: 'Apply Filters',
                        isPrimary: true,
                        height: 48,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandSection() {
    return _buildMultiSelectSection(
      title: 'Brand',
      items: _brands,
      selectedItems: _localFilters.brands,
      onSelectionChanged: (selectedBrands) {
        setState(() {
          _localFilters = _localFilters.copyWith(brands: selectedBrands);
        });
      },
    );
  }

  Widget _buildCoreSection() {
    return _buildMultiSelectSection(
      title: 'Core',
      items: _cores,
      selectedItems: _localFilters.cores,
      onSelectionChanged: (selectedCores) {
        setState(() {
          _localFilters = _localFilters.copyWith(cores: selectedCores);
        });
      },
    );
  }

  Widget _buildCoverstockSection() {
    return _buildMultiSelectSection(
      title: 'Coverstock',
      items: _coverstocks,
      selectedItems: _localFilters.coverstocks,
      onSelectionChanged: (selectedCoverstocks) {
        setState(() {
          _localFilters = _localFilters.copyWith(coverstocks: selectedCoverstocks);
        });
      },
    );
  }

  Widget _buildMultiSelectSection({
    required String title,
    required List<String> items,
    required Set<String> selectedItems,
    required ValueChanged<Set<String>> onSelectionChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade600,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (selectedItems.isNotEmpty)
                GestureDetector(
                  onTap: () => onSelectionChanged({}),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade600),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTagWrap(items, selectedItems, onSelectionChanged),
        ],
      ),
    );
  }

  Widget _buildTagWrap(
    List<String> items,
    Set<String> selectedItems, 
    ValueChanged<Set<String>> onSelectionChanged,
  ) {
    final screenWidth = MediaQuery.of(context).size.width * 0.9 - 72; // 扣除container padding和border
    final itemWidth = (screenWidth - 24) / 3; // 3-4個標籤每行，扣除spacing
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        return GestureDetector(
          onTap: () {
            final newSelection = Set<String>.from(selectedItems);
            if (isSelected) {
              newSelection.remove(item);
            } else {
              newSelection.add(item);
            }
            onSelectionChanged(newSelection);
          },
          child: Container(
            width: itemWidth.clamp(80, 120),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected 
                ? Theme.of(context).primaryColor
                : Colors.transparent,
              border: Border.all(
                color: isSelected 
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade600,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: isSelected 
                  ? Colors.white
                  : Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// 顯示篩選彈窗的函數
void showFilterPopout(
  BuildContext context, {
  required BallFilters initialFilters,
  required ValueChanged<BallFilters> onFiltersChanged,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return FilterPopout(
        currentFilters: initialFilters,
        onFiltersChanged: onFiltersChanged,
      );
    },
  );
}
