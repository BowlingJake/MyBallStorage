import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/simple_app_bar.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/features/tournament/logic/tournament_wizard_controller.dart';
import 'package:bowlingarsenal_app/features/tournament/models/tournament_wizard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// New Tournament Wizard - Step 2 (Oil Pattern - optional)
class NewTournamentStep2Page extends ConsumerStatefulWidget {
  const NewTournamentStep2Page({super.key});

  @override
  ConsumerState<NewTournamentStep2Page> createState() => _NewTournamentStep2PageState();
}

class _NewTournamentStep2PageState extends ConsumerState<NewTournamentStep2Page> {
  final TextEditingController _oilPatternNameController = TextEditingController();
  final TextEditingController _oilPatternLengthController = TextEditingController();
  final TextEditingController _entryFeeController = TextEditingController();
  final TextEditingController _prizeInfoController = TextEditingController();

  @override
  void dispose() {
    _oilPatternNameController.dispose();
    _oilPatternLengthController.dispose();
    _entryFeeController.dispose();
    _prizeInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(tournamentWizardProvider);
    final wizardNotifier = ref.read(tournamentWizardProvider.notifier);

    // Sync controllers with state
    if (_oilPatternNameController.text != wizardState.oilPatternName) {
      _oilPatternNameController.text = wizardState.oilPatternName;
    }
    if (_oilPatternLengthController.text != wizardState.oilPatternLength) {
      _oilPatternLengthController.text = wizardState.oilPatternLength;
    }
    if (_entryFeeController.text != wizardState.entryFee) {
      _entryFeeController.text = wizardState.entryFee;
    }
    if (_prizeInfoController.text != wizardState.prizeInfo) {
      _prizeInfoController.text = wizardState.prizeInfo;
    }

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarConfigs.tournament(
          title: 'New Tournament',
          onBackPressed: () => context.go('/tournaments/new/1'),
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
              // Step indicator (3 segments) - Step 2 active
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Step 2 — Oil Pattern (optional)',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                'Provide lane oil pattern name and length (inch). This step can be skipped and edited later in tournament settings.',
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
                        onPressed: () => context.go('/tournaments/new/1'),
                        outlineColor: Colors.white,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        text: 'Skip',
                        onPressed: () => context.go('/tournaments/new/3'),
                        outlineColor: Colors.white,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        text: 'Next',
                        onPressed: () {
                          wizardNotifier.nextStep();
                          context.go('/tournaments/new/3');
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

  Widget _buildOilPatternSection(TournamentWizardState state, TournamentWizard notifier) {
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
              Icon(Icons.water_drop, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Oil Pattern (Optional)',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Pattern Type Toggle
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => notifier.togglePatternType(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: state.isHousePattern ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: state.isHousePattern ? theme.colorScheme.primary : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'House Pattern',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => notifier.togglePatternType(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: !state.isHousePattern ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !state.isHousePattern ? theme.colorScheme.primary : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'Sport Pattern',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          if (!state.isHousePattern) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _oilPatternNameController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => notifier.updateOilPatternName(value),
                    decoration: InputDecoration(
                      hintText: 'Pattern name',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _oilPatternLengthController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => notifier.updateOilPatternLength(value),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Length',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTournamentDetailsSection(TournamentWizardState state, TournamentWizard notifier) {
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
              Icon(Icons.emoji_events, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Tournament Details',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Tournament Type
          const Text(
            'Tournament Type',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildTypeButton('Recreational', 'recreational', state, notifier),
              const SizedBox(width: 8),
              _buildTypeButton('Competitive', 'competitive', state, notifier),
              const SizedBox(width: 8),
              _buildTypeButton('Professional', 'professional', state, notifier),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Entry Fee and Prize Info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Entry Fee',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _entryFeeController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) => notifier.updateEntryFee(value),
                      decoration: InputDecoration(
                        hintText: '\$0.00',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prize Info',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _prizeInfoController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) => notifier.updatePrizeInfo(value),
                      decoration: InputDecoration(
                        hintText: 'Prize details',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String label, String value, TournamentWizardState state, TournamentWizard notifier) {
    final isSelected = state.tournamentType == value;
    final theme = Theme.of(context);
    
    return Expanded(
      child: GestureDetector(
        onTap: () => notifier.updateTournamentType(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : Colors.white.withOpacity(0.3),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}


