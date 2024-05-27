import SwiftUI
import ComposableArchitecture

struct TaigaProjectView: View {
    @Bindable var store: StoreOf<TaigaProjectFeature>
    
    var body: some View {
        VStack {
            Picker("Project Menu", selection: $store.selectedMenu.sending(\.menuSelected)) {
                ForEach(store.menus, id: \.self) { menu in
                    Text(menu.localizedName)
                        .tag(menu)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            switch(store.selectedMenu){
            case .kanban:
                TaigaKanbanView(
                    project: store.project,
                    statusList: store.taskStoryStatus,
                    storyList: store.taskStories,
                    tasks: store.tasks,
                    
                    onSetStatus: { taskStory, status in
                        var taskStory = taskStory
                        taskStory.status = status.id
                        store.send(.taskStoryUpdated(taskStory))
                    }
                )
            case .backlog:
                TaigaBacklogView(
                    project: store.project,
                    milestones: store.milestones
                )
            }
        }
    }
    
}


#Preview {
    TaigaProjectView(
        store: .init(
            initialState: .init(
                project: .sample,
                integration: Integration(1, 1),
                taskStoryStatus: Shared([TaigaTaskStoryStatus.sample]),
                taskStories: Shared([TaigaTaskStory.sample]),
                tasks: Shared([TaigaTask.sample]),
                milestones: Shared([TaigaMilestone.sample])
            )
        )
        {
            TaigaProjectFeature()
        }
    )
}
