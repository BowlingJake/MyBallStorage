import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// 通用的簡潔應用程式頂部欄
/// 基於Ball Library的設計風格，提供一致的導航體驗
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor = Colors.transparent,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: foregroundColor),
              onPressed: onBackPressed ?? () => context.go('/'),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      titleSpacing: 0, // 讓標題緊靠返回按鈕
      backgroundColor: backgroundColor,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// 預設的應用程式頂部欄配置
class AppBarConfigs {
  /// Ball Library 風格的應用程式欄
  static SimpleAppBar ballLibrary({
    required String title,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return SimpleAppBar(
      title: title,
      actions: actions,
      onBackPressed: onBackPressed,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    );
  }

  /// Tournament 風格（與 Ball Library 相同樣式，語義化命名）
  static SimpleAppBar tournament({
    required String title,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return SimpleAppBar(
      title: title,
      actions: actions,
      onBackPressed: onBackPressed,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    );
  }

  /// Arsenal 風格的應用程式欄
  static SimpleAppBar arsenal({
    required String title,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return SimpleAppBar(
      title: title,
      actions: actions,
      onBackPressed: onBackPressed,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    );
  }
}