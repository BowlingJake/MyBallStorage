import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('賽事'),
      ),
      body: const Center(
        child: Text(
          '賽事功能即將推出',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
} 