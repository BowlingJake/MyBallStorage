import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/shared/services/bag_color_service.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bag Management Dialog for managing bowling ball bags
class BagManagementDialog extends ConsumerStatefulWidget {
  /// Creates a bag management dialog
  const BagManagementDialog({super.key});

  @override
  ConsumerState<BagManagementDialog> createState() => 
      _BagManagementDialogState();
}

class _BagManagementDialogState extends ConsumerState<BagManagementDialog> {
  
  // 使用統一的袋子顏色服務
  List<Color> get _bagColors => BagColorService.getAllBagColors();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserProfile();
    });
  }

  void _initializeUserProfile() {
    final authState = ref.read(authControllerProvider);
    final userProfileState = ref.read(userProfileControllerProvider);
    
    if (authState.hasValue && authState.value != null) {
      final userId = authState.value!.id;
      // 只有當 profile 為 null 或者沒有載入中時才重新載入
      if (userProfileState.profile == null && !userProfileState.isLoading) {
        ref.read(userProfileControllerProvider.notifier).loadUserProfile(userId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileControllerProvider);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[600]!,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 標題
              _buildHeader(),
              const SizedBox(height: 20),
              
              // 3x3長方形球袋格子或載入中
              Expanded(
                child: userProfileState.isLoading 
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : _buildBagsGrid(),
              ),
              
              const SizedBox(height: 16),
              
              // 底部按鈕
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Bag Management',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        _buildBagStatistics(),
      ],
    );
  }

  /// 建構球袋統計資訊
  Widget _buildBagStatistics() {
    final userProfileState = ref.watch(userProfileControllerProvider);
    final statistics = ref.read(userProfileControllerProvider.notifier).getBagStatistics();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[700]!,
          width: 1,
        ),
      ),
      child: Text(
        '${statistics['unlockedBags']}/${statistics['totalBags']} Bags Unlocked',
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


  Widget _buildBagsGrid() {
    const double bagWidth = 100;
    const double bagHeight = 140;
    const double bagSpacing = 12;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // 計算整個網格的總尺寸
        final totalGridWidth = (bagWidth * 3) + (bagSpacing * 2);
        final totalGridHeight = (bagHeight * 3) + (bagSpacing * 2);
        
        // 計算網格在容器中的起始位置（讓整個網格居中）
        final startX = (constraints.maxWidth - totalGridWidth) / 2;
        final startY = (constraints.maxHeight - totalGridHeight) / 2;
        
        return Stack(
          children: List.generate(9, (index) {
            // 計算3x3位置
            final row = index ~/ 3;
            final col = index % 3;
            final top = startY + (row * (bagHeight + bagSpacing));
            final left = startX + (col * (bagWidth + bagSpacing));
            
            return Positioned(
              top: top,
              left: left,
              child: _buildSingleBagCard(index),
            );
          }),
        );
      },
    );
  }

  Widget _buildSingleBagCard(int index) {
    const double bagWidth = 100;  // 與_buildBagsGrid保持一致
    const double bagHeight = 140; // 與_buildBagsGrid保持一致
    
    final userProfileState = ref.watch(userProfileControllerProvider);
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final bagNumber = index + 1;
    
    // 檢查是否已開通，只有當 profile 存在時才檢查，否則只有袋子1預設開通
    final isUnlocked = userProfileState.profile != null 
        ? userProfileState.profile!.isBagUnlocked(bagNumber)
        : (bagNumber == 1);
    final nextBagToUnlock = userProfileState.profile?.nextBagToUnlock ?? 2; // 如果profile是null，預設下一個要開通的是袋子2
    final isNextToUnlock = nextBagToUnlock == bagNumber;
    
    // 計算該袋子中的球數
    final ballCount = _getBallCountInBag(arsenalState, bagNumber);
    
    // 決定顏色：已開通用原色，未開通用灰色
    final borderColor = isUnlocked ? _bagColors[index] : Colors.grey;
    final textColor = isUnlocked ? _bagColors[index] : Colors.grey;
    
    return Container(
      width: bagWidth,
      height: bagHeight,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: isNextToUnlock 
            ? () => _showUnlockBagDialog(index) 
            : isUnlocked 
                ? () => _showBagOperationDialog(index) 
                : null,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // 左上角編號
            Positioned(
              top: 8,
              left: 8,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // 已開通格子顯示名稱和球數
            if (isUnlocked)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bagNumber == 1 
                          ? 'All My Arsenal' 
                          : (userProfileState.profile?.getBagName(bagNumber) ?? 'Bag $bagNumber'),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$ballCount ball${ballCount == 1 ? '' : 's'}',
                      style: TextStyle(
                        color: textColor.withOpacity(0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            
            // 如果是下一個要開通的格子，顯示+號
            if (isNextToUnlock)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildBottomButtons() {
    return AppStandardButton(
      text: 'Close',
      height: 40,
      fontSize: 14,
      customColor: Colors.grey[400]!,
      onPressed: Navigator.of(context).pop,
    );
  }

  void _showBagOperationDialog(int index) {
    final bagNumber = index + 1;
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            constraints: const BoxConstraints(maxWidth: 400), // 加大對話框以容納兩個按鈕
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 兩個水平並列按鈕
                  Row(
                    children: [
                      // Edit Bag 按鈕
                      Expanded(
                        child: AppStandardButton(
                          text: 'Edit Bag',
                          height: 40, // 縮小高度
                          fontSize: 14,
                          customColor: Colors.grey[400]!,
                          isPrimary: false, // outlined樣式
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            _showEditBagDialog(index);
                          },
                        ),
                      ),
                      const SizedBox(width: 12), // 按鈕間距
                      // Delete This Bag 按鈕（袋子 1 不能刪除）
                      Expanded(
                        child: AppStandardButton(
                          text: 'Delete This Bag',
                          height: 40, // 縮小高度
                          fontSize: 14,
                          customColor: bagNumber == 1 ? Colors.grey : Colors.red,
                          isPrimary: false, // outlined樣式
                          onPressed: bagNumber == 1 ? () {} : () {
                            Navigator.of(dialogContext).pop();
                            _showDeleteBagDialog(index);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteBagDialog(int index) {
    final bagNumber = index + 1;
    final userProfileState = ref.read(userProfileControllerProvider);
    final currentName = userProfileState.profile?.getBagName(bagNumber) ?? 'Bag $bagNumber';
    
    AppBaseDialog.showConfirmation(
      context: context,
      title: 'Delete $currentName',
      message: 'Are you sure you want to delete this bag?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      confirmColor: Colors.red,
      isDestructive: true,
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          // 取得使用者ID
          final authState = ref.read(authControllerProvider);
          if (!authState.hasValue || authState.value == null) {
            throw Exception('User not authenticated');
          }
          final userId = authState.value!.id;
          
          // 刪除袋子
          await ref.read(userProfileControllerProvider.notifier).deleteBag(
            userId: userId,
            bagNumber: bagNumber,
          );
          
          if (mounted) {
            TopNotification.showSuccess(
              context,
              'Bag $bagNumber deleted successfully!',
            );
          }
        } catch (e) {
          if (mounted) {
            TopNotification.showError(
              context,
              'Failed to delete bag: $e',
            );
          }
        }
      }
    });
  }

  void _showEditBagDialog(int index) {
    final userProfileState = ref.read(userProfileControllerProvider);
    final bagNumber = index + 1;
    final currentName = userProfileState.profile?.getBagName(bagNumber) ?? '';
    
    final TextEditingController nameController = TextEditingController(
      text: currentName,
    );
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: const BoxConstraints(maxWidth: 350),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 標題
                  Text(
                    'Edit Bag ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 名稱輸入框
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter bag name...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: _bagColors[index]),
                      ),
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.6),
                    ),
                    maxLength: 20,
                  ),
                  const SizedBox(height: 16),
                  
                  // 按鈕
                  Row(
                    children: [
                      Expanded(
                        child: AppStandardButton(
                          text: 'Cancel',
                          height: 36,
                          fontSize: 14,
                          customColor: Colors.grey[400]!,
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStandardButton(
                          text: 'Save',
                          height: 36,
                          fontSize: 14,
                          customColor: _bagColors[index],
                          isPrimary: true,
                          onPressed: () async {
                            final bagName = nameController.text.trim();
                            if (bagName.isEmpty) {
                              TopNotification.showError(
                                dialogContext,
                                'Please enter a bag name',
                              );
                              return;
                            }
                            
                            try {
                              // 取得使用者ID
                              final authState = ref.read(authControllerProvider);
                              if (!authState.hasValue || authState.value == null) {
                                throw Exception('User not authenticated');
                              }
                              final userId = authState.value!.id;
                              
                              // 更新後端
                              await ref.read(userProfileControllerProvider.notifier).updateBagName(
                                userId: userId,
                                bagNumber: index + 1,
                                bagName: bagName,
                              );
                              
                              Navigator.of(dialogContext).pop();
                              if (!mounted) return;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  TopNotification.showSuccess(
                                    context,
                                    'Bag ${index + 1} updated successfully!',
                                  );
                                }
                              });
                            } catch (e) {
                              if (!mounted) return;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  TopNotification.showError(
                                    context,
                                    'Failed to update bag: $e',
                                  );
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      nameController.dispose();
    });
  }

  void _showUnlockBagDialog(int index) {
    final TextEditingController nameController = TextEditingController();
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: const BoxConstraints(maxWidth: 350),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 標題
                  Text(
                    'Unlock Bag ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 名稱輸入框
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter bag name...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: _bagColors[index]),
                      ),
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.6),
                    ),
                    maxLength: 20,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  
                  // 按鈕
                  Row(
                    children: [
                      Expanded(
                        child: AppStandardButton(
                          text: 'Cancel',
                          height: 36,
                          fontSize: 14,
                          customColor: Colors.grey[400]!,
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStandardButton(
                          text: 'Unlock',
                          height: 36,
                          fontSize: 14,
                          customColor: _bagColors[index],
                          isPrimary: true,
                          onPressed: () async {
                            final bagName = nameController.text.trim();
                            if (bagName.isEmpty) {
                              TopNotification.showError(
                                dialogContext,
                                'Please enter a bag name',
                              );
                              return;
                            }
                            
                            try {
                              // 取得使用者ID
                              final authState = ref.read(authControllerProvider);
                              if (!authState.hasValue || authState.value == null) {
                                throw Exception('User not authenticated');
                              }
                              final userId = authState.value!.id;
                              
                              // 更新後端
                              await ref.read(userProfileControllerProvider.notifier).unlockBag(
                                userId: userId,
                                bagNumber: index + 1,
                                bagName: bagName,
                              );
                              
                              Navigator.of(dialogContext).pop();
                              if (!mounted) return;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  TopNotification.showSuccess(
                                    context,
                                    'Bag ${index + 1} unlocked successfully!',
                                  );
                                }
                              });
                            } catch (e) {
                              if (!mounted) return;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  TopNotification.showError(
                                    context,
                                    'Failed to unlock bag: $e',
                                  );
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      nameController.dispose();
    });
  }

  /// 計算指定袋子中的球數
  int _getBallCountInBag(NewArsenalState arsenalState, int bagNumber) {
    if (arsenalState.allInstances.isEmpty) return 0;
    
    return arsenalState.allInstances.where((instance) {
      return instance.isInBag(bagNumber);
    }).length;
  }
}

/// Helper function to show the bag management dialog
Future<void> showBagManagementDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.8),
    builder: (BuildContext context) {
      return const BagManagementDialog();
    },
  );
}
