import Foundation
import SQLite

struct TaigaTable {
    private var db: IDatabase
    
    var projects: DatabaseTable<TaigaProject>
    var taskStories: DatabaseTable<TaigaTaskStory>
    var milestones: DatabaseTable<TaigaMilestone>
    var tasks: DatabaseTable<TaigaTask>
    var taskStatus: DatabaseTable<TaigaTaskStoryStatus>  
}

extension TaigaTable {
    init(_ db: IDatabase, _ track: ITrackTable) {
        self.db = db
        
        projects = DatabaseTable(db.connection, "projects")
        taskStories = DatabaseTable(db.connection, "taskStories", track)
        milestones = DatabaseTable(db.connection, "milestones")
        tasks = DatabaseTable(db.connection, "tasks")
        taskStatus = DatabaseTable(db.connection, "taskStatus")
    }
}
