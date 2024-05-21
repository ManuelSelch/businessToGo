import Foundation
import Combine
import Redux

struct ReportModule: Reducer {
    
    struct State: Equatable, Codable {
        var router: RouteModule<ReportRoute>.State = .init()
        
        var selectedDate: Date = Date.today
        var selectedProject: Int?
    }
    
    enum Action {
        case route(RouteModule<ReportRoute>.Action)
        
        case selectDate(Date)
        case selectProject(Int?)
    }
    
    struct Dependency {
        
    }
    
    static func reduce(_ state: inout State, _ action: Action, _ env: Dependency) -> AnyPublisher<Action, Error> {
        switch(action){
        case .route(let action):
            return RouteModule.reduce(&state.router, action, .init())
                .map { .route($0) }
                .eraseToAnyPublisher()
      
        
        case .selectDate(let date):
            state.selectedDate = date
        
        case .selectProject(let project):
            state.selectedProject = project
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
