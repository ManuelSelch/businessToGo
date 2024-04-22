import Foundation
import SQLite

struct TaigaTable {
    private var db: Database
    
    var projects: DatabaseTable<TaigaProject>
    var taskStories: DatabaseTable<TaigaTaskStory>
    var milestones: DatabaseTable<TaigaMilestone>
    var tasks: DatabaseTable<TaigaTask>
    var taskStatus: DatabaseTable<TaigaTaskStoryStatus>  
}

extension TaigaTable {
    init() {
        db = Database("taiga")
        
        projects = DatabaseTable(db.connection, "projects")
        taskStories = DatabaseTable(db.connection, "taskStories")
        milestones = DatabaseTable(db.connection, "milestones")
        tasks = DatabaseTable(db.connection, "tasks")
        taskStatus = DatabaseTable(db.connection, "taskStatus")
    }
}
