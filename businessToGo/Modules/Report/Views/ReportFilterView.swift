import SwiftUI


struct ReportFilterView: View {
    
    let selectedProject: KimaiProject?
    
    let filterProjectsTapped: () -> ()
    
    var body: some View {
        List {
            HStack {
                Text("Projekt")
                Spacer()
                
                Button(action: {
                    filterProjectsTapped()
                }){
                    HStack {
                        if let project = selectedProject {
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
