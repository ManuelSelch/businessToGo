import Foundation
import ComposableArchitecture
import SwiftUI

enum TaigaProjectMenu: String, Equatable, CaseIterable {
    case backlog = "Backlog"
    case kanban = "Kanban"

    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

enum TaigaRoute: Equatable, Hashable, Codable {
    case project(Integration)
}

extension TaigaRoute {
    @ViewBuilder func createView(_ store: StoreOf<TaigaModule>) -> some View {
        switch(self){
            
        case .project(let integration):
            if let project = store.projects.records.first(where: {$0.id == integration.taigaProjectId}) {
               TaigaProjectView(
                project: project,
                taskStoryStatus: store.taskStoryStatus.records.filter { $0.project == integration.taigaProjectId },
                taskStories: store.taskStories.records,
                tasks: store.tasks.records,
                milestones: store.milestones.records.filter { $0.project == integration.taigaProjectId },
                updateTaskStory: { store.send(.taskStories(.update($0))) }
               )
            }
            
        }
    }
}
