import SwiftUI
import Redux

import CommonUI
import KimaiUI
import OfflineSyncCore

struct KimaiContainer: View {
    @ObservedObject var store: ViewStoreOf<KimaiComponent>
    let route: KimaiComponent.Route
    
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
                changes: store.state.customerChanges,
                
                customerTapped: { store.send(.customer(.tapped($0))) },
                customerEditTapped: { store.send(.customer(.editTapped($0))) },
                customerDeleteTapped: { store.send(.customer(.deleteTapped($0))) },
                customerCreated: { store.send(.customer(.created($0))) }
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
                projectEditTapped: { store.send(.project(.editTapped($0))) },
                projectDeleteTapped: { store.send(.project(.deleteTapped($0))) },
                projectCreated: { store.send(.project(.created($0))) }
            )
        case let .projectSheet(project):
            KimaiProjectSheet(
                project: project,
                customers: store.state.customers,
                saveTapped: { store.send(.project(.saveTapped($0))) }
            )
        case let .projectDetail(id):
            if let project = store.state.projects.get(id) {
                KimaiProjectDetailsView(
                    project: project,
                    customer: store.state.customers.first { $0.id == project.customer },
                    timesheets: store.state.timesheets,
                    activities: store.state.activities,
                    users: store.state.users,
                    
                    timesheetEditTapped: { store.send(.timesheet(.editTapped($0))) },
                    timesheetDeleteTapped: { store.send(.timesheet(.deleteTapped($0))) },
                    
                    
                    activityEditTapped: { store.send(.activity(.editTapped($0))) },
                    activityDeleteTapped: { store.send(.activity(.deleteTapped($0))) },
                    activityCreated: { store.send(.activity(.created($0))) }
                )
            } else {
                Text("project not found")
            }
            
        case let .activitySheet(activity):
            KimaiActivitySheet(
                activity: activity,
                projects: store.state.projects,
                saveTapped: { store.send(.activity(.saveTapped($0))) }
            )
        
        case let .timesheetSheet(timesheet):
            KimaiTimesheetSheet(
                timesheet: timesheet,
                customers: store.state.customers,
                projects: store.state.projects,
                activities: store.state.activities,
                saveTapped: { store.send(.timesheet(.saveTapped($0))) }
            )
            
        case let .popup(route):
            switch(route) {
            case .customerDeleteNotAllowed:
                PopupView(
                    title: "Customer delete not allowed",
                    message: "Remove linked projects",
                    
                    okayTapped: {},
                    cancelTapped: { store.send(.popupCloseTapped) }
                )
            case .customerDeleteConfirmation(let customer):
                PopupView(
                    title: "Customer delete",
                    message: "Are you sure?",
                    
                    okayTapped: { store.send(.customer(.deleteConfirmed(customer))) },
                    cancelTapped: { store.send(.popupCloseTapped) }
                )
                
            case .projectDeleteNotAllowed(_):
                PopupView(
                    title: "Project delete not allowed",
                    message: "Remove linked timesheets",
                    
                    okayTapped: {},
                    cancelTapped: { store.send(.popupCloseTapped) }
                )
            case .projectDeleteConfirmation(let project):
                PopupView(
                    title: "Project delete",
                    message: "Are you sure?",
                    
                    okayTapped: { store.send(.project(.deleteConfirmed(project))) },
                    cancelTapped: { store.send(.popupCloseTapped) }
                )
                
            case .activityDeleteConfirmation(let activity):
                PopupView(
                    title: "Activity delete",
                    message: "Are you sure?",
                    
                    okayTapped: { store.send(.activity(.deleteConfirmed(activity))) },
                    cancelTapped: { store.send(.popupCloseTapped) }
                )
                
            case .timesheetDeleteConfirmation(let timesheet):
                PopupView(
                    title: "Timesheet delete",
                    message: "Are you sure?",
                    
                    okayTapped: { store.send(.timesheet(.deleteConfirmed(timesheet))) },
                    cancelTapped: { store.send(.popupCloseTapped) }
                )
            }
        }
    }
}
