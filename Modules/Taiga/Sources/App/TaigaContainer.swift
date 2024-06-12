import SwiftUI
import Redux

import TaigaUI
import TaigaCore

public struct TaigaContainer: View {
    @ObservedObject var store: StoreOf<TaigaFeature>
    let route: TaigaRoute
    
    public init(store: StoreOf<TaigaFeature>, route: TaigaRoute) {
        self.store = store
        self.route = route
    }
    
    public var body: some View {
        switch(route) {
        case let .project(_, taiga):
            if let project = store.state.projects.first(where: {$0.id == taiga}) {
                TaigaProjectView(
                    project: project,
                    statusList: store.state.taskStoryStatus,
                    storyList: store.state.taskStories,
                    tasks: store.state.tasks,
                    milestones: store.state.milestones,
                    menus: store.state.menus,
                    selectedMenu: store.binding(for: \.selectedMenu, action: {TaigaFeature.Action.project(.menuSelected($0))}),
                    taskStoryUpdated: { store.send(.project(.taskStoryUpdated($0))) }
                )
            }
        }
    }
}
