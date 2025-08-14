import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/simple_app_bar.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// New Tournament Wizard - Step 3 (Scoring preferences)
class NewTournamentStep3Page extends StatelessWidget {
  const NewTournamentStep3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarConfigs.tournament(
          title: 'New Tournament',
          onBackPressed: () => context.go('/tournaments/new/2'),
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: 4,
          onTap: (index) {
            switch (index) {
              case 0: context.go('/'); break;
              case 1: context.go('/library'); break;
              case 2: context.go('/my-arsenal'); break;
              case 3: context.go('/training'); break;
              case 4: context.go('/tournament'); break;
            }
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Step indicator (3 segments) - Step 3 active
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Step 3 — Scoring preferences (required)',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select recording method (by frame or by game total) and scoring logic (traditional or current). This step is required as it determines the later UI.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const Spacer(),
              SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: AppStandardButton(
                        text: 'Previous',
                        onPressed: () => context.go('/tournaments/new/2'),
                        outlineColor: Colors.white,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        text: 'Finish',
                        onPressed: () {
                          context.go('/tournament');
                        },
                        isPrimary: true,
                        whiteForeground: true,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


