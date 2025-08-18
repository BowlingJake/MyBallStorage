import 'package:flutter/material.dart';

/// 選擇器配置類
/// 定義選擇器的外觀和行為
class SelectorConfig {
  /// 對話框標題
  final String title;
  
  /// 搜尋欄提示文字
  final String searchHint;
  
  /// 選擇器按鈕提示文字
  final String buttonHint;
  
  /// 是否顯示搜尋欄
  final bool showSearch;
  
  /// 是否顯示結果計數
  final bool showResultCount;
  
  /// 是否支援分組顯示
  final bool showGroups;
  
  /// 是否顯示清除按鈕
  final bool showClearButton;
  
  /// 最大高度比例（相對於螢幕高度）
  final double maxHeightRatio;
  
  /// 自訂空狀態顯示
  final Widget? customEmptyWidget;
  
  /// 自訂載入中顯示
  final Widget? customLoadingWidget;
  
  /// 項目之間的分隔線
  final Widget? itemDivider;
  
  /// 選中項目的自訂樣式
  final TextStyle? selectedItemStyle;
  
  /// 未選中項目的自訂樣式
  final TextStyle? unselectedItemStyle;
  
  /// 自訂搜尋過濾邏輯
  final bool Function(String query, dynamic item)? customSearchFilter;
  
  /// 自訂排序邏輯
  final int Function(dynamic a, dynamic b)? customSortComparator;

  const SelectorConfig({
    required this.title,
    this.searchHint = 'Search...',
    this.buttonHint = 'Select an option',
    this.showSearch = true,
    this.showResultCount = true,
    this.showGroups = false,
    this.showClearButton = true,
    this.maxHeightRatio = 0.8,
    this.customEmptyWidget,
    this.customLoadingWidget,
    this.itemDivider,
    this.selectedItemStyle,
    this.unselectedItemStyle,
    this.customSearchFilter,
    this.customSortComparator,
  });

  /// 國家選擇器的預設配置
  static const SelectorConfig country = SelectorConfig(
    title: 'Select Country',
    searchHint: 'Search countries...',
    buttonHint: 'Select Country',
    showSearch: true,
    showResultCount: true,
    showGroups: false,
    maxHeightRatio: 0.85,
  );

  /// 語言選擇器的預設配置
  static const SelectorConfig language = SelectorConfig(
    title: 'Select Language',
    searchHint: 'Search languages...',
    buttonHint: 'Select Language',
    showSearch: true,
    showResultCount: false,
    showGroups: true,
    maxHeightRatio: 0.7,
  );

  /// 簡單選擇器的預設配置
  static const SelectorConfig simple = SelectorConfig(
    title: 'Select Option',
    searchHint: 'Search...',
    buttonHint: 'Select an option',
    showSearch: false,
    showResultCount: false,
    showGroups: false,
    maxHeightRatio: 0.6,
  );

  /// 大量選項選擇器的預設配置
  static const SelectorConfig bulk = SelectorConfig(
    title: 'Select Option',
    searchHint: 'Search...',
    buttonHint: 'Select an option',
    showSearch: true,
    showResultCount: true,
    showGroups: true,
    maxHeightRatio: 0.9,
  );

  /// 創建自訂配置的拷貝
  SelectorConfig copyWith({
    String? title,
    String? searchHint,
    String? buttonHint,
    bool? showSearch,
    bool? showResultCount,
    bool? showGroups,
    bool? showClearButton,
    double? maxHeightRatio,
    Widget? customEmptyWidget,
    Widget? customLoadingWidget,
    Widget? itemDivider,
    TextStyle? selectedItemStyle,
    TextStyle? unselectedItemStyle,
    bool Function(String query, dynamic item)? customSearchFilter,
    int Function(dynamic a, dynamic b)? customSortComparator,
  }) {
    return SelectorConfig(
      title: title ?? this.title,
      searchHint: searchHint ?? this.searchHint,
      buttonHint: buttonHint ?? this.buttonHint,
      showSearch: showSearch ?? this.showSearch,
      showResultCount: showResultCount ?? this.showResultCount,
      showGroups: showGroups ?? this.showGroups,
      showClearButton: showClearButton ?? this.showClearButton,
      maxHeightRatio: maxHeightRatio ?? this.maxHeightRatio,
      customEmptyWidget: customEmptyWidget ?? this.customEmptyWidget,
      customLoadingWidget: customLoadingWidget ?? this.customLoadingWidget,
      itemDivider: itemDivider ?? this.itemDivider,
      selectedItemStyle: selectedItemStyle ?? this.selectedItemStyle,
      unselectedItemStyle: unselectedItemStyle ?? this.unselectedItemStyle,
      customSearchFilter: customSearchFilter ?? this.customSearchFilter,
      customSortComparator: customSortComparator ?? this.customSortComparator,
    );
  }
}