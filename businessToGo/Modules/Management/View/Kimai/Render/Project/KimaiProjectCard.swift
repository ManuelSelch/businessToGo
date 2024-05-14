import SwiftUI
import OfflineSync

struct KimaiProjectCard: View {
    let kimaiProject: KimaiProject
    var change: DatabaseChange?
    let onOpenProject: (Int) -> Void
    
    var body: some View {
        HStack {
            if(change != nil){
                Image(systemName: "icloud.and.arrow.up")
            }
            
            if let color = kimaiProject.color {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: color))
            }
            
            Button(action: {
                onOpenProject(kimaiProject.id)
            }){
                Text(kimaiProject.name)
                    .foregroundColor(Color.theme)
            }
        }
    }
}
