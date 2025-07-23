# StrikeTrack 專案 AI 協作情境

## 專案目標
一個保齡球愛好者的個人化球具管理與訓練追蹤 App。

## 核心技術與架構
- **狀態管理:** Riverpod (使用 `@riverpod` 程式碼生成)
- **路由管理:** GoRouter (使用 named routes)
- **後端服務:** Supabase (Auth & Database)
- **數據模型:** Freezed
- **詳細規格:** 請參考 [docs/TECHNICAL_SPEC.md](docs/TECHNICAL_SPEC.md)

## 對 AI 的主要指令
1.  所有新產出的程式碼，必須嚴格遵守 `TECHNICAL_SPEC.md` 中的架構和規範。
2.  在產生任何 UI 畫面前，必須先確認對應的功能邏輯已在 `FUNCTIONAL_SPEC.md` 中被定義。
3.  所有 Riverpod Provider 必須使用程式碼生成的方式建立。
4.  所有與後端 Supabase 的互動，必須通過 Repository 層進行。