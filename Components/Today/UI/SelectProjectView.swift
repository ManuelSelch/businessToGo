import SwiftUI

import KimaiCore

struct SelectProjectView: View {
    let customers: [KimaiCustomer]
    let projects: [KimaiProject]
    
    let projectTapped: (Int) -> ()
    
    var body: some View {
        List {
            ForEach(customers) { customer in
                Section(
                    header: Text(customer.name).bold()
                ){
                    let projectsOfCustomer = projects.filter { $0.customer == customer.id }
                    ForEach(projectsOfCustomer) { project in
                        HStack {
                            Button(action: {
                                projectTapped(project.id)
                            }){
                                Text(project.name)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

