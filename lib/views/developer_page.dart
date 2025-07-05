import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('開發者 - 計分板 UI'),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
        child: _buildScorecard(context),
      ),
    );
  }

  Widget _buildScorecard(BuildContext context) {
    final glowingTextStyle = TextStyle(
      color: Colors.white.withOpacity(0.8),
      fontFamily: 'Electrolize',
      shadows: [
        for (double i = 1; i < 3; i++)
          Shadow(color: const Color(0xFF00B2A9), blurRadius: 2 * i),
      ],
      fontWeight: FontWeight.bold,
    );

    return Column(
      children: [
        // --- Serial Number Row ---
        Row(
          children: List.generate(10, (index) {
            // Split into two rows of 5 for alignment
            if (index == 5) {
              return const SizedBox.shrink(); // This will be handled in the main column split
            }
            return Expanded(
              child: Text(
                (index + 1).toString(),
                textAlign: TextAlign.center,
                style: glowingTextStyle.copyWith(fontSize: 14),
              ),
            );
          }).where((widget) => widget is! SizedBox).toList(),
        ),
        const SizedBox(height: 4),
        // --- First row of frames ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) => Expanded(child: _buildFrameD(context, index + 1))),
        ),
        const SizedBox(height: 12),
        // --- Serial Number Row for second half ---
         Row(
          children: List.generate(10, (index) {
            if (index < 5) {
              return const SizedBox.shrink();
            }
            return Expanded(
              child: Text(
                (index + 1).toString(),
                textAlign: TextAlign.center,
                style: glowingTextStyle.copyWith(fontSize: 14),
              ),
            );
          }).where((widget) => widget is! SizedBox).toList(),
        ),
        const SizedBox(height: 4),
        // --- Second row of frames ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) => Expanded(child: _buildFrameD(context, index + 6))),
        ),
      ],
    );
  }

  Widget _buildStandardFrameBody(BuildContext context, int frameNumber, Color borderColor, Color textColor) {
    final bool isTenthFrame = frameNumber == 10;
    
    Widget scoreArea;
    if (isTenthFrame) {
      scoreArea = Row(
        children: [
          Expanded(child: _buildSmallScoreBox(context, '', borderColor, textColor)),
          Expanded(child: _buildSmallScoreBox(context, '', borderColor, textColor)),
          Expanded(child: _buildSmallScoreBox(context, '', borderColor, textColor)),
        ],
      );
    } else {
      scoreArea = Row(
        children: [
          Expanded(flex: 1, child: _buildSmallScoreBox(context, '', borderColor, textColor)),
          Expanded(flex: 1, child: _buildSmallScoreBox(context, 'X', borderColor, textColor)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frame Number
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 2.0),
          child: Text(frameNumber.toString(), style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12)),
        ),
        // Score Area and Cumulative Score
        Container(
          height: 50,
          child: Stack(
            children: <Widget>[
              // Cumulative Score Box (bottom layer)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: borderColor, width: 1)),
                  ),
                  child: Text('108', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              // Top Score Area (top layer)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 25,
                child: scoreArea,
              ),
              // Vertical divider for frames 1-9
              if (!isTenthFrame)
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 25,
                  width: 50, // approx center
                  child: Center(
                    child: Container(
                      width: 1,
                      color: borderColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallScoreBox(BuildContext context, String score, Color borderColor, Color textColor) {
    return Container(
      height: 25,
      decoration: BoxDecoration(
        border: Border(
           right: BorderSide(color: borderColor, width: 1)
        ),
      ),
      child: Center(child: Text(score, style: TextStyle(color: textColor, fontSize: 14))),
    );
  }
  
  Widget _buildFrameD(BuildContext context, int frameNumber) {
    const accentColor = Color(0xFF00B2A9);

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            right: BorderSide(color: accentColor, width: 0.5),
            top: BorderSide(color: accentColor.withOpacity(0.3), width: 0.5),
          ),
        ),
        child: _buildStandardFrameBodyD(context, frameNumber, accentColor),
      ),
    );
  }

  Widget _buildStandardFrameBodyD(BuildContext context, int frameNumber, Color accentColor) {
    final bool isTenthFrame = frameNumber == 10;
    
    final glowingTextStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Electrolize',
      shadows: [
        for (double i = 1; i < 3; i++) Shadow(color: accentColor, blurRadius: 2 * i),
      ],
      fontWeight: FontWeight.bold,
    );

    // --- Mock Data to demonstrate different frame states ---
    // This logic will later be replaced by actual game data.
    final bool isStrike = !isTenthFrame && (frameNumber == 1 || frameNumber == 3 || frameNumber == 5);
    final bool isSpare = !isTenthFrame && (frameNumber == 2);

    Widget scoreArea;

    if (isTenthFrame) {
      scoreArea = Row(
        children: [
          Expanded(child: _buildSmallScoreBoxD(context, 'X', accentColor, glowingTextStyle, showRightBorder: true)),
          Expanded(child: _buildSmallScoreBoxD(context, 'X', accentColor, glowingTextStyle, showRightBorder: true)),
          Expanded(child: _buildSmallScoreBoxD(context, '7', accentColor, glowingTextStyle, showRightBorder: false)),
        ],
      );
    } else if (isStrike) {
      // For a strike, we show a single centered 'X' in the top area.
      scoreArea = Center(child: Text('X', style: glowingTextStyle.copyWith(fontSize: 18)));
    } else {
      // For a spare or an open frame, we show two boxes.
      scoreArea = Row(
        children: [
          Expanded(child: _buildSmallScoreBoxD(context, isSpare ? '9' : '8', accentColor, glowingTextStyle, showRightBorder: true)),
          Expanded(child: _buildSmallScoreBoxD(context, isSpare ? '/' : '1', accentColor, glowingTextStyle, showRightBorder: false)),
        ],
      );
    }

    return Column(
      children: [
        Expanded(flex: 2, child: scoreArea),
        Container(height: 1, color: accentColor),
        Expanded(
          flex: 3,
          child: Center(
            child: Text('127', style: glowingTextStyle.copyWith(fontSize: 22)),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallScoreBoxD(BuildContext context, String score, Color accentColor, TextStyle textStyle, {required bool showRightBorder}) {
    return Container(
      decoration: BoxDecoration(
        border: showRightBorder ? Border(right: BorderSide(color: accentColor.withOpacity(0.5))) : null,
      ),
      child: Center(child: Text(score, style: textStyle)),
    );
  }
}
