# 分支合併工作流程

## 目前狀況
- **在家分支**: `inhome` (基於 `removed-unused-code`)
- **公司分支**: `removed-unused-code` (有未push的training重構)
- **避免衝突**: inhome分支避開training相關功能

## 到公司後的操作步驟

### 第一步：推送公司的training修改
```bash
# 確保在removed-unused-code分支
git checkout removed-unused-code

# 檢查狀態
git status

# 推送公司的training修改到遠端
git push origin removed-unused-code
```

### 第二步：獲取家裡的工作
```bash
# 從遠端獲取inhome分支的最新內容
git fetch origin inhome

# 或者直接pull (如果本地沒有inhome分支)
git pull origin inhome
```

### 第三步：合併兩邊的工作
```bash
# 確保在removed-unused-code分支
git checkout removed-unused-code

# 合併inhome分支的修改
git merge inhome

# 如果有衝突，解決後：
# git add .
# git commit
```

### 第四步：清理和推送
```bash
# 推送合併後的結果
git push origin removed-unused-code

# 可選：刪除inhome分支 (如果不再需要)
git branch -d inhome
git push origin --delete inhome
```

## 衝突處理

如果出現合併衝突：

1. **查看衝突文件**:
   ```bash
   git status
   ```

2. **手動編輯衝突文件**:
   - 尋找 `<<<<<<<`, `=======`, `>>>>>>>>` 標記
   - 選擇保留哪個版本或合併兩個版本
   - 刪除衝突標記

3. **完成合併**:
   ```bash
   git add .
   git commit
   ```

## 注意事項
- 合併前先備份重要修改
- 如果不確定，可以先創建備份分支
- VS Code提供良好的衝突解決界面
- 測試合併後的功能是否正常運作

---
*創建時間: 2025-09-13*
*當前分支狀態: inhome (已創建並切換)*