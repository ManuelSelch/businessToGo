import SwiftUI

import KimaiCore
import IntegrationCore

struct IntegrationCard: View {
    let kimaiProject: KimaiProject
    let taigaProjects: [KimaiProject]
    let integration: Integration?
    
    let onConnect: (_ kimai: Int, _ taiga: Int) -> Void
    
    @State var selectedTaigaProject: Int = 0
    
    var body: some View {
        HStack {
            Text(kimaiProject.name)
            Spacer()
            Picker("Taiga Project", selection: $selectedTaigaProject) {
                ForEach(taigaProjects, id: \.id) {
                    Text($0.name)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
        .onAppear {
            if let integration = integration {
                selectedTaigaProject = integration.taigaProjectId
            }else {
                selectedTaigaProject = taigaProjects.first?.id ?? 0
            }
        }
        .onChange(of: selectedTaigaProject){ _ in 
            if(selectedTaigaProject != integration?.taigaProjectId){
                onConnect(kimaiProject.id, selectedTaigaProject)
            }
        }
    }
}
