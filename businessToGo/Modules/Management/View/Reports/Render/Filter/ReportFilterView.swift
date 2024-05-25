
import SwiftUI
import Redux

struct ReportFilterView: View {
    var customers: [KimaiCustomer]
    var projects: [KimaiProject]
    
    @Binding var selectedProject: Int?
    
    var filterTapped: () -> ()
   
    
    var body: some View {
        List {
            HStack {
                Text("Projekt")
                Spacer()
                
                Button(action: {
                    filterTapped()
                }){
                    HStack {
                        if let project = projects.first(where: { $0.id == selectedProject }) {
                            Text(project.name)
                        } else {
                            Text("Alle Projekte")
                        }
                        
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundStyle(Color.theme)
                
            
            }
        }
    }
}

