import Foundation
import Combine
import Redux
import ComposableArchitecture

@Reducer
struct ReportModule {
    struct State: Equatable, Codable {
        
        
        var selectedDate: Date = Date.today
        var selectedProject: Int?
    }
    
    enum Action {
        
        
        case selectDate(Date)
        case selectProject(Int?)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch(action){
  
        
        case .selectDate(let date):
            state.selectedDate = date
        
        case .selectProject(let project):
            state.selectedProject = project
        }
        
        return .none
    }
}
