import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class AddMatchRecordPage extends StatefulWidget {
  const AddMatchRecordPage({super.key});

  @override
  State<AddMatchRecordPage> createState() => _AddMatchRecordPageState();
}

class _AddMatchRecordPageState extends State<AddMatchRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000), // Allow dates from year 2000
      lastDate: DateTime(2101), // Allow dates up to year 2101
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, process the data
      final name = _nameController.text;
      final location = _locationController.text;
      final date = _selectedDate;

      if (date == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('請選擇賽事日期')),
        );
        return;
      }

      // For now, just print the data and pop
      print('賽事名稱: $name');
      print('賽事地點: $location');
      print('賽事日期: ${DateFormat('yyyy-MM-dd').format(date)}');

      Navigator.pop(context); // Go back to the previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    // Restore basic structure and first field
    print('--- Building AddMatchRecordPage (Step 1: Name Field Only) ---');
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增比賽紀錄'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: '儲存',
            onPressed: _saveRecord, // Keep the save logic for now
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView( // Use ListView for scrolling
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // 賽事名稱
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '賽事名稱',
                icon: Icon(Icons.emoji_events), // Event icon
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '請輸入賽事名稱';
                }
                return null;
              },
            ),
            const SizedBox(height: 16), // Keep spacing
            
            // Restore Location and Date Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align items nicely
              children: [
                // 賽事地點
                Expanded(
                  flex: 2, // Give location field more space
                  child: TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: '賽事地點',
                      icon: Icon(Icons.location_on), // Location icon
                      border: OutlineInputBorder(),
                    ),
                    // No validator needed for location? Optional
                  ),
                ),
                const SizedBox(width: 12),

                // 賽事日期選擇器 (Wrap with Expanded)
                Expanded(
                  flex: 1, // Give date picker less space
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '賽事日期',
                        icon: const Icon(Icons.calendar_today), // Calendar icon
                        border: const OutlineInputBorder(),
                        // Remove the error border if date is not selected, handle via save button
                        errorBorder: _selectedDate == null ? InputBorder.none : null,
                      ),
                      child: Text(
                        _selectedDate == null
                            ? '選擇日期'
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        style: TextStyle(
                          color: _selectedDate == null ? Colors.grey[600] : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24), // Add some space before potential future fields or save button at bottom

          ],
        ),
      ),
    );
  }
} 