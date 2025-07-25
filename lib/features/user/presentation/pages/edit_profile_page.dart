// 檔案路徑： edit_profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/custom_dropdown.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/providers/user_profile_provider.dart';

// --- Enums 定義 ---
enum DominateHand { left, right }
enum BowlingStyle { oneHanded, twoHanded, spinner, others }

// 修正：新增 none 選項，並將其設為第一個
enum PapUpDown {
  none, // 空白選項
  up,
  down;

  String get symbol {
    switch (this) {
      case PapUpDown.up:
        return '↑';
      case PapUpDown.down:
        return '↓';
      case PapUpDown.none:
        return ' '; // 空白選項顯示為空格
    }
  }
}

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  // 狀態變數
  final _nameController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  DominateHand? _selectedHand;
  BowlingStyle? _selectedStyle;
  int? _selectedPapInt;
  String? _selectedPapFraction1; // 第一個分數
  PapUpDown? _selectedPapUpDown = PapUpDown.none; // 預設為空白
  String? _selectedPapFraction2; // 第二個分數

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  void _loadUserProfile() {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile != null) {
      _nameController.text = userProfile.nickname;
      _countryController.text = userProfile.country;
      _cityController.text = userProfile.city;
      
      // 設定慣用手
      if (userProfile.hand == 'Left Hand') {
        _selectedHand = DominateHand.left;
      } else if (userProfile.hand == 'Right Hand') {
        _selectedHand = DominateHand.right;
      }
      
      // 設定打球風格
      switch (userProfile.bowlingStyle) {
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
      
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
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

  String _constructPapString() {
    final parts = <String>[];
    
    if (_selectedPapInt != null) {
      parts.add(_selectedPapInt.toString());
    }
    
    if (_selectedPapFraction1 != null) {
      parts.add(_selectedPapFraction1!);
    }
    
    if (_selectedPapUpDown != null && _selectedPapUpDown != PapUpDown.none) {
      parts.add(_selectedPapUpDown!.symbol);
      if (_selectedPapFraction2 != null) {
        parts.add(_selectedPapFraction2!);
      }
    }
    
    return parts.join(' ');
  }

  Future<void> _saveProfile() async {
    try {
      await ref.read(userProfileProvider.notifier).updateProfile(
        nickname: _nameController.text,
        country: _countryController.text,
        city: _cityController.text,
        hand: _selectedHand != null ? _getHandName(_selectedHand!) : '',
        bowlingStyle: _selectedStyle != null ? _getBowlingStyleName(_selectedStyle!) : '',
        pap: _constructPapString(),
        ballPath: '', // 保持現有值或空字串
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
        // 儲存成功後跳回主頁面
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $e')),
        );
      }
    }
  }

  void _exitWithoutSaving() {
    // 不儲存直接跳回主頁面
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      labelStyle: TextStyle(color: Colors.grey[400]),
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
            onPressed: () => GoRouter.of(context).pop(),
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
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // 頭像部分 (維持不變)
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(radius: 50, backgroundColor: Colors.grey.withOpacity(0.2), child: const Icon(Icons.person, size: 50, color: Colors.white70)),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            icon: const Icon(Icons.camera_alt, color: Colors.white70),
                            label: const Text('Add Photo', style: TextStyle(color: Colors.white70)),
                            onPressed: () { /* TODO: Image picker logic */ },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bowler's Name
                    TextFormField(
                      controller: _nameController,
                      decoration: inputDecorationTheme.copyWith(labelText: "Bowler's Name"),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 24),

                    // Location Section
                    const Text('Location', style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _countryController,
                            decoration: inputDecorationTheme.copyWith(labelText: "Country"),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: inputDecorationTheme.copyWith(labelText: "City"),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Dominate Hand & Bowling Style
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Dominate Hand', style: TextStyle(color: Colors.white, fontSize: 16)),
                              const SizedBox(height: 12),
                              CustomDropdown<DominateHand>(
                                hintText: 'Select Hand',
                                value: _selectedHand,
                                isFilled: true,
                                items: DominateHand.values.map((hand) => DropdownMenuItem(value: hand, child: Text(hand == DominateHand.left ? 'Left Hand' : 'Right Hand', style: const TextStyle(color: Colors.white)))).toList(),
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
                              const Text('Bowling Style', style: TextStyle(color: Colors.white, fontSize: 16)),
                              const SizedBox(height: 12),
                              CustomDropdown<BowlingStyle>(
                                hintText: 'Select Style',
                                value: _selectedStyle,
                                isFilled: true,
                                items: BowlingStyle.values.map((style) => DropdownMenuItem(value: style, child: Text(_getBowlingStyleName(style), style: const TextStyle(color: Colors.white)))).toList(),
                                onChanged: (val) => setState(() => _selectedStyle = val),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // PAP Section Title
                    const Text('Personal Positive Axis Point (PAP)', style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 12),

                    // *** 關鍵修改：PAP 改為三行式佈局 ***
                    // 第一行：整數和第一個分數
                    Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: CustomDropdown<int>(
                            hintText: ' ',
                            value: _selectedPapInt,
                            items: List.generate(7, (i) => i).map((val) => DropdownMenuItem(value: val, child: Text(val.toString(), style: const TextStyle(color: Colors.white)))).toList(),
                            onChanged: (val) => setState(() => _selectedPapInt = val),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 135,
                          child: CustomDropdown<String>(
                            hintText: ' ',
                            value: _selectedPapFraction1,
                            items: ['1/16', '1/8', '3/16', '1/4', '5/16', '3/8', '7/16', '1/2', '9/16', '5/8', '11/16', '3/4', '13/16', '7/8', '15/16']
                                .map((frac) => DropdownMenuItem(value: frac, child: Text(frac, style: const TextStyle(color: Colors.white)))).toList(),
                            onChanged: (val) => setState(() => _selectedPapFraction1 = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 第二行：上/下/空白 選項
                    SizedBox(
                      width: 100,
                      child: CustomDropdown<PapUpDown>(
                        hintText: 'Sign',
                        value: _selectedPapUpDown,
                        items: PapUpDown.values.map((dir) => DropdownMenuItem(value: dir, child: Text(dir.symbol, style: const TextStyle(color: Colors.white, fontSize: 18)))).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedPapUpDown = val;
                            // 如果選擇空白，就清空第二個分數的值
                            if (val == PapUpDown.none) {
                              _selectedPapFraction2 = null;
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 第三行：條件顯示的第二個分數
                    // 只有當選擇了 'up' 或 'down' 時才顯示
                    if (_selectedPapUpDown == PapUpDown.up || _selectedPapUpDown == PapUpDown.down)
                      SizedBox(
                        width: 135,
                        child: CustomDropdown<String>(
                          hintText: ' ',
                          value: _selectedPapFraction2,
                          items: ['1/16', '1/8', '3/16', '1/4', '5/16', '3/8', '7/16', '1/2', '9/16', '5/8', '11/16', '3/4', '13/16', '7/8', '15/16']
                              .map((frac) => DropdownMenuItem(value: frac, child: Text(frac, style: const TextStyle(color: Colors.white)))).toList(),
                          onChanged: (val) => setState(() => _selectedPapFraction2 = val),
                        ),
                      ),
                  ],
                ),
              ),
                ),
                
                // 底部按鈕區域
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppStandardButton(
                          onPressed: _exitWithoutSaving,
                          text: 'Exit',
                          isPrimary: false,
                          height: 50,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppStandardButton(
                          onPressed: _saveProfile,
                          text: 'Save',
                          isPrimary: true,
                          height: 50,
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