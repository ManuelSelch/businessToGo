import SwiftUI
import Redux
import OfflineSync

struct KimaiContainer: View {
    @ObservedObject var store: Store<KimaiState, KimaiAction, ManagementDependency>
    
    var route: KimaiRoute
    var router: (RouteAction<ManagementRoute>) -> ()
    
    var onProjectClicked: (Int) -> ()
    
    var body: some View {
        VStack {
            switch route {
            case .customers:
                getCustomersView()
            case .customer(let customer):
                getCustomerView(customer)
                
            case .projects(for: let id):
                getProjectsView(for: id)
            case .project(let project):
                getProjectView(project)
                
            case .timesheet(let timesheet):
                getTimesheetView(timesheet)
            }
        }
    }
    
}

extension KimaiContainer {
    @ViewBuilder func getCustomersView() -> some View {
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
    }
    
    @ViewBuilder func getCustomerView(_ customer: KimaiCustomer) -> some View {
        KimaiCustomerSheet(
            customer: customer,
            teams: store.state.teams,
            onSave: {
                if($0.id == KimaiCustomer.new.id){
                    store.send(.customers(.create($0)))
                } else {
                    store.send(.customers(.update($0)))
                }
            }
        )
    }
    
    @ViewBuilder func getProjectsView(for customer: Int) -> some View {
        KimaiProjectsView(
            customer: customer,
            projects: store.state.projects.filter { $0.customer == customer },
            timesheets: store.state.timesheets,
            changes: store.state.projectTracks,
            projectClicked: onProjectClicked,
            onEdit: { router(.presentSheet(.kimai(.project($0)))) }
        )
    }
    
    @ViewBuilder func getProjectView(_ project: KimaiProject) -> some View {
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
    }
    
    @ViewBuilder func getTimesheetView(_ timesheet: KimaiTimesheet) -> some View {
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
