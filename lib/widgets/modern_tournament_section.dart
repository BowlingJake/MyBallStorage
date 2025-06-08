import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

/// 現代化Tournament區塊
/// 橫向滾動的卡片設計，類似Popular Categories
class ModernTournamentSection extends StatefulWidget {
  final List<TournamentData>? tournaments;
  final VoidCallback? onSeeAllPressed;
  final void Function(TournamentData tournament)? onTournamentPressed;

  const ModernTournamentSection({
    super.key,
    this.tournaments,
    this.onSeeAllPressed,
    this.onTournamentPressed,
  });

  @override
  State<ModernTournamentSection> createState() => _ModernTournamentSectionState();
}

class _ModernTournamentSectionState extends State<ModernTournamentSection> {
  late ScrollController _scrollController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cardWidth = 240.0 + 16.0; // 卡片寬度 + 間距
    final currentIndex = (_scrollController.offset / cardWidth).round();
    if (currentIndex != _currentIndex) {
      setState(() {
        _currentIndex = currentIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tournamentData = widget.tournaments ?? _getDefaultTournaments();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 標題區域
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Tournament',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: widget.onSeeAllPressed ?? () => print('See All Tournaments'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 橫向滾動卡片
        SizedBox(
          height: 120,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tournamentData.length,
            itemBuilder: (context, index) {
              final tournament = tournamentData[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == tournamentData.length - 1 ? 0 : 16,
                ),
                child: _TournamentCard(
                  tournament: tournament,
                  onTap: () => widget.onTournamentPressed?.call(tournament),
                ),
              );
            },
          ),
        ),
        
        // 分頁指示器
        const SizedBox(height: 8),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              tournamentData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentIndex == index ? 8 : 6,
                height: _currentIndex == index ? 8 : 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index 
                    ? const Color(0xFFf39c12)
                    : Colors.grey.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<TournamentData> _getDefaultTournaments() {
    return [
      TournamentData(
        id: '1',
        name: 'Championship Series',
        location: 'Sports Center',
        date: '2025-01-15',
        averageScore: 195.5,
        participants: 24,
        status: TournamentStatus.upcoming,
        icon: Icons.emoji_events,
        imageUrl: 'https://images.unsplash.com/photo-1587280501635-356de24d2779?w=400&q=80',
      ),
      TournamentData(
        id: '2',
        name: 'Weekly League',
        location: 'Bowling Arena',
        date: '2025-01-20',
        averageScore: 180.0,
        participants: 16,
        status: TournamentStatus.active,
        icon: Icons.groups,
        imageUrl: 'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=400&q=80',
      ),
      TournamentData(
        id: '3',
        name: 'Pro Tournament',
        location: 'Elite Center',
        date: '2025-01-25',
        averageScore: 210.2,
        participants: 32,
        status: TournamentStatus.registration,
        icon: Icons.star_border,
        imageUrl: 'https://images.unsplash.com/photo-1593085512500-5d55148d6f0d?w=400&q=80',
      ),
      TournamentData(
        id: '4',
        name: 'Beginner Cup',
        location: 'Local Lanes',
        date: '2025-02-01',
        averageScore: 150.0,
        participants: 12,
        status: TournamentStatus.upcoming,
        icon: Icons.sports,
        imageUrl: 'https://images.unsplash.com/photo-1628890923662-2cb23c2e0cfe?w=400&q=80',
      ),
    ];
  }
}

/// Tournament卡片組件
class _TournamentCard extends StatelessWidget {
  final TournamentData tournament;
  final VoidCallback? onTap;

  const _TournamentCard({
    required this.tournament,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240, // 調整寬度，讓一頁顯示一格半
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(tournament.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournament.name.replaceAll('\n', ' '),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      shadows: [
                         Shadow(
                          blurRadius: 4.0,
                          color: Colors.black54,
                          offset: Offset(1.0, 1.0),
                        ),
                      ]
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: Colors.white.withOpacity(0.9),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${tournament.participants}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${tournament.averageScore.toInt()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
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

/// 帶閃爍效果的加載卡片
class TournamentLoadingCard extends StatelessWidget {
  const TournamentLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade300,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}