import SwiftUI
import Redux

struct ManagementContainer: View {
    @ObservedObject var store: Store<ManagementState, ManagementAction, ManagementDependency>
    
    @State var selectedTeam: Int = -1
    
    var body: some View {
        VStack {
            
            getTimesheetPopup()
            
            NavigationStack(
                path: Binding(
                    get: { store.state.routes },
                    set: { store.send(.route(.set($0))) }
                )
            ) {
                getKimai(.customers)
                    .toolbar { ToolbarItem(placement: .topBarTrailing) { getHeader() } }
                    .navigationDestination(for: ManagementRoute.self) { route in
                        VStack {
                            switch route {
                            case .kimai(let route): getKimai(route)
                            case .taiga(let route): getTaiga(route)
                            }
                        }
                        .toolbar { ToolbarItem(placement: .topBarTrailing) { getHeader() } }
                    }
                
            }
        }
        .sheet(item: Binding(
            get: { store.state.sheet },
            set: {
                if let route = $0 {
                    store.send(.route(.presentSheet(route)))
                } else {
                    store.send(.route(.dismissSheet))
                }
            }
        )) { route in
            route.createView(store)
        }
    }
}

extension ManagementContainer {
    @ViewBuilder func getKimai(_ route: KimaiRoute) -> some View {
        KimaiContainer(
            store: store.lift(\.kimai, ManagementAction.kimai, store.dependencies),
            route: route,
            router: { store.send(.route($0)) },
            onProjectClicked: { kimaiProject in
                if let integration = store.state.integrations.first(where: {$0.id == kimaiProject})
                {
                    store.send(.route(.push(
                        .taiga(.project(integration))
                    )))
                }
            }
        )
    }
    
    @ViewBuilder func getTaiga(_ route: TaigaScreen) -> some View {
        TaigaContainer(
            store: store.lift(\.taiga, ManagementAction.taiga, store.dependencies),
            route: route
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
                    onShow: { 
                        // todo: show timesheet session
                        /*
                        let route = ManagementRoute.kimai(.project(project.id))
                        if(router.routes.last != route){
                            router.navigate(route)
                        }
                         */
                    },
                    onStop: {
                        var timesheet = timesheet
                        timesheet.end = "\(Date.now)"
                        store.send(.kimai(.timesheets(.update(timesheet))))
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
            selectedTeam: $selectedTeam,
            route: store.state.routes.last,
            projects: store.state.kimai.projects,
            teams: store.state.kimai.teams,
            router: { store.send(.route($0)) },
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
            store.send(.route(.dismissSheet))
        }
        
    }
}
