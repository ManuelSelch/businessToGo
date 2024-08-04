import SwiftUI
import Redux

import KimaiUI

struct KimaiContainer: View {
    @ObservedObject var store: ViewStore
    let route: Route
    
    var body: some View {
        switch(route) {
        case .customersList:
            KimaiCustomersListView(
                customers: store.state.customers.filter {
                    if let team = store.state.selectedTeam {
                        return $0.teams.contains(team)
                    } else {
                        return true
                    }
                },
                customerTapped: { store.send(.customer(.tapped($0))) },
                customerEditTapped: { store.send(.customer(.editTapped($0))) }
            )
        case let .customerSheet(customer):
            KimaiCustomerSheet(
                customer: customer,
                teams: store.state.teams,
                saveTapped: { store.send(.customer(.saveTapped($0))) }
            )
            
        case let .projectsList(customer):
            KimaiProjectsListView(
                customer: customer,
                projects: store.state.projects,
                timesheets: store.state.timesheets,
                projectTapped: { store.send(.project(.tapped($0))) },
                projectEditTapped: { store.send(.project(.editTapped($0))) }
            )
        case let .projectSheet(project):
            KimaiProjectSheet(
                project: project,
                customers: store.state.customers,
                saveTapped: { store.send(.project(.saveTapped($0))) }
            )
        case let .projectDetail(id):
            if let project = store.state.projects.first(where: {$0.id == id}) {
                KimaiProjectDetailsView(
                    project: project,
                    customer: store.state.customers.first { $0.id == project.customer },
                    timesheets: store.state.timesheets,
                    activities: store.state.activities,
                    users: store.state.users,
                    deleteTapped: { store.send(.timesheet(.deleteTapped($0))) },
                    editTapped: { store.send(.timesheet(.editTapped($0))) },
                    activityTapped: { _ in }
                )
            } else {
                Text("project not found")
            }
            
        
        case let .timesheetSheet(timesheet):
            KimaiTimesheetSheet(
                timesheet: timesheet,
                customers: store.state.customers,
                projects: store.state.projects,
                activities: store.state.activities,
                saveTapped: { store.send(.timesheet(.saveTapped($0))) }
            )
        }
    }
}
