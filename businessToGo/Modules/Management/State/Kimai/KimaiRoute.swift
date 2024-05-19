import Foundation
import SwiftUI
import Redux

enum KimaiRoute: Equatable, Hashable, Codable {
    case customers
    case customer(KimaiCustomer)
    
    case projects(for: Int)
    case project(KimaiProject)
    
    case timesheet(KimaiTimesheet)
}


extension KimaiRoute {

    @ViewBuilder func createView(
        store: StoreOf<KimaiModule>,
        router: @escaping (RouteAction<ManagementRoute>) -> (),
        onProjectClicked: @escaping (Int) -> ()
    ) -> some View {
        switch self {
        case .customers:
            KimaiCustomersView(
                customers: store.state.customers.filter {
                    if let team = store.state.selectedTeam {
                        return $0.teams.contains(team)
                    } else {
                        return true
                    }
                },
                changes: store.state.customerTracks,
                router: { router($0) }
            )
        case .customer(let customer):
            KimaiCustomerSheet(
                customer: customer,
                teams: store.state.teams,
                onSave: {
                    if($0.id == KimaiCustomer.new.id){
                        store.send(.customers(.create($0)))
                    } else {
                        store.send(.customers(.update($0)))
                    }
                    router(.dismissSheet)
                }
            )
            
        case .projects(for: let id):
            KimaiProjectsView(
                customer: id,
                projects: store.state.projects.filter { $0.customer == id },
                timesheets: store.state.timesheets,
                changes: store.state.projectTracks,
                projectClicked: onProjectClicked,
                onEdit: { router(.presentSheet(.kimai(.project($0)))) }
            )
            
        case .project(let project):
            KimaiProjectSheet(
                project: project,
                customers: store.state.customers,
                onSave: {
                    if($0.id == KimaiProject.new.id){
                        store.send(.projects(.create($0)))
                    } else {
                        store.send(.projects(.update($0)))
                    }
                }
            )
            
        case .timesheet(let timesheet):
            KimaiTimesheetSheet(
                timesheet: timesheet,
                customers: store.state.customers,
                projects: store.state.projects,
                activities: store.state.activities,
                onSave: {
                    if($0.id == KimaiTimesheet.new.id){
                        store.send(.timesheets(.create($0)))
                    } else {
                        store.send(.timesheets(.update($0)))
                    }
                    router(.dismissSheet)
                }
            )
        }
    }
}
