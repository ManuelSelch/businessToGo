import SwiftUI
import ComposableArchitecture

struct IntegrationsView: View {
    let store: StoreOf<IntegrationsFeature>
    
    var customersFiltered: [KimaiCustomer] {
        var customers = store.customers
        customers.sort { $0.name < $1.name }
        return customers
    }
    
    var projectsFiltered: [KimaiProject] {
        var projects = store.projects // .filter { $0.customer == selectedCustomer }
        
        projects.sort { $0.name < $1.name }
        return projects
    }
    
    @State var selectedCustomer: Int = 0
    
    var body: some View {
        VStack {
            /*Picker("Kunde", selection: $selectedCustomer) {
                ForEach(customersFiltered, id: \.id) {
                    Text($0.name)
                }
            }
            .pickerStyle(.menu)
             */
            
            List {
                ForEach(projectsFiltered, id:\.id){ project in
                    IntegrationCard(
                        kimaiProject: project,
                        taigaProjects: store.taigaProjects,
                        integration: store.integrations.first { $0.id == project.id },
                        onConnect: { kimai, taiga in store.send(.onConnect(kimai, taiga)) }
                    )
                }
            }
        }
        .background(Color.background)
        .onAppear {
            selectedCustomer = customersFiltered.first?.id ?? 0
        }
    }
}
