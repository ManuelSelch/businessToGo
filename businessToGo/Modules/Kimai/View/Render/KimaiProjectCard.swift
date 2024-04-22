import SwiftUI

struct KimaiProjectCard: View {
    let kimaiProject: KimaiProject
    let onOpenProject: (Int) -> Void
    
    var body: some View {
        Button(action: {
            onOpenProject(kimaiProject.id)
        }){
            Text(kimaiProject.name)
        }
    }
}
