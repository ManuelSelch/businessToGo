import Foundation
import Combine
import Redux

import ManagementCore
import KimaiCore
import KimaiApp
import TaigaCore
import TaigaApp

extension ManagementFeature {
    
    public func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action) {
        case .sync:
            state.integrations = integrations.get()
            return .merge([
                KimaiFeature().sync()
                    .map { .intern(.kimai($0)) }
                    .eraseToAnyPublisher(),
                
                TaigaFeature().sync()
                    .map { .intern(.taiga($0)) }
                    .eraseToAnyPublisher()
            ])
            
        case let .internalAction(intern):
            return reduce(&state, intern.action)
                .map { .intern($0) }
                .eraseToAnyPublisher()
        }
    }
    
    func reduce(_ state: inout State, _ action: InternalAction.Action) -> AnyPublisher<InternalAction.Action, Error> {
        switch(action){
            
        case let .kimai(.delegate(action)):
            switch(action) {
            case let .route(kimaiRoute):
                switch(kimaiRoute) {
                case .customersList:
                    state.router.presentCover(.kimai(kimaiRoute))
                case .projectSheet, .customerSheet, .timesheetSheet:
                    state.router.presentSheet(.kimai(kimaiRoute))
                default:
                    state.router.push(.kimai(kimaiRoute))
                }
                
            case .dismiss:
                state.router.dismiss()
            }
        case let .kimai(action):
            return KimaiFeature().reduce(&state.kimai, action)
                .map { .kimai($0) }
                .eraseToAnyPublisher()            
        
        case .connect(let kimaiProject, let taigaProject):
            integrations.setIntegration(kimaiProject, taigaProject)
            state.integrations = integrations.get()
        
        case let .playTapped(timesheet):
            state.router.presentSheet(.kimai(.timesheetSheet(timesheet)))
            
            
        case .resetDatabase:
            database.reset()
            state = .init()
            
        case .timesheetTapped(_):
            return .none
        case .stopTapped(_):
            return .none
            
        case let .taiga(action):
            return TaigaFeature().reduce(&state.taiga, action)
                .map { .taiga($0) }
                .eraseToAnyPublisher()
            
        case let .router(action):
            return RouterFeature<ManagementRoute>().reduce(&state.router, action)
                .map { .router($0) }
                .eraseToAnyPublisher()
        
        }
        
        return .none
    }
}
