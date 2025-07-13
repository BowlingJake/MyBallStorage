import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_dialog.dart';
import 'package:flutter/material.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  late final PinSelectionController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = PinSelectionController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Options'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return PinSelectionDialog(controller: _pinController);
              },
            );
          },
          child: const Text('Show Pin Selection Dialog'),
        ),
      ),
    );
  }
}

