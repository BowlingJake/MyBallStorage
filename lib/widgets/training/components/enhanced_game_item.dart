import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../../../models/training_record.dart';

/// Enhanced Game Item with Professional Dark Tech Style
/// 具有專業深色科技風格的增強遊戲項目
class EnhancedGameItem extends StatelessWidget {
  final GameRecord game;
  final ThemeData theme;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const EnhancedGameItem({
    Key? key,
    required this.game,
    required this.theme,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          HapticFeedback.selectionClick();
          onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getScoreColor().withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: _getScoreColor().withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            // 遊戲編號
            _buildGameNumber(),
            
            SizedBox(width: 16),
            
            // 遊戲詳情
            Expanded(
              child: _buildGameDetails(),
            ),
            
            // 分數
            _buildScore(),
            
            // 刪除按鈕
            if (onDelete != null) ...[
              SizedBox(width: 12),
              _buildDeleteButton(),
            ],
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildGameNumber() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _getScoreColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getScoreColor().withOpacity(0.5),
        ),
      ),
      child: Center(
        child: Text(
          '${game.gameNumber}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: _getScoreColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGameDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                 // 統計資訊
         Row(
           children: [
             _buildStatChip(Iconsax.direct_up, '${game.strikes}', 'STR'),
             SizedBox(width: 8),
             _buildStatChip(Iconsax.arrow_circle_right, '${game.spares}', 'SPR'),
           ],
         ),
        
        SizedBox(height: 4),
        
        // 使用球具
        if (game.ballUsed != null)
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getBallColor(),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6),
              Text(
                game.ballUsed!.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 4),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          SizedBox(width: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScore() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getScoreColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getScoreColor().withOpacity(0.5),
        ),
      ),
      child: Text(
        '${game.score}',
        style: theme.textTheme.titleMedium?.copyWith(
          color: _getScoreColor(),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: () {
        if (onDelete != null) {
          HapticFeedback.lightImpact();
          onDelete!();
        }
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
          ),
        ),
        child: Icon(
          Iconsax.trash,
          size: 14,
          color: Colors.red.withOpacity(0.8),
        ),
      ),
    );
  }

  Color _getScoreColor() {
    if (game.score >= 200) {
      return Colors.green;
    } else if (game.score >= 170) {
      return Colors.blue;
    } else if (game.score >= 140) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getBallColor() {
    if (game.ballUsed == null) return theme.colorScheme.primary;
    
    try {
      return Color(int.parse(game.ballUsed!.brandColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return theme.colorScheme.primary;
    }
  }
} 