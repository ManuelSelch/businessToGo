import SwiftUI
import Redux

import ManagementUI
import KimaiUI
import KimaiApp
import TaigaApp

public struct ManagementContainer: View {
    @ObservedObject var store: StoreOf<ManagementFeature>
    
    public init(store: StoreOf<ManagementFeature>) {
        self.store = store
    }
    
    public var body: some View {
        RouterView(
            store: store.lift(
                \.router,
                 { ManagementFeature.Action.intern(.router($0)) }
            )
        ) { route in
            VStack {
                switch(route) {
                case let .kimai(route):
                    KimaiContainer(
                        store: store.lift(\.kimai, {ManagementFeature.Action.intern(.kimai($0))}),
                        route: route
                    )
                case let .taiga(route):
                    TaigaContainer(
                        store: store.lift(\.taiga, {ManagementFeature.Action.intern(.taiga($0))}),
                        route: route
                    )
                case .assistant:
                    KimaiAssistantContainer(
                        store: store.lift(\.kimai, {ManagementFeature.Action.intern(.kimai($0))})
                    )
                    
                }
                
                if  let timesheet = store.state.kimai.timesheets.first(where: { $0.end == nil }),
                    let activity = store.state.kimai.activities.first(where: { $0.id == timesheet.activity }),
                    let project = store.state.kimai.projects.first(where: { $0.id == timesheet.project }),
                    let customer = store.state.kimai.customers.first(where: { $0.id == project.customer })
                {
                    KimaiTimesheetPopup(
                        customer: customer,
                        project: project,
                        activity: activity,
                        timesheet: timesheet,
                        timesheetTapped: { store.send( .intern(.timesheetTapped(timesheet)) ) },
                        stopTapped: { store.send( .intern(.stopTapped(timesheet)) ) }
                    )
                }
            }
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    ManagementHeaderView(
                        selectedTeam: store.binding(
                            for: \.kimai.selectedTeam,
                            action: { ManagementFeature.Action.intern(.kimai(.customerList(.teamSelected($0)))) }
                        ),
                        route: store.state.router.currentRoute,
                        projects: store.state.kimai.projects,
                        teams: store.state.kimai.teams,
                        syncTapped: { store.send(.sync) }, 
                        projectTapped: { _ in },
                        playTapped: { store.send(.intern(.playTapped($0))) }
                    )
                }
                #endif
            }
        }
    }
}

