import Foundation
import Combine

extension TaigaState {
    static func reduce(_ state: inout TaigaState, _ action: TaigaAction) -> AnyPublisher<TaigaAction, Error>  {
        switch(action){
        case .navigate(let scene):
            state.scene = scene
            
        case .sync:
            return Publishers.MergeMany([
                Env.just(.projects(.fetch)),
                Env.just(.milestones(.fetch)),
                Env.just(.statusList(.fetch)),
                Env.just(.taskStories(.fetch)),
                Env.just(.tasks(.fetch))
            ]).eraseToAnyPublisher()
        
        case .projects(let action):
            return RequestReducer.reduce(action, Env.taiga.projects)
                .map { .projects($0) }
                .eraseToAnyPublisher()
        
        case .milestones(let action):
            return RequestReducer.reduce(action, Env.taiga.milestones)
                .map { .milestones($0) }
                .eraseToAnyPublisher()
        
        case .statusList(let action):
            return RequestReducer.reduce(action, Env.taiga.taskStoryStatus)
                .map { .statusList($0) }
                .eraseToAnyPublisher()
            
        case .taskStories(let action):
            return RequestReducer.reduce(action, Env.taiga.taskStories)
                .map { .taskStories($0) }
                .eraseToAnyPublisher()
            
        case .tasks(let action):
            return RequestReducer.reduce(action, Env.taiga.tasks)
                .map { .tasks($0) }
                .eraseToAnyPublisher()
            
        
            
        case .setImage(let id, let img):
            state.projectImages[id] = img

            
            
        case .loadImage(let project):
            return Env.taiga.loadImage(project.logo_big_url)
                .map { .setImage(project.id, $0) }
                .eraseToAnyPublisher()
            
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
