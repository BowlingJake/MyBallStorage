import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/weapon_library_viewmodel.dart';
import 'views/main_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeaponLibraryViewModel()..loadBallData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '保齡球球具紀錄',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
    );
  }
}
