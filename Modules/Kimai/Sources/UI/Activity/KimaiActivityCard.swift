import SwiftUI

import CommonUI
import KimaiCore

struct KimaiActivityCard: View {
    let activity: KimaiActivity
    
    let activityTapped: () -> ()
    
    var body: some View {
        HStack {
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
        activity: KimaiActivity.sample,
        activityTapped: {}
    )
}
