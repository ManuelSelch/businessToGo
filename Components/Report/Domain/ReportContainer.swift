import SwiftUI
import Redux
import Dependencies

struct ReportContainer: View {
    @Dependency(\.router) var router
    @ObservedObject var store: ViewStoreOf<ReportComponent>
    var route: ReportComponent.Route
    
    public var body: some View {
        switch(route) {
        case .reports:
            ReportsView(
                timesheets: store.state.timesheets,
                timesheetChanges: store.state.timesheetsChanges,
                projects: store.state.projects,
                activities: store.state.activities,
                
                selectedProject: store.binding(for: \.selectedProject, action: ReportComponent.Action.projectSelected),
                selectedDate: store.binding(for: \.selectedDate, action: ReportComponent.Action.dateSelected),
                selectedReportType: store.binding(for: \.selectedReportType, action: ReportComponent.Action.reportTypeSelected),
                
                calendarTapped: { router.showSheet(.report(.calendar)) },
                filterTapped: { router.showSheet(.report(.filter)) },
                playTapped: { router.showSheet(.management(.kimai(.timesheetSheet(.new)))) },
                editTapped: { router.showSheet(.management(.kimai(.timesheetSheet($0)))) },
                deleteTapped: { store.send(.reports(.deleteTapped($0))) }
            )
        case .calendar:
            ReportCalendarView(
                months: store.state.months,
                selectedDate: store.state.selectedDate,
                lastYearTapped: { store.send(.calendar(.previousYearTapped)) },
                nextYearTapped: { store.send(.calendar(.nextYearTapped)) },
                monthTapped: { store.send(.calendar(.monthTapped($0))) }
            )
        case .filter:
            ReportFilterView(
                selectedProject: store.state.projects.first { $0.id == store.state.selectedProject },
                filterProjectsTapped: { router.push(.report(.filterProjects)) }
            )
        case .filterProjects:
            ReportFilterProjectsView(
                customers: store.state.customers,
                projects: store.state.projects,
                selectedProject: store.state.selectedProject,
                allProjectsTapped: { store.send(.filterProjects(.allProjectsTapped)) },
                projectTapped: {
                    router.dismiss()
                    store.send(.filterProjects(.projectTapped($0)))
                }
            )
        }
        
    }
    
    
}
