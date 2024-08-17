import SwiftUI
import MyChart

import CommonUI
import KimaiCore

public struct KimaiProjectsListView: View {
    let customer: Int
    let projects: [KimaiProject]
    let timesheets: [KimaiTimesheet]
    
    let projectTapped: (Int) -> ()
    let projectEditTapped: (KimaiProject) -> ()
    let projectDeleteTapped: (KimaiProject) -> ()
    let projectCreated: (KimaiProject) -> ()
    
    var projectsFiltered: [KimaiProject] {
        var c = projects.filter { $0.customer == customer }
        c.sort { $0.name < $1.name }
        return c
    }
    
    var projectTimes: [ChartItem] {
        calculateProjectTimes()
    }
    
    public init(
        customer: Int, projects: [KimaiProject], timesheets: [KimaiTimesheet], 
        
        projectTapped: @escaping (Int) -> Void,
        projectEditTapped: @escaping (KimaiProject) -> Void,
        projectDeleteTapped: @escaping (KimaiProject) -> Void,
        projectCreated: @escaping (KimaiProject) -> Void
    ) {
        self.customer = customer
        self.projects = projects
        self.timesheets = timesheets
        
        self.projectTapped = projectTapped
        self.projectEditTapped = projectEditTapped
        self.projectDeleteTapped = projectDeleteTapped
        self.projectCreated = projectCreated
    }
    
    public var body: some View {
        List {
            CustomTextField("New Project") { name in
                
                var project = KimaiProject.new
                project.name = name
                project.customer = customer
                projectCreated(project)
            }
            
            
            ForEach(projectsFiltered) { project in
                KimaiProjectCard(
                    kimaiProject: project,
                    projectTapped: { projectTapped(project.id) }
                )
                .swipeActions(edge: .trailing) {
                    Button(role: .cancel) {
                        projectDeleteTapped(project)
                    } label: {
                        Text("Delete")
                            .foregroundColor(.white)
                    }
                    .tint(.red)
                    .padding()
                    
                    Button(role: .cancel) {
                        projectEditTapped(project)
                    } label: {
                        Text("Edit")
                            .foregroundColor(.white)
                    }
                    .tint(.gray)
                }
            }
        }
        .listStyle(.plain)
    }
    
    
    
    
}

extension KimaiProjectsListView {
    func calculateProjectTimes() -> [ChartItem] {
        var projectTimes: [ChartItem] = []
        
        for project in projectsFiltered {
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
