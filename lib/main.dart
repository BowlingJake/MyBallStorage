import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/weapon_library_viewmodel.dart';
import 'views/main_page.dart';
import 'shared/theme.dart';

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
      title: 'Bowling Arsenal App',
      theme: AppTheme.lightTheme,
      home: const MainPage(),
    );
  }
}
