import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../models/training_record.dart';

/// 可編輯的遊戲卡片組件
/// 支持內聯編輯分數、Strikes、Spares等數據
class EditableGameCard extends StatefulWidget {
  final GameRecord game;
  final ThemeData theme;
  final Function(GameRecord) onGameSaved;
  final VoidCallback? onGameCanceled;
  final VoidCallback? onGameDelete;
  final bool isEditing;

  const EditableGameCard({
    Key? key,
    required this.game,
    required this.theme,
    required this.onGameSaved,
    this.onGameCanceled,
    this.onGameDelete,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<EditableGameCard> createState() => _EditableGameCardState();
}

class _EditableGameCardState extends State<EditableGameCard> {
  late TextEditingController _scoreController;
  late TextEditingController _strikesController;
  late TextEditingController _sparesController;
  late TextEditingController _notesController;
  
  bool _isEditing = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing;
    
    _scoreController = TextEditingController(text: widget.game.score.toString());
    _strikesController = TextEditingController(text: widget.game.strikes.toString());
    _sparesController = TextEditingController(text: widget.game.spares.toString());
    _notesController = TextEditingController(text: widget.game.notes ?? '');
    
    // 監聽變化
    _scoreController.addListener(_onFieldChanged);
    _strikesController.addListener(_onFieldChanged);
    _sparesController.addListener(_onFieldChanged);
    _notesController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _strikesController.dispose();
    _sparesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {
      _hasChanges = true;
    });
  }

  void _saveGame() {
    final score = int.tryParse(_scoreController.text) ?? 0;
    final strikes = int.tryParse(_strikesController.text) ?? 0;
    final spares = int.tryParse(_sparesController.text) ?? 0;
    
    // 驗證數據
    if (score < 0 || score > 300) {
      _showErrorDialog('分數必須在 0-300 之間');
      return;
    }
    
    if (strikes < 0 || strikes > 12) {
      _showErrorDialog('Strike 數量必須在 0-12 之間');
      return;
    }
    
    if (spares < 0 || spares > 10) {
      _showErrorDialog('Spare 數量必須在 0-10 之間');
      return;
    }

    // 創建更新的遊戲記錄
    final updatedGame = GameRecord(
      id: widget.game.id,
      gameNumber: widget.game.gameNumber,
      score: score,
      frameScores: widget.game.frameScores, // 保持原有 frameScores
      strikes: strikes,
      spares: spares,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      timestamp: widget.game.timestamp,
      ballUsed: widget.game.ballUsed,
    );

    widget.onGameSaved(updatedGame);
    setState(() {
      _isEditing = false;
      _hasChanges = false;
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _hasChanges = false;
      // 重置控制器
      _scoreController.text = widget.game.score.toString();
      _strikesController.text = widget.game.strikes.toString();
      _sparesController.text = widget.game.spares.toString();
      _notesController.text = widget.game.notes ?? '';
    });
    widget.onGameCanceled?.call();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('輸入錯誤'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('確定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isEditing 
          ? widget.theme.colorScheme.primary.withOpacity(0.1)
          : widget.theme.colorScheme.surface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isEditing 
            ? widget.theme.colorScheme.primary.withOpacity(0.5)
            : widget.theme.colorScheme.primary.withOpacity(0.2),
          width: _isEditing ? 2 : 1,
        ),
        boxShadow: _isEditing ? [
          BoxShadow(
            color: widget.theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ] : null,
      ),
      child: Column(
        children: [
          // 頭部 - 局數和控制按鈕
          _buildHeader(),
          
          SizedBox(height: 16),
          
          // 主要內容區域
          if (_isEditing) _buildEditingContent() else _buildDisplayContent(),
          
          // 編輯模式下的操作按鈕
          if (_isEditing) ...[
            SizedBox(height: 16),
            _buildEditingActions(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // 局數徽章
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: widget.theme.colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.theme.colorScheme.primary.withOpacity(0.5),
            ),
          ),
          child: Center(
            child: Text(
              '${widget.game.gameNumber}',
              style: widget.theme.textTheme.bodyMedium?.copyWith(
                color: widget.theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        SizedBox(width: 12),
        
        // 標題
        Expanded(
          child: Text(
            'Game ${widget.game.gameNumber}',
            style: widget.theme.textTheme.titleMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // 控制按鈕
        if (!_isEditing) ...[
          IconButton(
            icon: Icon(Iconsax.edit, size: 20),
            onPressed: () => setState(() => _isEditing = true),
            color: widget.theme.colorScheme.primary,
          ),
          if (widget.onGameDelete != null)
            IconButton(
              icon: Icon(Iconsax.trash, size: 20),
              onPressed: widget.onGameDelete,
              color: Colors.red.withOpacity(0.8),
            ),
        ],
      ],
    );
  }

  Widget _buildDisplayContent() {
    return Row(
      children: [
        // 分數顯示
        Expanded(
          flex: 2,
          child: _buildStatDisplay(
            icon: Icons.emoji_events,
            label: '總分',
            value: '${widget.game.score}',
            color: _getScoreColor(widget.game.score),
          ),
        ),
        
        SizedBox(width: 12),
        
        // Strikes
        Expanded(
          child: _buildStatDisplay(
            icon: Iconsax.direct_up,
            label: 'STR',
            value: '${widget.game.strikes}',
            color: Colors.green,
          ),
        ),
        
        SizedBox(width: 12),
        
        // Spares
        Expanded(
          child: _buildStatDisplay(
            icon: Iconsax.arrow_circle_right,
            label: 'SPR',
            value: '${widget.game.spares}',
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildEditingContent() {
    return Column(
      children: [
        // 分數輸入行
        Row(
          children: [
            // 總分
            Expanded(
              flex: 2,
              child: _buildEditField(
                controller: _scoreController,
                label: '總分',
                icon: Icons.emoji_events,
                inputType: TextInputType.number,
                maxLength: 3,
              ),
            ),
            
            SizedBox(width: 12),
            
            // Strikes
            Expanded(
              child: _buildEditField(
                controller: _strikesController,
                label: 'STR',
                icon: Iconsax.direct_up,
                inputType: TextInputType.number,
                maxLength: 2,
              ),
            ),
            
            SizedBox(width: 12),
            
            // Spares
            Expanded(
              child: _buildEditField(
                controller: _sparesController,
                label: 'SPR',
                icon: Iconsax.arrow_circle_right,
                inputType: TextInputType.number,
                maxLength: 2,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16),
        
        // 備註輸入
        _buildEditField(
          controller: _notesController,
          label: '備註 (選填)',
          icon: Iconsax.note,
          inputType: TextInputType.text,
          maxLines: 2,
          maxLength: 100,
        ),
      ],
    );
  }

  Widget _buildStatDisplay({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          SizedBox(height: 4),
          Text(
            value,
            style: widget.theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: widget.theme.textTheme.bodySmall?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    int maxLength = 50,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLength: maxLength,
      maxLines: maxLines,
      style: widget.theme.textTheme.bodyMedium?.copyWith(
        color: widget.theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18),
        counterText: '', // 隱藏字符計數
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.theme.colorScheme.primary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: widget.theme.colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      inputFormatters: inputType == TextInputType.number 
        ? [FilteringTextInputFormatter.digitsOnly]
        : null,
    );
  }

  Widget _buildEditingActions() {
    return Row(
      children: [
        // 取消按鈕
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _cancelEdit,
            icon: Icon(Iconsax.close_circle, size: 18),
            label: Text('取消'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey,
              side: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
          ),
        ),
        
        SizedBox(width: 12),
        
        // 保存按鈕
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _hasChanges ? _saveGame : null,
            icon: Icon(Iconsax.tick_circle, size: 18),
            label: Text('保存'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.theme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 200) return Colors.green;
    if (score >= 170) return Colors.blue;
    if (score >= 140) return Colors.orange;
    return Colors.red;
  }
}