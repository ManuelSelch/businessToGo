import Foundation
import SQLite
import OfflineSync

class TaigaTable {
    var projects: DatabaseTable<TaigaProject>
    var taskStories: DatabaseTable<TaigaTaskStory>
    var milestones: DatabaseTable<TaigaMilestone>
    var tasks: DatabaseTable<TaigaTask>
    var taskStatus: DatabaseTable<TaigaTaskStoryStatus> 
    
    init(_ db: Connection?, _ track: TrackTable) {
        projects = DatabaseTable(db, "taiga_projects", nil)
        taskStories = DatabaseTable(db, "taiga_taskStories", track)
        milestones = DatabaseTable(db, "taiga_milestones", nil)
        tasks = DatabaseTable(db, "taiga_tasks", nil)
        taskStatus = DatabaseTable(db, "taiga_taskStatus", nil)
    }
}
