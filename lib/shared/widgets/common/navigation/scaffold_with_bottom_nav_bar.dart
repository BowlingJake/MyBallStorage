import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithBottomNavBar extends StatelessWidget {
  const ScaffoldWithBottomNavBar({
    super.key,
    required this.body,
  });

  final Widget body;

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/library');
        break;
      case 2:
        context.go('/my-arsenal');
        break;
      case 3:
        context.go('/training');
        break;
      case 4:
        context.go('/tournament');
        break;
    }
  }

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) {
      return 1;
    }
    if (location.startsWith('/my-arsenal')) {
      return 2;
    }
    if (location.startsWith('/training')) {
      return 3;
    }
    if (location.startsWith('/tournament')) {
      return 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: body,
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: _calculateCurrentIndex(location),
          onTap: (index) => _onItemTapped(index, context),
        ),
      ),
    );
  }
} 