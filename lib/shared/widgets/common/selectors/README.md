# 通用選擇器架構使用指南

## 🎯 概述

這個通用選擇器架構提供了一套完整的解決方案，用於創建各種類型的選擇器組件。支援搜尋、分組、自訂樣式等高級功能。

## 🏗️ 架構組成

### 1. 核心介面
- `SelectableItem<T>` - 所有選擇項目必須實現的介面
- `SelectorConfig` - 選擇器配置類

### 2. 通用組件
- `UniversalSelector<T>` - 終極通用選擇器
- 各種預設配置 (`SelectorConfig.country`, `SelectorConfig.language` 等)

### 3. 專用選擇器
- `CountrySelectorV2` - 國家選擇器
- `LanguageSelector` - 語言選擇器  
- `CurrencySelector` - 貨幣選擇器
- `TimezoneSelector` - 時區選擇器

## 🚀 快速開始

### 基本用法

```dart
// 使用預設的國家選擇器
CountrySelectorV2(
  selectedCountry: selectedCountry,
  onChanged: (country) => setState(() => selectedCountry = country),
)

// 帶分組的國家選擇器
CountrySelectorV2(
  selectedCountry: selectedCountry,
  onChanged: (country) => setState(() => selectedCountry = country),
  showGroups: true,
)
```

### 創建自訂選擇器

#### 步驟 1: 創建數據模型

```dart
class ColorItem implements SelectableItem<String> {
  final String code;
  final String name;
  final Color color;

  const ColorItem(this.code, this.name, this.color);

  @override
  String get value => code;

  @override
  String get displayText => name;

  @override
  String get searchText => '$name $code';

  @override
  Widget? get leadingWidget => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );

  @override
  String? get subtitle => code;

  // ... 其他必要屬性
}
```

#### 步驟 2: 創建選擇器組件

```dart
class ColorSelector extends StatelessWidget {
  final String? selectedColor;
  final ValueChanged<String?>? onChanged;

  const ColorSelector({
    super.key,
    this.selectedColor,
    this.onChanged,
  });

  static final List<ColorItem> _colors = [
    ColorItem('red', 'Red', Colors.red),
    ColorItem('blue', 'Blue', Colors.blue),
    ColorItem('green', 'Green', Colors.green),
    // ...
  ];

  @override
  Widget build(BuildContext context) {
    final config = SelectorConfig.simple.copyWith(
      title: 'Select Color',
      searchHint: 'Search colors...',
      buttonHint: 'Select a color',
    );

    return UniversalSelector<String>(
      selectedValue: selectedColor,
      items: _colors,
      onChanged: onChanged,
      config: config,
    );
  }
}
```

## ⚙️ 高級配置

### 自訂配置選項

```dart
final customConfig = SelectorConfig(
  title: 'Custom Selector',
  searchHint: 'Type to search...',
  buttonHint: 'Make a selection',
  showSearch: true,
  showResultCount: true,
  showGroups: true,
  showClearButton: true,
  maxHeightRatio: 0.8,
  customSearchFilter: (query, item) {
    // 自訂搜尋邏輯
    return item.searchText.toLowerCase().contains(query.toLowerCase());
  },
  customSortComparator: (a, b) {
    // 自訂排序邏輯
    return a.displayText.compareTo(b.displayText);
  },
);
```

### 分組顯示

```dart
class GroupedItem implements SelectableItem<String> {
  // ...

  @override
  String? get groupKey => 'category1'; // 分組識別

  @override
  String? get groupDisplayName => 'Category 1'; // 分組顯示名稱

  @override
  int get sortWeight => 0; // 排序權重
}
```

## 🎨 樣式自訂

### 自訂項目樣式

```dart
class StyledItem implements SelectableItem<String> {
  // ...

  @override
  TextStyle? get customTextStyle => TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget? get trailingWidget => Icon(Icons.star);
}
```

### 自訂配置樣式

```dart
final styledConfig = SelectorConfig.simple.copyWith(
  selectedItemStyle: TextStyle(
    color: Colors.gold,
    fontWeight: FontWeight.w600,
  ),
  unselectedItemStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
  ),
);
```

## 📱 預設選擇器

### 國家選擇器

```dart
// 基本國家選擇器
CountrySelectorV2(
  selectedCountry: country,
  onChanged: (country) => setCountry(country),
)

// 分組國家選擇器（按地區）
GroupedCountrySelectorV2(
  selectedCountry: country,
  onChanged: (country) => setCountry(country),
)

// 國家代碼選擇器（簡化版）
CountryCodeSelectorV2(
  selectedCountry: country,
  onChanged: (country) => setCountry(country),
)
```

### 其他選擇器

```dart
// 語言選擇器
LanguageSelector(
  selectedLanguage: language,
  onChanged: (lang) => setLanguage(lang),
)

// 貨幣選擇器
CurrencySelector(
  selectedCurrency: currency,
  onChanged: (curr) => setCurrency(curr),
)

// 時區選擇器
TimezoneSelector(
  selectedTimezone: timezone,
  onChanged: (tz) => setTimezone(tz),
)
```

## 🔧 最佳實踐

### 1. 數據結構設計
- 實現 `SelectableItem<T>` 介面
- 提供完整的搜尋關鍵詞
- 合理設置排序權重

### 2. 效能優化
- 使用 `ListView.builder` 進行虛擬化
- 避免在搜尋過濾中進行重複計算
- 適當使用分組來組織大量數據

### 3. 用戶體驗
- 提供清晰的搜尋提示
- 合理設置最大高度比例
- 提供適當的空狀態顯示

### 4. 可訪問性
- 提供語義化的標籤
- 支援鍵盤導航
- 確保足夠的顏色對比度

## 🎉 功能特色

- ✅ **完全可配置** - 外觀和行為都可自訂
- ✅ **支援搜尋** - 實時過濾，多關鍵詞搜尋
- ✅ **分組顯示** - 自動分組，層次清晰
- ✅ **虛擬化滾動** - 處理大量數據無卡頓
- ✅ **手機優化** - 觸控友好，響應式設計
- ✅ **型別安全** - 完整的 TypeScript 支援
- ✅ **可擴展** - 輕鬆添加新的選擇器類型
- ✅ **統一設計** - 符合 App 整體設計系統

這個架構讓你可以在幾分鐘內創建出專業級的選擇器組件！🚀