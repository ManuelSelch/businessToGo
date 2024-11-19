import SwiftUI
import Redux

import KimaiUI

struct AssistantContainer: View {
    @ObservedObject var store: ViewStoreOf<AssistantComponent>
    
   
    var body: some View {
        SetupAssistantView(
            currentStep: store.state.currentStep,
            steps: store.state.steps,
            stepTapped: { store.send(.stepTapped(store.state.currentStep)) },
            dashboardTapped: { store.send(.dashboardTapped) }
        )
    }
}
