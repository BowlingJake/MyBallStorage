import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/simple_app_bar.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/features/tournament/logic/tournament_wizard_controller.dart';
import 'package:bowlingarsenal_app/features/tournament/models/tournament_wizard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// New Tournament Wizard - Step 3 (Smart Recommendations)
class NewTournamentStep3Page extends ConsumerStatefulWidget {
  const NewTournamentStep3Page({super.key});

  @override
  ConsumerState<NewTournamentStep3Page> createState() => _NewTournamentStep3PageState();
}

class _NewTournamentStep3PageState extends ConsumerState<NewTournamentStep3Page> {
  
  @override
  void initState() {
    super.initState();
    // Generate recommendations when entering this step
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wizardNotifier = ref.read(tournamentWizardProvider.notifier);
      if (!ref.read(tournamentWizardProvider).analysisCompleted) {
        wizardNotifier.generateRecommendations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(tournamentWizardProvider);
    final wizardNotifier = ref.read(tournamentWizardProvider.notifier);

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
                'Smart Tournament Recommendations',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              
              if (wizardState.isLoading) 
                _buildLoadingSection()
              else if (wizardState.errorMessage.isNotEmpty)
                _buildErrorSection(wizardState.errorMessage, wizardNotifier)
              else if (wizardState.analysisCompleted)
                _buildRecommendationsSection(wizardState)
              else
                _buildGenerateSection(wizardNotifier),
              
              const Spacer(),
              SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: AppStandardButton(
                        text: 'Previous',
                        onPressed: () {
                          wizardNotifier.previousStep();
                          context.go('/tournaments/new/2');
                        },
                        outlineColor: Colors.white,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        text: 'Create Tournament',
                        onPressed: () async {
                          final success = await wizardNotifier.submitTournament();
                          if (success) {
                            TopNotification.showSuccess(context, 'Tournament created successfully!');
                            context.go('/tournament');
                          } else {
                            TopNotification.showError(context, 'Failed to create tournament');
                          }
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

  Widget _buildLoadingSection() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Analyzing your tournament settings...',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Generating personalized recommendations based on your arsenal and tournament configuration',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(String errorMessage, TournamentWizard notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32),
          const SizedBox(height: 12),
          const Text(
            'Analysis Failed',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppStandardButton(
            text: 'Retry Analysis',
            onPressed: () => notifier.generateRecommendations(),
            outlineColor: Colors.red,
            foregroundColor: Colors.white,
            backgroundColor: Colors.red.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateSection(TournamentWizard notifier) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.psychology, color: theme.colorScheme.primary, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Ready for Smart Analysis',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate personalized ball and strategy recommendations based on your tournament settings',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          AppStandardButton(
            text: 'Generate Recommendations',
            onPressed: () => notifier.generateRecommendations(),
            isPrimary: true,
            whiteForeground: true,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(TournamentWizardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ball Recommendations
        _buildBallRecommendations(state),
        const SizedBox(height: 16),
        
        // Strategy Recommendations
        _buildStrategyRecommendations(state),
      ],
    );
  }

  Widget _buildBallRecommendations(TournamentWizardState state) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sports, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Recommended Bowling Balls',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (state.recommendedBalls.isEmpty)
            const Text(
              'No specific ball recommendations available',
              style: TextStyle(color: Colors.white70),
            )
          else
            ...state.recommendedBalls.map((String ball) => _buildBallRecommendationItem(ball)),
        ],
      ),
    );
  }

  Widget _buildBallRecommendationItem(String ball) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ball,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Icon(
            Icons.check_circle_outline,
            color: Colors.green.withOpacity(0.7),
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyRecommendations(TournamentWizardState state) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Strategy Recommendations',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
            ),
            child: Text(
              state.strategyRecommendation.isEmpty 
                  ? 'No specific strategy recommendations available'
                  : state.strategyRecommendation,
              style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}