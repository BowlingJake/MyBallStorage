import 'dart:ui';

import 'package:bowlingarsenal_app/features/arsenal/models/arsenal_ball.dart';
import 'package:bowlingarsenal_app/features/arsenal/providers/arsenal_providers.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/widgets/search/search_bar.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/shared/providers/providers.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/filter_popout.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/sort_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';


class BallSelectionDialog extends ConsumerStatefulWidget {
  final List<BallInfo> initialSelectedBalls;

  const BallSelectionDialog({
    super.key,
    this.initialSelectedBalls = const [],
  });

  @override
  ConsumerState<BallSelectionDialog> createState() => _BallSelectionDialogState();
}

class _BallSelectionDialogState extends ConsumerState<BallSelectionDialog> {
  late Set<String> _selectedBallNames;
  bool _isGridView = true;
  String _searchText = '';
  BallFilters _filters = const BallFilters();
  SortCriterion _sortCriterion = const SortCriterion(field: SortField.name, ascending: true);

  @override
  void initState() {
    super.initState();
    _selectedBallNames = Set.from(widget.initialSelectedBalls.map((b) => b.name));
  }

  void _toggleSelection(ArsenalBall ball) {
    setState(() {
      if (_selectedBallNames.contains(ball.name)) {
        _selectedBallNames.remove(ball.name);
      } else {
        _selectedBallNames.add(ball.name);
      }
    });
  }

  void _onConfirm() {
    final userArsenalAsync = ref.read(userBallsProvider);
    final theme = Theme.of(context);

    userArsenalAsync.whenData((arsenal) {
      final selectedBalls = arsenal
          .where((ball) => _selectedBallNames.contains(ball.name))
          .map((ball) {
            final palette = getBrandTonalPalette(ball.brand, theme);
            final brandColor = palette[500] ?? theme.colorScheme.primary;
            return BallInfo(
              id: ball.name, // Use name as ID as ArsenalBall doesn't have a specific ID
              name: ball.name,
              brand: ball.brand,
              brandColor: colorToHexString(brandColor),
              imagePath: ball.imagePath,
            );
          })
          .toList();
      Navigator.of(context).pop(selectedBalls);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userArsenalAsync = ref.watch(userBallsProvider);
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    final filteredArsenal = userArsenalAsync.when(
      data: (arsenal) {
        // Apply search
        var filtered = arsenal.where((ball) =>
            ball.name.toLowerCase().contains(_searchText.toLowerCase()));
        
        // Apply filters
        if (_filters.brand != null) {
          filtered = filtered.where((ball) => ball.brand == _filters.brand);
        }
        // NOTE: ArsenalBall does not have structured core/coverstock type fields
        // like BowlingBall. A simple string contains() check will be used.
        if (_filters.core != null) {
          filtered = filtered.where((ball) => ball.core.toLowerCase().contains(_filters.core!.toLowerCase()));
        }
        if (_filters.coverstock != null) {
          filtered = filtered.where((ball) => ball.cover.toLowerCase().contains(_filters.coverstock!.toLowerCase()));
        }

        var sorted = filtered.toList();
        // Apply sort
        sorted.sort((a, b) {
          // NOTE: Sorting logic is simplified to name only for ArsenalBall
          final compare = a.name.compareTo(b.name);
          return _sortCriterion.ascending ? compare : -compare;
        });
        return sorted;
      },
      loading: () => [],
      error: (e, s) => [],
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          decoration: BoxDecoration(
            color: BrandColors.darkSurfaceColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accentColor.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Bowling Balls',
                        style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.grid_view),
                            onPressed: () {
                              if (!_isGridView) {
                                setState(() {
                                  _isGridView = true;
                                });
                              }
                            },
                            color: _isGridView ? theme.colorScheme.primary : Colors.white.withOpacity(0.5),
                            splashRadius: 20,
                          ),
                          IconButton(
                            icon: const Icon(Icons.view_list),
                            onPressed: () {
                              if (_isGridView) {
                                setState(() {
                                  _isGridView = false;
                                });
                              }
                            },
                            color: !_isGridView ? theme.colorScheme.primary : Colors.white.withOpacity(0.5),
                            splashRadius: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppSearchBar(
                    searchText: _searchText,
                    onSearchChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppStandardButton(
                          icon: Icons.filter_list,
                          text: 'Filter (${_filters.activeFilterCount})',
                          isPrimary: false,
                          onPressed: () {
                            showFilterPopout(
                              context,
                              initialFilters: _filters,
                              onFiltersChanged: (newFilters) {
                                setState(() {
                                  _filters = newFilters;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SortButton(
                          sortCriterion: _sortCriterion,
                          onSortChanged: (criterion) {
                            setState(() {
                              _sortCriterion = criterion;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: userArsenalAsync.when(
                    data: (arsenal) {
                      if (arsenal.isEmpty) {
                        return const Center(
                          child: Text(
                            'No balls in your arsenal.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }
                      if (filteredArsenal.isEmpty) {
                        return const Center(
                          child: Text(
                            'No balls match your search.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      if (_isGridView) {
                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredArsenal.length,
                          itemBuilder: (context, index) {
                            final ball = filteredArsenal[index];
                            final isSelected = _selectedBallNames.contains(ball.name);
                            return BallGridItem(
                              ball: ball,
                              isSelected: isSelected,
                              onTap: () => _toggleSelection(ball),
                              accentColor: accentColor,
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredArsenal.length,
                          itemBuilder: (context, index) {
                            final ball = filteredArsenal[index];
                            final isSelected = _selectedBallNames.contains(ball.name);
                            return BallListItem(
                              ball: ball,
                              isSelected: isSelected,
                              onTap: () => _toggleSelection(ball),
                              accentColor: accentColor,
                            );
                          },
                        );
                      }
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(
                      child: Text(
                        'Error: $err',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                       Expanded(
                        child: AppStandardButton(
                          onPressed: () => Navigator.of(context).pop(),
                          text: 'Cancel',
                          isPrimary: false,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppStandardButton(
                          onPressed: _onConfirm,
                          text: 'Confirm',
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BallGridItem extends StatelessWidget {
  final ArsenalBall ball;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  const BallGridItem({
    super.key,
    required this.ball,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accentColor : Colors.white.withOpacity(0.2),
            width: isSelected ? 2.5 : 1,
          ),
          color: Colors.black.withOpacity(0.3),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        ball.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.sports_baseball, size: 40, color: Colors.white70);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
                      ),
                      child: Text(
                        ball.name,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              if (isSelected)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.7),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BallListItem extends StatelessWidget {
  final ArsenalBall ball;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  const BallListItem({
    super.key,
    required this.ball,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accentColor : Colors.white.withOpacity(0.2),
            width: isSelected ? 2.0 : 1.0,
          ),
          color: Colors.black.withOpacity(0.3),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.4),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: Image.asset(
                ball.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.sports_handball, size: 40, color: Colors.white70);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ball.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ball.brand,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: accentColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
} 