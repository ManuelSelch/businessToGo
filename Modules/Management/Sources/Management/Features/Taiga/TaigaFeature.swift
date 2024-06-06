import Foundation
import OfflineSync
import SwiftUI
import Redux
import Combine
import Dependencies

import TaigaCore
import IntegrationsCore

public struct TaigaFeature: Reducer {
    @Dependency(\.track) var track
    @Dependency(\.taiga) var taiga
    
    public struct State: Equatable, Codable {
        var projects = RequestFeature<TaigaProject, TaigaRequest>.State()
        
        var taskStoryStatus = RequestFeature<TaigaTaskStoryStatus, TaigaRequest>.State()
        var taskStories = RequestFeature<TaigaTaskStory, TaigaRequest>.State()
        var tasks = RequestFeature<TaigaTask, TaigaRequest>.State()
        var milestones = RequestFeature<TaigaMilestone, TaigaRequest>.State()
        
        var menus: [Menu] = []
        var selectedMenu: Menu = .backlog
    }
    
    public enum Action: Codable {
        case projects(RequestFeature<TaigaProject, TaigaRequest>.Action)
        case milestones(RequestFeature<TaigaMilestone, TaigaRequest>.Action)
        case statusList(RequestFeature<TaigaTaskStoryStatus, TaigaRequest>.Action)
        case taskStories(RequestFeature<TaigaTaskStory, TaigaRequest>.Action)
        case tasks(RequestFeature<TaigaTask, TaigaRequest>.Action)
        
        case project(ProjectAction)
    }
    
    public enum ProjectAction: Codable {
        case menuSelected(Menu)
        case taskStoryUpdated(TaigaTaskStory)
    }
    
    public enum Menu: String, Codable {
        case kanban = "Kanban"
        case backlog = "Backlog 02"
        
        var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
    }
    
    public enum Route: Hashable, Codable {
        case project(Integration)
    }
    
    func sync() -> AnyPublisher<Action, Error> {
        return .merge([
            RequestFeature(service: taiga.projects).sync()
                .map { .projects($0) }
                .eraseToAnyPublisher(),
            
            RequestFeature(service: taiga.milestones).sync()
                .map { .milestones($0) }
                .eraseToAnyPublisher(),
            
            RequestFeature(service: taiga.taskStoryStatus).sync()
                .map { .statusList($0) }
                .eraseToAnyPublisher(),
            
            RequestFeature(service: taiga.taskStories).sync()
                .map { .taskStories($0) }
                .eraseToAnyPublisher(),
            
            RequestFeature(service: taiga.tasks).sync()
                .map { .tasks($0) }
                .eraseToAnyPublisher()
        ])
    }
    
    public func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action) {
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
