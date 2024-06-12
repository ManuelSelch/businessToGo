import Foundation
import OfflineSync
import SwiftUI
import Redux
import Combine
import Dependencies

import TaigaCore
import TaigaServices

public struct TaigaFeature: Reducer {
    public init() {}
    
    @Dependency(\.track) var track
    @Dependency(\.taiga) var taiga
    
    public struct State: Equatable, Codable {
        public init() {}
        
        var projects: [TaigaProject] = []
        var taskStoryStatus: [TaigaTaskStoryStatus] = []
        var taskStories: [TaigaTaskStory] = []
        var tasks: [TaigaTask] = []
        var milestones: [TaigaMilestone] = []
        
        var menus: [TaigaMenu] = []
        var selectedMenu: TaigaMenu = .backlog
    }
    
    public enum Action: Codable, Equatable {
        case synced(SyncAction)
        case project(ProjectAction)
    }
    
    public enum ProjectAction: Codable, Equatable {
        case menuSelected(TaigaMenu)
        case taskStoryUpdated(TaigaTaskStory)
    }
    
    public enum SyncAction: Codable, Equatable {
        case projects([TaigaProject])
        case taskStoryStatus([TaigaTaskStoryStatus])
        case taskStories([TaigaTaskStory])
        case tasks([TaigaTask])
        case milestones([TaigaMilestone])
    }
    
    public func sync() -> AnyPublisher<Action, Error> {
        return .merge([
            taiga.projects.sync()
                .map { .synced(.projects($0)) }
                .eraseToAnyPublisher(),
            
            taiga.taskStoryStatus.sync()
                .map { .synced(.taskStoryStatus($0)) }
                .eraseToAnyPublisher(),
            
            taiga.taskStories.sync()
                .map { .synced(.taskStories($0)) }
                .eraseToAnyPublisher(),
            
            taiga.tasks.sync()
                .map { .synced(.tasks($0)) }
                .eraseToAnyPublisher(),
            
            taiga.milestones.sync()
                .map { .synced(.milestones($0)) }
                .eraseToAnyPublisher()
        ])
    }
    
    public func reduce(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch(action) {
        case let .project(action):
            switch(action) {
            case let .menuSelected(menu):
                state.selectedMenu = menu
                return .none
            case let .taskStoryUpdated(taskStory):
                // return .send(.taskStories(.update(taskStory)))
                break
            }
            
        case let .synced(action):
            switch(action) {
            case let .projects(records):
                state.projects = records
            case let .taskStoryStatus(records):
                state.taskStoryStatus = records
            case let .taskStories(records):
                state.taskStories = records
            case let .tasks(records):
                state.tasks = records
            case let .milestones(records):
                state.milestones = records
            }
        
        }
        
        return .none
    }

    
    


}
