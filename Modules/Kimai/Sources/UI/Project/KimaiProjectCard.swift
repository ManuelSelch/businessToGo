import SwiftUI

import KimaiCore

struct KimaiProjectCard: View {
    let kimaiProject: KimaiProject
    let projectTapped: () -> Void
    
    var body: some View {
        HStack {
            if let color = kimaiProject.color {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: color))
            }
            
            Button(action: {
                projectTapped()
            }){
                Text(kimaiProject.name)
                    .foregroundColor(Color.theme)
            }
        }
    }
}
