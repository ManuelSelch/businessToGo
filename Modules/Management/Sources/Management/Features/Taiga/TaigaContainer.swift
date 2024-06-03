import SwiftUI
import Redux

struct TaigaContainer: View {
    @ObservedObject var store: StoreOf<TaigaFeature>
    let route: TaigaFeature.Route
    
    var body: some View {
        switch(route) {
        case let .project(integration):
            if let project = store.state.projects.records.first(where: {$0.id == integration.taigaProjectId}) {
                TaigaProjectView(
                    project: project,
                    statusList: store.state.taskStoryStatus.records,
                    storyList: store.state.taskStories.records,
                    tasks: store.state.tasks.records,
                    milestones: store.state.milestones.records,
                    menus: store.state.menus,
                    selectedMenu: store.binding(for: \.selectedMenu, action: {TaigaFeature.Action.project(.menuSelected($0))}),
                    taskStoryUpdated: { store.send(.project(.taskStoryUpdated($0))) }
                )
            }
        }
    }
}
