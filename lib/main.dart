import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/login_page.dart';
import 'viewmodels/weapon_library_viewmodel.dart';
import 'viewmodels/tournament_viewmodel.dart';
import 'viewmodels/practice_viewmodel.dart';
import 'views/main_page.dart';
import 'views/home_page.dart';
import 'shared/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeaponLibraryViewModel()..loadBallData(),
        ),
        ChangeNotifierProvider(
          create: (_) => TournamentViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => PracticeViewModel()..loadRecords(),
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
      home: const LoginPage(),
    );
  }
}
