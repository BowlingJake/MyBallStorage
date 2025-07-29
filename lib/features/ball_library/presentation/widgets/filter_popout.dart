import 'dart:ui';
import 'package:bowlingarsenal_app/features/ball_library/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/shared/providers/providers.dart';
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

  // 品牌圖標映射
  final Map<String, IconData> _brandIcons = {
    'Storm': Icons.thunderstorm,
    'Hammer': Icons.build,
    'Brunswick': Icons.circle,
    'Roto Grip': Icons.rotate_right,
    'Motiv': Icons.motion_photos_on,
    'Columbia 300': Icons.star,
    'Ebonite': Icons.fiber_manual_record,
    '900 Global': Icons.public,
    'Track': Icons.timeline,
    'Radical': Icons.whatshot,
    'SWAG': Icons.style,
  };

  // 球心圖標映射
  final Map<String, IconData> _coreIcons = {
    'Symmetric': Icons.circle_outlined,
    'Asymmetric': Icons.change_history,
  };

  // 球表圖標映射
  final Map<String, IconData> _coverstockIcons = {
    'Solid Reactive': Icons.circle,
    'Pearl Reactive': Icons.grain,
    'Hybrid Reactive': Icons.blur_on,
    'Urethane': Icons.radio_button_checked,
    'Polyester': Icons.fiber_manual_record,
  };

  @override
  void initState() {
    super.initState();
    _localFilters = widget.currentFilters;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              width: size.width * 0.9,
              height: size.height * 0.8,
              constraints: const BoxConstraints(
                maxWidth: 450,
                maxHeight: 600,
                minWidth: 320,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.3),
                    theme.colorScheme.primary.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(color: Colors.white.withOpacity(0.15)),
                    ),
                  ),
                  // 內容
                  Column(
                    children: [
                      // 標題列
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
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
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ),

                      // 篩選內容 - 使用Expanded和SingleChildScrollView
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Brand 篩選
                              _buildBrandFilterSection(),

                              const SizedBox(height: 24),

                              // Core 篩選
                              _buildCoreFilterSection(),

                              const SizedBox(height: 24),

                              // Cover 篩選
                              _buildCoverFilterSection(),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // 底部按鈕
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.onFiltersChanged(_localFilters);
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Apply Filters',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandFilterSection() {
    final brandGroups = <String, List<String>>{
      'Team SPI': ['Storm', 'Roto Grip', '900 Global'],
      'Brunswick Group': ['Brunswick', 'Ebonite', 'Track', 'Columbia 300', 'DV8', 'Radical'],
      'Others': ['Motiv', 'Hammer', 'SWAG'],
    };

    return _buildFilterSection(
      title: 'Brand',
      groups: brandGroups,
      selectedItem: _localFilters.brand,
      onSelected: (brand) {
        setState(() {
          _localFilters = _localFilters.copyWith(brand: _localFilters.brand == brand ? null : brand);
        });
      },
      icons: _brandIcons,
    );
  }

  Widget _buildCoreFilterSection() {
    return _buildFilterSection(
      title: 'Core',
      items: ['Symmetric', 'Asymmetric'],
      selectedItem: _localFilters.core,
      onSelected: (core) {
        setState(() {
          _localFilters = _localFilters.copyWith(core: _localFilters.core == core ? null : core);
        });
      },
      icons: _coreIcons,
    );
  }

  Widget _buildCoverFilterSection() {
    return _buildFilterSection(
      title: 'Coverstock',
      items: ['Solid Reactive', 'Pearl Reactive', 'Hybrid Reactive', 'Urethane', 'Polyester'],
      selectedItem: _localFilters.coverstock,
      onSelected: (cover) {
        setState(() {
          _localFilters = _localFilters.copyWith(coverstock: _localFilters.coverstock == cover ? null : cover);
        });
      },
      icons: _coverstockIcons,
    );
  }

  Widget _buildFilterSection({
    required String title,
    Map<String, List<String>>? groups,
    List<String>? items,
    required String? selectedItem,
    required ValueChanged<String?> onSelected,
    required Map<String, IconData> icons,
  }) {
    final allItems = groups?.values.expand((list) => list).toList() ?? items!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allItems.map((item) {
            final isSelected = selectedItem == item;
            return GestureDetector(
              onTap: () => onSelected(isSelected ? null : item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: (MediaQuery.of(context).size.width * 0.9 - 40 - 12) / 3,
                height: 36,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.25) : Colors.white.withOpacity(0.08),
                  border: Border.all(
                    color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ] : [],
                ),
                child: Center(
                  child: Text(
                    item!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(isSelected ? 1.0 : 0.8),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: FilterPopout(
          currentFilters: initialFilters,
          onFiltersChanged: onFiltersChanged,
        ),
      );
    },
  );
}
