import SwiftUI
import Redux

struct ReportContainer: View {
    @EnvironmentObject var store: Store<ManagementState, ManagementAction, ManagementDependency>
    @State var selectedReportType: ReportType = .week
    @State var selectedDate: Date = Date.getToday()
    
    var timesheets: [KimaiTimesheet] {
        let timesheets = store.state.kimai.timesheets
        
        switch(selectedReportType){
        case .day:
            return timesheets.filter({ $0.getBeginDate()?.isDay(of: selectedDate) ?? false })
        case .week:
            return timesheets.filter({ $0.getBeginDate()?.isWeekOfYear(of: selectedDate) ?? false })
        case .month:
            return timesheets.filter({$0.getBeginDate()?.isMonth(of: selectedDate) ?? false })
        case .year:
            return timesheets.filter({$0.getBeginDate()?.isYear(of: selectedDate) ?? false })
        }
    }
    
    var body: some View {
        VStack {
            ReportHeaderView(selectedReportType: $selectedReportType, selectedDate: $selectedDate)
            
            ScrollView {
                ReportSummaryView(timesheets: timesheets)
                
                switch(selectedReportType){
                case .week:
                    WeekReportView(days: [
                        DayReport(name: "Mo", time: getTotalTime(for: timesheets, weekday: 2)),
                        DayReport(name: "Di", time: getTotalTime(for: timesheets, weekday: 3)),
                        DayReport(name: "Mi", time: getTotalTime(for: timesheets, weekday: 4)),
                        DayReport(name: "Do", time: getTotalTime(for: timesheets, weekday: 5)),
                        DayReport(name: "Fr", time: getTotalTime(for: timesheets, weekday: 6)),
                        DayReport(name: "Sa", time: getTotalTime(for: timesheets, weekday: 7)),
                        DayReport(name: "So", time: getTotalTime(for: timesheets, weekday: 1))
                    ])
                default: EmptyView()
                }
                
                
                KimaiTimesheetsView(
                    timesheets: timesheets, // todo: filter
                    activities: [],
                    changes: [],
                    onEditClicked: {_ in},
                    onDeleteClicked: { _ in}
                )
            }
        }
        
    }
    
    func getTotalTime(for timesheets: [KimaiTimesheet], weekday: Int) -> TimeInterval {
        var time: TimeInterval = 0
        for timesheet in timesheets {
            if let timesheetDay = timesheet.getBeginDate()?.getWeekday() {
                if(timesheetDay == weekday){
                    time += timesheet.calculateDuration() ?? 0
                }
                
            }
        }
        return time
    }
}
