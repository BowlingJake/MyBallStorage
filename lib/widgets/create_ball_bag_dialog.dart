import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../models/arsenal_ball.dart';
import '../views/my_arsenal_page.dart';

/// Create Ball Bag Dialog with popout detail design style
class CreateBallBagDialog extends ConsumerStatefulWidget {
  const CreateBallBagDialog({super.key});

  @override
  ConsumerState<CreateBallBagDialog> createState() => _CreateBallBagDialogState();
}

class _CreateBallBagDialogState extends ConsumerState<CreateBallBagDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedBalls = <ArsenalBall>{};

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final allBalls = ref.read(userBallsProvider);

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              width: size.width * 0.9,
              height: size.height * 0.8,
              constraints: const BoxConstraints(
                maxWidth: 420,
                minWidth: 320,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.6),
                    theme.colorScheme.primary.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
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
                      child: Container(
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 標題區域
                        Row(
                          children: [
                            Icon(
                              Icons.create_new_folder,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Create New Ball Bag',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 28),
                              onPressed: () => Navigator.of(context).pop(),
                              tooltip: '關閉',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // 球袋名稱
                        _buildTextField(
                          controller: nameController,
                          label: 'Ball Bag Name',
                          icon: Icons.label,
                          onChanged: (value) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        
                        // 球袋描述
                        _buildTextField(
                          controller: descriptionController,
                          label: 'Description (Optional)',
                          icon: Icons.description,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),
                        
                        // 選擇球具標題
                        Row(
                          children: [
                            Text(
                              'Select Balls',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${selectedBalls.length}/${allBalls.length}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // 球具選擇列表
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: allBalls.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No balls available',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: allBalls.length,
                                    itemBuilder: (context, index) {
                                      final ball = allBalls[index];
                                      final isSelected = selectedBalls.contains(ball);
                                      
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected 
                                              ? Colors.white.withOpacity(0.2)
                                              : Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected 
                                                ? Colors.white.withOpacity(0.4)
                                                : Colors.white.withOpacity(0.1),
                                            width: 1,
                                          ),
                                        ),
                                        child: CheckboxListTile(
                                          value: isSelected,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (value == true) {
                                                selectedBalls.add(ball);
                                              } else {
                                                selectedBalls.remove(ball);
                                              }
                                            });
                                          },
                                          title: Text(
                                            ball.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${ball.brand} • ${ball.core}',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                            ),
                                          ),
                                          secondary: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.sports_baseball,
                                              color: Colors.white,
                                            ),
                                          ),
                                          checkColor: theme.colorScheme.primary,
                                          activeColor: Colors.white,
                                          controlAffinity: ListTileControlAffinity.leading,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // 操作按鈕
                        Row(
                          children: [
                            Expanded(
                              child: _buildButton(
                                text: 'Cancel',
                                onPressed: () => Navigator.pop(context),
                                isOutlined: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildButton(
                                text: 'Create',
                                onPressed: nameController.text.trim().isEmpty
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Ball Bag "${nameController.text}" created with ${selectedBalls.length} balls',
                                            ),
                                          ),
                                        );
                                      },
                                isOutlined: false,
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
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isOutlined,
  }) {
    return Container(
      height: 48,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
} 