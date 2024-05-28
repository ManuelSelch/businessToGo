
import SwiftUI
import ComposableArchitecture

struct ReportFilterView: View {
    let store: StoreOf<ReportFilterFeature>
    
    var body: some View {
        List {
            HStack {
                Text("Projekt")
                Spacer()
                
                Button(action: {
                    store.send(.filterProjectsTapped)
                }){
                    HStack {
                        if let project = store.projects.first(where: { $0.id == store.selectedProject }) {
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
