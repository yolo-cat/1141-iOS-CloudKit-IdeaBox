# Copilot 指令（IdeaBox 專案）

> Copilot 必須一律以台灣正體中文回答所有問題與程式碼註解。

## 專案背景

**IdeaBox** 是一款原生 iOS 應用程式（iOS 26+，Swift 6.2，SwiftUI），用於捕捉與管理想法。程式碼庫強調**現代 SwiftUI 模式**、**液態玻璃視覺設計**，並且從第一天起即支援**台灣正體中文本地化**。

**治理規範**：請參考 `.specify/memory/constitution.md`（v1.2.0），內含 7 項具約束力的開發原則，優先於其他建議。

---

## 架構總覽

### 元件結構
```
IdeaBox/
├── IdeaBoxApp.swift         # @main 進入點；初始化 TabView 協調器
├── ContentView.swift        # 根視圖：三分頁 TabView（全部／搜尋／已完成）
├── Models/Idea.swift        # 資料模型＋模擬資料（7 筆範例）
└── Views/
    ├── AllIdeasView.swift      # 全部想法列表（有狀態）
    ├── SearchView.swift        # 搜尋分頁，支援即時篩選＋空狀態
    ├── CompletedIdeasView.swift # 已完成想法分頁
    ├── IdeaRow.swift           # 單一想法卡片（核取方塊、標題、描述）
    └── AddIdeaSheet.swift      # 新增想法表單（標題必填，描述選填）
```

### 資料流原則
- **視圖**：僅負責 UI 呈現；狀態透過 `@Binding` 傳遞
- **模型**：`Idea` 結構體（`Identifiable`，無持久化邏輯）
- **狀態**：由父視圖（如 `ContentView`）管理；UI 元件檔案不得持有狀態
- **模擬資料**：集中於 `Idea.swift`，可隨時替換為 `@State` 或 SwiftData，無需修改視圖

**設計模式**：視圖僅負責顯示，透過 `@Binding` 接收資料與回呼。各視圖檔案間不得直接相依。

---

## 關鍵開發流程

### 建置與執行
```bash
# 模擬器除錯
xcodebuild -project IdeaBox.xcodeproj -scheme IdeaBox build
# 或在 Xcode：Cmd+B，然後 Cmd+R

# 執行所有測試
xcodebuild test -project IdeaBox.xcodeproj -scheme IdeaBox \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

### 測試規範（不可協商）
- **驗收測試**：所有使用者功能必須先寫測試，驗證失敗後再實作
- **單元測試**：強烈建議針對 `Idea` 模型及未來服務
- **模式**：父視圖用 `@State`，子視圖用 `@Binding`，測試時驗證狀態變化

範例：測試「核取方塊切換」功能：
```swift
// 測試：驗證 idea.isCompleted 狀態切換
// 實作：視圖點擊核取方塊時呼叫 binding handler
@State var idea: Idea
toggle(idea)  // 狀態更新
XCTAssertTrue(idea.isCompleted)
```

---

## 程式碼模式與慣例

### 現代 SwiftUI API（強制）
- ✅ **必須使用**：`@Observable`、`NavigationStack`、`foregroundStyle()`、雙參數 `onChange(of:)`
- ❌ **禁止使用**：`ObservableObject`、`@Published`、`NavigationView`、`foregroundColor()`、`onReceive`

範例：
```swift
// 正確
struct IdeaListView: View {
    @State var ideas: [Idea] = mockIdeas
    var body: some View {
        NavigationStack {
            List {
                ForEach($ideas) { $idea in
                    IdeaRow(idea: $idea)
                }
            }
        }
    }
}

// 錯誤 - 使用 NavigationView
NavigationView { ... }
```

### 液態玻璃材質（必須）
所有卡片、表單、容器皆須套用液態玻璃材質，且必須在容器層級設定：
```swift
// 正確 - 材質套用於容器
VStack { ... }
    .frame(maxWidth: .infinity)
    .background(.ultraThinMaterial)  // 或 .thin, .regular

// 錯誤 - 未套用材質
VStack { ... }
    .background(Color.white)
```

材質選擇（`.ultraThin`、`.thin`、`.regular`）必須在程式碼註解中說明視覺層級。

### 台灣本地化（從第一天起）
- **所有使用者文字**：必須用 `String(localized:)` 或 `.stringdict`
- **日期／數字**：用 `Locale(identifier: "zh-Hant-TW")`
- **UI 禁止硬編碼英文**

```swift
// 正確
Text(String(localized: "新增想法"))  // 已本地化字串

// 錯誤
Text("Add Idea")  // 英文硬編碼
```

### 檔案組織
- **一檔一主視圖**：如 `IdeaRow.swift` 僅含 `IdeaRow` 視圖
- **相關元件**：緊密相關元件可同檔
- **模型分離**：資料邏輯不得混入視圖

---

## 整合點與外部相依

### 狀態管理階段
- **第一階段（現行）**：`Idea.swift` 模擬資料
- **第二階段（下一步）**：`ContentView` 用 `@State` 取代模擬資料（視圖不需改動）
- **第三階段**：SwiftData 持久化（服務層新增；視圖不變）
- **第四階段**：CloudKit 雲端同步（背景層；維持相同視圖 API）

### 持久化架構（規劃中）
- `Idea` 模型設計為**持久化無關**
- 服務層抽象儲存（模擬 → 記憶體 → SwiftData → CloudKit）
- 視圖僅透過 `@Binding` 接收資料，禁止直接呼叫儲存 API

---

## 專案慣例

### TabView 寫法
使用 iOS 26+ 新 Tab 語法（禁止用 `.tabItem`）：
```swift
TabView {
    AllIdeasView(ideas: $ideas)
        .tab("全部想法", systemImage: "list.bullet")
    
    SearchView(ideas: $ideas)
        .tab("搜尋", systemImage: "magnifyingglass", role: .search)
    
    CompletedIdeasView(ideas: completedIdeas)
        .tab("已完成", systemImage: "checkmark.circle")
}
```

### 空狀態
- 搜尋無結果用 `ContentUnavailableView` 並設 `.search` 角色
- 列表無資料用 `ContentUnavailableView`

### Binding 傳遞
狀態僅能由父視圖用 `@Binding` 傳給子視圖，不可跨檔案傳遞：
```swift
@State var ideas: [Idea] = mockIdeas

IdeaRow(idea: $ideas[index])  // 傳遞 binding 給子元件
```

---

## 重要檔案參考

| 檔案 | 用途 | 編輯時機 |
|------|------|----------|
| `Idea.swift` | 資料模型＋模擬資料 | 新增欄位、更新範例資料 |
| `IdeaRow.swift` | 單一想法卡片 | 調整排版、加視覺效果 |
| `AddIdeaSheet.swift` | 新增想法表單 | 驗證欄位、加約束 |
| `.specify/memory/constitution.md` | 治理規則 | 未經團隊共識不得修改 |

---

## 不可協商限制

1. **僅限 SwiftUI**：禁止 UIKit、`UIViewRepresentable`（除非技術上不可避免）
2. **液態玻璃**：所有容器必須用材質效果，禁止純色
3. **本地化**：所有字串必須本地化，硬編碼英文會被拒絕
4. **測試優先**：驗收測試必須先寫，未通過不得合併
5. **Speckit 語言**：所有規劃、規格、任務文件必須用台灣正體中文（`.specify/` 目錄）

---

## 常見問題／參考

- **架構決策**：見 `.specify/memory/constitution.md`（原則 I–VII）
- **產品需求**：見 `PRD.md`（MVP 功能、設計原則）
- **建置與測試**：見 `CLAUDE.md`（指令、測試說明）
- **目前進度**：見 `TODO.md`（已完成項目、下一步）

---

**最後更新**：2025-11-04  
**憲法版本**：v1.2.0  
**Speckit 狀態**：001-swiftdata-icloud 功能分支（規劃中）
