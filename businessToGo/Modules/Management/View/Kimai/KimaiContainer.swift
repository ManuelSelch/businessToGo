import SwiftUI
import Redux


struct KimaiContainer: View {
    @EnvironmentObject var router: ManagementRouter
    @EnvironmentObject var store: Store<KimaiState, KimaiAction>
    
    @State var isPresentingPlayView = false
    
    var route: KimaiRoute
    
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
                KimaiProjectContainer(id)
                
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
            customers: Env.kimai.customers.get(),
            onCustomerSelected: showCustomer
        )
    }
    
    @ViewBuilder func getChartView() -> some View {
        KimaiChartView(
            projects: Env.kimai.projects.get(),
            timesheets: Env.kimai.timesheets.get()
        )
    }
    
    @ViewBuilder func getCustomerView(_ id: Int) -> some View {
        if let customer = Env.kimai.customers.get(by: id) {
            KimaiCustomerView(
                customer: customer,
                projects: Env.kimai.projects.get(),
                onProjectClicked: showProject
            )
        }else {
            Text("Error: Customer not found")
        }
    }
    
    
    @ViewBuilder func getTimesheetView(_ id: Int? = nil) -> some View {
        let timesheet = Env.kimai.timesheets.get().first { $0.id == id }
        
        KimaiPlayView(
            timesheet: timesheet,
            
            isPresentingPlayView: $isPresentingPlayView,
            
            customers: Env.kimai.customers.get(),
            projects: Env.kimai.projects.get(),
            activities: Env.kimai.activities.get(),
            
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
    
    func showTaigaProject(_ kimaiProject: Int){
        if let integration = Env.integrations.get(by: kimaiProject)
        {
            router.navigate(.taiga(.project(integration.taigaProjectId)))
        }
    }
    
    
    
}
