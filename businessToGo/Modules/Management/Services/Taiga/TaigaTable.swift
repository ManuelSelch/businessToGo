import Foundation
import SQLite
import OfflineSync

struct TaigaTable {
    private var db: IDatabase
    
    var projects: DatabaseTable<TaigaProject>
    var taskStories: DatabaseTable<TaigaTaskStory>
    var milestones: DatabaseTable<TaigaMilestone>
    var tasks: DatabaseTable<TaigaTask>
    var taskStatus: DatabaseTable<TaigaTaskStoryStatus>  
}

extension TaigaTable {
    init(_ db: IDatabase, _ track: TrackTable) {
        self.db = db
        
        projects = DatabaseTable(db.connection, "taiga_projects")
        taskStories = DatabaseTable(db.connection, "taiga_taskStories", track)
        milestones = DatabaseTable(db.connection, "taiga_milestones")
        tasks = DatabaseTable(db.connection, "taiga_tasks")
        taskStatus = DatabaseTable(db.connection, "taiga_taskStatus")
    }
}
