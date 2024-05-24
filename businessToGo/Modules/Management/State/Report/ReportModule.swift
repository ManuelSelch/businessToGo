import Foundation
import Combine
import Redux
import ComposableArchitecture

@Reducer
struct ReportModule {
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
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
        case .route(let action):
            return .publisher {
                return RouteModule.reduce(&state.router, action, .init())
                    .map { .route($0) }
                    .catch { _ in Empty() }
            }
      
        
        case .selectDate(let date):
            state.selectedDate = date
        
        case .selectProject(let project):
            state.selectedProject = project
        }
        
        return .none
    }
}
