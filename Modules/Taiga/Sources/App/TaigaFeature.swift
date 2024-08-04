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
    
    public struct State: Equatable, Codable, Hashable {
        public init() {}
        
        public var projects: [TaigaProject] = []
        public var taskStoryStatus: [TaigaTaskStoryStatus] = []
        public var taskStories: [TaigaTaskStory] = []
        public var tasks: [TaigaTask] = []
        public var milestones: [TaigaMilestone] = []
        
        var menus: [TaigaMenu] = []
        var selectedMenu: TaigaMenu = .backlog
        
        public func title(_ route: TaigaRoute) -> String {
            switch route {
            case .project(_, _):
                return "Projekt"
            }
        }
    }
    
    public enum Action: Codable, Equatable {
        case sync
        case synced(
            [TaigaProject], [TaigaTaskStoryStatus], [TaigaTaskStory], [TaigaTask], [TaigaMilestone]
        )
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
            
        case .sync:
            state.projects = taiga.projects.get()
            state.taskStoryStatus = taiga.taskStoryStatus.get()
            state.taskStories = taiga.taskStories.get()
            state.tasks = taiga.tasks.get()
            state.milestones = taiga.milestones.get()
            
            return .run { send in
                do {
                    let projects = try await taiga.projects.sync()
                    let taskStoryStatus = try await taiga.taskStoryStatus.sync()
                    let taskStories = try await taiga.taskStories.sync()
                    let tasks = try await taiga.tasks.sync()
                    let milestones = try await taiga.milestones.sync()
                    
                    send(.success(.synced(
                        projects, taskStoryStatus, taskStories, tasks, milestones
                    )))
                } catch {}
            }
            
        case let .synced(projects, taskStoryStatus, taskStories, tasks, milestones):
            state.projects = projects
            state.taskStoryStatus = taskStoryStatus
            state.taskStories = taskStories
            state.tasks = tasks
            state.milestones = milestones
        
        }
        
        return .none
    }

    
    


}
