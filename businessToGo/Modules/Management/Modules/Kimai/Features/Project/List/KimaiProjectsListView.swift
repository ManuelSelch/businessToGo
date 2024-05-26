import SwiftUI
import MyChart
import OfflineSync
import ComposableArchitecture

struct KimaiProjectsListView: View {
    let store: StoreOf<KimaiProjectsListFeature>
    
    var projectsFiltered: [KimaiProject] {
        var c = store.projects.records.filter { $0.customer == store.customer }
        c.sort { $0.name < $1.name }
        return c
    }
    
    var projectTimes: [ChartItem] {
        calculateProjectTimes()
    }

    var body: some View {
        VStack {
            if(projectsFiltered.count > 1) {
                ChartPieView(projectTimes)
                    .background(Color.background)
            }
            
            List {
                ForEach(projectsFiltered) { project in
                    KimaiProjectCard(
                        kimaiProject: project,
                        change: store.projects.changes.first { $0.recordID == project.id },
                        projectTapped: { store.send(.projectTapped(project.id)) }
                    )
                    .swipeActions(edge: .trailing) {
                        Button(role: .cancel) {
                            store.send(.projectEditTapped(project))
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
                        var project = KimaiProject.new
                        project.customer = store.customer
                        store.send(.projectEditTapped(project))
                    }){
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.theme)
                    }
                }
            }
        }
    }
    
    
    
    
}

extension KimaiProjectsListView {
    func calculateProjectTimes() -> [ChartItem] {
        var projectTimes: [ChartItem] = []
        
        for project in projectsFiltered {
            projectTimes.append(ChartItem(id: project.id, name: project.name, value: 0))
        }
        
        for timesheet in store.timesheets {
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
