import SwiftUI
// import Redux

enum TaigaProjectMenu: String, Equatable, CaseIterable {
    case backlog = "Backlog"
    case kanban = "Kanban"

    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct TaigaContainer: View {
    @EnvironmentObject var store: Store<TaigaState, TaigaAction>
    var route: TaigaScreen
    
    @State var selectedProjectMenu = TaigaProjectMenu.kanban
    
    var body: some View {
        VStack {
            switch(route){
            case .projects:
                TaigaProjectsView(
                    projects: Env.taiga.projects.get(),
                    images: store.state.projectImages,
                    
                    onProjectClicked: showProject,
                    onLoadImage: loadImage
                )
                
            case .project(let id):
                if let project = Env.taiga.projects.get(by: id) {
                    var menus: [TaigaProjectMenu] {
                        var menus: [TaigaProjectMenu] = []
                        
                        if(project.is_backlog_activated){
                            menus.append(.backlog)
                        }
                        
                        menus.append(.kanban)
                        
                        return menus
                    }
                    
                    VStack {
                        Picker("Project Menu", selection: $selectedProjectMenu) {
                            ForEach(menus, id: \.self) { value in
                                Text(value.localizedName)
                                    .tag(value)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        switch(selectedProjectMenu){
                        case .kanban:
                            TaigaKanbanView(
                                project: project,
                                statusList: Env.taiga.taskStoryStatus.get().filter { $0.project == id },
                                storyList: Env.taiga.taskStories.get(),
                                tasks: Env.taiga.tasks.get(),
                                
                                onSetStatus: setStatus
                            )
                        case .backlog:
                            TaigaBacklogView(
                                project: project,
                                milestones: Env.taiga.milestones.get().filter { $0.project == id }
                            )
                        }
                    }
                    .onAppear{
                        selectedProjectMenu = menus.first ?? .kanban
                    }
                }
                
            }
        }
        .toolbar {
            TaigaHeaderView()
        }
    }
}

extension TaigaContainer {
    func showProject(_ project: TaigaProject){
        store.send(.navigate(.project(project.id)))
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
        case .project(_):
            store.send(.navigate(.projects))
        }
    }
    
    func setStatus(_ taskStory: TaigaTaskStory, _ status: TaigaTaskStoryStatus){
        var taskStory = taskStory
        taskStory.status = status.id
        store.send(.taskStories(.update(taskStory)))
    }
}
