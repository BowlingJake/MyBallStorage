import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:ui';

// 訓練詳細資訊彈窗
class TrainingDetailDialog extends StatefulWidget {
  final String sessionId;

  const TrainingDetailDialog({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  @override
  State<TrainingDetailDialog> createState() => _TrainingDetailDialogState();
}

class _TrainingDetailDialogState extends State<TrainingDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedScoringMethod = 'traditional'; // 'traditional' 或 'current'

  void _saveDetails() {
    if (_formKey.currentState!.validate()) {
      // TODO: 保存訓練詳細資訊
      print('Save Training Details for session: ${widget.sessionId}');
      print('Scoring Method: $_selectedScoringMethod');
      
      Navigator.of(context).pop();
      
      // 顯示成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Training details saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              width: size.width * 0.9,
              constraints: BoxConstraints(
                maxWidth: 450,
                minWidth: 320,
                maxHeight: size.height * 0.8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                  ),
                  // 內容
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 標題與關閉按鈕
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Training Details',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // 計分方式選擇
                            _ScoringMethodSelector(
                              selectedMethod: _selectedScoringMethod,
                              onMethodSelected: (method) {
                                setState(() {
                                  _selectedScoringMethod = method;
                                });
                              },
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // 操作按鈕
                            _ActionButtons(onSave: _saveDetails),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 計分方式選擇器
class _ScoringMethodSelector extends StatefulWidget {
  final String selectedMethod;
  final Function(String) onMethodSelected;

  const _ScoringMethodSelector({
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  State<_ScoringMethodSelector> createState() => _ScoringMethodSelectorState();
}

class _ScoringMethodSelectorState extends State<_ScoringMethodSelector> {
  OverlayEntry? _tooltipOverlay;

  void _showTooltip(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    
    _tooltipOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hideTooltip,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            left: position.dx - 50,
            top: position.dy + 40,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 280,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Traditional Scoring: Classic 10-pin bowling scoring system with strikes, spares, and cumulative frame scoring.\n\nCurrent Scoring: Modern scoring method with simplified pin counting and instant score calculation.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
    Overlay.of(context).insert(_tooltipOverlay!);
  }

  void _hideTooltip() {
    _tooltipOverlay?.remove();
    _tooltipOverlay = null;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 標題與問號按鈕
          Row(
            children: [
              Text(
                'Scoring Method',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showTooltip(context),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.help_outline,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // 兩個並排按鈕
          Row(
            children: [
              // Traditional Scoring 按鈕
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onMethodSelected('traditional'),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: widget.selectedMethod == 'traditional' 
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: widget.selectedMethod == 'traditional' 
                          ? Colors.white.withOpacity(0.8)
                          : Colors.white.withOpacity(0.3),
                        width: widget.selectedMethod == 'traditional' ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Traditional',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: widget.selectedMethod == 'traditional' ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 12),
              
              // Current Scoring 按鈕
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onMethodSelected('current'),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: widget.selectedMethod == 'current' 
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: widget.selectedMethod == 'current' 
                          ? Colors.white.withOpacity(0.8)
                          : Colors.white.withOpacity(0.3),
                        width: widget.selectedMethod == 'current' ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Current',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: widget.selectedMethod == 'current' ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 操作按鈕
class _ActionButtons extends StatelessWidget {
  final VoidCallback onSave;

  const _ActionButtons({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GFButton(
            onPressed: () => Navigator.of(context).pop(),
            text: "Cancel",
            type: GFButtonType.outline,
            color: Colors.white,
            size: GFSize.MEDIUM,
            shape: GFButtonShape.pills,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: GFButton(
            onPressed: onSave,
            text: "Save",
            type: GFButtonType.outline,
            color: Colors.white,
            size: GFSize.MEDIUM,
            shape: GFButtonShape.pills,
          ),
        ),
      ],
    );
  }
}

// 顯示訓練詳細資訊彈窗的輔助函數
void showTrainingDetailDialog(BuildContext context, String sessionId) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: TrainingDetailDialog(sessionId: sessionId),
      );
    },
  );
} 