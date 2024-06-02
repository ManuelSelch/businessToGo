import Foundation
import Redux
import Combine


struct SettingsFeature: Reducer {
    @Dependency(\.database) var database
    @Dependency(\.integrations) var integrations
    @Dependency(\.keychain) var keychain
    @Dependency(\.kimai) var kimai
    @Dependency(\.taiga) var taiga
    
    struct State: Equatable, Codable {
        var account: Account?
        var isDebug: Bool = UserDefault.isDebug
        
        var customers: [KimaiCustomer] = []
        var projects: [KimaiProject] = []
        var taigaProjects: [TaigaProject] = []
        var integrations: [Integration] = []
        
        var router: RouterFeature<Route>.State = .init(root: .settings)
    }
    
    enum Action: Codable {
        case onConnect(_ kimai: Int, _ taiga: Int)
        case resetTapped
        case isDebugChanged(Bool)
        
        case settings(SettingsAction)
        
        case router(RouterFeature<Route>.Action)
        case delegate(Delegate)
    }
    
    enum SettingsAction: Codable {
        case integrationsTapped
        case debugTapped
        case logTapped
        case introTapped
        case logoutTapped
    }
    
    enum Delegate: Codable {
        case showIntro
        case logout
        case dismiss
    }
    
    enum Route: Identifiable, Codable {
        case settings
        case integrations
        case debug
        case log
        
        var id: Self {self}
    }
    
    func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action){
        case let .settings(action):
            switch(action){
            case .debugTapped:
                let accounts = (try? keychain.getAccounts()) ?? []
                let account = (try? keychain.getCurrentAccount(accounts)) ?? nil
                state.account = account
                
                state.router.push(.debug)
                return .none
            case .integrationsTapped:
                state.customers = kimai.customers.get()
                state.projects = kimai.projects.get()
                state.taigaProjects = taiga.projects.get()
                state.integrations = integrations.get()
                
                state.router.push(.integrations)
                return .none
            case .logTapped:
                state.router.push(.log)
                return .none
            case .introTapped:
                return .send(.delegate(.showIntro))
            case .logoutTapped:
                return .merge([
                    .send(.delegate(.logout)),
                    .send(.delegate(.dismiss))
                ])
            }
        
        case .resetTapped:
            database.reset()
            return .merge([
                .send(.delegate(.logout)),
                .send(.delegate(.dismiss))
            ])
            
        case let .isDebugChanged(isDebug):
            state.isDebug = isDebug
            UserDefault.isDebug = isDebug
            return .none
            
        case let .onConnect(kimai, taiga):
            integrations.setIntegration(kimai, taiga)
            state.integrations = integrations.get()
            return .none
            
        case let .router(action):
            return RouterFeature<Route>().reduce(&state.router, action)
                .map { .router($0) }
                .eraseToAnyPublisher()
                
        case .delegate:
            return .none
        }
    }
    
    
   
}
