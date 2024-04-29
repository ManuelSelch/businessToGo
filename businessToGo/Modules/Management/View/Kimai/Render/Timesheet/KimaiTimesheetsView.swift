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
        
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.fixed(40)),
                GridItem(),
                GridItem(),
                GridItem(.fixed(40)),
            ]) {
                GridRow {
                    Text("")
                    Text("Datum")
                    Text("Tätigkeit")
                    Text("")
                }
                ForEach(timesheetsFiltered){ timesheet in
                    KimaiTimesheetCard(
                        timesheet: timesheet,
                        change: changes.first(where: { $0.tableName == "timesheets" && $0.recordID == timesheet.id }),
                        activity: activities.first(where: { $0.id == timesheet.activity }),
                        
                        onTimesheetClicked: onTimesheetClicked,
                        onStopClicked: onStopClicked
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
