import Foundation
import SQLite
import OfflineSync

class TaigaTable {
    var projects: DatabaseTable<TaigaProject>
    var taskStories: DatabaseTable<TaigaTaskStory>
    var milestones: DatabaseTable<TaigaMilestone>
    var tasks: DatabaseTable<TaigaTask>
    var taskStatus: DatabaseTable<TaigaTaskStoryStatus> 
    
    init() {
        projects = DatabaseTable("taiga_projects")
        taskStories = DatabaseTable("taiga_taskStories")
        milestones = DatabaseTable("taiga_milestones")
        tasks = DatabaseTable("taiga_tasks")
        taskStatus = DatabaseTable("taiga_taskStatus")
    }
}
