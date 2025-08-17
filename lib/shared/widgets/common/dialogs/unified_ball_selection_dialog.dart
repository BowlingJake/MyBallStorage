import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_theme/core_theme.dart';

/// Arsenal Ball Selection Dialog
/// 
/// This dialog is specifically for selecting balls from user's arsenal
/// with grid-based UI for visual ball identification.
class ArsenalBallSelectionDialog extends ConsumerStatefulWidget {
  const ArsenalBallSelectionDialog({
    this.title,
    this.excludeBagNumbers,
    super.key,
  });

  final String? title;
  final List<int>? excludeBagNumbers; // Exclude balls from specific bags

  @override
  ConsumerState<ArsenalBallSelectionDialog> createState() => _ArsenalBallSelectionDialogState();
}

class _ArsenalBallSelectionDialogState extends ConsumerState<ArsenalBallSelectionDialog> {
  Set<int> _selectedIds = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedIds.clear();
    });
  }

  void _confirm() {
    Navigator.of(context).pop(_selectedIds.toList());
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.brightness == Brightness.dark
        ? BrandColors.accentColorDark
        : BrandColors.accentColorLight;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor, width: 1.5),
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Search and Filter
            _buildSearchAndFilter(),
            
            // Ball List
            Expanded(
              child: _buildArsenalContent(),
            ),
            
            // Footer Actions
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final defaultTitle = 'Select from My Arsenal';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[600]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title ?? defaultTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (_selectedIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
              ),
              child: Text(
                '${_selectedIds.length} selected',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[600]!),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search balls...',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildArsenalContent() {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    var instances = arsenalState.allInstances;
    
    // Filter by bag exclusions if specified
    if (widget.excludeBagNumbers != null) {
      instances = instances.where((instance) {
        return !widget.excludeBagNumbers!.any((bagNum) => 
          instance.activeBagNumbers.contains(bagNum));
      }).toList();
    }
    
    final filteredInstances = _filterArsenalInstances(instances);
    
    if (filteredInstances.isEmpty) {
      return _buildEmptyState();
    }
    
    return _buildBallGrid(
      balls: filteredInstances.map((instance) => _BallItem.fromArsenal(instance)).toList(),
    );
  }

  Widget _buildBallGrid({required List<_BallItem> balls}) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: balls.length,
        itemBuilder: (context, index) {
          final ballItem = balls[index];
          final isSelected = _selectedIds.contains(ballItem.id);
          
          return _buildBallCard(ballItem, isSelected);
        },
      ),
    );
  }

  Widget _buildBallCard(_BallItem ballItem, bool isSelected) {
    final theme = Theme.of(context);
    final primaryColor = theme.brightness == Brightness.dark
        ? BrandColors.accentColorDark
        : BrandColors.accentColorLight;
        
    final brandPalette = getBrandTonalPalette(ballItem.brandName, theme);
    final brandColor = brandPalette[400]!;
    
    return GestureDetector(
      onTap: () => _toggleSelection(ballItem.id),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.6),
          border: Border.all(
            color: isSelected 
                ? primaryColor
                : Colors.grey[600]!.withOpacity(0.6),
            width: 2.0, // 固定邊框寬度避免選中時變化
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ] : null,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ball Image
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: ClipOval(
                        child: _buildBallImage(ballItem.imageUrl, 100),
                      ),
                    ),
                  ),
                ),
                
                // Ball Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Ball Name
                        Text(
                          ballItem.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        
                        // Brand
                        Flexible(
                          child: Text(
                            ballItem.brandName,
                            style: TextStyle(
                              fontSize: 12,
                              color: brandColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        if (ballItem.additionalInfo != null) ...[
                          const SizedBox(height: 4),
                          Flexible(
                            child: Text(
                              ballItem.additionalInfo!,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Selection indicator
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBallImage(String imageUrl, double size) {
    if (imageUrl.isNotEmpty && imageUrl != 'https://via.placeholder.com/150') {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: size,
        height: size,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.sports_baseball, 
          color: Colors.white54, 
          size: 35,
        ),
      );
    } else {
      return const Icon(
        Icons.sports_baseball, 
        color: Colors.white54, 
        size: 35,
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_baseball_outlined,
            color: Colors.grey[400],
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No balls available',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some balls to your arsenal first',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[600]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppStandardButton.primaryOutlined(
              text: _selectedIds.isNotEmpty ? 'Reset' : 'Cancel',
              height: 40,
              onPressed: _selectedIds.isNotEmpty 
                  ? _resetSelection 
                  : () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppStandardButton(
              text: 'Add',
              height: 40,
              enabled: _selectedIds.isNotEmpty,
              onPressed: _confirm,
            ),
          ),
        ],
      ),
    );
  }


  List<UserArsenalInstance> _filterArsenalInstances(List<UserArsenalInstance> instances) {
    if (_searchQuery.isEmpty) return instances;
    
    return instances.where((instance) {
      return instance.displayName.toLowerCase().contains(_searchQuery) ||
             instance.brandName.toLowerCase().contains(_searchQuery);
    }).toList();
  }


}

/// Helper class to unify ball data representation
class _BallItem {
  const _BallItem({
    required this.id,
    required this.name,
    required this.brandName,
    required this.imageUrl,
    this.additionalInfo,
  });


  factory _BallItem.fromArsenal(UserArsenalInstance instance) {
    final ball = instance.bowlingBall;
    String additionalInfo = 'Unknown | Unknown';
    if (ball != null) {
      additionalInfo = '${ball.coreType ?? 'Unknown'} | ${ball.coverstockType ?? 'Unknown'}';
    }
    
    return _BallItem(
      id: instance.id,
      name: instance.displayName,
      brandName: instance.brandName,
      imageUrl: instance.effectiveImageUrl,
      additionalInfo: additionalInfo,
    );
  }

  final int id;
  final String name;
  final String brandName;
  final String imageUrl;
  final String? additionalInfo;
}

/// Helper function to show arsenal ball selection dialog
Future<List<int>?> showArsenalBallSelectionDialog({
  required BuildContext context,
  String? title,
  List<int>? excludeBagNumbers,
}) {
  return showDialog<List<int>>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (context) => ArsenalBallSelectionDialog(
      title: title,
      excludeBagNumbers: excludeBagNumbers,
    ),
  );
}