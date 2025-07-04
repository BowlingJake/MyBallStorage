// import '../shared/enums.dart'; // 導入共享的 enum
import 'package:bowlingarsenal_app/widgets/common/cards/section_container.dart';
import 'package:flutter/material.dart';
// import '../models/tournament.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 現代化Tournament區塊
/// 垂直列表顯示錦標賽卡片
class ModernTournamentSection extends ConsumerWidget {
  const ModernTournamentSection({
    required this.title,
    super.key,
    // this.onTournamentPressed,
    this.onViewAllPressed,
  });
  final String title;
  // final Function(Tournament tournament)? onTournamentPressed;
  final VoidCallback? onViewAllPressed;

  // static final List<Tournament> _tournaments = [
  //   Tournament(
  //     name: 'PBA World Championship',
  //     date: DateTime(2024, 5, 10),
  //     location: 'Las Vegas, NV',
  //     type: TournamentType.championship,
  //   ),
  //   Tournament(
  //     name: 'USBC Open Championships',
  //     date: DateTime(2024, 6, 22),
  //     location: 'Reno, NV',
  //     type: TournamentType.open,
  //   ),
  //   Tournament(
  //     name: 'Storm Lucky Larsen Masters',
  //     date: DateTime(2024, 8, 15),
  //     location: 'Malmö, Sweden',
  //     type: TournamentType.championship,
  //   ),
  // ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionContainer(
      title: title,
      onViewAll: onViewAllPressed,
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // itemCount: _tournaments.length,
          itemCount: 0, // Placeholder
          itemBuilder: (context, index) {
            // final tournament = _tournaments[index];
            return const SizedBox();
            // return TournamentCard(
            //   tournament: tournament,
            //   onTap: () => onTournamentPressed?.call(tournament),
            // );
          },
        ),
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
enum TournamentStatus { upcoming, active, registration, completed }
