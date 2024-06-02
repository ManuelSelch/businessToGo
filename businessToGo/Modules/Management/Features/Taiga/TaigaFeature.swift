import Foundation
import SwiftUI
import OfflineSync
import Redux
import Combine

struct TaigaFeature: Reducer {
    @Dependency(\.track) var track
    @Dependency(\.taiga) var taiga
    
    struct State: Equatable, Codable {
        var projects = RequestFeature<TaigaProject, TaigaRequest>.State()
        
        var taskStoryStatus = RequestFeature<TaigaTaskStoryStatus, TaigaRequest>.State()
        var taskStories = RequestFeature<TaigaTaskStory, TaigaRequest>.State()
        var tasks = RequestFeature<TaigaTask, TaigaRequest>.State()
        var milestones = RequestFeature<TaigaMilestone, TaigaRequest>.State()
        
        var menus: [Menu] = []
        var selectedMenu: Menu = .backlog
    }
    
    enum Action: Codable {
        case sync
        
        case projects(RequestFeature<TaigaProject, TaigaRequest>.Action)
        case milestones(RequestFeature<TaigaMilestone, TaigaRequest>.Action)
        case statusList(RequestFeature<TaigaTaskStoryStatus, TaigaRequest>.Action)
        case taskStories(RequestFeature<TaigaTaskStory, TaigaRequest>.Action)
        case tasks(RequestFeature<TaigaTask, TaigaRequest>.Action)
        
        case project(ProjectAction)
    }
    
    enum ProjectAction: Codable {
        case menuSelected(Menu)
        case taskStoryUpdated(TaigaTaskStory)
    }
    
    enum Menu: String, Codable {
        case kanban = "Kanban"
        case backlog = "Backlog 02"
        
        var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
    }
    
    enum Route: Hashable, Codable {
        case project(Integration)
    }
    
    func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action) {
        case .sync:
            return .merge([
                .send(.projects(.sync)),
                .send(.milestones(.sync)),
                .send(.statusList(.sync)),
                .send(.taskStories(.sync)),
                .send(.tasks(.sync))
            ])
            
        case let .project(action):
            switch(action) {
            case let .menuSelected(menu):
                state.selectedMenu = menu
                return .none
            case let .taskStoryUpdated(taskStory):
                return .send(.taskStories(.update(taskStory)))
            }
            
        case let .projects(action):
            return RequestFeature(service: taiga.projects).reduce(into: &state.projects, action: action)
                .map { .projects($0) }
                .eraseToAnyPublisher()
            
        // TODO: reduce request features
        case  .milestones, .statusList, .taskStories, .tasks:
            return .none
        
        }
    }

    
    


}
