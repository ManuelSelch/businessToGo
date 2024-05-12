import SwiftUI
import Redux
import OfflineSync

struct KimaiContainer: View {
    @EnvironmentObject var router: ManagementRouter
    @EnvironmentObject var store: Store<KimaiState, KimaiAction, ManagementDependency>
    
    @Binding var isPresentingPlayView: Bool
    
    var route: KimaiRoute
    let changes: [DatabaseChange]
    
    var body: some View {
        VStack {
            switch route {
            case .customers:
                getCustomersView()
                
            case .chart:
                getCustomersChartView()
                
            case .customer(let id):
                getProjectsChartView(id)
                // getCustomerView(id)
                
            case .project(let id):
                KimaiProjectContainer(id: id, changes: changes) // todo: reference changes
                
            case .timesheet(let id):
                getTimesheetView(id)
            }
        }
        .sheet(isPresented: $isPresentingPlayView) {
            getTimesheetView()
        }
    }
    
}

extension KimaiContainer {
    @ViewBuilder func getCustomersView() -> some View {
        KimaiCustomersView(
            customers: store.state.customers,
            onCustomerSelected: { customer in
                router.navigate(.kimai(.customer(customer)))
            }
        )
    }
    
    @ViewBuilder func getCustomersChartView() -> some View {
        KimaiCustomersChartView(
            customers: store.state.customers,
            projects: store.state.projects,
            timesheets: store.state.timesheets,
            
            customerClicked: { customer in
                router.navigate(.kimai(.customer(customer)))
            }
        )
    }
    
    @ViewBuilder func getProjectsChartView(_ customer: Int) -> some View {
        KimaiProjectsChartView(
            projects: store.state.projects.filter { $0.customer == customer },
            timesheets: store.state.timesheets,
            projectClicked: { project in
                router.navigate(.kimai(.project(project)))
            }
        )
    }
    
    @ViewBuilder func getCustomerView(_ id: Int) -> some View {
        if let customer = store.state.customers.first(where: {$0.id == id}) {
            KimaiCustomerView(
                customer: customer,
                projects: store.state.projects,
                onProjectClicked: { project in
                    router.navigate(.kimai(.project(project)))
                }
            )
        }else {
            Text("Error: Customer not found")
        }
    }
    
    
    @ViewBuilder func getTimesheetView(_ id: Int? = nil) -> some View {
        let timesheet = store.state.timesheets.first { $0.id == id }
        
        KimaiPlayView(
            timesheet: timesheet,
            
            isPresentingPlayView: $isPresentingPlayView,
            
            customers: store.state.customers,
            projects: store.state.projects,
            activities: store.state.activities,
            
            onSave: saveTimesheet
        )
        
        
    }
}

extension KimaiContainer {
    func saveTimesheet(_ timesheeet: KimaiTimesheet){
        if(timesheeet.id == -1){ // create
            store.send(.timesheets(.create(timesheeet)))
        }else { // update
            store.send(.timesheets(.update(timesheeet)))
            router.back()
        }
        
    }
}
