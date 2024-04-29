import SwiftUI
import Redux


struct KimaiContainer: View {
    @EnvironmentObject var router: ManagementRouter
    @EnvironmentObject var store: Store<KimaiState, KimaiAction, ManagementDependency>
    
    @State var isPresentingPlayView = false
    
    var route: KimaiRoute
    
    var showTaigaProject: (_ kimaiProject: Int) -> ()
    
    var body: some View {
        VStack {
            switch route {
            case .customers:
                getCustomersView()
                
            case .chart:
                getChartView()
                
            case .customer(let id):
                getCustomerView(id)
                
            case .project(let id):
                KimaiProjectContainer(id: id, changes: []) // todo: reference changes
                
            case .timesheet(let id):
                getTimesheetView(id)
            }
        }
        .toolbar {
            KimaiHeaderView(isPresentingPlayView: $isPresentingPlayView, route: route, onChart: showChart, onProjectClicked: showTaigaProject)
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
            onCustomerSelected: showCustomer
        )
    }
    
    @ViewBuilder func getChartView() -> some View {
        KimaiChartView(
            projects: store.state.projects,
            timesheets: store.state.timesheets
        )
    }
    
    @ViewBuilder func getCustomerView(_ id: Int) -> some View {
        if let customer = store.state.customers.first(where: {$0.id == id}) {
            KimaiCustomerView(
                customer: customer,
                projects: store.state.projects,
                onProjectClicked: showProject
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
    
    func goBack(){
        router.back()
    }

    func showCustomers(){
        router.navigate(.kimai(.customers))
    }
    
    func showCustomer(_ customer: Int){
        router.navigate(.kimai(.customer(customer)))
    }
    
    func showProject(_ project: Int){
        router.navigate(.kimai(.project(project)))
    }
    
    
    
    
    
   
    
    func saveTimesheet(_ timesheeet: KimaiTimesheet){
        if(timesheeet.id == -1){ // create
            store.send(.timesheets(.create(timesheeet)))
        }else { // update
            store.send(.timesheets(.update(timesheeet)))
            goBack()
        }
        
    }
    
    func showChart() {
        router.navigate(.kimai(.chart))
    }
}
