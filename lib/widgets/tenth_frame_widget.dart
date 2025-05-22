import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/score_data.dart';
import 'pin_selector_popup_widget.dart';

class TenthFrameWidget extends StatelessWidget {
  final Frame frame;
  final bool isCurrentFrame;
  final double availableWidth;
  final Function(Frame) onFrameUpdated;
  final Function() onGameComplete;

  const TenthFrameWidget({
    super.key,
    required this.frame,
    required this.isCurrentFrame,
    required this.availableWidth,
    required this.onFrameUpdated,
    required this.onGameComplete,
  });

  Future<void> _handleFrameTap(BuildContext context) async {
    Set<int> initialPinsDown;

    if (frame.rolls.isEmpty) {
      // 第一球，10瓶全站立
      initialPinsDown = {};
    } else if (frame.rolls.length == 1) {
      // 第二球
      if (frame.rolls[0].pinsDown == 10) {
        // 第一球全倒，第二球重置
        initialPinsDown = {};
      } else {
        // 第一球沒全倒，第二球剩下的瓶
        initialPinsDown = {1,2,3,4,5,6,7,8,9,10}.difference(frame.rolls[0].pinsStandingAfterThrow!);
      }
    } else if (frame.rolls.length == 2) {
      // 第三球
      if (frame.rolls[0].pinsDown == 10) {
        // 第一球全倒
        if (frame.rolls[1].pinsDown == 10) {
          // 第二球也全倒，第三球重置
          initialPinsDown = {}; 
        } else {
          // 第二球沒全倒，第三球為第二球剩下的瓶
          initialPinsDown = {1,2,3,4,5,6,7,8,9,10}.difference(frame.rolls[1].pinsStandingAfterThrow!);
        }
      } else if (frame.rolls[0].pinsDown + frame.rolls[1].pinsDown == 10) {
        // 前兩球補中，第三球重置
        initialPinsDown = {};
      } else {
        // 不應該有第三球
        return;
      }
    } else {
      // 已經三球，不能再投
      return;
    }

    final Set<int>? pinsHit = await showDialog<Set<int>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PinSelectorPopupWidget(
          initialPinsDown: initialPinsDown,
          pinStandingAssetPath: 'assets/images/pin_standing.svg',
          pinFallenAssetPath: 'assets/images/pin_fallen.svg',
        );
      },
    );

    if (pinsHit != null) {
      final int pinsDown = pinsHit.length;
      final Roll newRoll = Roll(
        pinsDown: pinsDown,
        pinsStandingAfterThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.difference(pinsHit),
        displayScore: _getDisplayScore(pinsDown),
        pinsStandingBeforeThrow: frame.rolls.isEmpty ? {1,2,3,4,5,6,7,8,9,10} : frame.rolls.last.pinsStandingAfterThrow!,
      );

      frame.rolls.add(newRoll);
      
      // 檢查是否需要結束遊戲
      if (frame.rolls.length == 2) {
        final int first = frame.rolls[0].pinsDown;
        final int second = frame.rolls[1].pinsDown;
        if (first != 10 && first + second != 10) {
          frame.isComplete = true;
          onGameComplete();
        }
      } else if (frame.rolls.length == 3) {
        frame.isComplete = true;
        onGameComplete();
      }

      onFrameUpdated(frame);
    }
  }

  String _getDisplayScore(int pinsDown) {
    if (frame.rolls.isEmpty) {
      // 第一球
      return pinsDown == 10 ? "X" : pinsDown.toString();
    } else if (frame.rolls.length == 1) {
      // 第二球
      if (pinsDown == 10) return "X";
      if (frame.rolls[0].pinsDown < 10 && frame.rolls[0].pinsDown + pinsDown == 10) {
        return "/";
      }
      return pinsDown.toString();
    } else {
      // 第三球
      if (pinsDown == 10) return "X";
      if (frame.rolls[1].pinsDown < 10 && frame.rolls[1].pinsDown + pinsDown == 10) {
        return "/";
      }
      return pinsDown.toString();
    }
  }

  String? _getBallScore(int ballIndex) {
    if (frame.rolls.length <= ballIndex) return null;
    final roll = frame.rolls[ballIndex];
    
    if (ballIndex == 0) {
      return roll.pinsDown == 10 ? "X" : roll.pinsDown.toString();
    } else if (ballIndex == 1) {
      if (roll.pinsDown == 10) return "X";
      if (frame.rolls[0].pinsDown < 10 && frame.rolls[0].pinsDown + roll.pinsDown == 10) {
        return "/";
      }
      return roll.pinsDown.toString();
    } else {
      if (roll.pinsDown == 10) return "X";
      if (frame.rolls[1].pinsDown < 10 && frame.rolls[1].pinsDown + roll.pinsDown == 10) {
        return "/";
      }
      return roll.pinsDown.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    const BorderSide borderSide = BorderSide(color: Colors.black, width: 0.5);
    final double frameNumberHeight = (availableWidth - 2) * 0.3;
    final double scoreBoxHeight = (availableWidth - 2) * 0.4;
    final double totalScoreHeight = (availableWidth - 2) * 0.3;
    final double smallBoxWidth = (availableWidth - 3) / 3;

    return GestureDetector(
      onTap: isCurrentFrame ? () => _handleFrameTap(context) : null,
      child: Container(
        width: availableWidth,
        height: availableWidth,
        decoration: BoxDecoration(
          border: Border.all(
            color: isCurrentFrame ? Colors.blue : Colors.grey,
            width: isCurrentFrame ? 1.0 : 0.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: frameNumberHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                border: const Border(bottom: borderSide),
                color: isCurrentFrame ? Colors.blue.withOpacity(0.1) : null,
              ),
              child: Center(
                child: Text(
                  "10",
                  style: TextStyle(
                    fontSize: availableWidth * 0.15,
                    fontWeight: FontWeight.bold,
                    color: isCurrentFrame ? Colors.blue : Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: scoreBoxHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildBallScoreBox(
                    _getBallScore(0),
                    smallBoxWidth,
                    scoreBoxHeight,
                    borderSide,
                    isLeftMost: true,
                    fontSize: availableWidth * 0.25,
                  ),
                  _buildBallScoreBox(
                    _getBallScore(1),
                    smallBoxWidth,
                    scoreBoxHeight,
                    borderSide,
                    fontSize: availableWidth * 0.25,
                  ),
                  _buildBallScoreBox(
                    _getBallScore(2),
                    smallBoxWidth,
                    scoreBoxHeight,
                    borderSide,
                    isRightMost: true,
                    fontSize: availableWidth * 0.25,
                  ),
                ],
              ),
            ),
            Container(
              height: totalScoreHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(top: borderSide),
              ),
              child: Center(
                child: Text(
                  frame.totalScore?.toString() ?? "",
                  style: TextStyle(
                    fontSize: availableWidth * 0.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBallScoreBox(
    String? score,
    double width,
    double height,
    BorderSide border, {
    bool isLeftMost = false,
    bool isRightMost = false,
    required double fontSize,
  }) {
    Widget displayWidget;
    
    if (score == "X") {
      displayWidget = SvgPicture.asset(
        'assets/images/strike_symbol.svg',
        width: width * 0.8,
        height: height * 0.8,
        fit: BoxFit.contain,
      );
    } else if (score == "/") {
      displayWidget = SvgPicture.asset(
        'assets/images/spare_symbol.svg',
        width: width * 0.8,
        height: height * 0.8,
        fit: BoxFit.contain,
      );
    } else {
      displayWidget = Text(
        score ?? "",
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          left: isLeftMost ? BorderSide.none : border,
          right: isRightMost ? BorderSide.none : border,
        ),
      ),
      child: Center(child: displayWidget),
    );
  }
} 