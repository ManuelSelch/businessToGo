import SwiftUI
import Redux

import KimaiUI

struct ManagementContainer: View {
    var mainStore: StoreOf<AppFeature>
    
    var store: ViewStoreOf<ManagementComponent>
    var route: ManagementComponent.Route
    
    var isSheet: Bool {
        switch(route) {
        case .kimai(.customerSheet), .kimai(.projectSheet), .kimai(.timesheetSheet):
            return true
        default:
            return false
        }
    }
    
    init(mainStore: StoreOf<AppFeature>, route: ManagementComponent.Route) {
        self.mainStore = mainStore
        self.store = mainStore.projection(ManagementComponent.self)
        self.route = route
    }
    
    
    var body: some View {
        VStack {
            switch(route) {
            case let .kimai(route):
                KimaiContainer(
                    store: mainStore.projection(KimaiComponent.self),
                    route: route
                )
            case .assistant:
                AssistantContainer(store: mainStore.projection(AssistantComponent.self))
            }
            
            
            if  !isSheet, route != .assistant,
                let timesheet = store.state.kimai.timesheets.first(where: { $0.end == nil }),
                let activity = store.state.kimai.activities.first(where: { $0.id == timesheet.activity }),
                let project = store.state.kimai.projects.first(where: { $0.id == timesheet.project }),
                let customer = store.state.kimai.customers.first(where: { $0.id == project.customer })
            {
                KimaiTimesheetPopup(
                    customer: customer,
                    project: project,
                    activity: activity,
                    timesheet: timesheet,
                    timesheetTapped: { store.send(.timesheetEditTapped(timesheet)) },
                    stopTapped: { store.send(.stopTapped(timesheet)) }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ManagementHeaderView(
                    selectedTeam: store.binding(for: \.kimai.selectedTeam, action: {.teamSelected($0)}),
                    route: route,
                    projects: store.state.kimai.projects,
                    teams: store.state.kimai.teams,
                    syncTapped: { store.send(.sync) },
                    projectTapped: { store.send(.projectTapped($0.taigaProjectId)) },
                    playTapped: { store.send(.playTapped($0)) },
                    settingsTapped: { store.send(.settingsTapped) }
                )
            }
        }
    }
}