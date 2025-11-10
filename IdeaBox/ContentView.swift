//
//  ContentView.swift
//  IdeaBox
//
//  Created by Harry Ng on 10/1/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddIdea = false
    @State private var ideaToEdit: Idea?

    var body: some View {
        TabView {
            Tab("All", systemImage: "list.bullet") {
                AllIdeasView(showingAddIdea: $showingAddIdea, ideaToEdit: $ideaToEdit)
            }

            Tab("Completed", systemImage: "checkmark.circle.fill") {
                CompletedIdeasView(ideaToEdit: $ideaToEdit)
            }

            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchView(ideaToEdit: $ideaToEdit)
            }
        }
        .sheet(isPresented: $showingAddIdea) {
            AddIdeaSheet(ideaToEdit: nil)
        }
        .sheet(item: $ideaToEdit) { idea in
            AddIdeaSheet(ideaToEdit: idea)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Idea.self, inMemory: true)
}
