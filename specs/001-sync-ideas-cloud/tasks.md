# Tasks: 雲端同步與排序體驗

**Input**: Documentation in `/specs/001-sync-ideas-cloud/`
**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/`

## Phase 1: Setup (Shared Infrastructure)

- [ ] T001 [P] [SETUP] 建立並提交新的資料夾與群組：`IdeaBox/Services/Sync`, `IdeaBox/Services/Reminders`, `IdeaBox/Features/IdeaSorting`, `IdeaBox/Views/IdeaList`, `IdeaBox/Views/Components`, `IdeaBox/Shared/Localization`，同步更新 `IdeaBox.xcodeproj/project.pbxproj` 以符合計畫結構。
- [ ] T002 [P] [SETUP] 透過 Swift Package Manager 將 `pointfreeco/swift-dependencies`（與必要時的 `pointfreeco/swiftui-navigation`）加入 `IdeaBox.xcodeproj/project.pbxproj`，更新 `Package.resolved` 以鎖定版本並確保專案可編譯。
- [ ] T003 [SETUP] 在 `IdeaBox.xcodeproj/project.pbxproj` 啟用 iCloud (CloudKit) 與 Push Notifications 能力，必要時建立 `IdeaBox/IdeaBox.entitlements` 以指向正確的 CloudKit container。

## Phase 2: Foundational (Blocking Prerequisites)

- [ ] T010 [FOUND] 將 `IdeaBox/Models/Idea.swift` 轉換為 SwiftData `@Model`，按照 `data-model.md` 增加 `detail`, `createdAt`, `updatedAt`, `customOrderIndex`, `lastSyncedAt`, `lastSyncError` 欄位並移除舊的 `description`/`isCompleted` 狀態。
- [ ] T011 [FOUND] 更新 `IdeaBox/IdeaBoxApp.swift` 以建立指向共用 CloudKit container 的 `ModelContainer`，並透過 `@Environment(\.modelContext)` 或依賴注入提供給整體 App。
- [ ] T012 [FOUND] 調整 `IdeaBox/ContentView.swift` 與 `IdeaBox/Views/AllIdeasView.swift` 使用 SwiftData 的 `@Query` 與 `ModelContext` 讀寫 `Idea`，替換原本的本地陣列狀態與 mock 資料。
- [ ] T013 [FOUND] 建立 `IdeaBox/Shared/Localization/zh-Hant.strings` 並加入同步錯誤、排序提醒、通知授權等基礎字串，以便後續故事直接使用正體中文文案。

## Phase 3: User Story 1 – 多裝置同步想法 (Priority: P1)

**Independent Test**: `IdeaBoxTests/SyncCloudTests.swift`, `IdeaBoxUITests/SyncCloudUITests.swift`

- [ ] T101 [P] [US1] 先撰寫 Swift Testing：在 `IdeaBoxTests/Sync/SyncCloudTests.swift` 模擬離線新增、雙裝置變更與錯誤回報，確保測試初期失敗。
- [ ] T102 [P] [US1] 先撰寫 UI 測試：在 `IdeaBoxUITests/SyncCloudUITests.swift` 建立跨裝置同步情境與狀態提示流程，確保測試初期失敗。
- [ ] T103 [US1] 實作 `IdeaBox/Services/Sync/CloudSyncCoordinator.swift`，運用 SwiftData 變更佇列與時間戳處理上行／下行同步與錯誤紀錄。
- [ ] T104 [US1] 建立 `IdeaBox/Services/Sync/IdeaSyncService.swift`，封裝同步觸發、重試排程與依賴注入（整合 `swift-dependencies`）。
- [ ] T105 [US1] 建立 `IdeaBox/Services/Sync/SyncStatusPresenter.swift` 以產出同步狀態與錯誤訊息，並確保可在 SwiftUI 檢視中監聽更新。
- [ ] T106 [US1] 將同步服務整合至 `IdeaBox/ContentView.swift` 與 `IdeaBox/Views/IdeaList/IdeaListView.swift`，在清單頂部顯示同步狀態並於網路恢復時觸發重新整理。
- [ ] T107 [US1] 擴充 `IdeaBox/Models/Idea.swift` 或相關延伸，確保 `lastSyncedAt` 與 `lastSyncError` 可透過 SwiftData metadata 映射並在 UI 顯示最新狀態。

## Phase 4: User Story 2 – 彈性排序控管 (Priority: P2)

**Independent Test**: `IdeaBoxTests/Sorting/IdeaSortingTests.swift`, `IdeaBoxUITests/IdeaSortingUITests.swift`

- [ ] T201 [P] [US2] 先撰寫 Swift Testing：在 `IdeaBoxTests/Sorting/IdeaSortingTests.swift` 驗證建立／更新／字母／自訂排序邏輯與覆蓋行為，確保測試初期失敗。
- [ ] T202 [P] [US2] 先撰寫 UI 測試：在 `IdeaBoxUITests/IdeaSortingUITests.swift` 模擬排序切換與拖拉手勢，確保測試初期失敗。
- [ ] T203 [US2] 建立 `IdeaBox/Features/IdeaSorting/IdeaSortingViewModel.swift`，提供排序模式狀態與資料來源轉換，支援依賴注入以利測試。
- [ ] T204 [US2] 建立 `IdeaBox/Features/IdeaSorting/DragDropHandler.swift`，計算 `customOrderIndex` 的插入值並更新 SwiftData。
- [ ] T205 [US2] 建置 `IdeaBox/Views/Components/SortPicker.swift`，提供正體中文排序選單並觸發模式切換。
- [ ] T206 [US2] 更新 `IdeaBox/Views/IdeaList/IdeaListView.swift` 以整合排序 ViewModel、顯示彈窗確認自訂排序、啟用 `.onMove` 拖拉並同步 `customOrderIndex`。

## Phase 5: User Story 3 – 每日提醒靈感 (Priority: P3)

**Independent Test**: `IdeaBoxTests/Reminders/DailyReminderTests.swift`, `IdeaBoxUITests/DailyReminderUITests.swift`

- [ ] T301 [P] [US3] 先撰寫 Swift Testing：在 `IdeaBoxTests/Reminders/DailyReminderTests.swift` 構建提醒授權、排程與停用情境測試，確保測試初期失敗。
- [ ] T302 [P] [US3] 先撰寫 UI 測試：在 `IdeaBoxUITests/DailyReminderUITests.swift` 模擬提醒設定流程與通知呈現檢查，確保測試初期失敗。
- [ ] T303 [US3] 實作 `IdeaBox/Services/Reminders/ReminderAuthorizationService.swift`，封裝通知授權、設定檢查與錯誤回報。
- [ ] T304 [US3] 實作 `IdeaBox/Services/Reminders/ReminderScheduler.swift`，使用 `AppStorage`／UserDefaults 儲存設定並安排每日 `UNCalendarNotificationTrigger`。
- [ ] T305 [US3] 建立 `IdeaBox/Views/Components/ReminderSettingsView.swift`（或等效設定檢視），提供使用者啟用／停用提醒與時間、訊息輸入。
- [ ] T306 [US3] 將提醒服務整合至 `IdeaBox/ContentView.swift` 或對應設定入口，顯示最近提醒狀態並與同步資訊相容。

## Phase 6: Polish & Cross-Cutting Concerns

- [ ] T401 [P] [POLISH] 更新 `IdeaBox/Shared/Localization/zh-Hant.strings` 與 `IdeaBox/Assets.xcassets` 需要的文案或圖示，完成最終文字校對。
- [ ] T402 [POLISH] 依 `quickstart.md` 驗證流程（啟用 iCloud、執行同步、觸發提醒），並於 `README.md` 或 `specs/001-sync-ideas-cloud/quickstart.md` 補述實際注意事項。
- [ ] T403 [POLISH] 執行並記錄 Swift Testing 與 UI 測試覆蓋率結果，確保 P1/P2/P3 故事測試達到規範後提交結案報告。
