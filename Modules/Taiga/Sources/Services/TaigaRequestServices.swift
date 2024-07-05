import Dependencies
import OfflineSync

import TaigaCore

var tables = TaigaTable()

struct ProjectRequestKey: DependencyKey {
    static var liveValue: RequestService<TaigaProject, TaigaAPI> = .live(
        table: tables.projects,
        fetchMethod: .simple(.getProjects)
    )
    
    static var mockValue: RequestService<TaigaProject, TaigaAPI> = .mock(
        table: tables.projects,
        fetchMethod: .simple(.getProjects)
    )
}

struct TaskStoriesKey: DependencyKey {
    static var liveValue: RequestService<TaigaTaskStory, TaigaAPI> = .live(
        table: tables.taskStories,
        fetchMethod: .simple(.getTaskStories),
        insertMethod: nil,
        updateMethod: TaigaAPI.updateTaskStory,
        deleteMethod: nil
    )
    
    static var mockValue: RequestService<TaigaTaskStory, TaigaAPI> = .mock(
        table: tables.taskStories,
        fetchMethod: .simple(.getTaskStories),
        insertMethod: nil,
        updateMethod: TaigaAPI.updateTaskStory,
        deleteMethod: nil
    )
}

struct TaskStoryStatusKey: DependencyKey {
    static var liveValue: RequestService<TaigaTaskStoryStatus, TaigaAPI> = .live(
        table: tables.taskStatus,
        fetchMethod: .simple(.getStatusList)
    )
    
    static var mockValue: RequestService<TaigaTaskStoryStatus, TaigaAPI> = .mock(
        table: tables.taskStatus,
        fetchMethod: .simple(.getStatusList)
    )
}

struct MilestonesKey: DependencyKey {
    static var liveValue: RequestService<TaigaMilestone, TaigaAPI> = .live(
        table: tables.milestones,
        fetchMethod: .simple(.getMilestones)
    )
    
    static var mockValue: RequestService<TaigaMilestone, TaigaAPI> = .mock(
        table: tables.milestones,
        fetchMethod: .simple(.getMilestones)
    )
}

struct TasksKey: DependencyKey {
    static var liveValue: RequestService<TaigaTask, TaigaAPI> = .live(
        table: tables.tasks,
        fetchMethod: .simple(.getTasks)
    )
    
    static var mockValue: RequestService<TaigaTask, TaigaAPI> = .mock(
        table: tables.tasks,
        fetchMethod: .simple(.getTasks)
    )
}

extension DependencyValues {
    var projects: RequestService<TaigaProject, TaigaAPI> {
        get { Self[ProjectRequestKey.self] }
        set { Self[ProjectRequestKey.self] = newValue }
    }
    
    var taskStories: RequestService<TaigaTaskStory, TaigaAPI> {
        get { Self[TaskStoriesKey.self] }
        set { Self[TaskStoriesKey.self] = newValue }
    }
    
    var taskStoryStatus: RequestService<TaigaTaskStoryStatus, TaigaAPI> {
        get { Self[TaskStoryStatusKey.self] }
        set { Self[TaskStoryStatusKey.self] = newValue }
    }
    
    var milestones: RequestService<TaigaMilestone, TaigaAPI> {
        get { Self[MilestonesKey.self] }
        set { Self[MilestonesKey.self] = newValue }
    }
    
    var tasks: RequestService<TaigaTask, TaigaAPI> {
        get { Self[TasksKey.self] }
        set { Self[TasksKey.self] = newValue }
    }
}
