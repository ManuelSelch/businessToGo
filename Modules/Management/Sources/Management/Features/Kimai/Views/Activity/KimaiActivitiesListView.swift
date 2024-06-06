import SwiftUI
import OfflineSync

import KimaiCore

struct KimaiActivityListView: View {
    let activities: [KimaiActivity]
    let activityChanges: [DatabaseChange]
    
    let activityTapped: (KimaiActivity) -> ()
    
    var body: some View {
        List {
            ForEach(activities) { activity in
                KimaiActivityCard(
                    change: activityChanges.first { $0.recordID == activity.id },
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
        activityChanges: [],
        activityTapped: { _ in }
    )
}
