import SwiftUI
import OfflineSync
import SwipeActions
import ComposableArchitecture

struct ReportTimesheetsView: View {
    var timesheets: [KimaiTimesheet]
    var timesheetChanges: [DatabaseChange]
    var projects: [KimaiProject]
    var activities: [KimaiActivity]
    
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
     
    
    var body: some View {
        LazyVStack(alignment: .leading) {
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
                .foregroundStyle(.textHeaderSecondary)
                
                
                let timesheetEntries = timesheetsByDate[date] ?? []
                ForEach(timesheetEntries){ timesheet in
                    KimaiTimesheetCard(
                        timesheet: timesheet,
                        project: projects.first { $0.id == timesheet.project },
                        change: timesheetChanges.first { $0.recordID == timesheet.id },
                        activity: activities.first{ $0.id == timesheet.activity }
                    )
                     
                    
                   
                }
            }
        }
        .padding()
    }
}
