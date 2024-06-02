import SwiftUI
import Redux

struct ReportContainer: View {
    @ObservedObject var store: StoreOf<ReportFeature>
    
    var body: some View {
        RouterView(store: store.lift(\.router, ReportFeature.Action.router)) { route in
            VStack {
                switch(route) {
                case .reports:
                    ReportsView(
                        timesheets: store.state.timesheets,
                        timesheetChanges: store.state.timesheetChanges,
                        projects: store.state.projects,
                        activities: store.state.activities,
                        
                        selectedProject: store.binding(for: \.selectedProject, action: ReportFeature.Action.projectSelected),
                        selectedDate: store.binding(for: \.selectedDate, action: ReportFeature.Action.dateSelected),
                        calendarTapped: { store.send(.reports(.calendarTapped)) },
                        filterTapped: { store.send(.reports(.filterTapped)) },
                        playTapped: { store.send(.reports(.playTapped)) },
                        deleteTapped: { store.send(.reports(.deleteTapped($0))) }
                    )
                case .calendar:
                    ReportCalendarView(
                        months: store.state.months,
                        selectedDate: store.state.selectedDate,
                        lastYearTapped: { store.send(.calendar(.lastYearTapped)) },
                        nextYearTapped: { store.send(.calendar(.nextYearTapped)) },
                        monthTapped: { store.send(.calendar(.monthTapped($0))) }
                    )
                case .filter:
                    ReportFilterView(
                        selectedProject: store.state.projects.first { $0.id == store.state.selectedProject },
                        filterProjectsTapped: { store.send(.filter(.projectsTapped)) }
                    )
                case .filterProjects:
                    ReportFilterProjectsView(
                        customers: store.state.customers,
                        projects: store.state.projects,
                        selectedProject: store.state.selectedProject,
                        allProjectsTapped: { store.send(.filterProjects(.allProjectsTapped)) },
                        projectTapped: { store.send(.filterProjects(.projectTapped($0))) }
                    )
                }
            }
        }
        
    }
    
    
}
