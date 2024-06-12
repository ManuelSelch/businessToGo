import SwiftUI

import TaigaCore

public struct TaigaProjectView: View {
    let project: TaigaProject
    let statusList: [TaigaTaskStoryStatus]
    let storyList: [TaigaTaskStory]
    let tasks: [TaigaTask]
    let milestones: [TaigaMilestone]
    let menus: [TaigaMenu]
    
    @Binding var selectedMenu: TaigaMenu
    
    let taskStoryUpdated: (TaigaTaskStory) -> ()
    
    public init(project: TaigaProject, statusList: [TaigaTaskStoryStatus], storyList: [TaigaTaskStory], tasks: [TaigaTask], milestones: [TaigaMilestone], menus: [TaigaMenu], selectedMenu: Binding<TaigaMenu>, taskStoryUpdated: @escaping (TaigaTaskStory) -> Void) {
        self.project = project
        self.statusList = statusList
        self.storyList = storyList
        self.tasks = tasks
        self.milestones = milestones
        self.menus = menus
        self._selectedMenu = selectedMenu
        self.taskStoryUpdated = taskStoryUpdated
    }
    
    public var body: some View {
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
