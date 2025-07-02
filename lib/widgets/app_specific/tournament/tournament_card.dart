import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/widgets/common/cards/standard_app_card.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart'; // 用於日期格式化

/// 用於在主頁顯示單個錦標賽資訊的卡片
/// 使用 StandardAppCard 作為基礎，以保持風格統一
class TournamentCard extends StatelessWidget {
  final VoidCallback? onTap;

  const TournamentCard({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StandardAppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon(
          //   tournament.type == TournamentType.championship ? Iconsax.cup : Iconsax.medal_star,
          //   color: Theme.of(context).colorScheme.primary,
          // ),
          // const SizedBox(height: 8),
          // Text(
          //   tournament.name,
          //   style: Theme.of(context).textTheme.titleMedium,
          // ),
          // Text(
          //   DateFormat('yyyy-MM-dd').format(tournament.date),
          //   style: Theme.of(context).textTheme.bodySmall,
          // ),
        ],
      ),
    );
  }
} 