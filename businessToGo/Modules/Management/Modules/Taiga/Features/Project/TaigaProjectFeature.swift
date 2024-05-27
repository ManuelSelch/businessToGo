import Foundation
import SwiftUI
import ComposableArchitecture


@Reducer
struct TaigaProjectFeature {
    @ObservableState
    struct State: Equatable {
        var menus: [Menu] = []
        var selectedMenu: Menu = .backlog
        
        var project: TaigaProject
        var integration: Integration
        
        @Shared var taskStoryStatus: [TaigaTaskStoryStatus]
        @Shared var taskStories: [TaigaTaskStory]
        @Shared var tasks: [TaigaTask]
        @Shared var milestones: [TaigaMilestone]
        
        enum Menu: String {
            case kanban = "Kanban"
            case backlog = "Backlog 02"
            
            var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
        }
        
        init(
            project: TaigaProject,
            integration: Integration,
            
            taskStoryStatus: Shared<[TaigaTaskStoryStatus]>,
            taskStories: Shared<[TaigaTaskStory]>,
            tasks: Shared<[TaigaTask]>,
            milestones: Shared<[TaigaMilestone]>
        )
        {
            self.project = project
            self.integration = integration
            
            self._taskStoryStatus = taskStoryStatus
            self._taskStories = taskStories
            self._tasks = tasks
            self._milestones = milestones
            
            if(project.is_backlog_activated) {
                menus.append(.backlog)
            }
            menus.append(.kanban)
            selectedMenu = menus.first ?? .kanban
        }
    }
    
    enum Action {
        case menuSelected(State.Menu)
        case taskStoryUpdated(TaigaTaskStory)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        return .none
    }
}
