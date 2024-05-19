import SwiftUI

struct TaigaProjectView: View {
    @State var selectedProjectMenu = TaigaProjectMenu.kanban
    
    let project: TaigaProject
    
    let taskStoryStatus: [TaigaTaskStoryStatus]
    let taskStories: [TaigaTaskStory]
    let tasks: [TaigaTask]
    let milestones: [TaigaMilestone]
    
    let updateTaskStory: (TaigaTaskStory) -> ()
    
    var menus: [TaigaProjectMenu] {
        var menus: [TaigaProjectMenu] = []
        
        if(project.is_backlog_activated){
            menus.append(.backlog)
        }
        
        menus.append(.kanban)
        
        return menus
    }
    
    
    
    var body: some View {
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
                    statusList: taskStoryStatus,
                    storyList: taskStories,
                    tasks: tasks,
                    
                    onSetStatus: { taskStory, status in
                        var taskStory = taskStory
                        taskStory.status = status.id
                        updateTaskStory(taskStory)
                    }
                )
            case .backlog:
                TaigaBacklogView(
                    project: project,
                    milestones: milestones
                )
            }
        }
        .onAppear{
            selectedProjectMenu = menus.first ?? .kanban
        }
    }
    
}
