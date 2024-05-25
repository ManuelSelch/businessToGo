import Foundation
import ComposableArchitecture

@Reducer
struct SettingsFeature {
    struct State: Equatable {
        
    }
    
    enum Action {
        case debugTapped
        case integrationsTapped
        case introTapped
        case logoutTapped
        
        case delegate(Delegate)
    }
    
    enum Delegate {
        case showDebug
        case showIntegrations
        case showIntro
        
        case logout
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action) {
        case .debugTapped:
            return .send(.delegate(.showDebug))
        case .integrationsTapped:
            return .send(.delegate(.showIntegrations))
        case .introTapped:
            return .send(.delegate(.showIntro))
        case .logoutTapped:
            return .send(.delegate(.logout))
            
        case .delegate:
            return .none
        }
    }
}
