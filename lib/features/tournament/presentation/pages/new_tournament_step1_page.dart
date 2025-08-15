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
 

/// New Tournament Wizard - Step 1 (Basic Info & Dates)
class NewTournamentStep1Page extends ConsumerStatefulWidget {
  const NewTournamentStep1Page({super.key});

  @override
  ConsumerState<NewTournamentStep1Page> createState() => _NewTournamentStep1PageState();
}

class _NewTournamentStep1PageState extends ConsumerState<NewTournamentStep1Page> {
  final TextEditingController tournamentNameController = TextEditingController();
  final TextEditingController customLocationController = TextEditingController();

  @override
  void dispose() {
    tournamentNameController.dispose();
    customLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(tournamentWizardProvider);
    final wizardNotifier = ref.read(tournamentWizardProvider.notifier);

    // Sync controllers with state
    if (tournamentNameController.text != wizardState.tournamentName) {
      tournamentNameController.text = wizardState.tournamentName;
    }
    if (customLocationController.text != wizardState.location && wizardState.useCustomLocation) {
      customLocationController.text = wizardState.location;
    }

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarConfigs.tournament(
          title: 'New Tournament',
          onBackPressed: () => context.go('/tournament'),
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
              // Step indicator (3 segments) - Step 1 active
              Row(
                children: [
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
              const Center(
                child: Text(
                  'Tournament Basic Information',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 16),

              // Tournament name
              _OutlinedSection(
                title: 'Tournament Name',
                isRequired: true,
                dense: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: tournamentNameController,
                    maxLength: 100,
                    buildCounter: (_, {required int currentLength, required bool isFocused, int? maxLength}) => null,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => wizardNotifier.updateTournamentName(value),
                    decoration: const InputDecoration(
                      hintText: 'Enter tournament name',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      filled: false,
                      isDense: true,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Location
              _OutlinedSection(
                title: 'Tournament Location',
                isRequired: true,
                dense: true,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: customLocationController,
                          maxLength: 100,
                          buildCounter: (_, {required int currentLength, required bool isFocused, int? maxLength}) => null,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) => wizardNotifier.updateLocation(value),
                          decoration: const InputDecoration(
                            hintText: 'Enter location',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            filled: false,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on, color: Colors.white70),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      onPressed: () => _openLocationPicker(wizardNotifier),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Dates
              _OutlinedSection(
                title: 'Tournament Date',
                isRequired: true,
                dense: true,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined, color: Colors.white70),
                    onPressed: () {},
                  ),
                ),
              ),

              const Spacer(),
              SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: AppStandardButton(
                        text: 'Cancel',
                        onPressed: () => context.go('/tournament'),
                        outlineColor: Colors.redAccent,
                        foregroundColor: Colors.redAccent,
                        backgroundColor: Colors.transparent,
                        height: 44,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        text: 'Next',
                        onPressed: wizardState.isStep1Valid 
                            ? () {
                                wizardNotifier.nextStep();
                                context.go('/tournaments/new/2');
                              }
                            : () {},
                        enabled: wizardState.isStep1Valid,
                        isPrimary: true,
                        whiteForeground: true,
                        height: 44,
                        backgroundColor: Colors.black.withOpacity(0.8),
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

  Widget _buildContinuousPicker(BuildContext context, TournamentWizardState state, TournamentWizard notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppStandardButton(
          text: state.startDate == null || state.endDate == null
              ? 'Pick start and end dates'
              : '${_fmt(state.startDate!)}  →  ${_fmt(state.endDate!)}',
          onPressed: () async {
            final DateTime now = DateTime.now();
            final DateTimeRange? picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(now.year - 2),
              lastDate: DateTime(now.year + 5),
              initialDateRange: state.startDate != null && state.endDate != null 
                  ? DateTimeRange(start: state.startDate!, end: state.endDate!) 
                  : null,
              helpText: 'Select date range',
            );
            if (picked != null) {
              final DateTime start = DateTime(picked.start.year, picked.start.month, picked.start.day);
              final DateTime end = DateTime(picked.end.year, picked.end.month, picked.end.day);
              notifier.updateDateRange(start, end);
            }
          },
          outlineColor: Colors.white,
          foregroundColor: Colors.white,
          backgroundColor: Colors.black.withOpacity(0.8),
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildNonContinuousPicker(BuildContext context, TournamentWizardState state, TournamentWizard notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AppStandardButton(
                text: 'Add a date',
                onPressed: () async {
                  final DateTime now = DateTime.now();
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(now.year - 2),
                    lastDate: DateTime(now.year + 5),
                    helpText: 'Select date',
                  );
                  if (picked != null) {
                    final DateTime normalized = DateTime(picked.year, picked.month, picked.day);
                    notifier.addNonContinuousDate(normalized);
                  }
                },
                outlineColor: Colors.white,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black.withOpacity(0.8),
                width: double.infinity,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.nonContinuousDates.map((DateTime d) {
            return InputChip(
              label: Text(_fmt(d)),
              onDeleted: () => notifier.removeNonContinuousDate(d),
            );
          }).toList(),
        ),
      ],
    );
  }

  // === Helpers ===
  Future<void> _openLocationPicker(TournamentWizard wizard) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _LocationBottomSheet(
          onPick: (place) {
            wizard.updateLocation(place);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Coming soon', style: TextStyle(color: Colors.white)),
        content: const Text('Map-based nearby search will be integrated (e.g., Google Places).', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  String _fmt(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

class _LocationBottomSheet extends StatefulWidget {
  const _LocationBottomSheet({required this.onPick});
  final ValueChanged<String> onPick;

  @override
  State<_LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<_LocationBottomSheet> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final Color outline = Colors.white.withOpacity(0.25);
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(1.0),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border.all(color: outline),
      ),
      child: Column(
        children: [
          // Title bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 40),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Choose The Alley',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Search field (outlined)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search places...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.transparent,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          const SizedBox(height: 4),
          // List
          Expanded(
            child: ListView.separated(
              itemCount: 8,
              separatorBuilder: (_, __) => Divider(height: 1, color: outline),
              itemBuilder: (context, index) {
                final String place = 'Nearby place ${index + 1}';
                return ListTile(
                  title: Text(place, style: const TextStyle(color: Colors.white)),
                  subtitle: const Text('Address...', style: TextStyle(color: Colors.white70)),
                  onTap: () => widget.onPick(place),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable outlined container with 80% black background
class _OutlinedSection extends StatelessWidget {
  const _OutlinedSection({required this.title, required this.child, this.trailing, this.isRequired = false, this.subtitle, this.dense = false});

  final String title;
  final Widget child;
  final Widget? trailing;
  final bool isRequired;
  final Widget? subtitle;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title placed OUTSIDE the outlined container to avoid taking space inside (remove top empty area)
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  if (isRequired) const SizedBox(width: 6),
                  if (isRequired)
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  if (trailing != null) const SizedBox(width: 8),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: subtitle!,
          ),
        Container(
          width: double.infinity,
          padding: dense ? const EdgeInsets.fromLTRB(12, 4, 12, 12) : const EdgeInsets.all(12),
          child: child,
        ),
      ],
    );
  }
}
 