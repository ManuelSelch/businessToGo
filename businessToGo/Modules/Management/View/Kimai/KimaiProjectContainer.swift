import SwiftUI
import Redux
import OfflineSync

struct KimaiProjectContainer: View {
    @EnvironmentObject var router: ManagementRouter
    @EnvironmentObject var store: Store<KimaiState, KimaiAction, ManagementDependency>
    
    let id: Int
    let changes: [DatabaseChange]
    @Binding var timesheetView: KimaiTimesheet?
    
    
    var body: some View {
        VStack {
            if let kimaiProject = store.state.projects.first(where: {$0.id == id})
            {
                getProjectTimeView(kimaiProject)
            }else {
                Text("error loading project")
            }
        }
        
    }
}

extension KimaiProjectContainer {
    @ViewBuilder func getProjectTimeView(_ kimaiProject: KimaiProject) -> some View {
        VStack {
            let timesheets = store.state.timesheets.filter { $0.project == kimaiProject.id }
            
            KimaiTimesheetsView(
                timesheets: timesheets,
                activities: store.state.activities,
                changes: changes,
                
                onTimesheetClicked: showTimesheet,
                onStopClicked: stopTimesheet
            )
        }
    }
}

extension KimaiProjectContainer {
    func showTimesheet(_ id: Int){
        timesheetView = store.state.timesheets.first(where: { $0.id == id })
    }
    
    func stopTimesheet(_ id: Int){
        if var timesheet = store.state.timesheets.first(where: {$0.id == id}) {
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
