import 'package:flutter/material.dart';
import 'dart:ui';

class FilterPopout extends StatefulWidget {
  final Map<String, String?> selectedFilters;
  final Function(String filterType, String? value) onFilterChanged;

  const FilterPopout({
    Key? key,
    required this.selectedFilters,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<FilterPopout> createState() => _FilterPopoutState();
}

class _FilterPopoutState extends State<FilterPopout> {
  late Map<String, List<String>> _localFilters;
  
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
    // 轉換為多選格式
    _localFilters = {
      'brand': widget.selectedFilters['brand'] != null ? [widget.selectedFilters['brand']!] : [],
      'core': widget.selectedFilters['core'] != null ? [widget.selectedFilters['core']!] : [],
      'coverstock': widget.selectedFilters['coverstock'] != null ? [widget.selectedFilters['coverstock']!] : [],
    };
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
              constraints: BoxConstraints(
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
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  ),
                  // 內容
                  Column(
                    children: [
                      // 標題列
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filter Options',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 24),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            // 清除按鈕
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _localFilters['brand']!.clear();
                                    _localFilters['core']!.clear();
                                    _localFilters['coverstock']!.clear();
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.white.withOpacity(0.5)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text('Clear All'),
                              ),
                            ),
                            
                            const SizedBox(width: 12),
                            
                            // 應用按鈕
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  // 應用篩選 - 多選品牌支持，其他保持單選相容性
                                  widget.onFilterChanged('brand', _localFilters['brand']!.isNotEmpty ? _localFilters['brand']!.first : null);
                                  widget.onFilterChanged('core', _localFilters['core']!.isNotEmpty ? _localFilters['core']!.first : null);
                                  widget.onFilterChanged('coverstock', _localFilters['coverstock']!.isNotEmpty ? _localFilters['coverstock']!.first : null);
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: theme.colorScheme.primary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
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
    // 定義品牌分組
    final Map<String, List<String>> brandGroups = {
      'Team SPI': ['Storm', 'Roto Grip', '900 Global'],
      'Brunswick Group': ['Brunswick', 'Ebonite', 'Track', 'Columbia 300', 'DV8', 'Radical', 'Hammer'],
      'Others': ['Motiv', 'SWAG'],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 區段標題
        Text(
          'Brand',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
                 // Select All 按鈕 - 全版寬度
         GestureDetector(
           onTap: () {
             setState(() {
               if (_localFilters['brand']!.isEmpty) {
                 // 如果目前沒有選擇，就全選
                 _localFilters['brand']!.addAll(brandGroups.values.expand((list) => list));
               } else {
                 // 如果有選擇，就清除所有
                 _localFilters['brand']!.clear();
               }
             });
           },
           child: Container(
             width: double.infinity,
             padding: EdgeInsets.symmetric(vertical: 12),
             margin: EdgeInsets.only(bottom: 16),
             decoration: BoxDecoration(
               color: _localFilters['brand']!.isNotEmpty
                   ? Colors.white.withOpacity(0.25)
                   : Colors.white.withOpacity(0.08),
               border: Border.all(
                 color: _localFilters['brand']!.isNotEmpty
                     ? Colors.white.withOpacity(0.9)
                     : Colors.white.withOpacity(0.3),
                 width: _localFilters['brand']!.isNotEmpty ? 2 : 1,
               ),
               borderRadius: BorderRadius.circular(20),
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(
                   _localFilters['brand']!.isNotEmpty ? Icons.check_circle : Icons.radio_button_unchecked,
                   color: Colors.white.withOpacity(_localFilters['brand']!.isNotEmpty ? 1.0 : 0.7),
                   size: 16,
                 ),
                 SizedBox(width: 8),
                 Text(
                   _localFilters['brand']!.isNotEmpty ? 'Clear All' : 'Select All',
                   style: TextStyle(
                     color: Colors.white.withOpacity(_localFilters['brand']!.isNotEmpty ? 1.0 : 0.8),
                     fontSize: 14,
                     fontWeight: _localFilters['brand']!.isNotEmpty ? FontWeight.w600 : FontWeight.w500,
                   ),
                 ),
               ],
             ),
           ),
         ),
        
        // 各品牌集團
        ...brandGroups.entries.map((entry) => _buildBrandGroup(entry.key, entry.value)).toList(),
      ],
    );
  }

    Widget _buildBrandGroup(String groupName, List<String> brands) {
    final isGroupSelected = brands.every((brand) => _localFilters['brand']!.contains(brand));
    final hasPartialSelection = brands.any((brand) => _localFilters['brand']!.contains(brand)) && !isGroupSelected;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 集團標題按鈕 - 簡潔的小標題樣式
        GestureDetector(
          onTap: () {
            setState(() {
              if (isGroupSelected) {
                // 如果集團全選，則取消選擇該集團所有品牌
                for (String brand in brands) {
                  _localFilters['brand']!.remove(brand);
                }
              } else {
                // 如果集團未全選，則選擇該集團所有品牌
                for (String brand in brands) {
                  if (!_localFilters['brand']!.contains(brand)) {
                    _localFilters['brand']!.add(brand);
                  }
                }
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isGroupSelected || hasPartialSelection
                  ? Colors.white.withOpacity(0.15)
                  : Colors.white.withOpacity(0.08),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isGroupSelected
                      ? Icons.check_circle
                      : hasPartialSelection
                          ? Icons.remove_circle
                          : Icons.radio_button_unchecked,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  groupName,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // 該集團的品牌選項 - 緊湊排列
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: brands.map((brand) {
            final isSelected = _localFilters['brand']!.contains(brand);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _localFilters['brand']!.remove(brand);
                  } else {
                    _localFilters['brand']!.add(brand);
                  }
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: (MediaQuery.of(context).size.width * 0.9 - 40 - 12) / 3,
                height: 36,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.25)
                      : Colors.white.withOpacity(0.08),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withOpacity(0.9)
                        : Colors.white.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.15),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    brand,
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
        
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCoreFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 區段標題
        Text(
          'Core',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Select All 按鈕 - 全版寬度
        GestureDetector(
          onTap: () {
            setState(() {
              if (_localFilters['core']!.isEmpty) {
                _localFilters['core']!.addAll(['Symmetric', 'Asymmetric']);
              } else {
                _localFilters['core']!.clear();
              }
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: _localFilters['core']!.isNotEmpty
                  ? Colors.white.withOpacity(0.25)
                  : Colors.white.withOpacity(0.08),
              border: Border.all(
                color: _localFilters['core']!.isNotEmpty
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white.withOpacity(0.3),
                width: _localFilters['core']!.isNotEmpty ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _localFilters['core']!.isNotEmpty ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: Colors.white.withOpacity(_localFilters['core']!.isNotEmpty ? 1.0 : 0.7),
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  _localFilters['core']!.isNotEmpty ? 'Clear All' : 'Select All',
                  style: TextStyle(
                    color: Colors.white.withOpacity(_localFilters['core']!.isNotEmpty ? 1.0 : 0.8),
                    fontSize: 14,
                    fontWeight: _localFilters['core']!.isNotEmpty ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
                 // Core 選項 - 兩個選項等寬並排
         Row(
           children: ['Symmetric', 'Asymmetric'].map((core) {
             final isSelected = _localFilters['core']!.contains(core);
             return Expanded(
               child: Container(
                 margin: EdgeInsets.only(right: core != 'Asymmetric' ? 6 : 0),
                 child: GestureDetector(
                   onTap: () {
                     setState(() {
                       if (isSelected) {
                         _localFilters['core']!.remove(core);
                       } else {
                         _localFilters['core']!.add(core);
                       }
                     });
                   },
                   child: AnimatedContainer(
                     duration: Duration(milliseconds: 200),
                     height: 36,
                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                     decoration: BoxDecoration(
                       color: isSelected
                           ? Colors.white.withOpacity(0.25)
                           : Colors.white.withOpacity(0.08),
                       border: Border.all(
                         color: isSelected
                             ? Colors.white.withOpacity(0.9)
                             : Colors.white.withOpacity(0.3),
                         width: isSelected ? 2 : 1,
                       ),
                       borderRadius: BorderRadius.circular(18),
                       boxShadow: isSelected
                           ? [
                               BoxShadow(
                                 color: Colors.white.withOpacity(0.15),
                                 blurRadius: 6,
                                 offset: Offset(0, 2),
                               ),
                             ]
                           : [],
                     ),
                     child: Center(
                       child: Text(
                         core,
                         style: TextStyle(
                           color: Colors.white.withOpacity(isSelected ? 1.0 : 0.8),
                           fontSize: 12,
                           fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                         ),
                         textAlign: TextAlign.center,
                       ),
                     ),
                   ),
                 ),
               ),
             );
           }).toList(),
         ),
      ],
    );
  }

  Widget _buildCoverFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 區段標題
        Text(
          'Cover',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Select All 按鈕 - 全版寬度
        GestureDetector(
          onTap: () {
            setState(() {
              if (_localFilters['coverstock']!.isEmpty) {
                _localFilters['coverstock']!.addAll(['Solid Reactive', 'Pearl Reactive', 'Hybrid Reactive', 'Urethane', 'Polyester']);
              } else {
                _localFilters['coverstock']!.clear();
              }
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: _localFilters['coverstock']!.isNotEmpty
                  ? Colors.white.withOpacity(0.25)
                  : Colors.white.withOpacity(0.08),
              border: Border.all(
                color: _localFilters['coverstock']!.isNotEmpty
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white.withOpacity(0.3),
                width: _localFilters['coverstock']!.isNotEmpty ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _localFilters['coverstock']!.isNotEmpty ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: Colors.white.withOpacity(_localFilters['coverstock']!.isNotEmpty ? 1.0 : 0.7),
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  _localFilters['coverstock']!.isNotEmpty ? 'Clear All' : 'Select All',
                  style: TextStyle(
                    color: Colors.white.withOpacity(_localFilters['coverstock']!.isNotEmpty ? 1.0 : 0.8),
                    fontSize: 14,
                    fontWeight: _localFilters['coverstock']!.isNotEmpty ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
                 // Cover 選項 - 等寬Grid布局
         Column(
           children: [
             // 第一行：前三個選項
             Row(
               children: ['Solid Reactive', 'Pearl Reactive', 'Hybrid Reactive'].asMap().entries.map((entry) {
                 final cover = entry.value;
                 final index = entry.key;
                 final isSelected = _localFilters['coverstock']!.contains(cover);
                 return Expanded(
                   child: Container(
                     margin: EdgeInsets.only(right: index != 2 ? 6 : 0),
                     child: GestureDetector(
                       onTap: () {
                         setState(() {
                           if (isSelected) {
                             _localFilters['coverstock']!.remove(cover);
                           } else {
                             _localFilters['coverstock']!.add(cover);
                           }
                         });
                       },
                       child: AnimatedContainer(
                         duration: Duration(milliseconds: 200),
                         height: 36,
                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                         decoration: BoxDecoration(
                           color: isSelected
                               ? Colors.white.withOpacity(0.25)
                               : Colors.white.withOpacity(0.08),
                           border: Border.all(
                             color: isSelected
                                 ? Colors.white.withOpacity(0.9)
                                 : Colors.white.withOpacity(0.3),
                             width: isSelected ? 2 : 1,
                           ),
                           borderRadius: BorderRadius.circular(18),
                           boxShadow: isSelected
                               ? [
                                   BoxShadow(
                                     color: Colors.white.withOpacity(0.15),
                                     blurRadius: 6,
                                     offset: Offset(0, 2),
                                   ),
                                 ]
                               : [],
                         ),
                         child: Center(
                           child: Text(
                             cover,
                             style: TextStyle(
                               color: Colors.white.withOpacity(isSelected ? 1.0 : 0.8),
                               fontSize: 11,
                               fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                             ),
                             textAlign: TextAlign.center,
                           ),
                         ),
                       ),
                     ),
                   ),
                 );
               }).toList(),
             ),
             
             SizedBox(height: 6),
             
             // 第二行：後兩個選項
             Row(
               children: ['Urethane', 'Polyester'].asMap().entries.map((entry) {
                 final cover = entry.value;
                 final index = entry.key;
                 final isSelected = _localFilters['coverstock']!.contains(cover);
                 return Expanded(
                   child: Container(
                     margin: EdgeInsets.only(right: index != 1 ? 6 : 0),
                     child: GestureDetector(
                       onTap: () {
                         setState(() {
                           if (isSelected) {
                             _localFilters['coverstock']!.remove(cover);
                           } else {
                             _localFilters['coverstock']!.add(cover);
                           }
                         });
                       },
                       child: AnimatedContainer(
                         duration: Duration(milliseconds: 200),
                         height: 36,
                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                         decoration: BoxDecoration(
                           color: isSelected
                               ? Colors.white.withOpacity(0.25)
                               : Colors.white.withOpacity(0.08),
                           border: Border.all(
                             color: isSelected
                                 ? Colors.white.withOpacity(0.9)
                                 : Colors.white.withOpacity(0.3),
                             width: isSelected ? 2 : 1,
                           ),
                           borderRadius: BorderRadius.circular(18),
                           boxShadow: isSelected
                               ? [
                                   BoxShadow(
                                     color: Colors.white.withOpacity(0.15),
                                     blurRadius: 6,
                                     offset: Offset(0, 2),
                                   ),
                                 ]
                               : [],
                         ),
                         child: Center(
                           child: Text(
                             cover,
                             style: TextStyle(
                               color: Colors.white.withOpacity(isSelected ? 1.0 : 0.8),
                               fontSize: 12,
                               fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                             ),
                             textAlign: TextAlign.center,
                           ),
                         ),
                       ),
                     ),
                   ),
                 );
               }).toList(),
             ),
           ],
         ),
      ],
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    Map<String, IconData> iconMap,
    String filterKey,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 區段標題
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // 文字按鈕網格
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = _localFilters[filterKey]!.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _localFilters[filterKey]!.remove(option);
                  } else {
                    _localFilters[filterKey]!.add(option);
                  }
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                constraints: BoxConstraints(
                  minWidth: 60,
                  minHeight: 32,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.25)
                      : Colors.white.withOpacity(0.08),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withOpacity(0.9)
                        : Colors.white.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.15),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: Colors.white.withOpacity(isSelected ? 1.0 : 0.8),
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
  BuildContext context,
  Map<String, String?> selectedFilters,
  Function(String filterType, String? value) onFilterChanged,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: FilterPopout(
          selectedFilters: selectedFilters,
          onFilterChanged: onFilterChanged,
        ),
      );
    },
  );
} 