import SwiftUI
import Redux

import KimaiUI
import TaigaApp

struct ManagementContainer: View {
    @ObservedObject var store: ViewStore
    var route: Route
    
    var isSheet: Bool {
        switch(route) {
        case .kimai(.customerSheet), .kimai(.projectSheet), .kimai(.timesheetSheet):
            return true
        default:
            return false
        }
    }
    
    var body: some View {
        VStack {
            switch(route) {
            case let .kimai(route):
                KimaiContainer(
                    store: store.projection(KimaiContainer.self),
                    route: route
                )
            case let .taiga(route):
                Text("Taiga Container")
            case .assistant:
               Text("Kimai Assistant")
                
            }
            
            
            if  !isSheet,
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
                    timesheetTapped: { store.send(.kimai(.timesheetEditTapped(timesheet))) },
                    stopTapped: { store.send(.stopTapped(timesheet)) }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ManagementHeaderView(
                    selectedTeam: store.binding(for: \.kimai.selectedTeam, action: {Action.kimai(.teamSelected($0))}),
                    route: route,
                    projects: store.state.kimai.projects,
                    teams: store.state.kimai.teams,
                    syncTapped: { store.send(.sync) },
                    projectTapped: { store.send(.kimai(.projectTapped($0.taigaProjectId))) },
                    playTapped: { store.send(.playTapped($0)) }
                )
            }
        }
    }
}
