import Foundation
import Combine

extension TaigaState {
    static func reduce(_ state: inout TaigaState, _ action: TaigaAction, _ env: ManagementDependency) -> AnyPublisher<TaigaAction, Error>  {
        switch(action){
        case .sync:
            state.projects = env.taiga.projects.get()
            state.taskStoryStatus = env.taiga.taskStoryStatus.get()
            state.taskStories = env.taiga.taskStories.get()
            state.tasks = env.taiga.tasks.get()
            state.milestones = env.taiga.milestones.get()
            
            return Publishers.MergeMany([
                env.just(.projects(.sync)),
                env.just(.milestones(.sync)),
                env.just(.statusList(.sync)),
                env.just(.taskStories(.sync)),
                env.just(.tasks(.sync))
            ]).eraseToAnyPublisher()
        
        case .projects(let action):
            return RequestReducer.reduce(action, env.taiga.projects, &state.projects)
                .map { .projects($0) }
                .eraseToAnyPublisher()
        
        case .milestones(let action):
            return RequestReducer.reduce(action, env.taiga.milestones, &state.milestones)
                .map { .milestones($0) }
                .eraseToAnyPublisher()
        
        case .statusList(let action):
            return RequestReducer.reduce(action, env.taiga.taskStoryStatus, &state.taskStoryStatus)
                .map { .statusList($0) }
                .eraseToAnyPublisher()
            
        case .taskStories(let action):
            return RequestReducer.reduce(action, env.taiga.taskStories, &state.taskStories)
                .map { .taskStories($0) }
                .eraseToAnyPublisher()
        
            
        case .tasks(let action):
            return RequestReducer.reduce(action, env.taiga.tasks, &state.tasks)
                .map { .tasks($0) }
                .eraseToAnyPublisher()
            
        
            
        case .setImage(let id, let img):
            state.projectImages[id] = img

            
            
        case .loadImage(let project):
            return env.taiga.loadImage(project.logo_big_url)
                .map { .setImage(project.id, $0) }
                .eraseToAnyPublisher()
            
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
