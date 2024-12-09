import SwiftUI
import Redux
import Dependencies
import KimaiUI

struct AssistantContainer: View {
    @Dependency(\.router) var router
    @ObservedObject var store: ViewStoreOf<AssistantComponent>
    
   
    var body: some View {
        SetupAssistantView(
            currentStep: store.state.currentStep,
            steps: store.state.steps,
            stepTapped: {
                switch(store.state.currentStep) {
                case .customer:
                    router.showSheet(.management(.kimai(.customerSheet(.new))))
                case .project:
                    router.showSheet(.management(.kimai(.projectSheet(.new))))
                case .activity:
                    router.showSheet(.management(.kimai(.activitySheet(.new))))
                case .timesheet:
                    router.showSheet(.management(.kimai(.timesheetSheet(.new))))
                default:
                    break
                }
            },
            dashboardTapped: {
                router.showTab(.management, route: .management(.kimai(.customersList)))
            }
        )
    }
}
