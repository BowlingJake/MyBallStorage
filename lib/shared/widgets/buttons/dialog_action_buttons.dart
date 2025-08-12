import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:core_theme/core_theme.dart';

/// 對話框統一操作按鈕組件
/// 提供標準化的按鈕佈局和樣式，減少重複程式碼
class DialogActionButtons extends StatelessWidget {
  /// 主要操作按鈕文字
  final String primaryText;
  
  /// 次要操作按鈕文字
  final String secondaryText;
  
  /// 主要操作回調
  final VoidCallback onPrimary;
  
  /// 次要操作回調
  final VoidCallback onSecondary;
  
  /// 主要按鈕是否啟用
  final bool primaryEnabled;
  
  /// 次要按鈕是否啟用
  final bool secondaryEnabled;
  
  /// 主要按鈕顏色
  final Color? primaryColor;
  
  /// 次要按鈕顏色
  final Color? secondaryColor;
  
  /// 按鈕高度
  final double buttonHeight;
  
  /// 按鈕字體大小
  final double fontSize;
  
  /// 按鈕間距
  final double spacing;
  
  /// 是否為危險操作（會使用紅色主題）
  final bool isDestructive;
  
  /// 按鈕排列方向
  final Axis direction;

  const DialogActionButtons({
    super.key,
    required this.primaryText,
    required this.secondaryText,
    required this.onPrimary,
    required this.onSecondary,
    this.primaryEnabled = true,
    this.secondaryEnabled = true,
    this.primaryColor,
    this.secondaryColor,
    this.buttonHeight = 36,
    this.fontSize = 12,
    this.spacing = 12,
    this.isDestructive = false,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final primaryButtonColor = primaryColor ?? 
        (isDestructive ? Colors.red : BrandColors.accentColorDark);
    final secondaryButtonColor = secondaryColor ?? Colors.white;

    final primaryButton = _buildPrimaryButton(primaryButtonColor);
    final secondaryButton = _buildSecondaryButton(secondaryButtonColor);

    if (direction == Axis.vertical) {
      return Column(
        children: [
          primaryButton,
          SizedBox(height: spacing),
          secondaryButton,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: secondaryButton),
        SizedBox(width: spacing),
        Expanded(child: primaryButton),
      ],
    );
  }

  /// 建構主要操作按鈕
  Widget _buildPrimaryButton(Color color) {
    return AppStandardButton(
      text: primaryText,
      height: buttonHeight,
      fontSize: fontSize,
      isPrimary: true,
      customColor: color,
      whiteForeground: true,
      width: double.infinity,
      enabled: primaryEnabled,
      onPressed: primaryEnabled ? onPrimary : () {},
    );
  }

  /// 建構次要操作按鈕
  Widget _buildSecondaryButton(Color color) {
    return AppStandardButton(
      text: secondaryText,
      height: buttonHeight,
      fontSize: fontSize,
      isPrimary: false,
      outlineColor: color,
      foregroundColor: color,
      backgroundColor: Colors.transparent,
      width: double.infinity,
      enabled: secondaryEnabled,
      onPressed: secondaryEnabled ? onSecondary : () {},
    );
  }
}

/// 單一操作按鈕組件
/// 當只需要一個按鈕時使用
class DialogSingleActionButton extends StatelessWidget {
  /// 按鈕文字
  final String text;
  
  /// 操作回調
  final VoidCallback onPressed;
  
  /// 按鈕是否啟用
  final bool enabled;
  
  /// 按鈕顏色
  final Color? color;
  
  /// 按鈕高度
  final double buttonHeight;
  
  /// 按鈕字體大小
  final double fontSize;
  
  /// 是否為主要按鈕樣式
  final bool isPrimary;
  
  /// 是否為危險操作
  final bool isDestructive;

  const DialogSingleActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.color,
    this.buttonHeight = 36,
    this.fontSize = 12,
    this.isPrimary = true,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? 
        (isDestructive ? Colors.red : BrandColors.accentColorDark);

    return AppStandardButton(
      text: text,
      height: buttonHeight,
      fontSize: fontSize,
      isPrimary: isPrimary,
      customColor: isPrimary ? buttonColor : null,
      outlineColor: isPrimary ? null : buttonColor,
      foregroundColor: isPrimary ? Colors.white : buttonColor,
      backgroundColor: isPrimary ? buttonColor : Colors.transparent,
      whiteForeground: isPrimary,
      width: double.infinity,
      enabled: enabled,
      onPressed: enabled ? onPressed : () {},
    );
  }
}

/// 三個操作按鈕組件
/// 當需要三個選項時使用（如：取消、選項A、選項B）
class DialogTripleActionButtons extends StatelessWidget {
  /// 第一個按鈕文字（通常是取消）
  final String firstText;
  
  /// 第二個按鈕文字
  final String secondText;
  
  /// 第三個按鈕文字
  final String thirdText;
  
  /// 第一個按鈕回調
  final VoidCallback onFirst;
  
  /// 第二個按鈕回調
  final VoidCallback onSecond;
  
  /// 第三個按鈕回調
  final VoidCallback onThird;
  
  /// 按鈕啟用狀態
  final bool firstEnabled;
  final bool secondEnabled;
  final bool thirdEnabled;
  
  /// 按鈕顏色
  final Color? firstColor;
  final Color? secondColor;
  final Color? thirdColor;
  
  /// 按鈕高度
  final double buttonHeight;
  
  /// 按鈕字體大小
  final double fontSize;
  
  /// 按鈕間距
  final double spacing;
  
  /// 主要按鈕索引（0、1 或 2）
  final int primaryIndex;

  const DialogTripleActionButtons({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.thirdText,
    required this.onFirst,
    required this.onSecond,
    required this.onThird,
    this.firstEnabled = true,
    this.secondEnabled = true,
    this.thirdEnabled = true,
    this.firstColor,
    this.secondColor,
    this.thirdColor,
    this.buttonHeight = 36,
    this.fontSize = 12,
    this.spacing = 8,
    this.primaryIndex = 2, // 預設第三個按鈕為主要按鈕
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 第一行：第一個按鈕（通常是取消）
        _buildButton(
          text: firstText,
          onPressed: onFirst,
          enabled: firstEnabled,
          color: firstColor ?? Colors.white,
          isPrimary: primaryIndex == 0,
        ),
        SizedBox(height: spacing),
        
        // 第二行：第二和第三個按鈕
        Row(
          children: [
            Expanded(
              child: _buildButton(
                text: secondText,
                onPressed: onSecond,
                enabled: secondEnabled,
                color: secondColor ?? Colors.blue,
                isPrimary: primaryIndex == 1,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildButton(
                text: thirdText,
                onPressed: onThird,
                enabled: thirdEnabled,
                color: thirdColor ?? Colors.red,
                isPrimary: primaryIndex == 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 建構單個按鈕
  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool enabled,
    required Color color,
    required bool isPrimary,
  }) {
    return AppStandardButton(
      text: text,
      height: buttonHeight,
      fontSize: fontSize,
      isPrimary: isPrimary,
      customColor: isPrimary ? color : null,
      outlineColor: isPrimary ? null : color,
      foregroundColor: isPrimary ? Colors.white : color,
      backgroundColor: isPrimary ? color : Colors.transparent,
      whiteForeground: isPrimary,
      width: double.infinity,
      enabled: enabled,
      onPressed: enabled ? onPressed : () {},
    );
  }
}

/// 對話框按鈕建構器類別
/// 提供靜態方法快速建構常用的按鈕組合
class DialogButtonBuilder {
  DialogButtonBuilder._(); // 私有建構子

  /// 建構確認/取消按鈕組合
  static Widget confirmCancel({
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    String confirmText = '確認',
    String cancelText = '取消',
    Color? confirmColor,
    bool confirmEnabled = true,
    bool isDestructive = false,
  }) {
    return DialogActionButtons(
      primaryText: confirmText,
      secondaryText: cancelText,
      onPrimary: onConfirm,
      onSecondary: onCancel,
      primaryEnabled: confirmEnabled,
      primaryColor: confirmColor,
      isDestructive: isDestructive,
    );
  }

  /// 建構是/否按鈕組合
  static Widget yesNo({
    required VoidCallback onYes,
    required VoidCallback onNo,
    String yesText = '是',
    String noText = '否',
    Color? yesColor,
    bool yesEnabled = true,
  }) {
    return DialogActionButtons(
      primaryText: yesText,
      secondaryText: noText,
      onPrimary: onYes,
      onSecondary: onNo,
      primaryEnabled: yesEnabled,
      primaryColor: yesColor,
    );
  }

  /// 建構繼續/取消按鈕組合
  static Widget continueCancel({
    required VoidCallback onContinue,
    required VoidCallback onCancel,
    String continueText = '繼續',
    String cancelText = '取消',
    Color? continueColor,
    bool continueEnabled = true,
  }) {
    return DialogActionButtons(
      primaryText: continueText,
      secondaryText: cancelText,
      onPrimary: onContinue,
      onSecondary: onCancel,
      primaryEnabled: continueEnabled,
      primaryColor: continueColor,
    );
  }

  /// 建構單一確定按鈕
  static Widget ok({
    required VoidCallback onPressed,
    String text = '確定',
    Color? color,
    bool enabled = true,
  }) {
    return DialogSingleActionButton(
      text: text,
      onPressed: onPressed,
      enabled: enabled,
      color: color,
    );
  }

  /// 建構移除選項按鈕組合（從袋子移除/完全移除/取消）
  static Widget removalOptions({
    required VoidCallback onRemoveFromBag,
    required VoidCallback onCompleteRemoval,
    required VoidCallback onCancel,
    String removeFromBagText = '從袋子移除',
    String completeRemovalText = '完全移除',
    String cancelText = '取消',
    bool removeFromBagEnabled = true,
    bool completeRemovalEnabled = true,
  }) {
    return DialogTripleActionButtons(
      firstText: cancelText,
      secondText: removeFromBagText,
      thirdText: completeRemovalText,
      onFirst: onCancel,
      onSecond: onRemoveFromBag,
      onThird: onCompleteRemoval,
      firstEnabled: true,
      secondEnabled: removeFromBagEnabled,
      thirdEnabled: completeRemovalEnabled,
      firstColor: Colors.white,
      secondColor: Colors.blue,
      thirdColor: Colors.red,
      primaryIndex: 1, // 預設「從袋子移除」為主要操作
    );
  }
}