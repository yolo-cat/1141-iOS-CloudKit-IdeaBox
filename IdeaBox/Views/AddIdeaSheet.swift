//
//  AddIdeaSheet.swift
//  IdeaBox
//
//  Created by Harry Ng on 10/1/25.
//

import SwiftUI
import SwiftData

struct AddIdeaSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var title = ""
    @State private var detail = ""

    let ideaToEdit: Idea?

    var isEditMode: Bool {
        ideaToEdit != nil
    }

    var navigationTitle: String {
        isEditMode ? "Edit Idea" : "New Idea"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                        .font(.headline)

                    TextField("Description", text: $detail, axis: .vertical)
                        .lineLimit(3...6)
                        .font(.body)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveIdea()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .onAppear {
            if let idea = ideaToEdit {
                title = idea.title
                detail = idea.detail ?? ""
            }
        }
    }

    private func saveIdea() {
        if let idea = ideaToEdit {
            // Edit existing idea
            idea.title = title
            idea.detail = detail.isEmpty ? nil : detail
            idea.updatedAt = Date()
        } else {
            // Create new idea
            let newIdea = Idea(title: title, detail: detail.isEmpty ? nil : detail)
            modelContext.insert(newIdea)
        }
        dismiss()
    }
}

#Preview {
    AddIdeaSheet(ideaToEdit: nil)
        .modelContainer(for: Idea.self, inMemory: true)
}
