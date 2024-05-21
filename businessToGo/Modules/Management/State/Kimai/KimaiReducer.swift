import Foundation
import Combine
import Moya 
import Redux

extension KimaiModule: Reducer {
    static func reduce(_ state: inout State, _ action: Action, _ env: Dependency) -> AnyPublisher<Action, Error>  {
        switch(action){
            case .sync:
                state.customers = env.kimai.customers.get()
                state.projects = env.kimai.projects.get()
                state.timesheets = env.kimai.timesheets.get()
                state.activities = env.kimai.activities.get()
                state.teams = env.kimai.teams.get()
                state.users = env.kimai.users.get()
            
                return Publishers.MergeMany([
                    just(.customers(.sync)),
                    just(.projects(.sync)),
                    just(.timesheets(.sync)),
                    just(.activities(.sync)),
                    just(.teams(.sync)),
                    just(.users(.sync))
                ]).eraseToAnyPublisher()
            
            case .selectTeam(let team):
                state.selectedTeam = team
            
            case .customers(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.customers,
                    env.track,
                    &state.customers,
                    &state.customerTracks
                )
                .map { .customers($0) }
                .eraseToAnyPublisher()
            
            case .projects(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.projects,
                    env.track,
                    &state.projects,
                    &state.projectTracks
                )
                .map { .projects($0) }
                .eraseToAnyPublisher()
            
            case .timesheets(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.timesheets,
                    env.track,
                    &state.timesheets,
                    &state.timesheetTracks
                )
                .map { .timesheets($0) }
                .eraseToAnyPublisher()
            
            case .activities(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.activities,
                    env.track,
                    &state.activities,
                    &state.activityTracks
                )
                .map { .activities($0) }
                .eraseToAnyPublisher()
            
            case .teams(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.teams,
                    env.track,
                    &state.teams,
                    &state.teamTracks
                )
                .map { .teams($0) }
                .eraseToAnyPublisher()
            
            case .users(let action):
                return RequestReducer.reduce(
                    action,
                    env.kimai.users,
                    env.track,
                    &state.users,
                    &state.userTracks
                )
                .map { .users($0) }
                .eraseToAnyPublisher()

        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    
}
