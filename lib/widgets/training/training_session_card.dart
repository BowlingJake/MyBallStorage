import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui';
import 'add_games_dialog.dart';

// 訓練記錄數據模型
class TrainingSession {
  final String id;
  final String title;
  final DateTime date;
  final String center;
  final String? oilPatternName;
  final String? oilPatternLength;
  final bool isHousePattern;
  final String scoringMethod; // 新增計分方式
  final DateTime createdAt;

  TrainingSession({
    required this.id,
    required this.title,
    required this.date,
    required this.center,
    this.oilPatternName,
    this.oilPatternLength,
    required this.isHousePattern,
    required this.scoringMethod, // 新增計分方式
    required this.createdAt,
  });
}

// 訓練記錄卡片組件 - Popout Details 風格
class TrainingSessionCard extends StatefulWidget {
  final TrainingSession session;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onAddGames;

  const TrainingSessionCard({
    Key? key,
    required this.session,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.onAddGames,
  }) : super(key: key);

  @override
  State<TrainingSessionCard> createState() => _TrainingSessionCardState();
}

class _TrainingSessionCardState extends State<TrainingSessionCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  String _getOilPatternDisplay() {
    if (widget.session.isHousePattern) {
      return 'House Pattern';
    } else if (widget.session.oilPatternName?.isNotEmpty == true || widget.session.oilPatternLength?.isNotEmpty == true) {
      final name = widget.session.oilPatternName ?? '';
      final length = widget.session.oilPatternLength ?? '';
      if (name.isNotEmpty && length.isNotEmpty) {
        return '$name (${length}ft)';
      } else if (name.isNotEmpty) {
        return name;
      } else if (length.isNotEmpty) {
        return '${length}ft';
      }
    }
    return 'Custom Pattern';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    // 限制標題在20字以內
    String displayTitle = widget.session.title.length > 20 
        ? '${widget.session.title.substring(0, 20)}...' 
        : widget.session.title;

    // Popout style 漸變色彩
    final List<Color> gradientColors = [
      theme.colorScheme.primary.withOpacity(0.7),
      theme.colorScheme.secondary.withOpacity(0.5),
      theme.colorScheme.tertiary?.withOpacity(0.3) ?? Colors.purple.withOpacity(0.3),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          _toggleExpanded();
          if (widget.onTap != null) widget.onTap!();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          height: _isExpanded ? 200 : 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                // 背景漸變
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                // 玻璃擬態效果
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                // 內容
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 頂部區域：標題和控制按鈕
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 標題
                                  Text(
                                    displayTitle,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                      fontSize: 18,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  // 日期和地點
                                  Text(
                                    '${DateFormat('yyyy.MM.dd').format(widget.session.date)} @ ${widget.session.center}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 2),
                                  // 油型信息（第三行）
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.drop,
                                        size: 12,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          _getOilPatternDisplay(),
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // 右側控制按鈕
                            Column(
                              children: [
                                // 刪除按鈕
                                if (widget.onDelete != null)
                                  GestureDetector(
                                    onTap: widget.onDelete,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 12),
                                // 展開/收起指示器
                                AnimatedRotation(
                                  turns: _isExpanded ? 0.5 : 0,
                                  duration: Duration(milliseconds: 400),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 24,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        // 展開內容
                        if (_isExpanded) ...[
                          Spacer(),
                          // 使用 ClipRect 和 SizeTransition 來控制內容展開
                          ClipRect(
                            child: SizeTransition(
                              sizeFactor: _animation,
                              axisAlignment: -1,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 分隔線
                                    Container(
                                      height: 1,
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.white.withOpacity(0.3),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    // 按鈕區域
                                    Row(
                                      children: [
                                        // Add Games 按鈕
                                        Expanded(
                                          child: Container(
                                            height: 36,
                                            child: GFButton(
                                                                                        onPressed: () async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (context) => AddGamesDialog(
                                                trainingId: widget.session.id,
                                                scoringMethod: widget.session.scoringMethod,
                                              ),
                                            );
                                            if (result != null && widget.onAddGames != null) {
                                              widget.onAddGames!();
                                            }
                                          },
                                              text: "Add Games",
                                              icon: Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              type: GFButtonType.solid,
                                              color: Colors.white.withOpacity(0.2),
                                              size: GFSize.SMALL,
                                              shape: GFButtonShape.pills,
                                              fullWidthButton: true,
                                              textStyle: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        // Delete Games 按鈕 (disabled)
                                        Expanded(
                                          child: Container(
                                            height: 36,
                                            child: GFButton(
                                              onPressed: null, // disabled
                                              text: "Delete Games",
                                              icon: Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.white.withOpacity(0.5),
                                                size: 16,
                                              ),
                                              type: GFButtonType.outline,
                                              color: Colors.white.withOpacity(0.3),
                                              size: GFSize.SMALL,
                                              shape: GFButtonShape.pills,
                                              fullWidthButton: true,
                                              textStyle: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white.withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}