//
//  LocalPersistenceTests.swift
//  IdeaBoxTests
//
//  Created by Harry Ng on 10/30/25.
//

import Foundation
import Testing
import SwiftData
@testable import IdeaBox

@Suite("本地持久化測試")
@MainActor
struct LocalPersistenceTests {
    
    // Helper to create in-memory model container for testing
    func createTestContainer() throws -> ModelContainer {
        let schema = Schema([Idea.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }
    
    @Test("應該能夠插入新的 Idea 到 ModelContext")
    func testInsertIdea() throws {
        // Given
        let container = try createTestContainer()
        let context = container.mainContext
        let idea = Idea(title: "測試插入", detail: "這是一個插入測試")
        
        // When
        context.insert(idea)
        try context.save()
        
        // Then
        let descriptor = FetchDescriptor<Idea>()
        let ideas = try context.fetch(descriptor)
        #expect(ideas.count == 1)
        #expect(ideas.first?.title == "測試插入")
    }
    
    @Test("應該能夠查詢所有 Idea")
    func testFetchAllIdeas() throws {
        // Given
        let container = try createTestContainer()
        let context = container.mainContext
        
        let idea1 = Idea(title: "想法一")
        let idea2 = Idea(title: "想法二")
        let idea3 = Idea(title: "想法三")
        
        context.insert(idea1)
        context.insert(idea2)
        context.insert(idea3)
        try context.save()
        
        // When
        let descriptor = FetchDescriptor<Idea>()
        let ideas = try context.fetch(descriptor)
        
        // Then
        #expect(ideas.count == 3)
    }
    
    @Test("應該能夠更新現有的 Idea")
    func testUpdateIdea() throws {
        // Given
        let container = try createTestContainer()
        let context = container.mainContext
        let idea = Idea(title: "原始標題", detail: "原始描述")
        
        context.insert(idea)
        try context.save()
        
        // When
        idea.title = "更新標題"
        idea.detail = "更新描述"
        idea.updatedAt = Date()
        try context.save()
        
        // Then
        let descriptor = FetchDescriptor<Idea>()
        let ideas = try context.fetch(descriptor)
        #expect(ideas.first?.title == "更新標題")
        #expect(ideas.first?.detail == "更新描述")
    }
    
    @Test("應該能夠刪除 Idea")
    func testDeleteIdea() throws {
        // Given
        let container = try createTestContainer()
        let context = container.mainContext
        let idea = Idea(title: "待刪除想法")
        
        context.insert(idea)
        try context.save()
        
        // When
        context.delete(idea)
        try context.save()
        
        // Then
        let descriptor = FetchDescriptor<Idea>()
        let ideas = try context.fetch(descriptor)
        #expect(ideas.isEmpty)
    }
    
    @Test("應該能夠依照 createdAt 排序查詢 Idea")
    func testFetchIdeasSortedByCreatedAt() throws {
        // Given
        let container = try createTestContainer()
        let context = container.mainContext
        
        let idea1 = Idea(title: "第一個想法", createdAt: Date().addingTimeInterval(-100))
        let idea2 = Idea(title: "第二個想法", createdAt: Date().addingTimeInterval(-50))
        let idea3 = Idea(title: "第三個想法", createdAt: Date())
        
        context.insert(idea1)
        context.insert(idea2)
        context.insert(idea3)
        try context.save()
        
        // When
        let descriptor = FetchDescriptor<Idea>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let ideas = try context.fetch(descriptor)
        
        // Then
        #expect(ideas.count == 3)
        #expect(ideas[0].title == "第三個想法")
        #expect(ideas[1].title == "第二個想法")
        #expect(ideas[2].title == "第一個想法")
    }
    
    @Test("應該能夠篩選已完成的 Idea")
    func testFetchCompletedIdeas() throws {
        // Given
        let container = try createTestContainer()
        let context = container.mainContext
        
        let idea1 = Idea(title: "未完成想法", isCompleted: false)
        let idea2 = Idea(title: "已完成想法", isCompleted: true)
        let idea3 = Idea(title: "另一個已完成想法", isCompleted: true)
        
        context.insert(idea1)
        context.insert(idea2)
        context.insert(idea3)
        try context.save()
        
        // When
        let descriptor = FetchDescriptor<Idea>(
            predicate: #Predicate { $0.isCompleted == true }
        )
        let completedIdeas = try context.fetch(descriptor)
        
        // Then
        #expect(completedIdeas.count == 2)
        #expect(completedIdeas.allSatisfy { $0.isCompleted })
    }
    
    @Test("應該能夠搜尋 Idea 標題")
    func testSearchIdeasByTitle() throws {
        // Given
        let container = try createTestContainer()
        let context = container.mainContext
        
        let idea1 = Idea(title: "學習 SwiftUI")
        let idea2 = Idea(title: "學習 SwiftData")
        let idea3 = Idea(title: "閱讀技術書籍")
        
        context.insert(idea1)
        context.insert(idea2)
        context.insert(idea3)
        try context.save()
        
        // When
        let descriptor = FetchDescriptor<Idea>()
        let allIdeas = try context.fetch(descriptor)
        let filteredIdeas = allIdeas.filter { $0.title.contains("Swift") }
        
        // Then
        #expect(filteredIdeas.count == 2)
    }
    
    @Test("應該能夠切換 Idea 的完成狀態")
    func testToggleIdeaCompletion() throws {
        // Given
        let container = try createTestContainer()
        let context = container.mainContext
        let idea = Idea(title: "可切換想法", isCompleted: false)
        
        context.insert(idea)
        try context.save()
        
        // When
        idea.isCompleted.toggle()
        idea.updatedAt = Date()
        try context.save()
        
        // Then
        let descriptor = FetchDescriptor<Idea>()
        let ideas = try context.fetch(descriptor)
        #expect(ideas.first?.isCompleted == true)
    }
    
    @Test("應該能夠批次插入多個 Idea")
    func testBatchInsert() throws {
        // Given
        let container = try createTestContainer()
        let context = container.mainContext
        
        let ideas = [
            Idea(title: "想法 1"),
            Idea(title: "想法 2"),
            Idea(title: "想法 3"),
            Idea(title: "想法 4"),
            Idea(title: "想法 5")
        ]
        
        // When
        ideas.forEach { context.insert($0) }
        try context.save()
        
        // Then
        let descriptor = FetchDescriptor<Idea>()
        let savedIdeas = try context.fetch(descriptor)
        #expect(savedIdeas.count == 5)
    }
}
