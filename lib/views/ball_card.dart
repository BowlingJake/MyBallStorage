import 'package:flutter/material.dart';
import '../models/bowling_ball.dart';
import '../viewmodels/weapon_library_viewmodel.dart';
// 如果您的 layout_dialog.dart 提供了 showBallActionDialog，並且卡片內部需要直接調用（雖然我們這裡主要用回調）
// import '../shared/dialogs/layout_dialog.dart';

/// 請同時在 pubspec.yaml 加上：
/// dependencies:
///   palette_generator: ^0.3.2

class BowlingBallCard extends StatelessWidget {
  final BowlingBall ball;
  final WeaponLibraryViewModel viewModel;
  final bool isSelected; // Unified selection display for the card
  final bool showIndividualDeleteIcon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const BowlingBallCard({
    super.key,
    required this.ball,
    required this.viewModel,
    required this.isSelected,
    required this.showIndividualDeleteIcon,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    bool isMotiv = ball.brand == 'Motiv Bowling';
    bool isStorm = ball.brand == 'Storm Bowling';
    bool hasSpecialBackground = isMotiv || isStorm;

    final baseTextStyle = TextStyle(
      color: hasSpecialBackground ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
      shadows: hasSpecialBackground ? [const Shadow(blurRadius: 1.0, color: Colors.black54, offset: Offset(0.5, 0.5))] : null,
    );
    final boldTextStyle = baseTextStyle.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    final smallTextStyle = baseTextStyle.copyWith(
      fontSize: 12,
      color: hasSpecialBackground ? Colors.white70 : Colors.grey,
    );
    final detailTextStyle = baseTextStyle.copyWith(
      fontSize: 14,
    );
    final layoutHeaderStyle = baseTextStyle.copyWith(
      fontWeight: FontWeight.w500,
    );

    Widget cardContent = InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/images/Jackal EXJ.jpg', // Consider making image path dynamic or passed
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        ball.brand,
                        style: smallTextStyle.copyWith(fontWeight: hasSpecialBackground ? FontWeight.w500 : FontWeight.normal),
                      ),
                    ),
                    Text(
                      ball.releaseDate,
                      style: smallTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ball.ball,
                            style: boldTextStyle,
                          ),
                        ),
                        if (showIndividualDeleteIcon)
                          InkWell(
                            onTap: () => viewModel.removeBallFromArsenal(ball),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: hasSpecialBackground ? Colors.black.withOpacity(0.4) : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: hasSpecialBackground ? Colors.white : Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Core: ${viewModel.getCoreCategory(ball.core)}', style: detailTextStyle, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('Cover: ${ball.coverstockcategory}', style: detailTextStyle, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text('RG: ${ball.rg} / Diff: ${ball.diff} / MB: ${ball.mbDiff}', style: detailTextStyle.copyWith(fontSize: 13), overflow: TextOverflow.ellipsis),
                    if (ball.handType != null &&
                        ball.layoutType != null &&
                        ball.layoutValues != null) ...[
                      const SizedBox(height: 10),
                      Divider(color: hasSpecialBackground ? Colors.white30 : Colors.grey[300], height: 1),
                      const SizedBox(height: 10),
                      Text(
                        '${ball.handType} • '
                        '${ball.layoutType == 'Duel' ? 'Duel Angle Layout' : 'VLS/2LS Layout'}',
                        style: layoutHeaderStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ball.layoutType == 'Duel'
                            ? '${ball.layoutValues![0]}° X ${ball.layoutValues![1]} X ${ball.layoutValues![2]}°'
                            : ball.layoutValues!.join(' X '),
                        style: detailTextStyle,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (isSelected)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.check_circle, color: Colors.lightGreenAccent, size: 40),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    BoxDecoration? cardDecoration;
    if (isMotiv) {
      cardDecoration = BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/motiv_test.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.darken),
        ),
      );
    } else if (isStorm) {
      cardDecoration = BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/storm_test.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.darken),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: cardDecoration,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: cardContent,
        ),
      ),
    );
  }
}
