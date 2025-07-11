# 🎳 Bowling Arsenal App

一個專為保齡球愛好者設計的綜合性球袋管理與訓練追蹤應用程式。透過科學化的數據分析，幫助業餘與職業球手優化球技表現。

[![Flutter CI](https://github.com/username/bowlingarsenal_app/workflows/Flutter%20CI/badge.svg)](https://github.com/username/bowlingarsenal_app/actions)
[![codecov](https://codecov.io/gh/username/bowlingarsenal_app/branch/main/graph/badge.svg)](https://codecov.io/gh/username/bowlingarsenal_app)
[![Flutter](https://img.shields.io/badge/Flutter-3.22.x-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)

## 🎯 專案定位

**Bowling Arsenal App** 是一個現代化的保齡球管理應用，提供：

- 📦 **球袋管理**：組織你的保齡球收藏，記錄球的規格與佈局
- 📊 **訓練追蹤**：記錄練習和比賽成績，分析進步趨勢
- 🎳 **球類庫**：瀏覽和搜尋各品牌保齡球的詳細規格
- 📈 **數據分析**：視覺化的成績統計和表現分析

### 目標族群
- 業餘保齡球愛好者
- 職業和半職業球手
- 保齡球教練
- 球館管理人員

## 🚀 快速開始

### 環境需求
- [Flutter](https://flutter.dev/docs/get-started/install) 3.22.x 或更高版本
- [Dart](https://dart.dev/get-dart) 3.0+ 
- Android Studio / VS Code
- 支持 Android 5.0+ 或 iOS 12.0+

### 安裝步驟

1. **克隆專案**
   ```bash
   git clone https://github.com/username/bowlingarsenal_app.git
   cd bowlingarsenal_app
   ```

2. **安裝依賴**
   ```bash
   flutter pub get
   ```

3. **生成代碼** (Freezed/JsonSerializable)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **運行應用**
   ```bash
   flutter run
   ```

### 推薦工具

如果使用 Flutter Version Management:
```bash
fvm use stable
fvm flutter pub get
fvm flutter run
```

## 🏗️ 技術棧

### 核心框架
- **[Flutter](https://flutter.dev/)** - 跨平台UI框架
- **[Dart](https://dart.dev/)** - 程式語言
- **[Riverpod](https://riverpod.dev/)** - 狀態管理
- **[go_router](https://pub.dev/packages/go_router)** - 導航路由

### 程式碼生成
- **[Freezed](https://pub.dev/packages/freezed)** - 不可變模型生成
- **[json_annotation](https://pub.dev/packages/json_annotation)** - JSON序列化
- **[build_runner](https://pub.dev/packages/build_runner)** - 代碼生成工具

### UI/UX
- **[Iconsax](https://pub.dev/packages/iconsax)** - 現代圖標庫
- **[fl_chart](https://pub.dev/packages/fl_chart)** - 圖表視覺化
- **[animated_text_kit](https://pub.dev/packages/animated_text_kit)** - 文字動畫

### 測試
- **[flutter_test](https://flutter.dev/docs/testing)** - 單元測試
- **[mocktail](https://pub.dev/packages/mocktail)** - Mock測試
- **[integration_test](https://flutter.dev/docs/testing/integration-tests)** - 整合測試

## 📁 專案架構

本專案採用 **Feature-First + Clean Architecture** 設計：

```
lib/
├── core/                   # 核心工具與錯誤處理
├── features/              # 功能模組
│   ├── arsenal/          # 球袋管理
│   │   ├── models/      # 資料模型
│   │   ├── repositories/ # 資料存取層
│   │   ├── providers/   # 狀態管理
│   │   ├── views/       # UI介面
│   │   └── widgets/     # 功能元件
│   ├── ball_library/    # 球類庫
│   ├── training/        # 訓練記錄
│   └── onboarding/      # 使用者引導
├── routing/              # 路由配置
├── shared/               # 共用元件
│   ├── models/          # 通用資料模型
│   ├── widgets/         # 共用UI元件
│   ├── providers/       # 全局狀態
│   └── services/        # 通用服務
└── theme/                # 主題配置
```

### 設計原則

1. **模組化**：每個功能獨立封裝
2. **可測試性**：透過Repository模式分離關注點
3. **不可變性**：使用Freezed確保資料不可變
4. **型別安全**：充分利用Dart的強型別系統

## 🧪 測試策略

### 測試層級

```bash
# 單元測試 - 快速回饋迴圈
flutter test test/routing/auth_guard_test.dart
flutter test test/features/ball_library/repositories/

# Widget測試 - UI邏輯驗證
flutter test test/widgets/

# 整合測試 - 端到端流程
flutter test integration_test/
```

### 測試覆蓋率

```bash
# 生成覆蓋率報告
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🔧 開發工具

### Git Hooks (推薦)

```bash
# 安裝 pre-commit
pip install pre-commit
pre-commit install

# 手動執行檢查
pre-commit run --all-files
```

### 程式碼品質

```bash
# 格式化程式碼
dart format .

# 靜態分析
flutter analyze

# 依賴檢查
flutter pub deps
```

## 🤝 貢獻指南

我們歡迎各種形式的貢獻！

### 分支策略

- `main` - 生產環境分支
- `develop` - 開發整合分支  
- `feature/*` - 功能開發分支
- `bugfix/*` - 錯誤修復分支

### Pull Request 流程

1. **Fork專案** 並創建功能分支
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **遵循規範**
   - 程式碼必須通過 `flutter analyze`
   - 新增功能需要包含測試
   - Commit message 遵循 [Conventional Commits](https://www.conventionalcommits.org/)

3. **提交 PR**
   - 描述清楚變更內容
   - 包含相關的截圖（如有UI變更）
   - 確保CI檢查通過

### 程式碼規範

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 風格指南
- 使用 [very_good_analysis](https://pub.dev/packages/very_good_analysis) 規則
- 每個public成員需要文檔註釋
- 優先使用 `const` 建構函式

## 📄 授權

本專案採用 [MIT License](LICENSE) 授權。

## 🎯 路線圖

### 近期目標 (v1.0)
- [ ] 基礎球袋管理功能
- [ ] 訓練記錄與統計
- [ ] 用戶認證系統
- [ ] 深色模式支援

### 中期目標 (v2.0)
- [ ] 雲端同步功能
- [ ] 社群分享功能
- [ ] 高級統計分析
- [ ] 多語言支援

### 長期目標 (v3.0+)
- [ ] AI輔助球局分析
- [ ] VR/AR球技訓練
- [ ] 專業教練功能
- [ ] 球館合作生態

## 📧 聯絡方式

- **專案維護者**: [您的名字](mailto:your.email@example.com)
- **Issue回報**: [GitHub Issues](https://github.com/username/bowlingarsenal_app/issues)
- **功能建議**: [Discussions](https://github.com/username/bowlingarsenal_app/discussions)

---

**用科技提升你的保齡球技藝！** 🎳✨
