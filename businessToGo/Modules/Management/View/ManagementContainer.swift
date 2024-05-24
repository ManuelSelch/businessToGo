import SwiftUI
import ComposableArchitecture

struct ManagementContainer: View {
    let store: StoreOf<ManagementModule>
    
    
    var body: some View {
        VStack {
            getTimesheetPopup()
            
            NavigationStack(
                path: Binding(
                    get: { store.state.router.routes },
                    set: { store.send(.route(.set($0))) }
                )
            ) {
                ManagementRoute.kimai(.customers).createView(store)
                    .toolbar { ToolbarItem(placement: .topBarTrailing) { getHeader() } }
                    .navigationDestination(for: ManagementRoute.self) { route in
                        route.createView(store)
                        .toolbar { ToolbarItem(placement: .topBarTrailing) { getHeader() } }
                    }
                
            }
        }
        .sheet(item: Binding(
            get: { store.state.router.sheet },
            set: {
                if let route = $0 {
                    store.send(.route(.presentSheet(route)))
                } else {
                    store.send(.route(.dismissSheet))
                }
            }
        )) { route in
            NavigationStack {
                route.createView(store)
            }
        }
    }
}

extension ManagementContainer {
    @ViewBuilder func getTimesheetPopup() -> some View {
        if let timesheet = store.kimai.timesheets.records.first(where: { $0.end == nil }) {
            if
                let project = store.kimai.projects.records.first(where: { $0.id == timesheet.project }),
                let customer = store.kimai.customers.records.first(where: { $0.id == project.customer }),
                let activity = store.kimai.activities.records.first(where: { $0.id == timesheet.activity })
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
            selectedTeam: Binding(get: { store.state.kimai.selectedTeam } , set: { store.send(.kimai(.selectTeam($0))) }),
            route: store.state.router.routes.last,
            projects: store.kimai.projects.records,
            teams: store.kimai.teams.records,
            router: { store.send(.route($0)) },
            onSync: { store.send(.sync) }
        )
    }
}
