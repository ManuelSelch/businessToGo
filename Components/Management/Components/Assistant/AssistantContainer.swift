import SwiftUI
import Redux

import KimaiUI

struct AssistantContainer: View {
    @ObservedObject var store: Store<State, Action>
    
   
    var body: some View {
        SetupAssistantView(
            steps: store.state.steps,
            stepTapped: { store.send(.stepTapped) },
            dashboardTapped: { store.send(.dashboardTapped) }
        )
    }
}
