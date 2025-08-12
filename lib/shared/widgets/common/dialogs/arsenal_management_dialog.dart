import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/shared/services/bag_color_service.dart';
import 'package:core_theme/core_theme.dart';

/// Arsenal Management Dialog for managing ball assignments between bags
/// 
/// This dialog provides contextual options based on current state:
/// - Move balls between bags
/// - Remove balls from specific bags  
/// - Remove balls completely from arsenal
class ArsenalManagementDialog extends ConsumerStatefulWidget {
  const ArsenalManagementDialog({super.key});

  @override
  ConsumerState<ArsenalManagementDialog> createState() => _ArsenalManagementDialogState();
}

class _ArsenalManagementDialogState extends ConsumerState<ArsenalManagementDialog> {
  Set<int> _selectedBallIds = {};
  String _selectedOperation = '';
  int? _targetBagNumber;
  
  // 使用統一的袋子顏色服務
  List<Color> get _bagColors => BagColorService.getAllBagColors();

  void _toggleBallSelection(int ballId) {
    setState(() {
      if (_selectedBallIds.contains(ballId)) {
        _selectedBallIds.remove(ballId);
      } else {
        _selectedBallIds.add(ballId);
      }
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedBallIds.clear();
      _selectedOperation = '';
      _targetBagNumber = null;
    });
  }

  void _selectOperation(String operation) {
    setState(() {
      _selectedOperation = operation;
      _targetBagNumber = null;
    });
  }

  void _selectTargetBag(int bagNumber) {
    setState(() {
      _targetBagNumber = bagNumber;
    });
  }

  Future<void> _executeOperation() async {
    if (_selectedBallIds.isEmpty || _selectedOperation.isEmpty) {
      TopNotification.showError(context, 'Please select balls and an operation');
      return;
    }

    try {
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        TopNotification.showError(context, 'Please log in to manage arsenal');
        return;
      }
      final userId = authState.value!.id;

      switch (_selectedOperation) {
        case 'move_to_bag':
          if (_targetBagNumber == null) {
            TopNotification.showError(context, 'Please select a target bag');
            return;
          }
          await _moveToBag(userId, _targetBagNumber!);
          break;
        case 'remove_from_bag':
          await _removeFromCurrentBag(userId);
          break;
        case 'remove_from_arsenal':
          await _removeFromArsenal(userId);
          break;
      }
      
      Navigator.of(context).pop();
    } catch (e) {
      TopNotification.showError(context, 'Operation failed: $e');
    }
  }

  Future<void> _moveToBag(String userId, int targetBag) async {
    int successCount = 0;
    for (final ballId in _selectedBallIds) {
      try {
        await ref.read(newArsenalControllerProvider.notifier).updateBagAssignment(
          instanceId: ballId,
          bagNumber: targetBag,
          isInBag: true,
        );
        successCount++;
      } catch (e) {
        print('Failed to move ball $ballId to bag $targetBag: $e');
      }
    }
    
    if (successCount > 0) {
      TopNotification.showSuccess(
        context,
        'Moved $successCount ball${successCount != 1 ? 's' : ''} to bag $targetBag',
      );
    }
  }

  Future<void> _removeFromCurrentBag(String userId) async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final currentBag = arsenalState.selectedBagNumber;
    
    int successCount = 0;
    for (final ballId in _selectedBallIds) {
      try {
        await ref.read(newArsenalControllerProvider.notifier).updateBagAssignment(
          instanceId: ballId,
          bagNumber: currentBag,
          isInBag: false,
        );
        successCount++;
      } catch (e) {
        print('Failed to remove ball $ballId from bag $currentBag: $e');
      }
    }
    
    if (successCount > 0) {
      TopNotification.showSuccess(
        context,
        'Removed $successCount ball${successCount != 1 ? 's' : ''} from bag $currentBag',
      );
    }
  }

  Future<void> _removeFromArsenal(String userId) async {
    int successCount = 0;
    for (final ballId in _selectedBallIds) {
      try {
        await ref.read(newArsenalControllerProvider.notifier).removeInstance(ballId, userId);
        successCount++;
      } catch (e) {
        print('Failed to remove ball $ballId from arsenal: $e');
      }
    }
    
    if (successCount > 0) {
      TopNotification.showSuccess(
        context,
        'Removed $successCount ball${successCount != 1 ? 's' : ''} from arsenal',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final userProfileState = ref.watch(userProfileControllerProvider);
    final filteredInstances = ref.read(newArsenalControllerProvider.notifier).filteredInstances;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 700,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[600]!,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[600]!.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Arsenal Management',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: Column(
                children: [
                  // Operation selection and info
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Selection info
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Selected: ${_selectedBallIds.length} ball${_selectedBallIds.length != 1 ? 's' : ''}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (_selectedBallIds.isNotEmpty)
                              GestureDetector(
                                onTap: _resetSelection,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.orange.withOpacity(0.6),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    'Clear',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        
                        if (_selectedBallIds.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          
                          // Operation buttons
                          const Text(
                            'Choose Operation:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          _buildOperationButtons(arsenalState, userProfileState),
                          
                          // Target bag selection if needed
                          if (_selectedOperation == 'move_to_bag' && userProfileState.profile != null)
                            _buildBagSelection(userProfileState.profile!),
                        ],
                      ],
                    ),
                  ),

                  // Ball list
                  Expanded(
                    child: _buildBallList(filteredInstances),
                  ),
                ],
              ),
            ),

            // Bottom action buttons
            if (_selectedBallIds.isNotEmpty && _selectedOperation.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey[600]!.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppStandardButton(
                        text: 'Cancel',
                        height: 40,
                        fontSize: 14,
                        customColor: Colors.grey[400]!,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        text: _getExecuteButtonText(),
                        height: 40,
                        fontSize: 14,
                        customColor: _getExecuteButtonColor(),
                        isPrimary: true,
                        onPressed: (_selectedOperation == 'move_to_bag' && _targetBagNumber == null) 
                            ? () {} 
                            : _executeOperation,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationButtons(NewArsenalState arsenalState, UserProfileState userProfileState) {
    final currentBag = arsenalState.selectedBagNumber;
    
    return Column(
      children: [
        // Move to bag (only if not in "All My Arsenal" and has other bags)
        if (currentBag != 1 && userProfileState.profile != null && userProfileState.profile!.unlockedBagNumbers.length > 1)
          _buildOperationButton(
            'Move to Different Bag',
            'move_to_bag',
            Icons.swap_horiz,
            BrandColors.accentColorDark,
          ),
        
        const SizedBox(height: 8),
        
        // Remove from current bag (only if not in "All My Arsenal")
        if (currentBag != 1)
          _buildOperationButton(
            'Remove from Bag $currentBag',
            'remove_from_bag',
            Icons.remove_circle_outline,
            Colors.orange,
          ),
        
        const SizedBox(height: 8),
        
        // Remove from arsenal completely
        _buildOperationButton(
          'Remove from Arsenal',
          'remove_from_arsenal',
          Icons.delete_forever,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildOperationButton(String text, String operation, IconData icon, Color color) {
    final isSelected = _selectedOperation == operation;
    
    return GestureDetector(
      onTap: () => _selectOperation(operation),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey[600]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? color : Colors.white,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBagSelection(UserProfile profile) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Target Bag:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.unlockedBags.map((bagInfo) {
              final isSelected = _targetBagNumber == bagInfo.number;
              final bagColor = _bagColors[bagInfo.number - 1];
              
              return GestureDetector(
                onTap: () => _selectTargetBag(bagInfo.number),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? bagColor.withOpacity(0.2) : Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? bagColor : Colors.grey[600]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    bagInfo.name,
                    style: TextStyle(
                      color: isSelected ? bagColor : Colors.white,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBallList(List<UserArsenalInstance> instances) {
    if (instances.isEmpty) {
      return const Center(
        child: Text(
          'No balls in current view',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: instances.length,
        itemBuilder: (context, index) {
          final instance = instances[index];
          final isSelected = _selectedBallIds.contains(instance.id);
          
          return GestureDetector(
            onTap: () => _toggleBallSelection(instance.id),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected 
                    ? BrandColors.accentColorDark.withOpacity(0.2)
                    : Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected 
                      ? BrandColors.accentColorDark
                      : Colors.grey[600]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Selection indicator
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? BrandColors.accentColorDark : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? BrandColors.accentColorDark : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: isSelected 
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Ball info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          instance.bowlingBall?.name ?? 'Unknown Ball',
                          style: TextStyle(
                            color: isSelected ? BrandColors.accentColorDark : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (instance.bowlingBall?.brand != null)
                          Text(
                            instance.bowlingBall!.brand,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getExecuteButtonText() {
    switch (_selectedOperation) {
      case 'move_to_bag':
        return _targetBagNumber != null 
            ? 'Move to Bag $_targetBagNumber'
            : 'Select Target Bag';
      case 'remove_from_bag':
        return 'Remove from Bag';
      case 'remove_from_arsenal':
        return 'Remove from Arsenal';
      default:
        return 'Execute';
    }
  }

  Color _getExecuteButtonColor() {
    switch (_selectedOperation) {
      case 'move_to_bag':
        return BrandColors.accentColorDark;
      case 'remove_from_bag':
        return Colors.orange;
      case 'remove_from_arsenal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/// Helper function to show the arsenal management dialog
Future<void> showArsenalManagementDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.8),
    builder: (BuildContext context) {
      return const ArsenalManagementDialog();
    },
  );
}