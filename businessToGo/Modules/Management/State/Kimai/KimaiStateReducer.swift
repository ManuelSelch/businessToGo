import Foundation
import Combine
import Moya 

extension KimaiState {
    static func reduce(_ state: inout KimaiState, _ action: KimaiAction, _ env: ManagementDependency) -> AnyPublisher<KimaiAction, Error>  {
        switch(action){
            case .loginSuccess:
                return env.just(.sync)
                
            case .sync:
                state.customers = env.kimai.customers.get()
                state.projects = env.kimai.projects.get()
                state.timesheets = env.kimai.timesheets.get()
                state.activities = env.kimai.activities.get()
            
                return Publishers.MergeMany([
                    env.just(.customers(.fetch)),
                    env.just(.projects(.fetch)),
                    env.just(.timesheets(.fetch)),
                    env.just(.activities(.fetch))
                ]).eraseToAnyPublisher()
            
            case .customers(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.customers
                )
                .map { .customers($0) }
                .eraseToAnyPublisher()
            
            case .projects(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.projects
                )
                .map { .projects($0) }
                .eraseToAnyPublisher()
            
            case .timesheets(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.timesheets
                )
                .map { .timesheets($0) }
                .eraseToAnyPublisher()
            
            case .activities(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.activities
                )
                .map { .activities($0) }
                .eraseToAnyPublisher()
        
            

            case .connect(let kimaiProject, let taigaProject):
                env.integrations.setIntegration(kimaiProject, taigaProject)

        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    
}
