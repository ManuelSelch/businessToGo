import SwiftUI
import OfflineSync
import SwipeActions
import ComposableArchitecture

struct KimaiTimesheetsListView: View {
    let store: StoreOf<KimaiTimesheetsListFeature>
    
    var timesheetsByDate: Dictionary<Date, [KimaiTimesheet]> {
        var timesheets = store.timesheets.records
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
                        project: store.projects.first { $0.id == timesheet.project },
                        change: store.timesheets.changes.first { $0.recordID == timesheet.id },
                        activity: store.activities.first{ $0.id == timesheet.activity }
                    )
                    .addSwipeAction(edge: .trailing) {
                        Button {
                            store.send(.deleteTapped(timesheet))
                        } label: {
                            Text("Delete")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxHeight: .infinity)
                        .background(.red)
                        
                        Button {
                            store.send(.editTapped(timesheet))
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
