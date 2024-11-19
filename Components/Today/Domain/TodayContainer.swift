import SwiftUI
import Redux

import KimaiUI

struct TodayContainer: View {
    var store: Store<TodayComponent.State, TodayComponent.Action>
    let route: TodayComponent.Route
    
    var body: some View {
        switch(route) {
        case .today:
            DashboardView(
                timesheets: store.state.timesheets,
                customers: store.state.customers,
                projects: store.state.projects,
                
                customerTapped: { store.send(.customerTapped($0.id)) }
            )
        case let .projects(for: customer):
            ProjectsView(
                projects: store.state.projects.filter({$0.customer == customer}),
                
                projectTapped: { store.send(.projectTapped($0.id)) }
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

