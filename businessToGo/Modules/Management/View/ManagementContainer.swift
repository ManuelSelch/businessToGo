import SwiftUI
import Redux

struct ManagementContainer: View {
    @EnvironmentObject var router: ManagementRouter
    @EnvironmentObject var store: Store<ManagementState, ManagementAction, ManagementDependency>
    
    @State var timesheetView: KimaiTimesheet?
    
    var body: some View {
        VStack {
            
            getTimesheetPopup()
            
            NavigationStack(path: $router.routes) {
                getKimai(.customers)
                    .toolbar { getHeader() }
                    .navigationDestination(for: ManagementRoute.self) { route in
                        VStack {
                            switch route {
                            case .kimai(let route): getKimai(route)
                            case .taiga(let route): getTaiga(route)
                            }
                        }
                        .toolbar { getHeader() }
                    }
                
            }
        }
        .sheet(item: $timesheetView) { timesheet in
            NavigationView {
                getTimesheetSheet(timesheet)
            }
        }
    }
}

extension ManagementContainer {
    @ViewBuilder func getKimai(_ route: KimaiRoute) -> some View {
        KimaiContainer(timesheetView: $timesheetView, route: route)
            .environmentObject(store.lift(\.kimai, ManagementAction.kimai, store.dependencies))
    }
    
    @ViewBuilder func getTaiga(_ route: TaigaScreen) -> some View {
        TaigaContainer(route: route)
            .environmentObject(store.lift(\.taiga, ManagementAction.taiga, store.dependencies))
    }
    
    @ViewBuilder func getTimesheetSheet(_ timesheet: KimaiTimesheet) -> some View {
        KimaiTimesheetSheet(
            timesheet: timesheet,
            customers: store.state.kimai.customers,
            projects: store.state.kimai.projects,
            activities: store.state.kimai.activities,
            
            onSave: saveTimesheet,
            timesheetView: $timesheetView
        )
        
        
    }
    
    @ViewBuilder func getTimesheetPopup() -> some View {
        if let timesheet = store.state.kimai.timesheets.first(where: { $0.end == nil }) {
            if
                let project = store.state.kimai.projects.first(where: { $0.id == timesheet.project }),
                let customer = store.state.kimai.customers.first(where: { $0.id == project.customer }),
                let activity = store.state.kimai.activities.first(where: { $0.id == timesheet.activity })
            {
                KimaiTimesheetPopup(
                    timesheet: timesheet,
                    customer: customer,
                    project: project,
                    activity: activity,
                    onStop: {
                        var timesheet = timesheet
                        timesheet.end = "\(Date.now)"
                        store.send(.kimai(.timesheets(.update(timesheet))))
                    },
                    onShow: {
                        let route = ManagementRoute.kimai(.project(project.id))
                        if(router.routes.last != route){
                            router.navigate(route)
                        }
                    }
                )
            } else {
                Text("error parsing timesheet record")
                    .foregroundStyle(Color.red)
            }
            
            
        }
    }
    
    @ViewBuilder func getHeader() -> some View {
        ManagementHeaderView(
            timesheetView: $timesheetView,
            route: router.routes.last, 
            projects: store.state.kimai.projects,
            onChart: {
                router.navigate(.kimai(.chart))
            },
            onProjectClicked: { kimaiProject in
                if let integration = store.state.integrations.first(where: {$0.id == kimaiProject})
                {
                    router.navigate(.taiga(.project(integration.taigaProjectId)))
                }
            },
            onSync: { store.send(.sync) }
        )
    }
}

extension ManagementContainer {
    func saveTimesheet(_ timesheeet: KimaiTimesheet){
        if(timesheeet.id == KimaiTimesheet.new.id){ // create
            store.send(.kimai(.timesheets(.create(timesheeet))))
        }else { // update
            store.send(.kimai(.timesheets(.update(timesheeet))))
            timesheetView = nil
        }
        
    }
}
