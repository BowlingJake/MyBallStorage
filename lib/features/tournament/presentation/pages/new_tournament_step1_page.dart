import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/simple_app_bar.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';

/// New Tournament Wizard - Step 1 (Basic Info & Dates)
class NewTournamentStep1Page extends StatefulWidget {
  const NewTournamentStep1Page({super.key});

  @override
  State<NewTournamentStep1Page> createState() => _NewTournamentStep1PageState();
}

class _NewTournamentStep1PageState extends State<NewTournamentStep1Page> {
  final TextEditingController tournamentNameController = TextEditingController();
  final TextEditingController customLocationController = TextEditingController();

  bool useCustomLocation = false;
  _DateMode selectedDateMode = _DateMode.singleDay;
  DateTime? singleDay;
  DateTimeRange? continuousRange;
  final List<DateTime> nonContinuousDays = <DateTime>[];

  @override
  void dispose() {
    tournamentNameController.dispose();
    customLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Tournament Basic Information',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),

              // Tournament name
              _OutlinedSection(
                title: 'Tournament Name',
                isRequired: true,
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
                    decoration: const InputDecoration(
                      hintText: 'Enter tournament name',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Location
              _OutlinedSection(
                title: 'Tournament Location',
                isRequired: true,
                trailing: Builder(
                  builder: (context) {
                    final Color border = Colors.grey[500]!;
                    final Color fill = Colors.grey[800]!;
                    return SizedBox(
                      height: 44,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AppStandardButton(
                          text: useCustomLocation ? 'Find Nearby' : 'Custom',
                          height: 22,
                          outlineColor: border,
                          foregroundColor: Colors.white,
                          backgroundColor: fill,
                          onPressed: () { setState(() { useCustomLocation = !useCustomLocation; }); },
                        ),
                      ),
                    );
                  },
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!useCustomLocation) ...[
                      Row(
                        children: [
                          Expanded(
                            child: AppStandardButton(
                              text: 'Find Nearby',
                              onPressed: () { _showComingSoon(context); },
                              outlineColor: Colors.white,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black.withOpacity(0.8),
                              height: 44,
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(child: SizedBox.shrink()),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 12),
                      Container(
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
                          decoration: const InputDecoration(
                            hintText: 'Enter location manually',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            filled: false,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Dates
              _OutlinedSection(
                title: 'Tournament Date',
                isRequired: true,
                trailing: Builder(
                  builder: (context) {
                    final Color border = Colors.grey[500]!;
                    final Color fill = Colors.grey[800]!;
                    return SizedBox(
                      height: 44,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AppStandardButton(
                          text: 'Change Format',
                          height: 22,
                          outlineColor: border,
                          foregroundColor: Colors.white,
                          backgroundColor: fill,
                          onPressed: () => _showDateModeDialog(context),
                        ),
                      ),
                    );
                  },
                ),
                subtitle: Text(
                  _dateModeLabel(selectedDateMode),
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    if (selectedDateMode == _DateMode.singleDay)
                      Row(
                        children: [
                          Expanded(
                            child: AppStandardButton(
                              text: singleDay == null ? 'Select date' : _fmt(singleDay!),
                              onPressed: () async {
                                final DateTime now = DateTime.now();
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: singleDay ?? now,
                                  firstDate: DateTime(now.year - 2),
                                  lastDate: DateTime(now.year + 5),
                                  helpText: 'Select date',
                                );
                                if (picked != null) {
                                  setState(() { singleDay = DateTime(picked.year, picked.month, picked.day); });
                                }
                              },
                              outlineColor: Colors.white,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black.withOpacity(0.8),
                              height: 44,
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(child: SizedBox.shrink()),
                        ],
                      ),
                    if (selectedDateMode == _DateMode.continuous) _buildContinuousPicker(context),
                    if (selectedDateMode == _DateMode.nonContinuous) _buildNonContinuousPicker(context),
                  ],
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
                        outlineColor: Colors.white,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black.withOpacity(0.8),
                        height: 44,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        text: 'Next',
                        onPressed: () => context.go('/tournaments/new/2'),
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

  // === Date pickers ===
  Widget _buildSingleDayPicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppStandardButton(
            text: singleDay == null ? 'Pick a date' : _fmt(singleDay!),
            onPressed: () async {
              final DateTime now = DateTime.now();
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: singleDay ?? now,
                firstDate: DateTime(now.year - 2),
                lastDate: DateTime(now.year + 5),
                helpText: 'Select date',
              );
              if (picked != null) {
                setState(() { singleDay = DateTime(picked.year, picked.month, picked.day); });
              }
            },
            outlineColor: Colors.white,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.8),
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  Widget _buildContinuousPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppStandardButton(
          text: continuousRange == null
              ? 'Pick start and end dates'
              : '${_fmt(continuousRange!.start)}  →  ${_fmt(continuousRange!.end)}',
          onPressed: () async {
            final DateTime now = DateTime.now();
            final DateTimeRange? picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(now.year - 2),
              lastDate: DateTime(now.year + 5),
              initialDateRange: continuousRange,
              helpText: 'Select date range',
            );
            if (picked != null) {
              final DateTime start = DateTime(picked.start.year, picked.start.month, picked.start.day);
              final DateTime end = DateTime(picked.end.year, picked.end.month, picked.end.day);
              setState(() { continuousRange = DateTimeRange(start: start, end: end); });
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

  Widget _buildNonContinuousPicker(BuildContext context) {
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
                    setState(() {
                      if (!nonContinuousDays.any((d) => _isSameDay(d, normalized))) {
                        nonContinuousDays.add(normalized);
                        nonContinuousDays.sort((a, b) => a.compareTo(b));
                      }
                    });
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
          children: nonContinuousDays.map((DateTime d) {
            return InputChip(
              label: Text(_fmt(d)),
              onDeleted: () { setState(() { nonContinuousDays.remove(d); }); },
            );
          }).toList(),
        ),
      ],
    );
  }

  // === Helpers ===
  String _dateModeLabel(_DateMode mode) {
    switch (mode) {
      case _DateMode.singleDay:
        return 'Single day';
      case _DateMode.nonContinuous:
        return 'Multi-session (non-continuous)';
      case _DateMode.continuous:
        return 'Multi-day (continuous)';
    }
  }

  Future<void> _showDateModeDialog(BuildContext context) async {
    await AppBaseDialog.show<void>(
      context: context,
      title: 'Select format',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppStandardButton(
            text: 'Single day',
            onPressed: () { setState(() { selectedDateMode = _DateMode.singleDay; }); Navigator.of(context).pop(); },
            outlineColor: Colors.white,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.8),
            width: double.infinity,
          ),
          const SizedBox(height: 12),
          AppStandardButton(
            text: 'Multi-session (non-continuous)',
            onPressed: () { setState(() { selectedDateMode = _DateMode.nonContinuous; }); Navigator.of(context).pop(); },
            outlineColor: Colors.white,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.8),
            width: double.infinity,
          ),
          const SizedBox(height: 12),
          AppStandardButton(
            text: 'Multi-day (continuous)',
            onPressed: () { setState(() { selectedDateMode = _DateMode.continuous; }); Navigator.of(context).pop(); },
            outlineColor: Colors.white,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.8),
            width: double.infinity,
          ),
        ],
      ),
      actions: const [],
      maxHeight: 420,
      barrierDismissible: true,
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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

enum _DateMode { singleDay, nonContinuous, continuous }

/// Reusable outlined container with 80% black background
class _OutlinedSection extends StatelessWidget {
  const _OutlinedSection({required this.title, required this.child, this.trailing, this.isRequired = false, this.subtitle});

  final String title;
  final Widget child;
  final Widget? trailing;
  final bool isRequired;
  final Widget? subtitle;

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
          padding: const EdgeInsets.all(12),
          child: child,
        ),
      ],
    );
  }
}


