import SwiftUI

import KimaiCore
import CommonUI
import CommonCore

public struct KimaiTimesheetsListView: View {
    let projects: [KimaiProject]
    
    let timesheets: [KimaiTimesheet]
    let activities: [KimaiActivity]
    
    let deleteTapped: (KimaiTimesheet) -> ()
    let editTapped: (KimaiTimesheet) -> ()
    
    public init(projects: [KimaiProject], timesheets: [KimaiTimesheet], activities: [KimaiActivity], deleteTapped: @escaping (KimaiTimesheet) -> Void, editTapped: @escaping (KimaiTimesheet) -> Void) {
        self.projects = projects
        self.timesheets = timesheets
        self.activities = activities
        self.deleteTapped = deleteTapped
        self.editTapped = editTapped
    }
    
    var timesheetsByDate: Dictionary<Date, [KimaiTimesheet]> {
        var timesheets = timesheets
        timesheets.sort(by: { $0.begin > $1.begin })
        return Dictionary(grouping: timesheets, by: {
            Calendar.current.date(
                from: Calendar.current.dateComponents(
                    [.year, .month, .day],
                    from: $0.getBeginDate() ?? Date.now
                )
            ) ?? Date.now
            
        })
    }
     
    
    public var body: some View {
        List {
            ForEach(timesheetsByDate.keys.sorted(by: >), id: \.self){ date in
                
                HStack {
                    Text(MyFormatter.date(date))
                    Spacer()
                    Text(
                        MyFormatter.duration(
                            KimaiTimesheet.totalHours(of: timesheetsByDate[date] ?? [])
                        )
                    )
                }
                .font(.system(size: 15))
                .textCase(.uppercase)
                .foregroundStyle(Color.textHeaderSecondary)
                
                
                let timesheetEntries = timesheetsByDate[date] ?? []
                ForEach(timesheetEntries){ timesheet in
                    KimaiTimesheetCard(
                        timesheet: timesheet,
                        project: projects.first { $0.id == timesheet.project },
                        activity: activities.first{ $0.id == timesheet.activity }
                    )
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteTapped(timesheet)
                        } label: {
                            Text("Delete")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(.red)
                        
                        Button {
                            editTapped(timesheet)
                        } label: {
                            Text("Edit")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxHeight: .infinity)
                        .background(.gray)
                    }
                     
                    
                   
                }
            }
        }
        // .padding()
    }
  
    
}
