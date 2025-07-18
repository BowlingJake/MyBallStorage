import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/profile_image_picker.dart'; // 假設這個 Widget 已存在
import '../widgets/pap_widgets.dart'; // 引用新的 Widget

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _bowlersNameController = TextEditingController();

  // State for dropdowns
  DominateHand? _selectedHand;
  BowlingStyle? _selectedStyle;
  PapDirection? _selectedPapDirection;
  int? _selectedPapInteger;
  String? _selectedPapFraction;

  @override
  void dispose() {
    _bowlersNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'), // Title as specified
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Step 1: Profile Image
              const ProfileImagePicker(), // 您的頭像選擇器
              const SizedBox(height: 24),

              // Bowler’s Name TextField
              TextFormField(
                controller: _bowlersNameController,
                decoration: const InputDecoration(
                  labelText: 'Bowler’s Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Bowler’s Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Row for Dominate Hand and Bowling Style dropdowns
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dominate Hand Dropdown
                  Expanded(
                    child: HandAndStyleDropdowns(
                      label: 'Dominate Hand',
                      items: DominateHand.values
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.displayName),
                              ))
                          .toList(),
                      selectedValue: _selectedHand,
                      onChanged: (value) {
                        setState(() {
                          _selectedHand = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bowling Style Dropdown
                  Expanded(
                    child: HandAndStyleDropdowns(
                      label: 'Bowling Style',
                      items: BowlingStyle.values
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.displayName),
                              ))
                          .toList(),
                      selectedValue: _selectedStyle,
                      onChanged: (value) {
                        setState(() {
                          _selectedStyle = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Personal Positive Axis Point (PAP) Section
              const Text(
                'Personal Positive Axis Point (PAP)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              PapInputWidget(
                selectedDirection: _selectedPapDirection,
                selectedInteger: _selectedPapInteger,
                selectedFraction: _selectedPapFraction,
                onDirectionChanged: (direction) {
                  setState(() {
                    _selectedPapDirection = direction;
                    // 如果選擇空白，則清除整數和分數
                    if (direction == null) {
                      _selectedPapInteger = null;
                      _selectedPapFraction = null;
                    }
                  });
                },
                onIntegerChanged: (value) {
                  setState(() {
                    _selectedPapInteger = value;
                  });
                },
                onFractionChanged: (value) {
                  setState(() {
                    _selectedPapFraction = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement your save logic with the state variables
      // e.g., _bowlersNameController.text, _selectedHand, _selectedStyle, etc.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    }
  }
}