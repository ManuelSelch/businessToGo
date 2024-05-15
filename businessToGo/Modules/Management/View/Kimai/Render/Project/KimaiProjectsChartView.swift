import SwiftUI
import MyChart
import OfflineSync

struct KimaiProjectsChartView: View {
    let projects: [KimaiProject]
    let timesheets: [KimaiTimesheet]
    let changes: [DatabaseChange]
    
    var projectClicked: (_ id: Int) -> ()
    var onEdit: (KimaiProject) -> ()
    
    var projectsFiltered: [KimaiProject] {
        var c = projects
        c.sort { $0.name < $1.name }
        return c
    }

    var body: some View {
        let projectTimes = calculateProjectTimes()
        ChartView(projectTimes, projectClicked)
            .background(Color.background)
        
        List {
            ForEach(projectsFiltered) { project in
                KimaiProjectCard(
                    kimaiProject: project,
                    change: changes.first { $0.recordID == project.id },
                    onOpenProject: projectClicked
                )
                .swipeActions(edge: .trailing) {
                    Button(role: .cancel) {
                        onEdit(project)
                    } label: {
                        Text("Edit")
                            .foregroundColor(.white)
                    }
                    .tint(.gray)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    onEdit(KimaiProject.new)
                }){
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.theme)
                }
            }
        }
    }
    
    
    
    
}

extension KimaiProjectsChartView {
    func calculateProjectTimes() -> [ChartItem] {
        var projectTimes: [ChartItem] = []
        
        for project in projects {
            projectTimes.append(ChartItem(id: project.id, name: project.name, value: 0))
        }
        
        for timesheet in timesheets {
            if  let index = projectTimes.firstIndex(where: { $0.id == timesheet.project }),
                let duration = timesheet.calculateDuration()
            {
                projectTimes[index].value += duration
            }
        }
        
        projectTimes.sort { $0.value > $1.value }
        return projectTimes
    }
}
