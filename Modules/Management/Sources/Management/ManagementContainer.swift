import SwiftUI
import Redux

public struct ManagementContainer: View {
    @ObservedObject var store: StoreOf<ManagementFeature>
    
    public init(store: StoreOf<ManagementFeature>) {
        self.store = store
    }
    
    public var body: some View {
        RouterView(store: store.lift(\.router, ManagementFeature.Action.router)) { route in
            VStack {
                switch(route) {
                case let .kimai(route):
                    KimaiContainer(
                        store: store.lift(\.kimai, ManagementFeature.Action.kimai),
                        route: route
                    )
                case let .taiga(route):
                    TaigaContainer(
                        store: store.lift(\.taiga, ManagementFeature.Action.taiga),
                        route: route
                    )
                case .assistant:
                    SetupAssistantView(
                        steps: store.state.kimai.steps,
                        stepTapped: { store.send(.kimai(.stepTapped)) },
                        dashboardTapped: { store.send(.kimai(.dashboardTapped)) }
                    )
                    
                }
                
                if  let timesheet = store.state.kimai.timesheets.records.first(where: { $0.end == nil }),
                    let activity = store.state.kimai.activities.records.first(where: { $0.id == timesheet.activity }),
                    let project = store.state.kimai.projects.records.first(where: { $0.id == timesheet.project }),
                    let customer = store.state.kimai.customers.records.first(where: { $0.id == project.customer })
                {
                    KimaiTimesheetPopup(
                        customer: customer,
                        project: project,
                        activity: activity,
                        timesheet: timesheet,
                        timesheetTapped: { store.send(.timesheetTapped(timesheet)) },
                        stopTapped: { store.send(.stopTapped(timesheet)) }
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ManagementHeaderView(
                        selectedTeam: store.binding(
                            for: \.kimai.selectedTeam,
                            action: { ManagementFeature.Action.kimai(.teamSelected($0)) }
                        ),
                        route: store.state.router.currentRoute,
                        projects: store.state.kimai.projects.records,
                        teams: store.state.kimai.teams.records,
                        syncTapped: { store.send(.sync) }, 
                        projectTapped: { _ in },
                        playTapped: { store.send(.playTapped($0)) }
                    )
                }
            }
        }
    }
}

