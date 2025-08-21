import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

/// 自定義日期選擇器對話框
/// 符合科技運動風格的設計
class CustomDatePickerDialog extends StatefulWidget {
  /// 創建日期選擇器對話框
  const CustomDatePickerDialog({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  /// 初始選擇的日期
  final DateTime? initialDate;
  
  /// 可選擇的最早日期
  final DateTime? firstDate;
  
  /// 可選擇的最晚日期
  final DateTime? lastDate;

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();

  /// 顯示日期選擇器對話框
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2020),
        lastDate: lastDate ?? DateTime.now(),
      ),
    );
  }
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  List<DateTime?> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDates = [widget.initialDate];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: 400,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 標題欄
            _buildHeader(theme),
            
            // 日曆內容
            Flexible(
              child: _buildCalendar(theme),
            ),
            
            // 操作按鈕
            _buildActions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_month,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'Select Training Date',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.single,
          selectedDayHighlightColor: theme.colorScheme.primary,
          weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
          weekdayLabelTextStyle: TextStyle(
            color: theme.colorScheme.primary.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          firstDayOfWeek: 1, // 週一開始
          controlsHeight: 50,
          controlsTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          dayTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          disabledDayTextStyle: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          todayTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          selectedDayTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          dayBorderRadius: BorderRadius.circular(8),
          yearTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          selectedYearTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          monthTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          selectedMonthTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          // 日期範圍限制
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          currentDate: DateTime.now(),
        ),
        value: _selectedDates,
        onValueChanged: (dates) {
          setState(() {
            _selectedDates = dates;
          });
        },
      ),
    );
  }

  Widget _buildActions(ThemeData theme) {
    final hasSelection = _selectedDates.isNotEmpty && 
        _selectedDates.first != null;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppStandardButton.secondary(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              height: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppStandardButton(
              text: 'Confirm',
              onPressed: () => Navigator.of(context).pop(_selectedDates.first),
              enabled: hasSelection,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
