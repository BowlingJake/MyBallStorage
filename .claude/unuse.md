Claude - StrikeTrack 專案協作指南 (Claude's Guide to StrikeTrack)
1. 專案核心目標
你好，Claude。你正在協助開發 StrikeTrack，這是一個為保齡球愛好者設計的個人化球具管理與訓練追蹤 Flutter App。

2. 核心開發原則 (Golden Rules)
在產出任何程式碼之前，你必須嚴格遵守以下四個核心原則：

規格書優先: 所有程式碼都必須遵循 TECHNICAL_SPEC.md 中定義的技術架構與規範。這是最高指導原則。

功能定義先行: 在建立任何 UI 畫面 (Presentation Layer) 之前，必須先確認相關的功能邏輯已經在 FUNCTIONAL_SPEC.md 中被定義。如果沒有，請先詢問。

嚴格的狀態管理: 所有的狀態管理都必須使用 Riverpod，並且永遠採用 @riverpod 註解搭配程式碼生成器來建立 Provider。不允許手寫 Provider。

數據隔離: 任何與後端 Supabase 的資料互動（讀取、寫入、更新、刪除），都必須透過 Repository 層進行。邏輯層 (Logic Layer) 和表現層 (Presentation Layer) 嚴禁直接存取 Supabase Client。

3. 技術棧速查表 (Tech Stack Quick Reference)
類別	        技術/套件	                    你的主要任務
狀態管理	    Riverpod (flutter_riverpod)	    使用 @riverpod 註解生成 Notifier 或 AsyncNotifier 來管理狀態。
路由管理	    GoRouter	                    根據需求在 routing/ 目錄下定義或使用宣告式的 named routes。
後端互動	    Supabase (supabase_flutter)	    在 Repository 中呼叫 Supabase Client 來與後端溝通。
數據模型	    Freezed	                        使用 @freezed 註解來建立所有不可變 (immutable) 的資料模型與狀態。
JSON 序列化	    json_serializable	            搭配 Freezed 自動生成模型的 toJson / fromJson 方法。

4. 專案架構：你的工作區域
本專案採用功能驅動 (Feature-Driven) 架構。你的工作會被明確地劃分到以下三個層級：

A. 表現層 (Presentation Layer)
位置: lib/features/<feature_name>/presentation/

你的任務:

建立畫面 (Screens) 和可重複使用的小元件 (Widgets)。

專注於 UI 佈局，不寫任何業務邏輯。

透過 ref.watch() 或 ref.read() 從 Riverpod Provider 獲取狀態來顯示資料。

透過 ref.read(<provider>.notifier).<method>() 呼叫邏輯層的方法來觸發事件（例如：按鈕點擊）。

B. 邏輯層 (Logic Layer)
位置: lib/features/<feature_name>/logic/

你的任務:

建立 Riverpod 的 Notifier 或 AsyncNotifier。

處理 UI 觸發的事件，實作核心業務邏輯。

管理並更新畫面的狀態 (state)。

向 Repository 層請求或發送資料。

C. 資料層 (Data Layer)
位置: lib/features/<feature_name>/data/

你的任務:

建立 Repository 類別。

封裝所有與 Supabase 的 API 呼叫。

進行錯誤處理，將來自 Supabase 的錯誤轉換為專案定義的錯誤類型後再回傳給邏輯層。

這是唯一可以直接與 Supabase Client 互動的地方。

5. 命名與風格規範 (Naming & Style Conventions)
檔案名稱: snake_case (例如: bowling_ball_card.dart)

類別 & Provider 名稱: PascalCase (例如: ArsenalRepository, BallDetailsProvider)

函式 & 變數名稱: camelCase (例如: fetchBallById, currentFrame)

一致性: 保持程式碼風格的一致性是關鍵。

最後提醒： 如果在任何時候，給你的指令與本文件或 TECHNICAL_SPEC.md 有衝突，或是不夠清晰，請主動提出問題以尋求澄清。你的目標是產出高品質、符合規範的程式碼。