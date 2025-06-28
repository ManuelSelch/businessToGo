import SwiftUI

import KimaiCore

struct TimesheetView: View {
    
    let project: Int
    let activities: [KimaiActivity]
    
    let saveTapped: (KimaiTimesheet) -> ()
    
    @State private var startTime: Date = Date().roundTo15Minutes()
    @State private var endTime: Date = Date().roundTo15Minutes()
    @State private var activity: Int?
    
    var body: some View {
        VStack {
            
            Picker("Activity", selection: $activity) {
                Text("SELECT")
                    .tag(Int?(nil))
                ForEach(activities) { activity in
                    Text(activity.name)
                        .tag(Int?(activity.id))
                }
            }
            .pickerStyle(.navigationLink)
            
            DatePicker("Start time", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
              
            
            DatePicker("End time", selection: $endTime, in: startTime..., displayedComponents: [.date, .hourAndMinute])
                
            
    
            
            Button("Save") {
                if let activity = activity {
                    var timesheet = KimaiTimesheet.new
                    timesheet.begin = "\(startTime)"
                    timesheet.end = "\(endTime)"
                    timesheet.project = project
                    timesheet.activity = activity
                    
                    saveTapped(timesheet)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            if(activity == nil) {
                activity = activities.first?.id
            }
        }
    }
}
