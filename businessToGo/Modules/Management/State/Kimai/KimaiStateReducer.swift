import Foundation
import Combine
import Moya 

extension KimaiState {
    static func reduce(_ state: inout KimaiState, _ action: KimaiAction, _ env: ManagementDependency) -> AnyPublisher<KimaiAction, Error>  {
        switch(action){                
            case .sync:
                state.customers = env.kimai.customers.get()
                state.projects = env.kimai.projects.get()
                state.timesheets = env.kimai.timesheets.get()
                state.activities = env.kimai.activities.get()
            
                return Publishers.MergeMany([
                    env.just(.customers(.sync)),
                    env.just(.projects(.sync)),
                    env.just(.timesheets(.sync)),
                    env.just(.activities(.sync))
                ]).eraseToAnyPublisher()
            
            case .customers(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.customers,
                    &state.customers
                )
                .map { .customers($0) }
                .eraseToAnyPublisher()
            
            case .projects(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.projects,
                    &state.projects
                )
                .map { .projects($0) }
                .eraseToAnyPublisher()
            
            case .timesheets(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.timesheets,
                    &state.timesheets
                )
                .map { .timesheets($0) }
                .eraseToAnyPublisher()
            
            case .activities(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.activities,
                    &state.activities
                )
                .map { .activities($0) }
                .eraseToAnyPublisher()

        }
    }
    
    
}
