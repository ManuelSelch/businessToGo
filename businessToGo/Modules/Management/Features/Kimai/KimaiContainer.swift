import SwiftUI
import Redux

struct KimaiContainer: View {
    @ObservedObject var store: StoreOf<KimaiFeature>
    let route: KimaiFeature.Route
    
    var body: some View {
        switch(route){
        case .customersList:
            KimaiCustomersListView(
                customers: store.state.customers.records,
                customerChanges: store.state.customers.changes,
                customerTapped: { store.send(.customerTapped($0)) },
                customerEditTapped: { store.send(.customerEditTapped($0)) }
            )
        case let .customerSheet(customer):
            KimaiCustomerSheet(
                customer: customer,
                teams: store.state.teams.records,
                saveTapped: { store.send(.customerSaveTapped($0)) }
            )
            
            
        case let .projectsList(customer):
            KimaiProjectsListView(
                customer: customer,
                projects: store.state.projects.records,
                projectChanges: store.state.projects.changes,
                timesheets: store.state.timesheets.records,
                projectTapped: { store.send(.projectList(.projectTapped($0))) },
                projectEditTapped: { store.send(.projectList(.projectEditTapped($0))) }
            )
        case let .projectSheet(project):
            KimaiProjectSheet(
                project: project,
                customers: store.state.customers.records,
                saveTapped: { store.send(.projectSheet(.saveTapped($0))) }
            )
        case let .projectDetail(project):
            KimaiProjectDetailsView(
                project: project,
                customer: store.state.customers.records.first { $0.id == project.customer },
                timesheets: store.state.timesheets.records,
                timesheetChanges: store.state.timesheets.changes,
                activities: store.state.activities.records,
                users: store.state.users.records,
                deleteTapped: { store.send(.projectDetail(.deleteTapped($0))) },
                editTapped: { store.send(.projectDetail(.editTapped($0))) }
            )
        
        case let .timesheetSheet(timesheet):
            KimaiTimesheetSheet(
                timesheet: timesheet,
                customers: store.state.customers.records,
                projects: store.state.projects.records,
                activities: store.state.activities.records,
                saveTapped: { store.send(.timesheetSheet(.saveTapped($0))) }
            )
        }
    }
}
