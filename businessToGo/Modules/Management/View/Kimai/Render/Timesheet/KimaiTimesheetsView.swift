import SwiftUI
import OfflineSync

struct KimaiTimesheetsView: View {
    let timesheets: [KimaiTimesheet]
    let activities: [KimaiActivity]
    let changes: [DatabaseChange]
    
    let onEditClicked: (Int) -> Void
    let onStopClicked: (Int) -> Void
    let onDeleteClicked: (KimaiTimesheet) -> Void
    
    var timesheetsFiltered: [KimaiTimesheet] {
        var t = timesheets
        t.sort {
            $0.begin > $1.begin
        }
        return t
    }
    
   
    var body: some View {
        VStack {}
        /*
        let timesheetsByDate = Dictionary(grouping: timesheetsFiltered, by: {
            Calendar.current.date(
                from: Calendar.current.dateComponents(
                    [.year, .month, .day],
                    from: getDate($0.begin) ?? Date.now
                )
            ) ?? Date.now
         
        })
         
        
        
        List {
            ForEach(timesheetsByDate.keys.sorted(by: >), id: \.self){ date in
                
                /*HStack { // todo: error?
                    var t = formatDate(date)
                    Text("formatDate(date)")
                        .foregroundColor(Color.theme)
                    Spacer()
                }*/
                
                
                let timesheetEntries = timesheetsByDate[date] ?? []
                ForEach(timesheetEntries){ timesheet in
                    KimaiTimesheetCard(
                        timesheet: timesheet,
                        change: changes.first(where: { $0.recordID == timesheet.id }),
                        activity: activities.first(where: { $0.id == timesheet.activity }),
                        onStopClicked: onStopClicked
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
        .background(Color.background)
         */
    }
    
    func getDate(_ dateStr: String) -> Date? {
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            timeZone: .current
        )
        
        return try? Date(dateStr, strategy: strategy)
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
            return date.formatted(date: .numeric, time: .omitted)
        }
    }
    
}
