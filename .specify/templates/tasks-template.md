---

description: "功能實作的任務列表範本"
---

# 任務：[功能名稱]

**輸入**: 來自 `/specs/[###-feature-name]/` 的設計文件  
**前提條件**: plan.md (必填)、spec.md (使用者故事必填)、research.md、data-model.md、contracts/

**測試**: 下方範例包含測試任務。測試為選填 - 僅在功能規格中明確要求時才包含。

**組織**: 任務依使用者故事分組，以便獨立實作和測試每個故事。

> **⚠️ 重要**: 本文件必須使用台灣正體中文撰寫（符合憲法原則 VII）。所有任務描述、標題、組織說明均應使用繁體中文，確保團隊對實作流程的共同理解。

## 格式：`[ID] [P?] [Story] 描述`

- **[P]**: 可並行執行（不同檔案、無相依性）
- **[Story]**: 此任務屬於哪個使用者故事（例如 US1、US2、US3）
- 在描述中包含精確的檔案路徑

## 路徑約定

- **單一專案**: `src/`、`tests/` 於儲存庫根目錄
- **Web 應用**: `backend/src/`、`frontend/src/`
- **行動裝置**: `api/src/`、`ios/src/` 或 `android/src/`
- 下方路徑假設為單一專案 - 根據 plan.md 結構調整

<!-- 
  ============================================================================
  重要：下方任務僅為說明用途。
  
  /speckit.tasks 命令必須基於下列內容替換為實際任務：
  - spec.md 的使用者故事 (附其優先級 P1, P2, P3...)
  - plan.md 的功能需求
  - data-model.md 的實體
  - contracts/ 的端點
  
  任務必須依使用者故事組織，使每個故事可以：
  - 獨立實作
  - 獨立測試
  - 作為 MVP 增量獨立交付
  
  不要在最終 tasks.md 檔案中保留這些範例任務。
  ============================================================================
-->

## 第 1 階段：設定 (共享基礎架構)

**目的**: 專案初始化和基本結構

- [ ] T001 按照實作計畫建立專案結構
- [ ] T002 初始化 [語言] 專案及 [框架] 相依套件
- [ ] T003 [P] 配置 linting 和格式化工具

---

## 第 2 階段：基礎 (阻礙性前提條件)

**目的**: 任何使用者故事實作前必須完成的核心基礎架構

**⚠️ 重大**: 在此階段完成前無使用者故事工作可開始

基礎任務範例（根據專案調整）：

- [ ] T004 設定資料模型和相依框架
- [ ] T005 [P] 實作狀態管理框架
- [ ] T006 [P] 設定視圖層級和元件結構
- [ ] T007 建立所有故事依賴的基本模型/實體
- [ ] T008 配置錯誤處理和日誌基礎架構
- [ ] T009 設定環境組態管理

**檢查點**: 基礎準備好 - 使用者故事實作現可開始並行進行

---

## 第 3 階段：使用者故事 1 - [標題] (優先級: P1) 🎯 MVP

**目標**: [本故事交付內容簡述]

**獨立測試**: [如何驗證此故事獨立運作]

### 使用者故事 1 測試 (選填 - 僅在測試被明確要求時) ⚠️

> **備註：先寫這些測試，確保它們失敗再實作**

- [ ] T010 [P] [US1] [端點] 契約測試於 tests/contract/test_[name].swift
- [ ] T011 [P] [US1] [使用者旅程] 整合測試於 tests/integration/test_[name].swift

### 使用者故事 1 實作

- [ ] T012 [P] [US1] 於 IdeaBox/Models/[entity1].swift 建立 [Entity1] 模型
- [ ] T013 [P] [US1] 於 IdeaBox/Models/[entity2].swift 建立 [Entity2] 模型
- [ ] T014 [US1] 於 IdeaBox/Services/[service].swift 實作 [Service] (相依 T012、T013)
- [ ] T015 [US1] 於 IdeaBox/Views/[view].swift 實作 [視圖/功能]
- [ ] T016 [US1] 新增驗證和錯誤處理
- [ ] T017 [US1] 為使用者故事 1 操作新增日誌

**檢查點**: 此時使用者故事 1 應完全可運作且獨立可測試

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2 (OPTIONAL - only if tests requested) ⚠️

- [ ] T018 [P] [US2] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T019 [P] [US2] Integration test for [user journey] in tests/integration/test_[name].py

### Implementation for User Story 2

- [ ] T020 [P] [US2] Create [Entity] model in src/models/[entity].py
- [ ] T021 [US2] Implement [Service] in src/services/[service].py
- [ ] T022 [US2] Implement [endpoint/feature] in src/[location]/[file].py
- [ ] T023 [US2] Integrate with User Story 1 components (if needed)

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3 (OPTIONAL - only if tests requested) ⚠️

- [ ] T024 [P] [US3] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T025 [P] [US3] Integration test for [user journey] in tests/integration/test_[name].py

### Implementation for User Story 3

- [ ] T026 [P] [US3] Create [Entity] model in src/models/[entity].py
- [ ] T027 [US3] Implement [Service] in src/services/[service].py
- [ ] T028 [US3] Implement [endpoint/feature] in src/[location]/[file].py

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates in docs/
- [ ] TXXX Code cleanup and refactoring
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX [P] Additional unit tests (if requested) in tests/unit/
- [ ] TXXX Security hardening
- [ ] TXXX Run quickstart.md validation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together (if tests requested):
Task: "Contract test for [endpoint] in tests/contract/test_[name].py"
Task: "Integration test for [user journey] in tests/integration/test_[name].py"

# Launch all models for User Story 1 together:
Task: "Create [Entity1] model in src/models/[entity1].py"
Task: "Create [Entity2] model in src/models/[entity2].py"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
