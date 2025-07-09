import 'package:bowlingarsenal_app/widgets/common/cards/standard_app_card.dart';
import 'package:flutter/material.dart';

/// 用於在主頁顯示單個錦標賽資訊的卡片
/// 使用 StandardAppCard 作為基礎，以保持風格統一
class TournamentCard extends StatelessWidget {
  const TournamentCard({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return StandardAppCard(
      onTap: onTap,
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start),
    );
  }
}
