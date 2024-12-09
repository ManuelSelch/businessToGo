import SwiftUI
import Redux
import Dependencies

import KimaiUI

struct TodayContainer: View {
    @Dependency(\.router) var router
    var store: Store<TodayComponent.State, TodayComponent.Action>
    let route: TodayComponent.Route
    
    var body: some View {
        switch(route) {
        case .today:
            DashboardView(
                timesheets: store.state.timesheets,
                customers: store.state.customers,
                projects: store.state.projects,
                
                customerTapped: { router.push(.today(.projects(for: $0.id))) }
            )
        case let .projects(for: customer):
            ProjectsView(
                projects: store.state.projects.filter({$0.customer == customer}),
                
                projectTapped: { router.push(.today(.timesheet(for: $0.id))) }
            )
       
        case let .timesheet(for: project):
            TimesheetView(
                project: project, 
                activities: store.state.activities,
                
                saveTapped: { store.send(.timesheetSaveTapped($0)) }
            )
        }
    }
}

