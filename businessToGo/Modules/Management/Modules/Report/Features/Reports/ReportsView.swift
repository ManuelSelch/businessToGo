import SwiftUI
import OfflineSync
import MyChart
import ComposableArchitecture

struct ReportsView: View {
    @Bindable var store: StoreOf<ReportsFeature>
    
    @State var selectedReportType: ReportType = .week
    
    var timesheetsFiltered: [KimaiTimesheet] {
        var timesheets = store.timesheets.records
        
        if let project = store.selectedProject {
            timesheets = timesheets.filter { $0.project == project }
        }
        
        switch(selectedReportType){
        case .day:
            return timesheets.filter{ $0.getBeginDate()?.isDay(of: store.selectedDate) ?? false }
        case .week:
            return timesheets.filter { $0.getBeginDate()?.isWeekOfYear(of: store.selectedDate) ?? false }
        case .month:
            return timesheets.filter { $0.getBeginDate()?.isMonth(of: store.selectedDate) ?? false }
        case .year:
            return timesheets.filter { $0.getBeginDate()?.isYear(of: store.selectedDate) ?? false }
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
            selectedDate: $store.selectedDate.sending(\.dateSelected),
            selectedProject: $store.selectedProject.sending(\.projectSelected),
            projects: store.projects,
            
            calendarTapped: { store.send(.calendarTapped) },
            filterTapped: { store.send(.filterTapped) },
            playTapped: { store.send(.playTapped) }
            
        )
    }
    
    
    @ViewBuilder
    func getTimesheets() -> some View {
        KimaiTimesheetsListView(
            projects: store.projects,
            timesheets: timesheetsFiltered,
            timesheetChanges: store.timesheets.changes,
            activities: store.activities,
            deleteTapped: { store.send(.deleteTapped($0)) },
            editTapped: { _ in } // TODO: handle edit tapped event
        )
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
