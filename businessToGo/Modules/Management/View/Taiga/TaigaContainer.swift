import SwiftUI
import Redux

enum TaigaProjectMenu: String, Equatable, CaseIterable {
    case backlog = "Backlog"
    case kanban = "Kanban"

    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct TaigaContainer: View {
    @EnvironmentObject var router: ManagementRouter
    @EnvironmentObject var store: Store<TaigaState, TaigaAction, ManagementDependency>
    var route: TaigaScreen
    
    @State var selectedProjectMenu = TaigaProjectMenu.kanban
    
    var body: some View {
        VStack {
            switch(route){
            case .projects:
                TaigaProjectsView(
                    projects: store.state.projects,
                    images: store.state.projectImages,
                    
                    onProjectClicked: showProject,
                    onLoadImage: loadImage
                )
                
            case .project(let id):
                if let project = store.state.projects.first(where: {$0.id == id}) {
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
                                statusList: store.state.taskStoryStatus.filter { $0.project == id },
                                storyList: store.state.taskStories,
                                tasks: store.state.tasks,
                                
                                onSetStatus: setStatus
                            )
                        case .backlog:
                            TaigaBacklogView(
                                project: project,
                                milestones: store.state.milestones.filter { $0.project == id }
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
        router.navigate(.taiga(.project(project.id)))
    }
    
    func loadImage(_ project: TaigaProject){
        if store.state.projectImages[project.id] == nil {
            store.send(.loadImage(project))
        }
    }
    
    func goBack(){
        router.back()
    }
    
    func setStatus(_ taskStory: TaigaTaskStory, _ status: TaigaTaskStoryStatus){
        var taskStory = taskStory
        taskStory.status = status.id
        store.send(.taskStories(.update(taskStory)))
    }
}
