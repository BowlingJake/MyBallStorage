import 'package:bowlingarsenal_app/models/tournament.dart';
import 'package:bowlingarsenal_app/shared/enums.dart'; // 導入共享的 enum
import 'package:bowlingarsenal_app/widgets/section_container.dart'; // 導入新的容器元件
import 'package:bowlingarsenal_app/widgets/tournament_card.dart'; // 導入新的 TournamentCard
import 'package:flutter/material.dart';

/// 現代化Tournament區塊
/// 垂直列表顯示錦標賽卡片
class ModernTournamentSection extends StatelessWidget {

  const ModernTournamentSection({
    super.key,
    this.onSeeAllPressed,
    this.onTournamentPressed,
  });
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

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'My Tournament',
      onSeeAllPressed: onSeeAllPressed,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _tournaments.length,
        itemBuilder: (context, index) {
          final tournament = _tournaments[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index < _tournaments.length - 1 ? 12.0 : 0),
            child: TournamentCard(
              tournament: tournament,
              onTap: onTournamentPressed != null
                  ? () => onTournamentPressed!(tournament)
                  : null,
            ),
          );
        },
      ),
    );
  }
}

/// Tournament數據模型
class TournamentData {

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
  final String id;
  final String name;
  final String location;
  final String date;
  final double averageScore;
  final int participants;
  final TournamentStatus status;
  final IconData icon;
  final String imageUrl;
}

/// Tournament狀態枚舉
enum TournamentStatus {
  upcoming,
  active,
  registration,
  completed,
}