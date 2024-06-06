import Foundation
import Redux
import Combine
import Dependencies

import AppCore
import LoginCore
import KimaiCore
import TaigaCore
import IntegrationsCore

public struct SettingsFeature: Reducer {
    @Dependency(\.database) var database
    @Dependency(\.integrations) var integrations
    @Dependency(\.keychain) var keychain
    @Dependency(\.kimai) var kimai
    @Dependency(\.taiga) var taiga
    
    public init() {}
    
    public struct State: Equatable, Codable {
        public init() {}
        
        var account: Account?
        var isLocalLog: Bool = UserDefault.isLocalLog
        var isRemoteLog: Bool = UserDefault.isRemoteLog
        
        
        var customers: [KimaiCustomer] = []
        var projects: [KimaiProject] = []
        var taigaProjects: [TaigaProject] = []
        var integrations: [Integration] = []
        
        var router: RouterFeature<Route>.State = .init(root: .settings)
    }
    
    public enum Action: Codable {
        case onConnect(_ kimai: Int, _ taiga: Int)
        
        case onLocalLogChanged(Bool)
        case onRemoteLogChanged(Bool)
        
        case resetTapped
        case settings(SettingsAction)
        
        case router(RouterFeature<Route>.Action)
        case delegate(Delegate)
    }
    
    public enum SettingsAction: Codable {
        case integrationsTapped
        case debugTapped
        case logTapped
        case introTapped
        case logoutTapped
    }
    
    public enum Delegate: Codable {
        case showIntro
        case logout
        case dismiss
    }
    
    public enum Route: Identifiable, Codable {
        case settings
        case integrations
        case debug
        case log
        
        public var id: Self {self}
    }
    
    public func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
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
            
        case let .onLocalLogChanged(isLocalLog):
            state.isLocalLog = isLocalLog
            UserDefault.isLocalLog = isLocalLog
            return .none
            
        case let .onRemoteLogChanged(isRemoteLog):
            state.isRemoteLog = isRemoteLog
            UserDefault.isRemoteLog = isRemoteLog
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
