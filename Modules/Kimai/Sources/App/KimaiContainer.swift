import SwiftUI
import Redux

import KimaiUI
import KimaiCore

public struct KimaiContainer: View {
    @ObservedObject var store: StoreOf<KimaiFeature>
    let route: KimaiRoute
    
    public init(store: StoreOf<KimaiFeature>, route: KimaiRoute) {
        self.store = store
        self.route = route
    }
    
    public var body: some View {
        switch(route){
        case .customersList:
            KimaiCustomersListView(
                customers: store.state.customers.filter {
                    if let team = store.state.selectedTeam {
                        return $0.teams.contains(team)
                    } else {
                        return true
                    }
                },
                customerTapped: { store.send(.customerList(.tapped($0))) },
                customerEditTapped: { store.send(.customerList(.editTapped($0))) }
            )
        case let .customerSheet(customer):
            KimaiCustomerSheet(
                customer: customer,
                teams: store.state.teams,
                saveTapped: { store.send(.customerList(.saveTapped($0))) }
            )
            
            
        case let .projectsList(customer):
            KimaiProjectsListView(
                customer: customer,
                projects: store.state.projects,
                timesheets: store.state.timesheets,
                projectTapped: { store.send(.projectList(.projectTapped($0))) },
                projectEditTapped: { store.send(.projectList(.projectEditTapped($0))) }
            )
        case let .projectSheet(project):
            KimaiProjectSheet(
                project: project,
                customers: store.state.customers,
                saveTapped: { store.send(.projectSheet(.saveTapped($0))) }
            )
        case let .projectDetail(project):
            KimaiProjectDetailsView(
                project: project,
                customer: store.state.customers.first { $0.id == project.customer },
                timesheets: store.state.timesheets,
                activities: store.state.activities,
                users: store.state.users,
                deleteTapped: { store.send(.projectDetail(.deleteTapped($0))) },
                editTapped: { store.send(.projectDetail(.editTapped($0))) },
                activityTapped: { _ in }
            )
        
        case let .timesheetSheet(timesheet):
            KimaiTimesheetSheet(
                timesheet: timesheet,
                customers: store.state.customers,
                projects: store.state.projects,
                activities: store.state.activities,
                saveTapped: { store.send(.timesheetSheet(.saveTapped($0))) }
            )
        }
    }
}
