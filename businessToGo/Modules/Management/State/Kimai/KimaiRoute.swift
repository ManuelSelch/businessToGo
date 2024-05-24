import Foundation
import SwiftUI
import ComposableArchitecture
import Redux

enum KimaiRoute: Equatable, Hashable, Codable {
    case customers
    case customer(KimaiCustomer)
    
    case projects(for: Int)
    case project(KimaiProject)
    case projectDetails(Int)
    
    case timesheet(KimaiTimesheet)
}


extension KimaiRoute {

    @ViewBuilder func createView(
        store: ComposableArchitecture.StoreOf<KimaiModule>,
        router: @escaping (RouteModule<ManagementRoute>.Action) -> (),
        onProjectClicked: @escaping (Int) -> ()
    ) -> some View {
        switch self {
        case .customers:
            /*
            KimaiCustomersView(
                customers: store.customers.records.filter {
                    if let team = store.selectedTeam {
                        return $0.teams.contains(team)
                    } else {
                        return true
                    }
                },
                changes: store.customers.changes,
                router: { router($0) }
            )
             */
            EmptyView()
        case .customer(let customer):
            /*
            KimaiCustomerSheet(
                customer: customer,
                teams: store.teams.records,
                onSave: {
                    if($0.id == KimaiCustomer.new.id){
                        store.send(.customers(.create($0)))
                    } else {
                        store.send(.customers(.update($0)))
                    }
                    router(.dismissSheet)
                }
            )
             */
            EmptyView()
            
        case .projects(for: let id):
            /*
            KimaiProjectsView(
                customer: id,
                projects: store.projects.records.filter { $0.customer == id },
                timesheets: store.timesheets.records,
                changes: store.projects.changes,
                projectClicked: onProjectClicked,
                onEdit: { router(.presentSheet(.kimai(.project($0)))) }
            )
             */
            EmptyView()
            
        case .project(let project):
            KimaiProjectSheet(
                project: project,
                customers: store.customers.records,
                onSave: {
                    if($0.id == KimaiProject.new.id){
                        store.send(.projects(.create($0)))
                    } else {
                        store.send(.projects(.update($0)))
                    }
                }
            )
        
        case .projectDetails(let id):
            if let project = store.projects.records.first(where: { $0.id == id }) {
                KimaiProjectDetailsView(
                    project: project,
                    customer: store.customers.records.first { $0.id == project.customer },
                    activities: store.activities.records,
                    timesheets: store.timesheets.records,
                    users: store.users.records
                )
            } else {
                Text("project not found")
            }
            
        case .timesheet(let timesheet):
            KimaiTimesheetSheet(
                timesheet: timesheet,
                customers: store.customers.records,
                projects: store.projects.records,
                activities: store.activities.records,
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
