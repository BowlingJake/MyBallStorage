import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/providers/user_profile_provider.dart';
import 'package:bowlingarsenal_app/shared/models/user_profile.dart';
import 'package:iconsax/iconsax.dart';

class FavoriteCentersOilPatternsPage extends ConsumerStatefulWidget {
  const FavoriteCentersOilPatternsPage({super.key});

  @override
  ConsumerState<FavoriteCentersOilPatternsPage> createState() => _FavoriteCentersOilPatternsPageState();
}

class _FavoriteCentersOilPatternsPageState extends ConsumerState<FavoriteCentersOilPatternsPage> {
  final List<TextEditingController> _centerControllers = [];
  final List<_OilPatternControllers> _oilPatternControllers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile != null) {
      // 載入常用球館
      if (userProfile.favoriteCenters.isNotEmpty) {
        for (final center in userProfile.favoriteCenters) {
          final controller = TextEditingController(text: center);
          _centerControllers.add(controller);
        }
      } else {
        _centerControllers.add(TextEditingController());
      }

      // 載入常用油圖
      if (userProfile.favoriteOilPatterns.isNotEmpty) {
        for (final pattern in userProfile.favoriteOilPatterns) {
          final controllers = _OilPatternControllers(
            nameController: TextEditingController(text: pattern.name),
            lengthController: TextEditingController(text: pattern.lengthInFeet),
          );
          _oilPatternControllers.add(controllers);
        }
      } else {
        _oilPatternControllers.add(_OilPatternControllers(
          nameController: TextEditingController(),
          lengthController: TextEditingController(),
        ));
      }
    } else {
      // 如果沒有資料，添加一個空的輸入框
      _centerControllers.add(TextEditingController());
      _oilPatternControllers.add(_OilPatternControllers(
        nameController: TextEditingController(),
        lengthController: TextEditingController(),
      ));
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (final controller in _centerControllers) {
      controller.dispose();
    }
    for (final controllers in _oilPatternControllers) {
      controllers.nameController.dispose();
      controllers.lengthController.dispose();
    }
    super.dispose();
  }

  void _addCenterField() {
    setState(() {
      _centerControllers.add(TextEditingController());
    });
  }

  void _addOilPatternField() {
    setState(() {
      _oilPatternControllers.add(_OilPatternControllers(
        nameController: TextEditingController(),
        lengthController: TextEditingController(),
      ));
    });
  }

  void _removeCenterField(int index) {
    if (_centerControllers.length > 1) {
      setState(() {
        _centerControllers[index].dispose();
        _centerControllers.removeAt(index);
      });
    }
  }

  void _removeOilPatternField(int index) {
    if (_oilPatternControllers.length > 1) {
      setState(() {
        _oilPatternControllers[index].nameController.dispose();
        _oilPatternControllers[index].lengthController.dispose();
        _oilPatternControllers.removeAt(index);
      });
    }
  }

  Future<void> _saveData() async {
    try {
      final centers = _centerControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final oilPatterns = _oilPatternControllers
          .where((controllers) => controllers.nameController.text.trim().isNotEmpty)
          .map((controllers) => OilPattern(
            name: controllers.nameController.text.trim(),
            lengthInFeet: controllers.lengthController.text.trim(),
          ))
          .toList();

      await ref.read(userProfileProvider.notifier).updateProfile(
        favoriteCenters: centers,
        favoriteOilPatterns: oilPatterns,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved successfully!')),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }

  void _exitWithoutSaving() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
        borderSide: BorderSide(color: theme.primaryColor),
      ),
      labelStyle: TextStyle(color: Colors.grey[400]),
    );

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Favorite Centers & Oil Patterns'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 球館區塊
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Bowling Centers',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _addCenterField,
                              icon: const Icon(Iconsax.add_circle, color: Colors.white70),
                              tooltip: 'Add Center',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(_centerControllers.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _centerControllers[index],
                                    decoration: inputDecorationTheme.copyWith(
                                      hintText: 'Enter bowling center name',
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                if (_centerControllers.length > 1)
                                  IconButton(
                                    onPressed: () => _removeCenterField(index),
                                    icon: const Icon(Iconsax.minus_cirlce, color: Colors.red),
                                    tooltip: 'Remove',
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 油圖區塊
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Oil Patterns',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _addOilPatternField,
                              icon: const Icon(Iconsax.add_circle, color: Colors.white70),
                              tooltip: 'Add Pattern',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(_oilPatternControllers.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _oilPatternControllers[index].nameController,
                                    decoration: inputDecorationTheme.copyWith(
                                      hintText: 'Enter oil pattern name',
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _oilPatternControllers[index].lengthController,
                                    decoration: inputDecorationTheme.copyWith(
                                      hintText: 'Ft',
                                      suffixText: 'Ft',
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                if (_oilPatternControllers.length > 1)
                                  IconButton(
                                    onPressed: () => _removeOilPatternField(index),
                                    icon: const Icon(Iconsax.minus_cirlce, color: Colors.red),
                                    tooltip: 'Remove',
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
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
                      onPressed: _saveData,
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
      ),
    );
  }
}

class _OilPatternControllers {
  final TextEditingController nameController;
  final TextEditingController lengthController;

  _OilPatternControllers({
    required this.nameController,
    required this.lengthController,
  });
} 