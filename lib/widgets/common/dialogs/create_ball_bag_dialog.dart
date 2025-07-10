import 'dart:ui';

import 'package:bowlingarsenal_app/models/arsenal_ball.dart';
import 'package:bowlingarsenal_app/providers/arsenal_providers.dart';
import 'package:bowlingarsenal_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Create Ball Bag Dialog with popout detail design style, refined based on professional feedback.
class CreateBallBagDialog extends ConsumerStatefulWidget {
  const CreateBallBagDialog({super.key});

  @override
  ConsumerState<CreateBallBagDialog> createState() =>
      _CreateBallBagDialogState();
}

class _CreateBallBagDialogState extends ConsumerState<CreateBallBagDialog>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedBalls = <ArsenalBall>{};
  final int bagCapacity = 5;

  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final allBallsAsync = ref.watch(userBallsProvider);
    final isCreateEnabled = nameController.text.isNotEmpty;

    return Material(
      type: MaterialType.transparency,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppGlows.medium,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    width: size.width * 0.9,
                    height: size.height * 0.8,
                    constraints: const BoxConstraints(
                      maxWidth: 420,
                      minWidth: 320,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: theme.colorScheme.surface
                          .withOpacity(0.2)
                          .withAlpha(40),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          Row(
                            children: [
                              const Icon(
                                Icons.create_new_folder_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Create New Ball Bag',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.58),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Scrollable Content
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Bag Name Input
                                  _buildTextField(
                                    controller: nameController,
                                    label: 'Ball Bag Name',
                                    icon: Icons.label,
                                    onChanged: (value) => setState(() {}),
                                  ),
                                  const SizedBox(height: 16),

                                  // Description Input
                                  _buildTextField(
                                    controller: descriptionController,
                                    label: 'Description (Optional)',
                                    icon: Icons.description,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 20),

                                  // Ball Selection Header
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Select Balls',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${selectedBalls.length}/$bagCapacity)',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color:
                                                  selectedBalls.length >=
                                                          bagCapacity
                                                      ? Colors.redAccent
                                                      : Colors.white
                                                          .withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Ball Selection List
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: allBallsAsync.when(
                                      data: (allBalls) {
                                        if (allBalls.isEmpty) {
                                          return const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(32),
                                              child: Text(
                                                'No balls available in your arsenal.',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        }
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.all(8),
                                          itemCount: allBalls.length,
                                          itemBuilder: (context, index) {
                                            final ball = allBalls[index];
                                            final isSelected = selectedBalls
                                                .contains(ball);
                                            final isCapacityReached =
                                                selectedBalls.length >=
                                                bagCapacity;

                                            return _SelectableBallCard(
                                              ball: ball,
                                              isSelected: isSelected,
                                              isEnabled:
                                                  !isCapacityReached ||
                                                  isSelected,
                                              onTap: () {
                                                setState(() {
                                                  if (isSelected) {
                                                    selectedBalls.remove(
                                                      ball,
                                                    );
                                                  } else if (!isCapacityReached) {
                                                    selectedBalls.add(ball);
                                                  }
                                                });
                                              },
                                            );
                                          },
                                        );
                                      },
                                      loading: () => const Center(child: CircularProgressIndicator()),
                                      error: (error, stack) => Center(child: Text('Error: $error')),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _DialogActionButton(
                                  text: 'Cancel',
                                  onPressed: () => Navigator.pop(context),
                                  isPrimary: false,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _DialogActionButton(
                                  text: 'Create',
                                  onPressed: () {
                                    // TODO: Implement create logic
                                  },
                                  isEnabled: isCreateEnabled,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        prefixIcon: Icon(icon, color: Colors.white, size: 22),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        hintText: label,
        hintStyle: TextStyle(color: const Color(0xFFE6F3FF).withOpacity(0.6)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}

class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isEnabled = true,
  });
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side:
          isPrimary
              ? BorderSide(color: theme.colorScheme.primary.withOpacity(0.3))
              : BorderSide(color: Colors.white.withOpacity(0.5)),
    );
    final textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: isPrimary ? Colors.white : Colors.white.withOpacity(0.8),
    );
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient:
              isPrimary && isEnabled
                  ? const LinearGradient(
                    colors: [Color(0xFF003B5C), Color(0xFF052C43)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          boxShadow: isPrimary && isEnabled ? AppGlows.small : null,
        ),
        child: OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: Text(text, style: textStyle),
        ),
      ),
    );
  }
}

class _SelectableBallCard extends StatefulWidget {
  const _SelectableBallCard({
    required this.ball,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });
  final ArsenalBall ball;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  @override
  State<_SelectableBallCard> createState() => _SelectableBallCardState();
}

class _SelectableBallCardState extends State<_SelectableBallCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final elevation = (widget.isSelected || _isHovered) ? 8.0 : 1.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isEnabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          transform: Matrix4.translationValues(0, -elevation / 2, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient:
                widget.isSelected
                    ? const LinearGradient(
                      colors: [Color(0xFF003B5C), Color(0xFF052C43)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            color: widget.isSelected ? null : Colors.black.withOpacity(0.2),
            border:
                widget.isSelected
                    ? Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    )
                    : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: -2,
              ),
              if (widget.isSelected)
                ...AppGlows.small
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.2 * elevation / 8.0),
                  blurRadius: elevation,
                  offset: Offset(0, elevation),
                ),
            ],
          ),
          child: Opacity(
            opacity: widget.isEnabled ? 1.0 : 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          widget.isSelected
                              ? theme.colorScheme.primary
                              : Colors.black.withOpacity(0.3),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child:
                        widget.isSelected
                            ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            )
                            : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.ball.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${widget.ball.brand} • ${widget.ball.core}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.sports_baseball,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
