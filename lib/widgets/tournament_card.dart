import 'package:bowlingarsenal_app/models/tournament.dart';
import 'package:bowlingarsenal_app/shared/enums.dart'; // 導入共享的 enum
import 'package:bowlingarsenal_app/widgets/standard_app_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart'; // 用於日期格式化

/// 用於在主頁顯示單個錦標賽資訊的卡片
/// 使用 StandardAppCard 作為基礎，以保持風格統一
class TournamentCard extends StatelessWidget {

  const TournamentCard({
    required this.tournament, super.key,
    this.onTap,
  });
  final Tournament tournament;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StandardAppCard(
      variant: StandardAppCardVariant.nested, // 使用嵌套變體以獲得更好的視覺對比
      onTap: onTap,
      child: Row(
        children: [
          // 左側：代表錦標賽類型的圖示
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tournament.type == TournamentType.championship ? Iconsax.cup : Iconsax.medal_star,
              color: theme.colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),

          // 右側：錦標賽資訊
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tournament.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      size: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tournament.location, // 顯示地點
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Iconsax.calendar_1,
                      size: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      // 格式化並顯示開始日期
                      DateFormat.yMMMd().format(tournament.startDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 