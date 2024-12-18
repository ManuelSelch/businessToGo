import SwiftUI

import KimaiCore
import IntegrationCore

public struct IntegrationsView: View {
    let customers: [KimaiCustomer]
    let projects: [KimaiProject]
    let integrations: [Integration]
    
    let onConnect: (_ kimai: Int, _ taiga: Int) -> ()
    
    var customersFiltered: [KimaiCustomer] {
        var customers = customers
        customers.sort { $0.name < $1.name }
        return customers
    }
    
    var projectsFiltered: [KimaiProject] {
        var projects = projects // .filter { $0.customer == selectedCustomer }
        
        projects.sort { $0.name < $1.name }
        return projects
    }
    
    @State var selectedCustomer: Int = 0
    
    public init(customers: [KimaiCustomer], projects: [KimaiProject], integrations: [Integration], onConnect: @escaping (_: Int, _: Int) -> Void) {
        self.customers = customers
        self.projects = projects
        self.integrations = integrations
        self.onConnect = onConnect
    }
    
    public var body: some View {
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
                        taigaProjects: [],
                        integration: integrations.first { $0.id == project.id },
                        onConnect: { kimai, taiga in onConnect(kimai, taiga) }
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
