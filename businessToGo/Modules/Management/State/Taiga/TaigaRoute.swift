import Foundation
import Redux
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
            if let project = store.state.projects.first(where: {$0.id == integration.taigaProjectId}) {
               TaigaProjectView(
                project: project,
                taskStoryStatus: store.state.taskStoryStatus.filter { $0.project == integration.taigaProjectId },
                taskStories: store.state.taskStories,
                tasks: store.state.tasks,
                milestones: store.state.milestones.filter { $0.project == integration.taigaProjectId },
                updateTaskStory: { store.send(.taskStories(.update($0))) }
               )
            }
            
        }
    }
}
