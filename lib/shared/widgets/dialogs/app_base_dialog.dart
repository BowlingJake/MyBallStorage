import 'package:flutter/material.dart';
import 'package:core_theme/core_theme.dart';

/// 對話框預設樣式常數，統一按鈕尺寸與間距
class DialogDefaults {
  static const double buttonHeight = 52;
  static const double buttonFontSize = 14;
  static const double spacing = 16;
}

/// 應用程式統一的基礎對話框組件
/// 提供一致的樣式和行為，減少重複程式碼
class AppBaseDialog extends StatelessWidget {
  /// 對話框標題
  final String? title;
  
  /// 對話框內容區域
  final Widget content;
  
  /// 底部操作按鈕
  final List<Widget>? actions;
  
  /// 對話框最大寬度
  final double maxWidth;
  
  /// 對話框最大高度
  final double? maxHeight;
  
  /// 邊框顏色，預設為灰色
  final Color? borderColor;
  
  /// 邊框寬度
  final double borderWidth;
  
  /// 背景顏色透明度
  final double backgroundOpacity;
  
  /// 圓角半徑
  final double borderRadius;
  
  /// 內容區域的內邊距
  final EdgeInsets contentPadding;
  
  /// 是否可以點擊遮罩關閉
  final bool barrierDismissible;
  
  /// 遮罩顏色透明度
  final double barrierOpacity;

  const AppBaseDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.maxWidth = 420,
    this.maxHeight,
    this.borderColor,
    this.borderWidth = 1.5,
    this.backgroundOpacity = 0.85,
    this.borderRadius = 16,
    this.contentPadding = const EdgeInsets.all(20),
    this.barrierDismissible = true,
    this.barrierOpacity = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(backgroundOpacity),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? Colors.grey[600]!,
            width: borderWidth,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 標題區域
            if (title != null) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  contentPadding.left,
                  contentPadding.top,
                  contentPadding.right,
                  contentPadding.top / 2,
                ),
                child: _buildTitle(context),
              ),
            ],
            
            // 內容區域（可滾動，隱藏滾動條）
            Flexible(
              child: Padding(
                padding: title != null 
                  ? EdgeInsets.fromLTRB(
                      contentPadding.left,
                      contentPadding.top / 2,
                      contentPadding.right,
                      actions != null ? contentPadding.bottom / 2 : contentPadding.bottom,
                    )
                  : actions != null
                    ? EdgeInsets.fromLTRB(
                        contentPadding.left,
                        contentPadding.top,
                        contentPadding.right,
                        contentPadding.bottom / 2,
                      )
                    : contentPadding,
                child: ScrollConfiguration(
                  behavior: const _NoScrollbarBehavior(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: content,
                  ),
                ),
              ),
            ),
            
            // 操作按鈕區域
            if (actions != null && actions!.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  contentPadding.left,
                  contentPadding.bottom / 2,
                  contentPadding.right,
                  contentPadding.bottom,
                ),
                child: _buildActions(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 建構標題區域
  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// 建構操作按鈕區域
  Widget _buildActions() {
    if (actions == null || actions!.isEmpty) {
      return const SizedBox.shrink();
    }

    // 如果只有一個按鈕，顯示全寬
    if (actions!.length == 1) {
      return SizedBox(
        width: double.infinity,
        child: actions!.first,
      );
    }

    // 多個按鈕時，使用 Row 橫向排列
    return Row(
      children: [
        for (int i = 0; i < actions!.length; i++) ...[
          if (i > 0) const SizedBox(width: DialogDefaults.spacing),
          Expanded(child: actions![i]),
        ],
      ],
    );
  }

  /// 靜態方法：顯示基礎對話框
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    double maxWidth = 420,
    double? maxHeight,
    Color? borderColor,
    double borderWidth = 1.5,
    double backgroundOpacity = 0.85,
    double borderRadius = 16,
    EdgeInsets contentPadding = const EdgeInsets.all(20),
    bool barrierDismissible = true,
    double barrierOpacity = 0.8,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(barrierOpacity),
      builder: (context) => AppBaseDialog(
        title: title,
        content: content,
        actions: actions,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        borderColor: borderColor,
        borderWidth: borderWidth,
        backgroundOpacity: backgroundOpacity,
        borderRadius: borderRadius,
        contentPadding: contentPadding,
        barrierDismissible: barrierDismissible,
        barrierOpacity: barrierOpacity,
      ),
    );
  }

  /// 靜態方法：顯示確認對話框
  static Future<bool?> showConfirmation({
    required BuildContext context,
    String title = '確認',
    required String message,
    String confirmText = '確認',
    String cancelText = '取消',
    Color? confirmColor,
    Color? cancelColor,
    bool isDestructive = false,
  }) {
    return show<bool>(
      context: context,
      title: title,
      borderColor: isDestructive ? Colors.red[700] : null,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        _buildDialogButton(
          text: cancelText,
          onPressed: () => Navigator.of(context).pop(false),
          isPrimary: false,
          color: cancelColor ?? Colors.grey,
        ),
        _buildDialogButton(
          text: confirmText,
          onPressed: () => Navigator.of(context).pop(true),
          isPrimary: true,
          color: confirmColor ?? (isDestructive ? Colors.red : BrandColors.accentColorDark),
        ),
      ],
    );
  }

  /// 靜態方法：顯示訊息對話框
  static Future<void> showMessage({
    required BuildContext context,
    String title = '訊息',
    required String message,
    String buttonText = '確定',
    Color? buttonColor,
  }) {
    return show<void>(
      context: context,
      title: title,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        _buildDialogButton(
          text: buttonText,
          onPressed: () => Navigator.of(context).pop(),
          isPrimary: true,
          color: buttonColor ?? BrandColors.accentColorDark,
        ),
      ],
    );
  }

  /// 建構對話框按鈕的輔助方法
  static Widget _buildDialogButton({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = false,
    Color? color,
  }) {
    return Container(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? (color ?? BrandColors.accentColorDark) : Colors.transparent,
          foregroundColor: isPrimary ? Colors.white : (color ?? Colors.white),
          side: BorderSide(
            color: color ?? (isPrimary ? Colors.transparent : Colors.white),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// 隱藏滾動條的行為（保留觸控滾動與回彈）
class _NoScrollbarBehavior extends ScrollBehavior {
  const _NoScrollbarBehavior();

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child; // 不包任何 Scrollbar
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

/// Arsenal 風格的對話框擴展
/// 提供 Arsenal 功能特定的對話框樣式
class ArsenalDialog extends AppBaseDialog {
  const ArsenalDialog({
    super.key,
    super.title,
    required super.content,
    super.actions,
    super.maxWidth = 420,
    super.maxHeight,
    super.borderWidth = 1.5,
    super.backgroundOpacity = 0.8,
    super.borderRadius = 16,
    super.contentPadding = const EdgeInsets.all(20),
    super.barrierDismissible = true,
    super.barrierOpacity = 0.8,
  }) : super(
    borderColor: BrandColors.accentColorDark,
  );

  /// 顯示 Arsenal 風格對話框
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    double maxWidth = 420,
    double? maxHeight,
    bool barrierDismissible = true,
  }) {
    return AppBaseDialog.show<T>(
      context: context,
      title: title,
      content: content,
      actions: actions,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      borderColor: BrandColors.accentColorDark,
      barrierDismissible: barrierDismissible,
    );
  }
}