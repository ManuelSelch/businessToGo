import Foundation
import OfflineSync
import SwiftUI
import ComposableArchitecture

@Reducer
struct KimaiModule {
    @Dependency(\.track) var track
    @Dependency(\.kimai) var kimai
    
    @ObservableState
    struct State: Equatable, Codable {
        var selectedTeam: Int?
        
        var customers = RequestModule<KimaiCustomer, KimaiRequest>.State()
        var projects = RequestModule<KimaiProject, KimaiRequest>.State()
        var timesheets = RequestModule<KimaiTimesheet, KimaiRequest>.State()
        var activities = RequestModule<KimaiActivity, KimaiRequest>.State()
        var teams = RequestModule<KimaiTeam, KimaiRequest>.State()
        var users = RequestModule<KimaiUser, KimaiRequest>.State()
    }
    
    enum Action {
        case selectTeam(Int?)
        
        case sync
        
        case customers(RequestModule<KimaiCustomer, KimaiRequest>.Action)
        case projects(RequestModule<KimaiProject, KimaiRequest>.Action)
        case timesheets(RequestModule<KimaiTimesheet, KimaiRequest>.Action)
        case activities(RequestModule<KimaiActivity, KimaiRequest>.Action)
        case teams(RequestModule<KimaiTeam, KimaiRequest>.Action)
        case users(RequestModule<KimaiUser, KimaiRequest>.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.customers, action: \.customers) {
            RequestModule(service: kimai.customers)
        }
        Scope(state: \.projects, action: \.projects) {
            RequestModule(service: kimai.projects)
        }
        Scope(state: \.timesheets, action: \.timesheets) {
            RequestModule(service: kimai.timesheets)
        }
        Scope(state: \.activities, action: \.activities) {
            RequestModule(service: kimai.activities)
        }
        Scope(state: \.teams, action: \.teams) {
            RequestModule(service: kimai.teams)
        }
        Scope(state: \.users, action: \.users) {
            RequestModule(service: kimai.users)
        }
        
        Reduce { state, action in
            switch(action){
                
            case .sync:
                return .merge([
                    .send(.customers(.sync)),
                    .send(.projects(.sync)),
                    .send(.timesheets(.sync)),
                    .send(.activities(.sync)),
                    .send(.teams(.sync)),
                    .send(.users(.sync))
                ])
               
            
            case .selectTeam(let team):
                state.selectedTeam = team
                return .none
                
            case .customers, .projects, .timesheets, .activities, .teams, .users:
                return .none
            }
            
            
        }
    }
}



