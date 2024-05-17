import SwiftUI
import OfflineSync

struct KimaiTimesheetsView: View {
    let timesheets: [KimaiTimesheet]
    let activities: [KimaiActivity]
    let changes: [DatabaseChange]
    
    let onEditClicked: (Int) -> Void
    let onDeleteClicked: (KimaiTimesheet) -> Void
    
    var timesheetsByDate: Dictionary<Date, [KimaiTimesheet]> {
        Dictionary(grouping: timesheets, by: {
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
            Text("Sessions")
                .font(.system(size: 25, weight: .heavy))
            
            ForEach(timesheetsByDate.keys.sorted(by: >), id: \.self){ date in
                
                HStack {
                    Text(formatDate(date))
                    Spacer()
                    Text(getTotalTime(for: timesheetsByDate[date] ?? []))
                }
                .font(.system(size: 15))
                .textCase(.uppercase)
                .foregroundStyle(.textHeaderSecondary)
                
                
                let timesheetEntries = timesheetsByDate[date] ?? []
                ForEach(timesheetEntries){ timesheet in
                    KimaiTimesheetCard(
                        timesheet: timesheet,
                        project: nil, // todo: add references
                        change: nil,
                        activity: nil
                    )
                    .swipeActions(edge: .trailing) {
                        Button(role: .cancel) {
                            onDeleteClicked(timesheet)
                        } label: {
                            Text("Delete")
                                .foregroundColor(.white)
                        }
                        .tint(.red)
                        
                        Button(role: .cancel) {
                            onEditClicked(timesheet.id)
                        } label: {
                            Text("Edit")
                                .foregroundColor(.white)
                        }
                        .tint(.gray)
                    }
                }
            }
        }
        .padding()
    }
    
    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date.now)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
        let entryDay = calendar.startOfDay(for: date)
        
        if entryDay == today {
            return "Heute"
        } else if entryDay == yesterday {
            return "Gestern"
        }else {
            return date.formatted(date: .complete, time: .omitted)
        }
    }
    
    func getTotalTime(for timesheets: [KimaiTimesheet]) -> String {
        var time: TimeInterval = 0
        for timesheet in timesheets {
            time += timesheet.calculateDuration() ?? 0
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: time) ?? "--"
    }
    
   
  
    
}
