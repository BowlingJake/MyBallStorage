import 'package:flutter/material.dart';
import '../models/tournament.dart';
import 'tournament_card.dart'; // 導入新的 TournamentCard
import '../shared/enums.dart'; // 導入共享的 enum

/// 現代化Tournament區塊
/// 垂直列表顯示錦標賽卡片
class ModernTournamentSection extends StatelessWidget {
  final VoidCallback? onSeeAllPressed;
  final Function(Tournament tournament)? onTournamentPressed;

  // 靜態的假數據
  static final List<Tournament> _tournaments = [
    Tournament(
      id: '1',
      name: 'Championship Series',
      location: 'Taipei',
      startDate: DateTime.now(),
      selectedBallNames: [],
      games: [],
      type: TournamentType.championship,
    ),
    Tournament(
      id: '2',
      name: 'Weekly Open',
      location: 'Kaohsiung',
      startDate: DateTime.now(),
      selectedBallNames: [],
      games: [],
      type: TournamentType.open,
    ),
    Tournament(
      id: '3',
      name: 'Summer Championship',
      location: 'Taichung',
      startDate: DateTime.now(),
      selectedBallNames: [],
      games: [],
      type: TournamentType.championship,
    ),
  ];

  const ModernTournamentSection({
    Key? key,
    this.onSeeAllPressed,
    this.onTournamentPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Tournament', style: theme.textTheme.headlineMedium),
            TextButton(
              onPressed: onSeeAllPressed,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
              child: const Row(
                children: [
                  Text('See All'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tournaments.length,
          itemBuilder: (context, index) {
            final tournament = _tournaments[index];
            return TournamentCard(
              tournament: tournament,
              onTap: onTournamentPressed != null
                  ? () => onTournamentPressed!(tournament)
                  : null,
            );
          },
        )
      ],
    );
  }
}

/// Tournament數據模型
class TournamentData {
  final String id;
  final String name;
  final String location;
  final String date;
  final double averageScore;
  final int participants;
  final TournamentStatus status;
  final IconData icon;
  final String imageUrl;

  const TournamentData({
    required this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.averageScore,
    required this.participants,
    required this.status,
    required this.icon,
    required this.imageUrl,
  });
}

/// Tournament狀態枚舉
enum TournamentStatus {
  upcoming,
  active,
  registration,
  completed,
}