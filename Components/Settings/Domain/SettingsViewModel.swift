import Redux

import CommonServices

import LoginCore
import KimaiCore
import TaigaCore
import IntegrationCore

extension SettingsContainer: ViewModel {
    typealias DState = AppFeature.State
    typealias DAction = AppFeature.Action
    
    struct State: ViewState {
        var account: Account?
        var isLocalLog: Bool
        var isRemoteLog: Bool
        var isMock: Bool
        
        
        var customers: [KimaiCustomer]
        var projects: [KimaiProject]
        var taigaProjects: [TaigaProject]
        var integrations: [Integration]
        
        static func from(_ state: AppFeature.State) -> Self {
            return State(
                account: state.login.current,
                
                isLocalLog: state.debug.isLocalLog,
                isRemoteLog: state.debug.isRemoteLog,
                isMock: state.debug.isMock,
                
                customers: state.kimai.customers,
                projects: state.kimai.projects,
                taigaProjects: state.taiga.projects,
                integrations: state.integration.integrations
            )
        }
    }
    
    enum Action: Codable, Equatable, ViewAction {
        case onConnect(_ kimai: Int, _ taiga: Int)
        
        case onLocalLogChanged(Bool)
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
                
            case let .onLocalLogChanged(val): return .debug(.onLocalLogChanged(val))
            case let .onRemoteLogChanged(val): return .debug(.onRemoteLogChanged(val))
            case let .onMockChanged(val): return .debug(.onMockChanged(val))
                
           
                
            case .integrationsTapped: return .component(.settings(.integrationsTapped))
            case .debugTapped: return .component(.settings(.debugTapped))
            case .logTapped: return .component(.settings(.logTapped))
            case .introTapped: return .component(.settings(.introTapped))
                
            case .resetTapped: return .login(.resetTapped)
            case .logoutTapped: return .login(.logoutTapped)
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
