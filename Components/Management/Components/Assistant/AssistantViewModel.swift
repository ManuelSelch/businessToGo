import Foundation
import Redux

import KimaiCore

extension AssistantContainer {
    struct State: Equatable {
        var steps: [KimaiAssistantStep]
    }
    
    enum Action: Equatable {
        case stepTapped
        case dashboardTapped
    }
}
