import SwiftUI
import OfflineSync

struct KimaiTimesheetsView: View {
    let timesheets: [KimaiTimesheet]
    let activities: [KimaiActivity]
    let changes: [DatabaseChange]
    
    let onTimesheetClicked: (Int) -> Void
    let onStopClicked: (Int) -> Void
    
    var timesheetsFiltered: [KimaiTimesheet] {
        var t = timesheets
        t.sort {
            $0.begin > $1.begin
        }
        return t
    }
    
   
    var body: some View {
        
       
        
        let timesheetsByDate = Dictionary(grouping: timesheetsFiltered, by: {
            Calendar.current.date(
                from: Calendar.current.dateComponents(
                    [.year, .month, .day],
                    from: getDate($0.begin) ?? Date.now
                )
            ) ?? Date.now
         
        })
        
        
        List {
            ForEach(timesheetsByDate.keys.sorted(by: >), id: \.self){ key in
                
                HStack {
                    Text(key.formatted(date: .numeric, time: .omitted))
                        .foregroundColor(Color.theme)
                    Spacer()
                }
                
                
                let timesheetEntries = timesheetsByDate[key] ?? []
                ForEach(timesheetEntries){ timesheet in
                    KimaiTimesheetCard(
                        timesheet: timesheet,
                        change: changes.first(where: { $0.recordID == timesheet.id }),
                        activity: activities.first(where: { $0.id == timesheet.activity }),
                        onStopClicked: onStopClicked
                    )
                    .swipeActions(edge: .trailing) {
                        Button(role: .cancel) {
                            
                        } label: {
                            Text("Delete")
                                .foregroundColor(.white)
                        }
                        .tint(.red)
                        
                        Button(role: .cancel) {
                            onTimesheetClicked(timesheet.id)
                        } label: {
                            Text("Edit")
                                .foregroundColor(.white)
                        }
                        .tint(.gray)
                    }
                }
                
            }
            
            
            
        }
        .background(Color.background)
    }
    
    func getDate(_ dateStr: String) -> Date? {
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            timeZone: .current
        )
        
        return try? Date(dateStr, strategy: strategy)
    }
}
