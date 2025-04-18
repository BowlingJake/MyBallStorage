import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bowling_ball.dart';
import '../viewmodels/weapon_library_viewmodel.dart';

class AddCustomBallPage extends StatefulWidget {
  const AddCustomBallPage({super.key});

  @override
  State<AddCustomBallPage> createState() => _AddCustomBallPageState();
}

class _AddCustomBallPageState extends State<AddCustomBallPage> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _ballNameController = TextEditingController();
  final _coreController = TextEditingController();
  final _coverstockController = TextEditingController();
  final _rgController = TextEditingController();
  final _diffController = TextEditingController();
  final _mbDiffController = TextEditingController();
  final _releaseDateController = TextEditingController(text: 'N/A'); // Default release date

  @override
  void dispose() {
    _brandController.dispose();
    _ballNameController.dispose();
    _coreController.dispose();
    _coverstockController.dispose();
    _rgController.dispose();
    _diffController.dispose();
    _mbDiffController.dispose();
    _releaseDateController.dispose();
    super.dispose();
  }

  void _saveCustomBall() {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<WeaponLibraryViewModel>();
      
      // Create the new ball object
      final newBall = BowlingBall(
        brand: _brandController.text.trim(),
        ball: _ballNameController.text.trim(),
        core: _coreController.text.trim(), // Consider simplifying core input later
        coverstockname: _coverstockController.text.trim(), // Use input for name
        coverstockcategory: _coverstockController.text.trim(), // Use input for category for now
        rg: _rgController.text.trim(), // Consider parsing to double
        diff: _diffController.text.trim(), // Consider parsing to double
        mbDiff: _mbDiffController.text.trim(), // Consider parsing to double
        releaseDate: _releaseDateController.text.trim(), // Keep as string for now
        // Add default value for factoryFinish if it's required and not provided by user
        factoryFinish: 'Unknown', // Assuming required, provide default
      );

      // Add the ball to the arsenal via ViewModel
      viewModel.addBallToArsenal(newBall);

      // Show success message
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('"${newBall.ball}" 已成功新增至我的球櫃')),
      );

      // Pop back to the previous screen (MyArsenalPage)
      Navigator.pop(context);
    }
  }

  // Helper for text input fields
  Widget _buildTextField(TextEditingController controller, String label, {IconData? icon, TextInputType keyboard = TextInputType.text, bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          icon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboard,
        validator: isRequired ? (value) {
          if (value == null || value.trim().isEmpty) {
            return '請輸入$label';
          }
          return null;
        } : null,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增自訂球具'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: '儲存',
            onPressed: _saveCustomBall,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _buildTextField(_brandController, '品牌', icon: Icons.business),
            _buildTextField(_ballNameController, '球名', icon: Icons.sports_baseball),
            _buildTextField(_coreController, '核心 (Core)', icon: Icons.settings),
            _buildTextField(_coverstockController, '球面材質名稱 (Coverstock Name)', icon: Icons.texture),
             _buildTextField(_rgController, 'RG', icon: Icons.settings_backup_restore, keyboard: TextInputType.numberWithOptions(decimal: true)),
             _buildTextField(_diffController, 'Diff', icon: Icons.compare_arrows, keyboard: TextInputType.numberWithOptions(decimal: true)),
             _buildTextField(_mbDiffController, 'MB Diff', icon: Icons.trending_up, keyboard: TextInputType.numberWithOptions(decimal: true), isRequired: false), // MB Diff might not always exist
             _buildTextField(_releaseDateController, '發行日期 (選填)', icon: Icons.calendar_today, isRequired: false), // Release date optional
            
            const SizedBox(height: 24),
             ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('儲存球具'),
                onPressed: _saveCustomBall,
                 style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 