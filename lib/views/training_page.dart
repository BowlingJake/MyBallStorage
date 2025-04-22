import 'package:flutter/material.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('訓練模式')),
      body: const Center(child: Text('這裡是訓練模式頁')),
    );
  }
}
