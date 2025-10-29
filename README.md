# IdeaBox

IdeaBox 是一款以 SwiftUI 打造的 iOS 應用程式，提供快速、簡單的靈感紀錄體驗。專案遵循正體中文文件與測試優先原則，確保每次迭代都具備穩定品質與清晰結構。

## SpecKit 活動紀錄

### 1. 執行 `/speckit.constitution` 工作流，制定《IdeaBox 憲章》v1.0.0，並同步更新 SpecKit 計畫、規格、任務、檢查清單模板以符合新原則。

```
/speckit.constitution
建立簡單易用的 iOS App，需要可測試，資料夾結構分明，減少單一文件的程式碼行數，在程式中附帶註解，使用正體中文
```

### 2. 執行 `/speckit.specify` 建立「雲端同步與排序體驗」規格，分支 `001-sync-ideas-cloud`。

```
/speckit.specify
收集並儲存 Ideas 到數據庫中，並能同步至雲端
可以在多個個人設備中共享
Ideas 有不同的排序方式，例如按照建立日期、修改日期、英文字母、或可自行拖拉調整
一但進行拖拉，便會覆蓋之前的自定義排序
將會使用第三方程式碼庫提供額外功能
建立本地提醒功能，每天給予一個提示
```

### 3. 執行 `/speckit.plan` 為「雲端同步與排序體驗」制定實作計畫，運用 SwiftData with iCloud、AppStorage 通知設定以及 Swift Testing 覆蓋策略。

```
/speckit.plan
使用 SwiftData with iCloud
使用預設的 SwiftUI Drag & Drop
如通過拖拉觸發切換排序方式至自定義時，需要先由彈窗提醒
有機會使用 Pointfree 提供的第三方庫，如 Navigation 及 Dependencies
Search for SwiftData + CloudKit
No need to manage user sync profile manually, let SwiftData do the work
Use local notifications without maintaining ReminderSchedule table
Remove sortGroupToken and syncState related properties as SwiftData will take care of them
```