// 檔案路徑： edit_profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/selection_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/selection_bottom_sheet.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/selectors/country_selector_v2.dart';
import 'package:bowlingarsenal_app/shared/widgets/selectors/pap_selector.dart';
import 'package:bowlingarsenal_app/shared/models/country_model.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

// --- Enums 定義 ---
enum DominateHand { left, right }
enum BowlingStyle { oneHanded, twoHanded, spinner, others }

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  // 狀態變數
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  Country? _selectedCountry;
  DominateHand? _selectedHand;
  BowlingStyle? _selectedStyle;
  int? _selectedPapInt;
  String? _selectedPapFraction1; // 第一個分數
  PapDirection _selectedPapDirection = PapDirection.none; // 預設為空白
  String? _selectedPapFraction2; // 第二個分數
  
  // 照片相關
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProfile();
    });
  }

  Future<void> _initializeProfile() async {
    // 獲取當前用戶 ID 並載入 profile
    final supabase = ref.read(supabaseClientProvider);
    final userId = supabase.auth.currentUser?.id;
    
    if (userId != null) {
      // 先載入用戶資料到 controller
      await ref.read(userProfileControllerProvider.notifier).loadUserProfile(userId);
      // 然後將資料載入到頁面控制項
      _loadUserProfile();
    }
  }

  void _loadUserProfile() {
    final userProfileState = ref.read(userProfileControllerProvider);
    final userProfile = userProfileState.profile;
    
    if (userProfile != null) {
      _applyProfileToFields();
    }
  }

  void _applyProfileToFields() {
    final userProfileState = ref.read(userProfileControllerProvider);
    final userProfile = userProfileState.profile;
    if (userProfile == null) {
      return;
    }
    _nameController.text = userProfile.nickname ?? '';
    _cityController.text = userProfile.city ?? '';
      
    // 嘗試从國家名稱找到對應的 Country 物件
    if (userProfile.country != null && userProfile.country!.isNotEmpty) {
      _selectedCountry = Countries.findByCode(userProfile.country!);
      if (_selectedCountry == null) {
        try {
          _selectedCountry = Countries.all.firstWhere(
            (country) => country.name.toLowerCase() == userProfile.country!.toLowerCase(),
          );
        } catch (e) {
          _selectedCountry = null;
        }
      }
    }
      
    // 設定慣用手
    if (userProfile.dominateHand == 'Left Hand') {
      _selectedHand = DominateHand.left;
    } else if (userProfile.dominateHand == 'Right Hand') {
      _selectedHand = DominateHand.right;
    }
      
    // 設定打球風格
    switch (userProfile.style) {
      case 'One-Handed':
        _selectedStyle = BowlingStyle.oneHanded;
        break;
      case 'Two-Handed':
        _selectedStyle = BowlingStyle.twoHanded;
        break;
      case 'Spinner':
        _selectedStyle = BowlingStyle.spinner;
        break;
      case 'Others':
        _selectedStyle = BowlingStyle.others;
        break;
    }
      
    // 載入 PAP 資料
    _selectedPapInt = userProfile.papInteger;
    _selectedPapFraction1 = userProfile.papFraction;
    _selectedPapDirection = PapDirection.fromValue(userProfile.papDirection);
    _selectedPapFraction2 = userProfile.papDriftFraction;
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  String _getBowlingStyleName(BowlingStyle style) {
    switch (style) {
      case BowlingStyle.oneHanded: return 'One-Handed';
      case BowlingStyle.twoHanded: return 'Two-Handed';
      case BowlingStyle.spinner: return 'Spinner';
      case BowlingStyle.others: return 'Others';
    }
  }

  String _getHandName(DominateHand hand) {
    return hand == DominateHand.left ? 'Left Hand' : 'Right Hand';
  }

  /// 獲取照片按鈕文字
  String _getPhotoButtonText() {
    // 如果當前選擇了新圖片
    if (_selectedImage != null) {
      return 'Change Photo';
    }
    
    // 如果用戶已經有頭像
    final userProfile = ref.watch(userProfileControllerProvider).profile;
    final hasExistingAvatar = userProfile?.avatarUrl != null && 
        userProfile!.avatarUrl!.isNotEmpty &&
        !userProfile.avatarUrl!.contains('localhost') &&
        userProfile.avatarUrl!.startsWith('http');
    
    return hasExistingAvatar ? 'Change Photo' : 'Add Photo';
  }

  /// 獲取 PAP 顯示文字
  String _getPapDisplayText() {
    if (!_hasAnyPapValue()) {
      return 'Not set';
    }

    final parts = <String>[];
    
    // 添加整數部分
    if (_selectedPapInt != null) {
      parts.add(_selectedPapInt.toString());
    }
    
    // 添加第一個分數
    if (_selectedPapFraction1 != null) {
      parts.add(_selectedPapFraction1!);
    }
    
    // 添加方向和第二個分數
    if (_selectedPapDirection != PapDirection.none) {
      parts.add(_selectedPapDirection.symbol);
      if (_selectedPapFraction2 != null) {
        parts.add(_selectedPapFraction2!);
      }
    }
    
    return parts.isEmpty ? 'Not set' : parts.join(' ');
  }

  /// 檢查是否有任何 PAP 值設定
  bool _hasAnyPapValue() {
    return _selectedPapInt != null || 
           _selectedPapFraction1 != null || 
           _selectedPapDirection != PapDirection.none ||
           _selectedPapFraction2 != null;
  }

  /// 重置 PAP 所有數值
  void _resetPapValues() async {
    // 顯示確認對話框
    final bool? shouldReset = await AppBaseDialog.showConfirmation(
      context: context,
      title: 'Reset PAP Configuration',
      message: 'Are you sure you want to reset all PAP values? This action cannot be undone.',
      confirmText: 'Reset',
      cancelText: 'Cancel',
      isDestructive: true, // 使用紅色邊框表示危險操作
    );
    
    // 如果用戶確認重置
    if (shouldReset == true) {
      setState(() {
        _selectedPapInt = null;
        _selectedPapFraction1 = null;
        _selectedPapDirection = PapDirection.none;
        _selectedPapFraction2 = null;
      });
      
      TopNotification.showSuccess(context, 'PAP configuration has been reset');
    }
  }

  /// 選擇照片
  Future<void> _pickImage() async {
    try {
      // 顯示選擇來源對話框
      final ImageSource? source = await AppBaseDialog.show<ImageSource>(
        context: context,
        title: 'Select Photo Source',
        borderColor: Theme.of(context).colorScheme.primary,
        content: const Text(
          'Choose where you want to select your photo from:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          AppStandardButton.primaryOutlined(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            text: 'Camera',
            height: 48,
          ),
          AppStandardButton.primaryOutlined(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            text: 'Gallery',
            height: 48,
          ),
        ],
      );

      if (source != null) {
        
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
        
        if (image != null) {
          
          setState(() {
            _selectedImage = image;
          });
          
          TopNotification.showSuccess(context, 'Photo selected successfully! Click Save to upload.');
        }
      }
    } catch (e) {
      TopNotification.showError(context, 'Failed to select photo: $e');
    }
  }

  /// 開啟 PAP 滾動選擇器
  void _openPapSelector() async {
    final result = await showPapSelector(
      context,
      initialInteger: _selectedPapInt,
      initialFraction1: _selectedPapFraction1,
      initialDirection: _selectedPapDirection,
      initialFraction2: _selectedPapFraction2,
    );
    
    if (result != null) {
      setState(() {
        _selectedPapInt = result.integer;
        _selectedPapFraction1 = result.fraction1;
        _selectedPapDirection = result.direction;
        _selectedPapFraction2 = result.fraction2;
      });
    }
  }

  Future<void> _saveProfile() async {
    try {
      // 獲取當前用戶 ID
      final supabase = ref.read(supabaseClientProvider);
      final userId = supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      String? avatarUrl;
      
      // 如果用戶選擇了新圖片，先上傳到Supabase
      if (_selectedImage != null) {
        try {
          final imageUploadService = ref.read(imageUploadServiceProvider);
          
          // 先刪除舊頭像（如果存在）
          final currentProfile = ref.read(userProfileControllerProvider).profile;
          if (currentProfile?.avatarUrl != null && currentProfile!.avatarUrl!.isNotEmpty) {
            try {
              await imageUploadService.deleteOldAvatar(currentProfile.avatarUrl!);
            } catch (e) {
              // 刪除舊頭像失敗不影響新頭像上傳
            }
          }
          
          // 上傳新圖片
          avatarUrl = await imageUploadService.uploadUserAvatar(
            userId: userId,
            imageFile: _selectedImage!,
          );
          
          // 驗證URL格式
          if (avatarUrl.contains('localhost') || !avatarUrl.startsWith('http')) {
            throw Exception('上傳失敗：生成的URL無效 ($avatarUrl)');
          }
          
        } catch (e) {
          // 提供詳細錯誤信息
          String errorMessage = e.toString();
          String helpMessage = '';
          
          if (errorMessage.contains('bucket') && errorMessage.contains('不存在')) {
            helpMessage = '\n\n解決方法：\n1. 登入Supabase Dashboard\n2. 進入Storage\n3. 創建名為"avatars"的bucket\n4. 設定為Public';
          } else if (errorMessage.contains('權限') || errorMessage.contains('permission')) {
            helpMessage = '\n\n解決方法：請檢查Supabase storage policies設定';
          }
          
          if (mounted) {
            TopNotification.showError(context, '圖片上傳失敗: $errorMessage$helpMessage');
          }
          return; // 上傳失敗就不繼續保存
        }
      }

      // 使用新的 controller 更新個人資料
      await ref.read(userProfileControllerProvider.notifier).updateProfile(
        userId: userId,
        nickname: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
        avatarUrl: avatarUrl, // 使用上傳後的URL，如果沒有上傳則為null
        country: _selectedCountry?.name,
        city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
        dominateHand: _selectedHand != null ? _getHandName(_selectedHand!) : null,
        style: _selectedStyle != null ? _getBowlingStyleName(_selectedStyle!) : null,
        papInteger: _selectedPapInt,
        papFraction: _selectedPapFraction1,
        papDirection: _selectedPapDirection.value,
        papDriftInteger: null, // 如果有此欄位的輸入可以加上
        papDriftFraction: _selectedPapFraction2,
      );
      
      if (mounted) {
        TopNotification.showSuccess(context, 'Profile saved successfully!');
        // 儲存成功後跳回主頁面
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        TopNotification.showError(context, 'Failed to save profile: $e');
      }
    }
  }

  void _exitWithoutSaving() {
    // 不儲存直接跳回主頁面
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    // 在 build 內監聽 state 變化（符合 Riverpod 規範）
    ref.listen<UserProfileState>(
      userProfileControllerProvider,
      (previous, next) {
        if (next.profile != null && previous?.profile != next.profile) {
          _applyProfileToFields();
        }
      },
    );
    final inputDecorationTheme = InputDecoration(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
      ),
      labelStyle: TextStyle(color: Colors.grey[400]),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
    );

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: Stack(
          children: [
            // 在此頁面加上半透明黑色遮罩，讓 UI 更清晰
            Container(color: Colors.black.withOpacity(0.4)),
            
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // 頭像部分
                    Center(
                      child: Column(
                        children: [
                          // 頭像顯示
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            backgroundImage: _selectedImage != null 
                                ? (kIsWeb 
                                    ? NetworkImage(_selectedImage!.path) as ImageProvider
                                    : FileImage(File(_selectedImage!.path)) as ImageProvider)
                                : (ref.watch(userProfileControllerProvider).profile?.avatarUrl != null
                                    ? NetworkImage(ref.watch(userProfileControllerProvider).profile!.avatarUrl!) as ImageProvider
                                    : null),
                            child: _selectedImage == null && ref.watch(userProfileControllerProvider).profile?.avatarUrl == null
                                ? const Icon(Icons.person, size: 40, color: Colors.white70)
                                : null,
                          ),
                          const SizedBox(height: 6),
                          // Add/Change Photo 按鈕
                          InkWell(
                            onTap: _pickImage,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _selectedImage != null ? Icons.edit : Icons.camera_alt, 
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _getPhotoButtonText(),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bowler's Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Bowler's Name", style: TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          decoration: inputDecorationTheme,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Country and City Section
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Country', style: TextStyle(color: Colors.white, fontSize: 14)),
                              const SizedBox(height: 6),
                              CountrySelectorV2(
                                selectedCountry: _selectedCountry,
                                onChanged: (country) => setState(() => _selectedCountry = country),
                                showGroups: false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('City', style: TextStyle(color: Colors.white, fontSize: 14)),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _cityController,
                                decoration: inputDecorationTheme.copyWith(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Dominate Hand & Bowling Style
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Dominate Hand', style: TextStyle(color: Colors.white, fontSize: 14)),
                              const SizedBox(height: 6),
                              SelectionButton<DominateHand>(
                                hint: 'Select Hand',
                                value: _selectedHand,
                                dialogTitle: 'Dominate Hand',
                                items: DominateHand.values.map((hand) => SelectionItem(
                                  value: hand,
                                  displayText: hand == DominateHand.left ? 'Left Hand' : 'Right Hand',
                                )).toList(),
                                onChanged: (val) => setState(() => _selectedHand = val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Bowling Style', style: TextStyle(color: Colors.white, fontSize: 14)),
                              const SizedBox(height: 6),
                              SelectionButton<BowlingStyle>(
                                hint: 'Select Style',
                                value: _selectedStyle,
                                dialogTitle: 'Bowling Style',
                                items: BowlingStyle.values.map((style) => SelectionItem(
                                  value: style,
                                  displayText: _getBowlingStyleName(style),
                                )).toList(),
                                onChanged: (val) => setState(() => _selectedStyle = val),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // PAP Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Personal Positive Axis Point (PAP)', style: TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 6),
                        
                        // PAP 顯示和設定區域
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getPapDisplayText(),
                                      style: TextStyle(
                                        color: _hasAnyPapValue() ? Colors.white : Colors.grey[400],
                                        fontSize: 18, // 從14增大到18
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    // 移除次行說明
                                  ],
                                ),
                              ),
                              
                              // Set/Reset 按鈕
                              InkWell(
                                onTap: _hasAnyPapValue() ? _resetPapValues : _openPapSelector,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    // 移除外框
                                  ),
                                  child: Text(
                                    _hasAnyPapValue() ? 'Reset' : 'Set', // 根據是否有資料顯示不同文字
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
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
                ),
                
                // 底部按鈕區域
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppStandardButton.primaryOutlined(
                          onPressed: _exitWithoutSaving,
                          text: 'Exit',
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppStandardButton(
                          onPressed: _saveProfile,
                          text: 'Save',
                          height: 40,
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
    );
  }
}