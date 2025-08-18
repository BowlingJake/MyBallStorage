import 'package:flutter/material.dart';

/// 可選擇項目的通用介面
/// 所有用於選擇器的項目都應實現此介面
abstract class SelectableItem<T> {
  /// 項目的唯一值
  T get value;
  
  /// 顯示文字
  String get displayText;
  
  /// 用於搜尋的文字（包含所有可搜尋的關鍵詞）
  String get searchText;
  
  /// 可選的前置圖示（如國旗、圖標等）
  Widget? get leadingWidget => null;
  
  /// 可選的副標題文字
  String? get subtitle => null;
  
  /// 可選的尾隨圖示
  Widget? get trailingWidget => null;
  
  /// 自訂顯示樣式
  TextStyle? get customTextStyle => null;
  
  /// 是否啟用此項目
  bool get isEnabled => true;
  
  /// 項目分組（用於分組顯示）
  String? get groupKey => null;
  
  /// 分組顯示名稱
  String? get groupDisplayName => null;
  
  /// 排序權重（數字越小越靠前）
  int get sortWeight => 0;
}

/// 簡化的選擇項目實現
class SimpleSelectableItem<T> implements SelectableItem<T> {
  @override
  final T value;
  
  @override
  final String displayText;
  
  @override
  final String searchText;
  
  @override
  final Widget? leadingWidget;
  
  @override
  final String? subtitle;
  
  @override
  final Widget? trailingWidget;
  
  @override
  final TextStyle? customTextStyle;
  
  @override
  final bool isEnabled;
  
  @override
  final String? groupKey;
  
  @override
  final String? groupDisplayName;
  
  @override
  final int sortWeight;

  const SimpleSelectableItem({
    required this.value,
    required this.displayText,
    String? searchText,
    this.leadingWidget,
    this.subtitle,
    this.trailingWidget,
    this.customTextStyle,
    this.isEnabled = true,
    this.groupKey,
    this.groupDisplayName,
    this.sortWeight = 0,
  }) : searchText = searchText ?? displayText;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleSelectableItem &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}