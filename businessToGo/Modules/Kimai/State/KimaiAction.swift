import Foundation

enum KimaiAction {
    case navigate(KimaiScreen)
    
    case sync
    
    case customers(RequestAction<KimaiCustomer>)
    case projects(RequestAction<KimaiProject>)
    case timesheets(RequestAction<KimaiTimesheet>)
    case activities(RequestAction<KimaiActivity>)
    
    // integrations
    case connect(_ kimai: Int, _ taiga: Int)
    
    // timesheet
    case createTimesheet(_ project: Int, _ activity: Int, _ begin: String, _ description: String?)
}

enum RequestAction<Model> {
    /// fetch local & remote
    case fetch
    /// sync by remote data
    case sync([Model])
    /// delete synced change history
    case hasSynced(DatabaseChange)
}
