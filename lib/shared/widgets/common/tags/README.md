# OvalTag Widget

通用橢圓標籤組件，提供與 arsenal scrollable bar 標籤一致的視覺風格。

## 使用方式

### 基本用法
```dart
import 'package:bowlingarsenal_app/shared/widgets/common/tags/oval_tag.dart';

OvalTag(
  text: 'Add from Favorite',
  color: theme.colorScheme.secondary,
  onTap: () {
    // 點擊處理
  },
)
```

### 自定義樣式
```dart
OvalTag(
  text: 'Custom Tag',
  color: Colors.blue,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  horizontalPadding: 16,
  verticalPadding: 8,
  borderWidth: 2.0,
  backgroundOpacity: 0.15,
  onTap: () {
    // 點擊處理
  },
)
```

## 參數說明

- `text`: 標籤顯示的文字
- `color`: 標籤顏色（用於文字、邊框和背景）
- `onTap`: 點擊回調（可選）
- `fontSize`: 字體大小（預設 13）
- `fontWeight`: 字體粗細（預設 FontWeight.w600）
- `horizontalPadding`: 水平內邊距（預設 12）
- `verticalPadding`: 垂直內邊距（預設 6）
- `borderWidth`: 邊框寬度（預設 1.5）
- `backgroundOpacity`: 背景透明度（預設 0.1）

## 設計規範

此組件遵循 arsenal scrollable bar 標籤的視覺規範：
- 20 圓角邊框
- 1.5 寬度邊框
- 10% 透明度背景
- 文字與邊框同色
- 標準內邊距和字體大小