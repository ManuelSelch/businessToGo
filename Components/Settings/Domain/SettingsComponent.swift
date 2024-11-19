import Redux

import CommonServices

import LoginCore
import KimaiCore
import IntegrationCore

struct SettingsComponent: ViewModel {
    typealias DState = AppFeature.State
    typealias DAction = AppFeature.Action
    
    struct State: ViewState {
        var account: Account?
        var isRemoteLog: Bool
        var isMock: Bool
        
        
        var customers: [KimaiCustomer]
        var projects: [KimaiProject]
        var integrations: [Integration]
        
        static func from(_ state: AppFeature.State) -> Self {
            return State(
                account: state.login.accounts.first(where: {
                    $0.identifier == state.login.accountId
                }),
                
                isRemoteLog: state.debug.isRemoteLog,
                isMock: state.debug.isMock,
                
                customers: state.kimai.customers,
                projects: state.kimai.projects,
                integrations: state.integration.integrations
            )
        }
    }
    
    enum Action: Codable, Equatable, ViewAction {
        case onConnect(_ kimai: Int, _ taiga: Int)
        
        case onRemoteLogChanged(Bool)
        case onMockChanged(Bool)
        
        case integrationsTapped
        case debugTapped
        case logTapped
        case introTapped
        
        case resetTapped
        case logoutTapped
        
        
        var lifted: AppFeature.Action {
            switch self {
            case let .onConnect(kimai, taiga): return .integration(.onConnect(kimai, taiga))
                
            case let .onRemoteLogChanged(val): return .debug(.onRemoteLogChanged(val))
            case let .onMockChanged(val): return .debug(.onMockChanged(val))
                
           
                
            case .integrationsTapped: return .component(.settings(.integrationsTapped))
            case .debugTapped: return .component(.settings(.debugTapped))
            case .logTapped: return .component(.settings(.logTapped))
            case .introTapped: return .component(.settings(.introTapped))
                
            case .resetTapped: return .user(.reset)
            case .logoutTapped: return .user(.logout)
            }
            
        }
    }
    
    enum UIAction: Equatable, Codable {
        case integrationsTapped
        case debugTapped
        case logTapped
        case introTapped
    }
    
    

    enum Route: Identifiable, Codable {
        case settings
        case integrations
        case debug
        case log
        
        public var id: Self {self}
    }
    
   
    
}
