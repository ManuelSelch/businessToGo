import SwiftUI

import ManagementDependencies

struct TaigaProjectView: View {
    let project: TaigaProject
    let statusList: [TaigaTaskStoryStatus]
    let storyList: [TaigaTaskStory]
    let tasks: [TaigaTask]
    let milestones: [TaigaMilestone]
    let menus: [TaigaFeature.Menu]
    @Binding var selectedMenu: TaigaFeature.Menu
    
    let taskStoryUpdated: (TaigaTaskStory) -> ()
    
    var body: some View {
        VStack {
            Picker("Project Menu", selection: $selectedMenu) {
                ForEach(menus, id: \.self) { menu in
                    Text(menu.localizedName)
                        .tag(menu)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            switch(selectedMenu){
            case .kanban:
                TaigaKanbanView(
                    project: project,
                    statusList: statusList,
                    storyList: storyList,
                    tasks: tasks,
                    
                    onSetStatus: { taskStory, status in
                        var taskStory = taskStory
                        taskStory.status = status.id
                        taskStoryUpdated(taskStory)
                    }
                )
            case .backlog:
                TaigaBacklogView(
                    project: project,
                    milestones: milestones
                )
            }
        }
    }
    
}
