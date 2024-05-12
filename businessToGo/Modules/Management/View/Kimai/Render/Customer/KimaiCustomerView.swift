import SwiftUI

struct KimaiCustomerView: View {
    let customer: KimaiCustomer
    let projects: [KimaiProject]
    
    var onProjectClicked: (Int) -> Void
    
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
                        KimaiProjectCard(
                            kimaiProject: project,
                            onOpenProject: onProjectClicked
                        )
                    }
                }
            }
        }
        .background(Color.background)
    }
}
