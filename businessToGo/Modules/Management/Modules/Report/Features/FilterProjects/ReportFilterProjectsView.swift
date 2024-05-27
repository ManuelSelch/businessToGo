
import SwiftUI
import ComposableArchitecture

struct ReportFilterProjectsView: View {
    let store: StoreOf<ReportFilterProjectsFeature>
    
    var body: some View {
        List {
            HStack {
                Button(action: {
                    store.send(.projectSelected(nil))
                }){
                    Text("Alle Projekte")
                }
                Spacer()
                if(store.selectedProject == nil){
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.theme)
                }
            }
            
            ForEach(store.customers) { customer in
                Section(
                    header: Text(customer.name).bold()
                ){
                    let projectsOfCustomer = store.projects.filter { $0.customer == customer.id }
                    ForEach(projectsOfCustomer) { project in
                        HStack {
                            Button(action: {
                                store.send(.projectSelected(project.id))
                            }){
                                Text(project.name)
                            }
                            Spacer()
                            if(project.id == store.selectedProject){
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
