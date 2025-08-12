# My Arsenal — Game Used 設計規格（Instance-based）

更新日期：2025-08-12

## 目標
- 以「球的實例」為單位計數使用次數，避免刪除後再加入同款時產生歷史混淆。
- 保留完整歷史（比賽/練習使用紀錄），同時讓 UI 呈現清楚一致。

---

## 核心原則
1) 計數單位是 `user_arsenal_instance.id`（以下稱「實例」），不是 `ball_id`（球款）。
2) 刪除實例後不延續其使用次數；之後加入同款會產生「新實例」，`games_used` 從 0 開始。
3) 歷史紀錄永遠保留，可選擇顯示「同款總歷史」（以 `user_id+ball_id` 聚合），但不影響單實例計數。

---

## 資料模型

### 既有
- `user_arsenal`（對應 App 模型 `UserArsenalInstance`）
  - 主鍵：`id`
  - 欄位（節錄）：`user_id`, `ball_id`, `bag_1..bag_9`, `games_used`, `has_layout`, `notes`, `added_date`

### 新增
- `game_ball_usage`（一場比賽或練習中使用了哪顆球的哪個「實例」）
  - `usage_id` (PK)
  - `user_id` (FK → profiles)
  - `game_id` (FK → games 或 tournaments 的場次/局次 id)
  - `arsenal_instance_id` (FK → user_arsenal.id) 允許為 NULL（當實例被刪除後保留歷史）
  - `ball_id`（冗餘存球款，便於在實例刪除後仍可顯示歷史）
  - `frames_used`（可選：此局/場中使用的 frame 數量）
  - `created_at`

索引建議：`(user_id, game_id)`, `(user_id, arsenal_instance_id)`, `(user_id, ball_id)`。

---

## 寫入流程（Training/Tournament）
1) 使用者於建立/編輯「一局/一場」時選擇所用球的「實例」。
2) 每保存一局：
   - 新增一筆 `game_ball_usage`（`user_id`, `game_id`, `arsenal_instance_id`, `ball_id`, `frames_used`）。
   - 同步更新快取：`UPDATE user_arsenal SET games_used = games_used + 1 WHERE id = :arsenal_instance_id`。
   - 若同一局使用多顆球，可新增多筆 `usage`。

備註：若想避免同步更新，可改成查詢聚合（以 `COUNT(*)` 由 `game_ball_usage` 計算），但 UI 需以快取與查詢一致性折衝。

---

## 刪除與重加行為
- 刪除實例（賣掉/處理掉）：
  - 推薦「軟刪」：`user_arsenal.is_active=false, deleted_at=NOW()`；UI 不再顯示於 My Arsenal。
  - 不論軟刪或真刪，`game_ball_usage` 一律保留；若真刪，將 `arsenal_instance_id` 設為 NULL，但保留 `ball_id`。
- 重新加入同款：
  - 建立新 `user_arsenal` 實例，`games_used=0`，不承接舊實例歷史。
  - 歷史頁若要顯示「同款總歷史」，以 `user_id+ball_id` 聚合呈現為額外資訊（不影響新實例的 `games_used`）。

---

## 查詢介面（UI/服務層）
- 「此實例的使用次數」：
  - 直接讀 `user_arsenal.games_used`（或即時計算 `COUNT(game_ball_usage WHERE arsenal_instance_id=...)`）。
- 「此實例的使用紀錄列表」：
  - `SELECT * FROM game_ball_usage WHERE user_id=:u AND arsenal_instance_id=:iid ORDER BY created_at DESC`。
- 「同款總歷史（可選）」：
  - `SELECT COUNT(*) FROM game_ball_usage WHERE user_id=:u AND ball_id=:ball`。

---

## UI 規則（重點）
- Game Used 的文案需說明：「以這顆球的當前實例為準；刪除後再加入同款視為新實例。」
- 在詳細頁提供「查看此實例歷史」；可選地提供「查看同款總歷史」。
- 刪除實例後，歷史頁面仍可查到其過往（以 `ball_id` 顯示名稱，並標示『已不在 My Arsenal』）。

---

## 邊界與一致性
- 同一局可記錄多顆球（多筆 `usage`）。
- 移動球至不同子袋不影響 `games_used`（計數與袋關聯無關）。
- 若使用聚合計算而非同步加總，需留意多端並發的最終一致；建議保留 `games_used` 快取欄位以優化讀取。

---

## 後續工作（漸進式）
1) 建表 `game_ball_usage` 與索引。
2) Training/Tournament 保存流程寫入 `usage` 與同步 `games_used`。
3) Arsenal 詳細頁加入「此實例歷史」入口；（可選）加入「同款總歷史」。
4) 刪除流程改為軟刪或保留歷史關聯的真刪策略。

---

## 簡易偽代碼
```dart
// 保存一局時
for (final instanceId in selectedInstanceIds) {
  await supabase.from('game_ball_usage').insert({
    'user_id': userId,
    'game_id': gameId,
    'arsenal_instance_id': instanceId,
    'ball_id': instanceIdToBallId[instanceId],
    'frames_used': framesUsed,
  });
  await supabase.from('user_arsenal')
    .update({'games_used': sql('games_used + 1')})
    .eq('id', instanceId);
}
```

---

## 決策摘要
- 計數維度：實例級（不回溯，不合併）。
- 歷史保留：永遠保留 usage；刪除實例後以 `ball_id` 回顯必要資訊。
- UI 說明：明確提示 Game Used 的定義與同款歷史的額外性。
