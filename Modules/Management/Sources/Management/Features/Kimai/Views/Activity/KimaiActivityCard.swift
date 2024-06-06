import SwiftUI
import OfflineSync

import AppCore
import KimaiCore

struct KimaiActivityCard: View {
    let change: DatabaseChange?
    let activity: KimaiActivity
    
    let activityTapped: () -> ()
    
    var body: some View {
        HStack {
            if(change != nil){
                Image(systemName: "icloud.and.arrow.up")
            }
            
            if let color = activity.color {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: color))
            }
            
            Button(action: {
                activityTapped()
            }){
                Text(activity.name)
                    .foregroundColor(Color.theme)
            }
        }
    }
}

#Preview {
    KimaiActivityCard(
        change: nil,
        activity: KimaiActivity.sample,
        activityTapped: {}
    )
}
