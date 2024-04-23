import Foundation
import Combine
import Moya 

extension KimaiState {
    static func reduce(_ state: inout KimaiState, _ action: KimaiAction) -> AnyPublisher<KimaiAction, Error>  {
        switch(action){
            case .navigate(let scene):
                state.scene = scene
            
            case .loginSuccess:
                return Env.just(.sync)
                
            case .sync:
                return Publishers.MergeMany([
                    Env.just(.customers(.fetch)),
                    Env.just(.projects(.fetch)),
                    Env.just(.timesheets(.fetch)),
                    Env.just(.activities(.fetch))
                ]).eraseToAnyPublisher()
            
            case .customers(let action):
                return RequestReducer.reduce(
                    action,
                    Env.kimai.customers
                )
                .map { .customers($0) }
                .eraseToAnyPublisher()
            
            case .projects(let action):
                return RequestReducer.reduce(
                    action,
                    Env.kimai.projects
                )
                .map { .projects($0) }
                .eraseToAnyPublisher()
            
            case .timesheets(let action):
                return RequestReducer.reduce(
                    action,
                    Env.kimai.timesheets
                )
                .map { .timesheets($0) }
                .eraseToAnyPublisher()
            
            case .activities(let action):
                return RequestReducer.reduce(
                    action,
                    Env.kimai.activities
                )
                .map { .activities($0) }
                .eraseToAnyPublisher()
        
            

            case .connect(let kimaiProject, let taigaProject):
                Env.integrations.setIntegration(kimaiProject, taigaProject)

        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    
}
