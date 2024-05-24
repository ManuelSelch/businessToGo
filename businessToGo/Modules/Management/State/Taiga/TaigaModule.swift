import Foundation
import SwiftUI
import OfflineSync
import ComposableArchitecture

@Reducer
struct TaigaModule {
    @Dependency(\.track) var track
    @Dependency(\.taiga) var taiga
    
    @ObservableState
    struct State: Equatable, Codable {
        var projects = RequestModule<TaigaProject, TaigaRequest>.State()
        
        var taskStoryStatus = RequestModule<TaigaTaskStoryStatus, TaigaRequest>.State()
        var taskStories = RequestModule<TaigaTaskStory, TaigaRequest>.State()
        var tasks = RequestModule<TaigaTask, TaigaRequest>.State()
        var milestones = RequestModule<TaigaMilestone, TaigaRequest>.State()
    }
    
    enum Action {
        case sync
        
        case projects(RequestModule<TaigaProject, TaigaRequest>.Action)
        case milestones(RequestModule<TaigaMilestone, TaigaRequest>.Action)
        case statusList(RequestModule<TaigaTaskStoryStatus, TaigaRequest>.Action)
        case taskStories(RequestModule<TaigaTaskStory, TaigaRequest>.Action)
        case tasks(RequestModule<TaigaTask, TaigaRequest>.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.projects, action: \.projects) {
            RequestModule(service: taiga.projects)
        }
        Scope(state: \.milestones, action: \.milestones) {
            RequestModule(service: taiga.milestones)
        }
        Scope(state: \.taskStoryStatus, action: \.statusList) {
            RequestModule(service: taiga.taskStoryStatus)
        }
        Scope(state: \.taskStories, action: \.taskStories) {
            RequestModule(service: taiga.taskStories)
        }
        Scope(state: \.tasks, action: \.tasks) {
            RequestModule(service: taiga.tasks)
        }
        
        Reduce { state, action in
            switch(action) {
            case .sync:
                return .merge([
                    .send(.projects(.sync)),
                    .send(.milestones(.sync)),
                    .send(.statusList(.sync)),
                    .send(.taskStories(.sync)),
                    .send(.tasks(.sync))
                ])
                
            case .projects, .milestones, .statusList, .taskStories, .tasks:
                return .none
            }
        }
    }
   


}
