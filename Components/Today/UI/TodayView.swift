import SwiftUI

import KimaiCore
import OfflineSyncCore

struct TodayView: View {
    var timesheets: [KimaiTimesheet]
    var projects: [KimaiProject]
    var customers: [KimaiCustomer]
    var activities: [KimaiActivity]
    
    let projectChangeTapped: () -> ()
    let activityChangeTapped: (_ for: Int) -> ()
    
    var currentCustomer: KimaiCustomer?
    var currentProject: KimaiProject?
    var currentActivity: KimaiActivity?
    
    init(
        timesheets: [KimaiTimesheet], projects: [KimaiProject], customers: [KimaiCustomer], activities: [KimaiActivity],
        projectChangeTapped: @escaping () -> Void,
        activityChangeTapped: @escaping (_ for: Int) -> Void
    ) {
        self.timesheets = timesheets
        self.projects = projects
        self.customers = customers
        self.activities = activities
        
        self.projectChangeTapped = projectChangeTapped
        self.activityChangeTapped = activityChangeTapped
        
        let currentTimesheet = timesheets.filter({$0.end == nil}).last
        currentProject = projects.get(currentTimesheet?.project)
        currentCustomer = customers.get(currentProject?.customer) 
        currentActivity = activities.get(currentProject?.id)
    }
    
    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Heute")
                        .font(.system(.title3, weight: .bold))
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading) {
                            Text("0h 00m")
                                .font(.system(.title3, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Gearbeitet")
                                .foregroundStyle(.secondary)
                        }
                        VStack(alignment: .leading) {
                            Text("0h 00m")
                                .font(.system(.title3, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .clipped()
                            Text("Pausiert")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Text("Zeitplan")
                        .font(.system(.title3, weight: .bold))
                        .padding(.top)
                    
                    if let currentCustomer = currentCustomer, let currentProject = currentProject, let currentActivity = currentActivity {
                        ChangeView(
                            currentCustomer: currentCustomer,
                            currentProject: currentProject,
                            currentActivity: currentActivity,
                            projectChangeTapped: projectChangeTapped,
                            activityChangeTapped: activityChangeTapped
                        )
                    }
                    
                    VStack(spacing: 0) {
                        ForEach(timesheets) { t in
                            let project = projects.first(where: {$0.id == t.project})
                            let customer = customers.first(where: {$0.id == project?.customer})
                            TodayItem(
                                timesheet: t,
                                customer: customer,
                                project: project,
                                isLastItem: t == timesheets.last
                            )
                        }
                    }
                }
                .padding()
            }
    }
}
