import SwiftUI
import Redux

import KimaiUI

public struct KimaiAssistantContainer: View {
    @ObservedObject var store: StoreOf<KimaiFeature>
    
    public init(store: StoreOf<KimaiFeature>) {
        self.store = store
    }
    
    public var body: some View {
        SetupAssistantView(
            steps: store.state.steps,
            stepTapped: { store.send(.assistant(.stepTapped)) },
            dashboardTapped: { store.send(.assistant(.dashboardTapped)) }
        )
    }
}
