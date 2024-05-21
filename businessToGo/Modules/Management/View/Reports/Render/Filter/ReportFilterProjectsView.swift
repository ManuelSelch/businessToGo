
import SwiftUI
import Redux

struct ReportFilterProjectsView: View {
    var customers: [KimaiCustomer]
    var projects: [KimaiProject]
    
    @Binding var selectedProject: Int?
    
    var router: (RouteModule<ReportRoute>.Action) -> ()
    
    var body: some View {
        List {
            HStack {
                Button(action: {
                    selectedProject = nil
                }){
                    Text("Alle Projekte")
                }
                Spacer()
                if(selectedProject == nil){
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.theme)
                }
            }
            
            ForEach(customers) { customer in
                Section(
                    header: Text(customer.name).bold()
                ){
                    let projectsOfCustomer = projects.filter { $0.customer == customer.id }
                    ForEach(projectsOfCustomer) { project in
                        HStack {
                            Button(action: {
                                selectedProject = project.id
                            }){
                                Text(project.name)
                            }
                            Spacer()
                            if(project.id == selectedProject){
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.theme)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ReportFilterProjectsView(
        customers: [
            .init(id: 0, name: "C1", teams: []),
            .init(id: 1, name: "C2", teams: [])
        ],
        projects: [
            .init(id: 0, customer: 0, name: "P1", globalActivities: false, visible: true),
            .init(id: 1, customer: 0, name: "P1", globalActivities: false, visible: true),
            .init(id: 2, customer: 0, name: "P1", globalActivities: false, visible: true),
            .init(id: 3, customer: 1, name: "P2", globalActivities: false, visible: true),
            .init(id: 4, customer: 1, name: "P2", globalActivities: false, visible: true),
            .init(id: 5, customer: 1, name: "P2", globalActivities: false, visible: true)
        ],
        selectedProject: .constant(4),
        router: { _ in }
    )
}
