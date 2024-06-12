
import SwiftUI

import CommonUI
import KimaiCore

struct ReportFilterProjectsView: View {
    
    let customers: [KimaiCustomer]
    let projects: [KimaiProject]
    let selectedProject: Int?
    
    let allProjectsTapped: () -> ()
    let projectTapped: (Int) -> ()
    
    var body: some View {
        List {
            HStack {
                Button(action: {
                    allProjectsTapped()
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
                                projectTapped(project.id)
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
