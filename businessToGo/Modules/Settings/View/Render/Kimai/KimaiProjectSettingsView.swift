import SwiftUI

struct KimaiProjectSettingsView: View {
    
    var projects: [KimaiProject]
    var onEdit: (KimaiProject) -> ()
    
    var body: some View {
        VStack {
            List {
                ForEach(projects) { project in
                    Button(action: {
                        onEdit(project)
                    }){
                        Text(project.name)
                    }
                }
            }
        }
        .tint(Color.theme)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    onEdit(KimaiProject.new)
                }){
                    Image(systemName: "plus")
                        .padding()
                        .font(.system(size: 20))
                        .foregroundStyle(Color.theme)
                }
            }
        }
    }
}

