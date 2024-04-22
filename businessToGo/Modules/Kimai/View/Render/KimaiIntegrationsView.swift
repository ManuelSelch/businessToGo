import SwiftUI

struct KimaiIntegrationsView: View {
    let customer: KimaiCustomer
    let projects: [KimaiProject]
    let taigaProjects: [TaigaProject]
    let integrations: [Integration]
    
    let onConnect: (_ kimai: Int, _ taiga: Int) -> Void
    
    var projectsFiltered: [KimaiProject] {
        var projects = projects
            .filter { p in
                return p.customer == customer.id
            }
        
        projects.sort { $0.name < $1.name }
        
        return projects
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(projectsFiltered, id:\.id){ project in
                    HStack {
                        
                    }
                }
            }
        }
    }
}
