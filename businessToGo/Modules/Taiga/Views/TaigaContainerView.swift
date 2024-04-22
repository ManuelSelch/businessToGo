import SwiftUI

struct TaigaContainerView: View {
    @EnvironmentObject var store: Store<TaigaState, TaigaAction>
    
    var body: some View {
        VStack {
            TaigaHeaderView(
                isBack: store.state.scene != .projects,
                onBack: goBack
            )
            switch(store.state.scene){
            case .projects:
                TaigaProjectsView(
                    projects: Env.taiga.projects.get(),
                    images: store.state.projectImages,
                    
                    onProjectClicked: showProject,
                    onLoadImage: loadImage
                )
                   
                
            case .backlog(let project):
                TaigaBacklogView(
                    project: project,
                    milestones: Env.taiga.milestones.get()
                )
            
            case .kanban(let project):
                TaigaKanbanView(
                    project: project,
                    statusList: Env.taiga.taskStoryStatus.get(),
                    storyList: Env.taiga.taskStories.get(),
                    tasks: Env.taiga.tasks.get(),
                    
                    onSetStatus: setStatus
                )
            }
        }
    }
}

extension TaigaContainerView {
    func showProject(_ project: TaigaProject){
        store.send(.navigate(.kanban(project)))
    }
    
    func loadImage(_ project: TaigaProject){
        if store.state.projectImages[project.id] == nil {
            store.send(.loadImage(project))
        }
    }
    
    func goBack(){
        switch(store.state.scene){
        case .projects:
            break
        case .backlog(_), .kanban(_):
            store.send(.navigate(.projects))
        }
    }
    
    func setStatus(_ taskStory: TaigaTaskStory, _ status: TaigaTaskStoryStatus){
        store.send(.setStatus(taskStory, status))
    }
}

#Preview {
    TaigaContainerView()
        .environmentObject(
            Store<TaigaState, TaigaAction>(
                initialState: TaigaState(),
                reducer: TaigaState.reduce
            )
        )
}
