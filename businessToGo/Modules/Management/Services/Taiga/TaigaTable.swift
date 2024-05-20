import Foundation
import SQLite
import OfflineSync

struct TaigaTable {
    var projects: DatabaseTable<TaigaProject>
    var taskStories: DatabaseTable<TaigaTaskStory>
    var milestones: DatabaseTable<TaigaMilestone>
    var tasks: DatabaseTable<TaigaTask>
    var taskStatus: DatabaseTable<TaigaTaskStoryStatus>  
}

extension TaigaTable {
    init(_ db: Connection?, _ track: TrackTable) {
        projects = DatabaseTable.live(db, "taiga_projects", nil)
        taskStories = DatabaseTable.live(db, "taiga_taskStories", track)
        milestones = DatabaseTable.live(db, "taiga_milestones", nil)
        tasks = DatabaseTable.live(db, "taiga_tasks", nil)
        taskStatus = DatabaseTable.live(db, "taiga_taskStatus", nil)
    }
}
