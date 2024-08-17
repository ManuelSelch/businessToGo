import Foundation
import Redux

extension SettingsComponent {
    static func reduce(_ state: inout AppFeature.State, _ action: UIAction) -> Effect<AppFeature.Action> {
        switch(action) {
        case .integrationsTapped:
            state.router.push(.settings(.integrations))
        case .debugTapped:
            state.router.push(.settings(.debug))
        case .logTapped:
            state.router.push(.settings(.log))
        case .introTapped:
            state.router.push(.intro)
        }
        
        return .none
    }
}
