import SwiftUI
import OfflineSync
import SwipeActions

struct KimaiTimesheetsView: View {
    let timesheets: [KimaiTimesheet]
    let projects: [KimaiProject]
    let activities: [KimaiActivity]
    let changes: [DatabaseChange]
    
    let onEditClicked: (KimaiTimesheet) -> Void
    let onDeleteClicked: (KimaiTimesheet) -> Void
    
    
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
                        project: projects.first { $0.id == timesheet.project }, 
                        change: changes.first { $0.recordID == timesheet.id },
                        activity: activities.first{ $0.id == timesheet.activity }
                    )
                    /*
                    .addFullSwipeAction(menu: .slided) {
                                  Trailing {
                                      
                                      
                                      Button {
                                          
                                      } label: {
                                          Image(systemName: "trash")
                                              .foregroundColor(.white)
                                      }
                                      .contentShape(Rectangle())
                                      .frame(width: 60)
                                      .frame(maxHeight: .infinity)
                                      .background(Color.red) // <=== Look here
                                  }
                    } action: {
                                  
                    }
                     */
                    
                    .addSwipeAction(edge: .trailing) {
                        Button {
                            onDeleteClicked(timesheet)
                        } label: {
                            Text("Delete")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxHeight: .infinity)
                        .background(.red)
                        
                        Button {
                            onEditClicked(timesheet)
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
