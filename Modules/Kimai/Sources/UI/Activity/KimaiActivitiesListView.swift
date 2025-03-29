import SwiftUI
import OfflineSyncCore

import KimaiCore
import CommonUI

public struct KimaiActivityListView: View {
    let project: KimaiProject
    let activities: [KimaiActivity]
    
    let tapped: (KimaiActivity) -> ()
    let editTapped: (KimaiActivity) -> ()
    let deleteTapped: (KimaiActivity) -> ()
    let created: (KimaiActivity) -> ()
    
    public init(
        project: KimaiProject,
        activities: [KimaiActivity],
        tapped: @escaping (KimaiActivity) -> Void,
        editTapped: @escaping (KimaiActivity) -> Void,
        deleteTapped: @escaping (KimaiActivity) -> Void,
        created: @escaping (KimaiActivity) -> Void
    ) {
        self.project = project
        self.tapped = tapped
        self.editTapped = editTapped
        self.deleteTapped = deleteTapped
        self.created = created
        
        self.activities = activities.filter({
            $0.project == project.id ||
            ($0.project == nil && project.globalActivities == true)
        }).sorted(by: { $0.id > $1.id })
    }
    
    public var body: some View {
        List {
            CustomTextField("New Activity") { name in
                var activity = KimaiActivity.new
                activity.name = name
                activity.project = project.id
                created(activity)
            }
            .listRowBackground(Color.clear)
            
            
            ForEach(activities) { activity in
                KimaiActivityCard(
                    activity: activity,
                    activityTapped: { tapped(activity) }
                )
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing) {
                    Button(role: .cancel) {
                        deleteTapped(activity)
                    } label: {
                        Text("Delete")
                            .foregroundColor(.white)
                    }
                    .tint(.red)
                    .padding()
                    
                    Button(role: .cancel) {
                        editTapped(activity)
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
