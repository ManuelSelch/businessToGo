import SwiftUI
import Redux

struct ReportContainer: View {
    @ObservedObject var store: StoreOf<ManagementModule>
    
    @State var selectedReportType: ReportType = .week
    @State var selectedDate: Date = Date.today
    @State var isCalendarPicker = false
    @State var selectedProject: Int?
    
    var timesheets: [KimaiTimesheet] {
        var timesheets = store.state.kimai.timesheets
        
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
        VStack {
            getHeader()
            ScrollView {
                getReportChart()
                getTimesheets()
            }
        }
        .sheet(isPresented: $isCalendarPicker){
            YearMonthPickerView(selectedDate: $selectedDate)
                .presentationDetents([.medium])
        }
        
    }
    
    
}

extension ReportContainer {
    @ViewBuilder
    func getHeader() -> some View {
        ReportHeaderView(
            selectedReportType: $selectedReportType,
            selectedDate: $selectedDate,
            isCalendarPicker: $isCalendarPicker,
            
            selectedProject: $selectedProject,
            projects: store.state.kimai.projects,
            
            onEdit: { store.send(.route(.presentSheet(.kimai(.timesheet($0))))) }
        )
    }
    
    @ViewBuilder
    func getTimesheets() -> some View {
        KimaiTimesheetsView(
            timesheets: timesheets,
            projects: store.state.kimai.projects,
            activities: store.state.kimai.activities,
            changes: store.state.kimai.timesheetTracks,
            onEditClicked: { store.send(.route(.presentSheet(.kimai(.timesheet($0))))) },
            onDeleteClicked: { store.send(.kimai(.timesheets(.delete($0)))) }
        )
    }
    
    @ViewBuilder
    func getReportChart() -> some View {
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
    }
    
    @ViewBuilder
    func getTimesheeetSheet(_ timesheet: KimaiTimesheet) -> some View {
        KimaiTimesheetSheet(
            timesheet: timesheet,
            customers: store.state.kimai.customers,
            projects: store.state.kimai.projects,
            activities: store.state.kimai.activities,
            onSave: { timesheet in
                if(timesheet.id == KimaiTimesheet.new.id){
                    store.send(.kimai(.timesheets(.create(timesheet))))
                } else {
                    store.send(.kimai(.timesheets(.update(timesheet))))
                }
            }
        )
    }
}

extension ReportContainer {
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
