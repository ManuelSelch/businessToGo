import Foundation
import Combine
import Redux

extension TaigaModule: Reducer {
    static func reduce(_ state: inout State, _ action: Action, _ env: Dependency) -> AnyPublisher<Action, Error>  {
        switch(action){
        case .sync:
            state.projects = env.taiga.projects.get()
            state.taskStoryStatus = env.taiga.taskStoryStatus.get()
            state.taskStories = env.taiga.taskStories.get()
            state.tasks = env.taiga.tasks.get()
            state.milestones = env.taiga.milestones.get()
            
            return Publishers.MergeMany([
                just(.projects(.sync)),
                just(.milestones(.sync)),
                just(.statusList(.sync)),
                just(.taskStories(.sync)),
                just(.tasks(.sync))
            ]).eraseToAnyPublisher()
        
        case .projects(let action):
            return RequestReducer.reduce(
                action,
                env.taiga.projects,
                env.track,
                &state.projects,
                &state.projectTracks
            )
                .map { .projects($0) }
                .eraseToAnyPublisher()
        
        case .milestones(let action):
            return RequestReducer.reduce(
                action,
                env.taiga.milestones,
                env.track,
                &state.milestones,
                &state.milestoneTracks
            )
                .map { .milestones($0) }
                .eraseToAnyPublisher()
        
        case .statusList(let action):
            return RequestReducer.reduce(
                action,
                env.taiga.taskStoryStatus,
                env.track,
                &state.taskStoryStatus,
                &state.statusTracks
            )
                .map { .statusList($0) }
                .eraseToAnyPublisher()
            
        case .taskStories(let action):
            return RequestReducer.reduce(
                action,
                env.taiga.taskStories,
                env.track,
                &state.taskStories,
                &state.storyTracks
            )
                .map { .taskStories($0) }
                .eraseToAnyPublisher()
        
            
        case .tasks(let action):
            return RequestReducer.reduce(
                action,
                env.taiga.tasks,
                env.track,
                &state.tasks,
                &state.taskTracks
            )
                .map { .tasks($0) }
                .eraseToAnyPublisher()
            
        
            
        case .setImage(_, _):
            // state.projectImages[id] = img
            break // todo: add projectImage

            
            
        case .loadImage(let project):
            return env.taiga.loadImage(project.logo_big_url)
                .map { .setImage(project.id, $0) }
                .eraseToAnyPublisher()
            
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
