import SwiftUI
import OfflineSync
import MyChart

import KimaiCore

struct ReportsView: View {
    
    // MARK: - State
    let timesheets: [KimaiTimesheet]
    let timesheetChanges: [DatabaseChange]
    let projects: [KimaiProject]
    let activities: [KimaiActivity]
    @Binding var selectedProject: Int?
    @Binding var selectedDate: Date
    
    // MARK: - Action
    let calendarTapped: () -> ()
    let filterTapped: () -> ()
    let playTapped: () -> ()
    let deleteTapped: (KimaiTimesheet) -> ()
    
    
    // MARK: - View
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
            getReportChart()
                .frame(maxHeight: 100)
            getTimesheets()
        }
    }
}

extension ReportsView {
    
    @ViewBuilder
    func getHeader() -> some View {
        ReportHeaderView(
            selectedReportType: $selectedReportType,
            selectedDate: $selectedDate ,
            selectedProject: $selectedProject,
            projects: projects,
            
            calendarTapped: calendarTapped,
            filterTapped: filterTapped,
            playTapped: playTapped
            
        )
    }
    
    
    @ViewBuilder
    func getTimesheets() -> some View {
        VStack {
            Text("TODO: implement kimai timesheets view")
                .foregroundStyle(Color.red)
            Spacer()
        }
        /*
        KimaiTimesheetsListView(
            projects: projects,
            timesheets: timesheetsFiltered,
            timesheetChanges: timesheetChanges,
            activities: activities,
            deleteTapped: deleteTapped,
            editTapped: { _ in } // TODO: handle edit tapped event
        )
         */
    }
    
    @ViewBuilder
    func getReportChart() -> some View {
        ReportSummaryView(timesheets: timesheetsFiltered)
        
        switch(selectedReportType){
        case .week:
            ChartBarView([
                .init(id: 0, name: "Mo", value: getTotalTime(for: timesheetsFiltered, weekday: 2)),
                .init(id: 1, name: "Di", value: getTotalTime(for: timesheetsFiltered, weekday: 3)),
                .init(id: 2, name: "Mi", value: getTotalTime(for: timesheetsFiltered, weekday: 4)),
                .init(id: 3, name: "Do", value: getTotalTime(for: timesheetsFiltered, weekday: 5)),
                .init(id: 4, name: "Fr", value: getTotalTime(for: timesheetsFiltered, weekday: 6)),
                .init(id: 5, name: "Sa", value: getTotalTime(for: timesheetsFiltered, weekday: 7)),
                .init(id: 6, name: "So", value: getTotalTime(for: timesheetsFiltered, weekday: 1))
            ], Color.theme)
        default: EmptyView()
        }
    }
}

extension ReportsView {
    func getTotalTime(for timesheets: [KimaiTimesheet], weekday: Int) -> TimeInterval {
        let timesheets = timesheets.filter { $0.getBeginDate()?.getWeekday() == weekday }
        
        return KimaiTimesheet.totalHours(of: timesheets) / 3600
    }
}
