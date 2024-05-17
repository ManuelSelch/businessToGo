import SwiftUI
import Redux
import OfflineSync

struct KimaiContainer: View {
    @EnvironmentObject var router: ManagementRouter
    @EnvironmentObject var store: Store<KimaiState, KimaiAction, ManagementDependency>
    
    @Binding var selectedTeam: Int
    @Binding var timesheetView: KimaiTimesheet?
    
    @State var customerView: KimaiCustomer?
    @State var projectView: KimaiProject?
    
    var route: KimaiRoute
    
    var onProjectClicked: (_ kimaiProject: Int) -> ()
    
    var body: some View {
        VStack {
            switch route {
            case .customers:
                getCustomersView()
                
            case .customer(let id):
                getProjectsView(id)
                
            case .project(let id):
                getTimesheetsView(id)
            }
        }
        .sheet(item: $customerView){ customer in
            KimaiCustomerSheet(
                customer: customer,
                teams: store.state.teams,
                onSave: { customer in
                    let isCreate = (customer.id == KimaiCustomer.new.id)
                    if(isCreate){
                        store.send(.customers(.create(customer)))
                    }else {
                        store.send(.customers(.update(customer)))
                    }
                    customerView = nil
                }
            )
        }
        .sheet(item: $projectView){ project in
            KimaiProjectSheet(
                project: project,
                customers: store.state.customers,
                onSave: { project in
                    let isCreate = (project.id == KimaiProject.new.id)
                    if(isCreate){
                        store.send(.projects(.create(project)))
                    }else {
                        store.send(.projects(.update(project)))
                    }
                    projectView = nil
                }
            )
        }
    }
    
}

extension KimaiContainer {
    @ViewBuilder func getCustomersView() -> some View {
        KimaiCustomersView(
            customers: store.state.customers.filter { 
                if selectedTeam == -1 {
                    return true
                } else {
                    return $0.teams.contains(selectedTeam)
                }
            },
            changes: store.state.customerTracks,
            onCustomerSelected: { customer in
                router.navigate(.kimai(.customer(customer)))
            },
            onEdit: { customer in
                customerView = customer
            }
        )
    }
    
    @ViewBuilder func getProjectsView(_ customer: Int) -> some View {
        KimaiProjectsView(
            customer: customer,
            projects: store.state.projects.filter { $0.customer == customer },
            timesheets: store.state.timesheets,
            changes: store.state.projectTracks,
            projectClicked: onProjectClicked,
            onEdit: { project in
                projectView = project
            }
        )
    }
    
    @ViewBuilder func getTimesheetsView(_ project: Int) -> some View {
        let timesheets = store.state.timesheets.filter { $0.project == project }
        
        KimaiTimesheetsView(
            timesheets: timesheets,
            activities: store.state.activities,
            changes: store.state.timesheetTracks,
            
            onEditClicked: { id in
                timesheetView = store.state.timesheets.first(where: { $0.id == id })
            },
            onStopClicked: { id in
                if var timesheet = store.state.timesheets.first(where: {$0.id == id}) {
                    timesheet.end = "\(Date.now)"
                    store.send(.timesheets(.update(timesheet)))
                }
            },
            onDeleteClicked: { timesheet in
                store.send(.timesheets(.delete(timesheet)))
            }
        )
    }
}
