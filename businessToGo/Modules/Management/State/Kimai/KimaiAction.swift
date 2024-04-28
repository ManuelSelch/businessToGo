import Foundation

enum KimaiAction {
    case navigate(KimaiRoute)
    
    case sync
    
    case loginSuccess
    
    case customers(RequestAction<KimaiCustomer>)
    case projects(RequestAction<KimaiProject>)
    case timesheets(RequestAction<KimaiTimesheet>)
    case activities(RequestAction<KimaiActivity>)
    
    // integrations
    case connect(_ kimai: Int, _ taiga: Int)
}

enum RequestAction<Model> {
    /// fetch local & remote
    case fetch
    /// sync by remote data
    case sync([Model])
    /// delete synced change history
    case hasSynced(SyncResponse<Model>)
    
    /// create local record
    case create(Model)
    /// update local record
    case update(Model)
}
