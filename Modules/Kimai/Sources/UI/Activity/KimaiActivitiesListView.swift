import SwiftUI
import OfflineSync

import KimaiCore

public struct KimaiActivityListView: View {
    let activities: [KimaiActivity]
    
    let activityTapped: (KimaiActivity) -> ()
    
    public init(activities: [KimaiActivity], activityTapped: @escaping (KimaiActivity) -> Void) {
        self.activities = activities
        self.activityTapped = activityTapped
    }
    
    public var body: some View {
        List {
            ForEach(activities) { activity in
                KimaiActivityCard(
                    activity: activity,
                    activityTapped: { activityTapped(activity) }
                )
                .swipeActions(edge: .trailing) {
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("Edit")
                            .foregroundColor(.white)
                    }
                    .tint(.gray)
                }
            }
        }
    }
}

#Preview {
    KimaiActivityListView(
        activities: [KimaiActivity.sample],
        activityTapped: { _ in }
    )
}
