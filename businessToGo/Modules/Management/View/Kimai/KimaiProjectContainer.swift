import SwiftUI
import Redux

struct KimaiProjectContainer: View {
    @EnvironmentObject var router: ManagementRouter
    @EnvironmentObject var store: Store<KimaiState, KimaiAction>
    
    let id: Int
    
    init(_ id: Int){
        self.id = id
    }
    
    var body: some View {
        VStack {
            if let kimaiProject = Env.kimai.projects.get(by: id)
            {
                let integration = Env.integrations.get(by: id)
                
                var taigaProject: TaigaProject? {
                    if let integration = integration {
                        return Env.taiga.projects.get(by: integration.taigaProjectId)
                    }
                    return nil
                }
                
                getProjectTimeView(kimaiProject, taigaProject)

                
            }else {
                Text("error loading project")
            }
        }
        
    }
}

extension KimaiProjectContainer {
    @ViewBuilder func getProjectTimeView(_ kimaiProject: KimaiProject, _ taigaProject: TaigaProject?) -> some View {
        VStack {
            let timesheets = Env.kimai.timesheets.get().filter { $0.project == kimaiProject.id }
            
            KimaiTimesheetsView(
                timesheets: timesheets,
                activities: Env.kimai.activities.get(),
                changes: Env.track.getAll(timesheets, "timesheets"),
                
                onTimesheetClicked: showTimesheet,
                onStopClicked: stopTimesheet
            )
        }
    }
}

extension KimaiProjectContainer {
    func showTimesheet(_ id: Int){
        router.navigate(.kimai(.timesheet(id)))
    }
    
    func stopTimesheet(_ id: Int){
        if var timesheet = Env.kimai.timesheets.get(by: id) {
            timesheet.end = "\(Date.now)"
            store.send(.timesheets(.update(timesheet)))
        }
    }
    
    func setStatus(_ task: TaigaTaskStory, _ status: TaigaTaskStoryStatus){
        var task = task
        task.status = status.id
        // taigaStore.send(.taskStories(.update(task)))
    }
}
