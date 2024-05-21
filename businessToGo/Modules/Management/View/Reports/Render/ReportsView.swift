import SwiftUI
import OfflineSync
import Redux

struct ReportsView: View {
    
    var timesheets: [KimaiTimesheet]
    var projects: [KimaiProject]
    var activities: [KimaiActivity]
    var timesheetTracks: [DatabaseChange]
    
    @Binding var selectedProject: Int?
    @Binding var selectedDate: Date
    
    var router: (RouteModule<ReportRoute>.Action) -> ()
    
    var onDelete: (KimaiTimesheet) -> ()
    
    @State var selectedReportType: ReportType = .week
    
    var timesheetsFiltered: [KimaiTimesheet] {
        var timesheets = timesheets
        
        if let project = selectedProject {
            timesheets = timesheets.filter { $0.project == project }
        }
        
        switch(selectedReportType){
        case .day:
            return timesheets.filter{ $0.getBeginDate()?.isDay(of: selectedDate) ?? false }
        case .week:
            return timesheets.filter { $0.getBeginDate()?.isWeekOfYear(of: selectedDate) ?? false }
        case .month:
            return timesheets.filter { $0.getBeginDate()?.isMonth(of: selectedDate) ?? false }
        case .year:
            return timesheets.filter { $0.getBeginDate()?.isYear(of: selectedDate) ?? false }
        }
    }
    
    
    var body: some View {
        VStack(spacing: 0){
            getHeader()
            ScrollView {
                getReportChart()
                getTimesheets()
            }
        }
    }
}

extension ReportsView {
    
    @ViewBuilder
    func getHeader() -> some View {
        ReportHeaderView(
            selectedReportType: $selectedReportType,
            selectedDate: $selectedDate,
            selectedProject: $selectedProject,
            projects: projects,
            
            router: { router($0) }
        )
    }
    
    
    @ViewBuilder
    func getTimesheets() -> some View {
        KimaiTimesheetsView(
            timesheets: timesheetsFiltered,
            projects: projects,
            activities: activities,
            changes: timesheetTracks,
            onEditClicked: { router(.presentSheet(.timesheet($0))) },
            onDeleteClicked: onDelete
        )
    }
    
    @ViewBuilder
    func getReportChart() -> some View {
        ReportSummaryView(timesheets: timesheetsFiltered)
        
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
    }
}

extension ReportsView {
    func getTotalTime(for timesheets: [KimaiTimesheet], weekday: Int) -> TimeInterval {
        var time: TimeInterval = 0
        for timesheet in timesheetsFiltered {
            if let timesheetDay = timesheet.getBeginDate()?.getWeekday() {
                if(timesheetDay == weekday){
                    time += timesheet.calculateDuration() ?? 0
                }
                
            }
        }
        return time
    }
}
